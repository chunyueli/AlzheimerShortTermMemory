import numpy as np
import numpy.random as npr
import matplotlib.pyplot as plt
import pickle as pkl
import os
from scipy.io import loadmat, savemat
from math import ceil

def create_hyperparameters(data_path, save_path, *args):
	"""
        Create/Modify hyperparameters settings for RNN.

    Args:
		data_path: 	Directory of mat file containing animal neural activities data
		save_path: 	Directory to save RNN.pkl file
		*args:		(region_idx, seed number, ramp_slope)

    Returns:
        p:    DictionaryAll_regions_1024units_v3 containing the hyperparameters for RNN.

    """
	if args:
		region_idx, seed, ramp = args

	pklfile = os.path.join(save_path, 'RNN.pkl')
	if os.path.exists(pklfile):
		with open(pklfile, 'rb') as f:
			p = pkl.load(f)
		print('Hyperparameters loaded.')

	else:
		# Setup hyperparameters for RNN
		p = {
			'dt': 0.001,					# integration learning time step
			'tau': 0.01,					# time constant of neurons
			'g': 1.2,						# spectial radius, where g in range [1.2, 1.5]
			'p': 1.0,						# sparsity of the network, where p in range [0,1], where 1 is fully connected.
			'alpha': 0.005,					# coefficient of P0
			'training_trials': 1500,		# number of training trials for RNN
			'learning_rate': 0.05,			# learning rate for weights update
			'seed_number': seed,
		# Setup hyperparameters for inputs
			'region_index': region_idx,		# 0: ALM, etc
			'ramping_slope': ramp,
			'stim_amplitude_R': 1.0,		# stimulus amplitude for R-licking trials
			'stim_amplitude_L': 0.0,		# stimulus amplitude for L-licking trials
			'batch_size': 1024
			}
  
	data = loadmat(data_path)
	key = 'trial_averaged_correct_response'
	for region_num in range(8):
		L, R = data[key].squeeze()[region_num].squeeze()[0], data[key].squeeze()[region_num].squeeze()[1]
		L, R = L*5, R*5
		L, R = np.append(L,L, axis=0), np.append(R,R, axis=0)

	# To get std threshold across all neurons across all regions
	concatenated_LR = np.hstack((L, R))
	std_threshold = (2 *np.std(concatenated_LR))
  
	concat_L, concat_R  = np.zeros([p['batch_size'],L.shape[1]]), np.zeros([p['batch_size'],R.shape[1]])
	concat_batch = np.zeros([int(p['batch_size']/8), 8])	
	# Start sampling from each region
	for region_num in range(8):
		L, R = data[key].squeeze()[region_num].squeeze()[0], data[key].squeeze()[region_num].squeeze()[1]
		L, R = L*5, R*5

		print(f'Total # cells: {L.shape[0]}')

		#Filter then clip
		# Apply selection criteria
		concatenated_LR = np.hstack((L, R))
		selection_criteria = concatenated_LR > std_threshold
		passed = np.any(selection_criteria, axis=1)
		L, R = L[passed], R[passed]
		# Clipping and max normalization
		L, R = normalize(L), normalize(R)
		print(f'Selected # cells: {L.shape[0]}')

		# Sample with replacement
		rng = npr.default_rng(seed)
		batch = rng.choice(range(len(L)), int(p['batch_size']/8), replace=True)
		L, R = L[batch], R[batch]

		concat_L[int(region_num*p['batch_size']/8) : int(region_num*p['batch_size']/8+p['batch_size']/8)] = L
		concat_R[int(region_num*p['batch_size']/8) : int(region_num*p['batch_size']/8+p['batch_size']/8)] = R
	
	L, R = concat_L, concat_R
	# Upsample data from 9.35Hz to 93.5Hz
	L, R = interpolating(L, 9), interpolating(R, 9)
	# Only consider 0.5s of pre-sample epoch, 1.0s of sample epoch and 2.0s of delay epoch
	L, R = truncate(L), truncate(R)

	# Apply inverse sigmoid to obtain target functions
	inv_sig_L, inv_sig_R = inv_sigmoid(L), inv_sigmoid(R)
	# 38/93.5 = 406ms Smoothing window
	L, R = moving_average(L, 38), moving_average(R, 38)
	inv_sig_L, inv_sig_R = moving_average(inv_sig_L, 38), moving_average(inv_sig_R, 38)

	p.update({'L_activities': L, 'R_activities': R})
	p.update({'target_fn_L' : inv_sig_L, 'target_fn_R': inv_sig_R})
	p.update({'network_size': L.shape[0]})

	if os.path.exists(save_path) is False:
		os.mkdir(save_path)
	with open(pklfile, 'wb') as f:
		pkl.dump(p, f)
	print('Number of RNN units: {}'.format(p['network_size']))
	print('Hyperparameters saved.')
	return p

def interpolating(activity, n_interp_points):
	'''
		Upsample the data
	'''
	interpolated = np.repeat(activity, n_interp_points+1).reshape(activity.shape[0], activity.shape[1]*(n_interp_points+1))
	interpolated = interpolated.astype('float')
	diff = (activity[:,1:] - activity[:,:-1])/(n_interp_points+1)
	for i in range(diff.shape[1]):
		for n in range(n_interp_points):
			interpolated[:,i*(n_interp_points+1) + n+1] += diff[:,i] * (n+1)
	for _ in range(n_interp_points):
		interpolated = np.delete(interpolated, -1, 1)
	return interpolated

def truncate(tseries):
	'''
		Crop the time series into 0.5s pre-sample epoch, 1.0s sample epoch and 2.0s delay epoch 
	'''
	start = round(0.5 * 93.5)
	end = round(6.0 * 93.5)
	if len(tseries.shape) > 1:
		tseries = tseries[:, start:end]
	else:
		tseries = tseries[start:end]
	return tseries


def normalize(tseries, min_value=0.0, max_value=1.0):
	'''
		Clip and max normalize the data
	'''
	# To avoid divide by zero during inverse sigmoid
	offset = 0.01
	## Threshold
	tseries = np.clip(tseries, min_value + offset, max_value - offset)
	## Max Normalization
	tseries = tseries / max_value
	return tseries

def moving_average(activity, window_size = 5):
	'''
		Data Smoothing
	'''
	left_tail = window_size//2
	right_tail = window_size-left_tail-1
	smoothed = np.zeros_like(activity)
	timelen = activity.shape[1]
	for i in range(timelen):
		if i + right_tail < window_size:
			smoothed[:,i] = np.mean(activity[:, :right_tail+i+1], axis=1)
		elif timelen - (i-left_tail) < window_size:
			smoothed[:,i] = np.mean(activity[:, -(timelen-(i-left_tail)):], axis=1)
		else:
			smoothed[:,i] = np.mean(activity[:, i-left_tail:i+right_tail+1], axis=1)
	return smoothed

def inv_sigmoid(y, beta=1.0, theta=3.0):
	'''
		Inverse sigmoidal function
	'''
	return theta + (1/beta) * np.log(y/(1-y))

# Preparing inputs for RNN
def prepare_ext_inputs(activity, target_fn, stim_amp, ramping_slope, dist_amp=None, dist_type='early', dist_duration=0.5):
	'''
		Generate the time series for all the external inputs, including stimulus, cue and distractor
	'''
	stim = np.zeros(activity.shape[1])
	
	## Triangular Stim
	n_bins = round(1.0 * 93.5)
	half_t = ceil(n_bins/2)
	up_slope = (np.arange(half_t)+1)/half_t
	down_slope = np.flip(up_slope)
	if (n_bins - half_t) == half_t:
		triangle = np.concatenate((up_slope, down_slope)) * stim_amp
	else:
		triangle = np.concatenate((up_slope, down_slope[1:])) * stim_amp
	start = round(0.5 * 93.5)
	end = start + n_bins
	stim[start:end] = triangle
	
	# Triangular distractor
	if dist_amp is not None:
		n_bins = round(dist_duration * 93.5)
		half_t = ceil(n_bins/2)
		up_slope = (np.arange(half_t)+1)/half_t
		down_slope = np.flip(up_slope)
		if (n_bins - half_t) == half_t:
			triangle = np.concatenate((up_slope, down_slope)) * dist_amp
		else:
			triangle = np.concatenate((up_slope, down_slope[1:])) * dist_amp

		if dist_type == 'early':
			# Start at 1.75s (at 0.25s of the delay ep)
			start = round((1.5 + 0.7) * 93.5)
		elif dist_type == 'mid':
			# Start at 2.0s (at 0.5s of the delay ep)
			start = round((1.5 + 1.7) * 93.5)
		elif dist_type == 'late':
			# Start at 2.0s (at 0.5s of the delay ep)
			start = round((1.5 + 2.7) * 93.5)
		end = start + n_bins
		stim[start:end] = triangle
	
	# Delimiter Cue
	cue = np.zeros(activity.shape[1])

	n_bins = round(0.1 * 93.5)
	half_t = ceil(n_bins/2)
	up_slope = (np.arange(half_t)+1)/half_t
	down_slope = np.flip(up_slope)
	if (n_bins - half_t) == half_t:
		triangle = np.concatenate((up_slope, down_slope))
	else:
		triangle = np.concatenate((up_slope, down_slope[1:]))
	start = round(1.4 * 93.5)
	end = start + n_bins
	cue[start:end] = triangle

	# Ramping input started from sample epoch to the end of delay epoch
	ramp = np.zeros(activity.shape[1])
	start = round(0.5 * 93.5)
	ramp[start:] = (np.arange(len(ramp[start:])) + 1) / len(ramp[start:]) * ramping_slope
		
	stim = stim.repeat(activity.shape[0]).reshape(activity.shape[1], activity.shape[0]).T
	cue = cue.repeat(activity.shape[0]).reshape(activity.shape[1], activity.shape[0]).T
	ramp = ramp.repeat(activity.shape[0]).reshape(activity.shape[1], activity.shape[0]).T
	ramp = moving_average(ramp)

	inputs = {'orig': activity, 'target': target_fn, 'stim': stim, 'cue': cue, 'ramp': ramp}

	return inputs

def save_readouts(readouts, savedir, filename=None):
	'''
		Convert the readouts into mat file
	'''
	if filename is None:
		filename = os.path.join(savedir, 'readouts.mat')
	else:
		filename = os.path.join(savedir, filename)
	savemat(filename, readouts)
	print('Converted to Mat file.')