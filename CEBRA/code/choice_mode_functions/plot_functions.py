import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import sem
from matplotlib.colors import ListedColormap, BoundaryNorm
import matplotlib
matplotlib.use('TkAgg')


def plot_3d_line(ax, arr, set_color='lightblue', set_alpha=0.5, set_linewidth=0.5, set_label='None'):
    for i in range(arr.shape[0]):
        # Extract the x, y, z coordinates
        xs = arr[i, :, 0]
        ys = arr[i, :, 1]
        zs = arr[i, :, 2]
        if i == 0:
            ax.plot(xs, ys, zs, color=set_color, alpha=set_alpha, linewidth=set_linewidth, linestyle='-',
                    label=set_label)
            ax.legend(frameon=False)
        else:
            ax.plot(xs, ys, zs, color=set_color, alpha=set_alpha, linewidth=set_linewidth, linestyle='-')

    ax.grid(False)
    ax.set_xlim([-1, 1])
    ax.set_ylim([-1, 1])
    ax.set_zlim([-1, 1])
    ax.xaxis.pane.fill = False
    ax.yaxis.pane.fill = False
    ax.zaxis.pane.fill = False
    ax.xaxis.pane.set_edgecolor('w')
    ax.yaxis.pane.set_edgecolor('w')
    ax.zaxis.pane.set_edgecolor('w')

    return ax


def plot_embedding_cross_validation(embedding, label, save_name, start_time=2, end_time=6, idx_order=(0, 1, 2)):
    fs_image = 9.35211

    duration_start = round(start_time * fs_image) - 1
    duration_end = round(end_time * fs_image) - 1
    Trial_len = duration_end - duration_start + 1

    # get trial_index
    left_control_ind = (label['left_choice'] == 1)
    right_control_ind = (label['left_choice'] == 0)

    left_control_trials = embedding[left_control_ind, :].reshape(-1, Trial_len, 3)
    right_control_trials = embedding[right_control_ind, :].reshape(-1, Trial_len, 3)

    fig = plt.figure(figsize=(30, 40))
    # plot 3D embedding
    ax1 = fig.add_subplot(111, projection='3d')
    ax1 = plot_3d_line(ax1, left_control_trials, set_color='red', set_alpha=0.35, set_linewidth=0.5, set_label='L')
    ax1 = plot_3d_line(ax1, right_control_trials, set_color='blue', set_alpha=0.5, set_linewidth=0.5, set_label='R')
    # plt.show()
    plt.savefig(save_name, format='svg')
    plt.close(fig)
    return None


def plot_embedding(ax, embedding, label, data_type, mice_type,  gray = False, idx_order = (0, 1, 2)):
    """
    Plot the 3D neural embedding.
    Parameters:
        - ax: matplotlib.axes.Axes
        - embedding: ndarray, shape (n_samples, 3).
        - label: dict with keys 'left_choice', 'session_frame'. Values are ndarray, shape (n_samples,).
        - data_type: str, 'train', 'test' or distractor type ('early', 'middle', 'late').
        - mice_type: str, 'control' or 'APP'.
    Returns:
        - ax: matplotlib.axes.Axes
    """

    l_ind = label['left_choice'] == 1 # left choice
    r_ind = label['left_choice'] == 0 # right choice

    if not gray:
        r_cmap = plt.cm.Reds
        l_cmap = plt.cm.Blues
        r_c = label['session_frame'][r_ind]
        l_c = label['session_frame'][l_ind]
    else:
        r_cmap = None
        l_cmap = None
        r_c = 'gray'
        l_c = 'gray'

    idx1, idx2, idx3 = idx_order
    r=ax.scatter(embedding[r_ind,idx1],
               embedding[r_ind,idx2],
               embedding[r_ind,idx3],
               c=r_c,
               cmap=r_cmap, s=0.5)
    l=ax.scatter(embedding[l_ind,idx1],
               embedding[l_ind,idx2],
               embedding[l_ind,idx3],
               c=l_c,
               cmap=l_cmap, s=0.5)

    ax.grid(False)
    ax.xaxis.pane.fill = False
    ax.yaxis.pane.fill = False
    ax.zaxis.pane.fill = False
    ax.xaxis.pane.set_edgecolor('w')
    ax.yaxis.pane.set_edgecolor('w')
    ax.zaxis.pane.set_edgecolor('w')
    ax.set_xlim([-1, 1])
    ax.set_ylim([-1, 1])
    ax.set_zlim([-1, 1])

    if mice_type == 'control':
        ax.set_title('Control ' + data_type, fontsize=14)
        ax.view_init(elev=16, azim=109)
    else:
        ax.set_title('APP-KI ' + data_type, fontsize=14)
        ax.view_init(elev=5, azim=87)

    ax.set_xticks([])
    ax.set_yticks([])
    ax.set_zticks([])
    ax.set_axis_off()

    return ax


def plot_distractor_trials_decoding_accuracy(ax, arglist, decoding_ACC_early, decoding_ACC_mid, decoding_ACC_late, seed_num, mice):
    """
    Plot the relative decoding accuracy of distractor trials.
    Parameters:
        - ax: matplotlib.axes.Axes
        - arglist: dict, arguments for the experiment.
        - decoding_ACC_early: list of ndarray, shape (seed_num, n_timepoints).
        - decoding_ACC_mid: list of ndarray, shape (seed_num, n_timepoints).
        - decoding_ACC_late: list of ndarray, shape (seed_num, n_timepoints).
        - seed_num: int, number of seeds.
        - mice: str, 'control' or 'APP'.
    Returns:
        - ax: matplotlib.axes.Axes
    """

    # set line color
    if mice == 'control':
        line_color = {'early': (0.0, 0.0, 0.0, 1.0), 'middle': (0.25, 0.25, 0.25, 1.0), 'late': (0.5, 0.5, 0.5, 1.0)}
        color_fill = (0.5, 0.5, 0.5)
    else:
        line_color = {'early': (0.64, 0.08, 0.18, 1.0), 'middle': (0.82, 0.29, 0.34, 1.0), 'late': (1.0, 0.5, 0.5, 1.0)}
        color_fill = (0.64, 0.08, 0.18)

    # Define the timepoints for the distractors
    distractor = {'early': [], 'middle': [], 'late': []}
    distractor['early'] = (arglist.distractor_early - arglist.duration_start) * arglist.fs_image - 1
    distractor['middle'] = (arglist.distractor_mid - arglist.duration_start) * arglist.fs_image - 1
    distractor['late'] = (arglist.distractor_late - arglist.duration_start) * arglist.fs_image - 1

    # Plot the decoding accuracy
    mean_decoding_ACC_early = np.mean(decoding_ACC_early, axis=0)
    sem_decoding_ACC_early = np.std(decoding_ACC_early, axis=0) / np.sqrt(seed_num)
    mean_decoding_ACC_mid = np.mean(decoding_ACC_mid, axis=0)
    sem_decoding_ACC_mid = np.std(decoding_ACC_mid, axis=0) / np.sqrt(seed_num)
    mean_decoding_ACC_late = np.mean(decoding_ACC_late, axis=0)
    sem_decoding_ACC_late = np.std(decoding_ACC_late, axis=0) / np.sqrt(seed_num)
    ax.plot(mean_decoding_ACC_early, linewidth=1, color=line_color['early'], label='Early')
    ax.fill_between(np.arange(len(mean_decoding_ACC_early)), mean_decoding_ACC_early - sem_decoding_ACC_early,
                          mean_decoding_ACC_early + sem_decoding_ACC_early, color=color_fill, alpha=0.25)
    ax.plot(mean_decoding_ACC_mid, linewidth=1, color=line_color['middle'], label='Middle')
    ax.fill_between(np.arange(len(mean_decoding_ACC_mid)), mean_decoding_ACC_mid - sem_decoding_ACC_mid,
                          mean_decoding_ACC_mid + sem_decoding_ACC_mid, color=color_fill, alpha=0.25)
    ax.plot(mean_decoding_ACC_late, linewidth=1, color=line_color['late'], label='Late')
    ax.fill_between(np.arange(len(mean_decoding_ACC_late)), mean_decoding_ACC_late - sem_decoding_ACC_late,
                          mean_decoding_ACC_late + sem_decoding_ACC_late, color=color_fill, alpha=0.25)

    ax.set_xticks([distractor['early'], distractor['middle'], distractor['late']])
    ax.set_xticklabels([-3, -2, -1], fontsize=14)
    ax.set_xlim([0, len(mean_decoding_ACC_early) - 1])
    ax.set_ylim([-60, 60])
    ax.set_yticks([-60, 0, 60])
    ax.set_yticklabels([-60, 0, 60], fontsize=14)
    ax.set_xlabel('Time to go cue (s)', fontsize=14)
    ax.set_ylabel('Relative decoding accuracy (%)', fontsize=14)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    # Set tick appearance
    ax.tick_params(direction='in', length=6, width=1)
    ax.tick_params(which='minor', bottom=False, left=False)

    # plot distractor lines
    for key in distractor.keys():
        ax.axvline(x=distractor[key], color=[0.25, 0.25, 0.25], linewidth=1)

    ax.legend(frameon=False, fontsize=14)
    if mice == 'control':
        ax.set_title('Control', fontsize=14)
    else:
        ax.set_title('APP-KI', fontsize=14)
    return ax


def plot_bar_panel_control_vs_app_mice_decoding_accuracy(ax, control_decoding_avg, APP_decoding_avg):
    """
    Compare the average decoding accuracy of 1 second after distractor presentation between control and APP mice.
    Parameters:
        - ax: matplotlib.axes.Axes
        - control_decoding_avg: dict, average decoding accuracy during 1s following distractor presentation of control mice.
        - APP_decoding_avg: dict, average decoding accuracy during 1s following distractor presentation of APP mice.
    Return:
        - ax: matplotlib.axes.Axes
    """

    # Set random seed for reproducibility
    np.random.seed(142)

    control_decoding_avg_mean = [np.mean(control_decoding_avg[k]) for k in ['early', 'middle', 'late']]
    control_decoding_avg_sem = [sem(control_decoding_avg[k]) for k in ['early', 'middle', 'late']]
    APP_decoding_avg_mean = [np.mean(APP_decoding_avg[k]) for k in ['early', 'middle', 'late']]
    APP_decoding_avg_sem = [sem(APP_decoding_avg[k]) for k in ['early', 'middle', 'late']]

    # plot the bar graph
    x = np.arange(3)
    width = 0.25
    ax.bar(x - width / 2, control_decoding_avg_mean, width, yerr=control_decoding_avg_sem, capsize=5, color=[0.25, 0.25, 0.25], alpha=0.6, label='Control')
    ax.bar(x + width / 2, APP_decoding_avg_mean, width, yerr=APP_decoding_avg_sem, capsize=5, color=[0.64, 0.08, 0.18], alpha=0.6, label='APP-KI')
    # Add scatter for individual data points
    jitter = 0.1  # Amount of jitter to add to the x positions for scatter
    for i, stage in enumerate(['early', 'middle', 'late']):
        # Scatter for control
        x_positions_control = np.full_like(control_decoding_avg[stage], x[i] - width / 2) + np.random.uniform(-jitter, jitter, len(control_decoding_avg[stage]))
        ax.scatter(x_positions_control, control_decoding_avg[stage], color=[0.25, 0.25, 0.25], edgecolor='none')

        # Scatter for APP
        x_positions_APP = np.full_like(APP_decoding_avg[stage], x[i] + width / 2) + np.random.uniform(-jitter, jitter, len(APP_decoding_avg[stage]))
        ax.scatter(x_positions_APP, APP_decoding_avg[stage], color=[0.64, 0.08, 0.18], edgecolor='none')

    ax.axhline(y=0, color='black', linewidth=1, linestyle='--')
    ax.set_xticks(x)
    ax.set_xticklabels(['Early', 'Middle', 'Late'], fontsize=14)
    ax.set_ylabel('Relative decoding accuracy (%)', fontsize=14)
    ax.legend(frameon=False, fontsize=14)
    ax.set_ylim([-60, 30])
    ax.set_yticks([-60, -30, 0])
    ax.set_yticklabels([-60, -30, 0], fontsize=14)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    # Set tick appearance similar to MATLAB
    ax.tick_params(direction='in', length=6, width=1)  # Major ticks inside
    ax.tick_params(which='minor', bottom=False, left=False)
    return ax


def decoding_accuracy_control_vs_app_mice_ablation(ax, relative_decoding_accuracy_summary, arglist, region_name, mice):
    """
    Plot the relative decoding accuracy for individual brain regions.
    Parameters:
        - ax: matplotlib.axes.Axes
        - relative_decoding_accuracy_summary: dict, relative decoding accuracy for each brain region.
        - arglist: dict, arguments for the experiment.
        - region_name: str, name of the brain region.
        - mice: str, 'control' or 'APP'.
    Returns:
        - ax: matplotlib.axes.Axes
    """

    # set line color
    if mice == 'control':
        line_color = {'early': (0.0, 0.0, 0.0, 1.0), 'middle': (0.25, 0.25, 0.25, 1.0), 'late': (0.5, 0.5, 0.5, 1.0)}
        color_fill = (0.5, 0.5, 0.5)
    else:
        line_color = {'early': (0.64, 0.08, 0.18, 1.0), 'middle': (0.82, 0.29, 0.34, 1.0), 'late': (1.0, 0.5, 0.5, 1.0)}
        color_fill = (0.64, 0.08, 0.18)

    # trial length
    start_index = round(arglist.duration_start * arglist.fs_image) - 1
    end_index = round(arglist.duration_end * arglist.fs_image) - 1
    Trial_len = end_index - start_index + 1

    distractor = {'early': [], 'middle': [], 'late': []}
    distractor['early'] = (arglist.distractor_early - arglist.duration_start) * arglist.fs_image - 1
    distractor['middle'] = (arglist.distractor_mid - arglist.duration_start) * arglist.fs_image - 1
    distractor['late'] = (arglist.distractor_late - arglist.duration_start) * arglist.fs_image - 1

    # get seed array
    seed_array_control_mice = list(relative_decoding_accuracy_summary.keys())
    region_relative_decoding_ACC = {'early': [], 'middle': [], 'late': []}
    distractor_decoding_acc = {'early': [], 'middle': [], 'late': []}

    for distractor_type in ['early', 'middle', 'late']:
        for seed_num in seed_array_control_mice:
                region_relative_decoding_ACC[distractor_type].append(relative_decoding_accuracy_summary[seed_num][distractor_type][region_name])
        distractor_decoding_acc = np.array(region_relative_decoding_ACC[distractor_type])

        # plot the relative decoding accuracy
        decoding_ACC_mean = np.mean(distractor_decoding_acc, axis=0)
        decoding_ACC_sem = np.std(distractor_decoding_acc, axis=0) / np.sqrt(len(seed_array_control_mice))
        ax.plot(decoding_ACC_mean, color=line_color[distractor_type], label=distractor_type.capitalize(), linewidth=1)
        ax.fill_between(range(Trial_len), decoding_ACC_mean - decoding_ACC_sem,
                        decoding_ACC_mean + decoding_ACC_sem,
                        color=color_fill, alpha=0.25)
        ax.axvline(x=distractor[distractor_type], color=[0.25, 0.25, 0.25], linewidth=1)
        del decoding_ACC_mean, decoding_ACC_sem, distractor_decoding_acc

    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.legend(frameon=False, fontsize=14)
    if mice == 'control':
        ax.set_title('Control ' + region_name, fontsize=14)
    else:
        ax.set_title('APP-KI ' + region_name, fontsize=14)
        ax.set_xlabel('Time to go cue (s)', fontsize=14)

    ax.set_xlim([0, Trial_len - 1])
    ax.set_xticks([distractor['early'], distractor['middle'], distractor['late']])
    ax.set_xticklabels([-3, -2, -1], fontsize=14)
    ax.set_ylim([-50, 50])
    ax.set_yticks([-50, 0, 50])
    ax.set_yticklabels([-50, 0, 50], fontsize=14)
    if region_name == 'ALM':
        ax.set_ylabel('Relative decoding accuracy (%)', fontsize=14)

    # Set tick appearance similar to MATLAB
    ax.tick_params(direction='in', length=6, width=1)  # Major ticks inside
    ax.tick_params(which='minor', bottom=False, left=False)
    return ax


def plot_bar_panel_control_vs_app_mice_decoding_accuracy_ablation(ax, Decoding_ACC_control_mice_summary, Decoding_ACC_APP_mice_summary, arglist):
    """
    Plot decoding accuracy for control and APP mice across brain regions and distractor types (early, mid, late).
    Parameters:
        - ax: matplotlib.axes.Axes
        - Decoding_ACC_control_mice_summary: dict, decoding accuracy summary for control mice.
        - Decoding_ACC_APP_mice_summary: dict, decoding accuracy summary for APP mice.
        - arglist: arguments with experiment settings (e.g., duration_start, fs_image, etc.).
    Returns:
        - ax: matplotlib.axes.Axes
    """

    brain_region = ['ALM', 'M1a', 'M1p', 'M2', 'S1fl', 'vS1', 'RSC', 'PPC']

    # set bar color
    control_color = {'early': (0.25, 0.25, 0.25, 1.0), 'middle': (0.5, 0.5, 0.5, 1.0), 'late': (0.75, 0.75, 0.75, 1.0)}
    APP_color = {'early': (0.64, 0.08, 0.18, 1.0), 'middle': (0.82, 0.29, 0.34, 1.0), 'late': (1.0, 0.5, 0.5, 1.0)}

    # Trial length
    start_index = round(arglist.duration_start * arglist.fs_image) - 1
    end_index = round(arglist.duration_end * arglist.fs_image) - 1
    Trial_len = end_index - start_index + 1

    distractor_1s_after = {'early': [], 'middle': [], 'late': []}
    distractor = {'early': [], 'middle': [], 'late': []}
    distractor['early'] = (arglist.distractor_early - arglist.duration_start) * arglist.fs_image - 1
    distractor['middle'] = (arglist.distractor_mid - arglist.duration_start) * arglist.fs_image - 1
    distractor['late'] = (arglist.distractor_late - arglist.duration_start) * arglist.fs_image - 1
    for distractor_type in ['early', 'middle', 'late']:
        distractor_1s_after[distractor_type] = round(distractor[distractor_type] + arglist.fs_image)

    # Get seed array
    seed_array_control_mice = list(Decoding_ACC_control_mice_summary.keys())
    region_decoding_ACC_control_mice = {region_name: {'early': [], 'middle': [], 'late': []} for region_name in brain_region}
    region_decoding_ACC_APP_mice = {region_name: {'early': [], 'middle': [], 'late': []} for region_name in brain_region}

    # Get region data
    for distractor_type in ['early', 'middle', 'late']:
        for region_name in brain_region:
            for seed_num in seed_array_control_mice:
                region_decoding_ACC_control_mice[region_name][distractor_type].append(Decoding_ACC_control_mice_summary[seed_num][distractor_type][region_name])
                region_decoding_ACC_APP_mice[region_name][distractor_type].append(Decoding_ACC_APP_mice_summary[seed_num][distractor_type][region_name])

    # Initialize variables for plotting
    bar_width = 0.15  # Adjust width for 6 bars per group
    x = np.arange(len(brain_region))  # Positions for each brain region
    offset = [-0.375, -0.225, -0.075, 0.075, 0.225, 0.375]  # Bar offsets for 6 bars

    for i, distractor_type in enumerate(['early', 'middle', 'late']):
        # Calculate mean and SEM for control and APP
        control_array_temp = {k: np.array(region_decoding_ACC_control_mice[k][distractor_type]) for k in brain_region}
        control_temp = {k: np.mean(control_array_temp[k][:, round(distractor[distractor_type]):distractor_1s_after[distractor_type]], axis=1) for k in brain_region}
        control_decoding_acc_mean = [np.mean(control_temp[k]) for k in brain_region]
        control_decoding_acc_sem = [sem(control_temp[k]) for k in brain_region]

        APP_array_temp = {k: np.array(region_decoding_ACC_APP_mice[k][distractor_type]) for k in brain_region}
        APP_temp = {k: np.mean(APP_array_temp[k][:, round(distractor[distractor_type]):distractor_1s_after[distractor_type]], axis=1) for k in brain_region}
        APP_decoding_acc_mean = [np.mean(APP_temp[k]) for k in brain_region]
        APP_decoding_acc_sem = [sem(APP_temp[k]) for k in brain_region]

        # Plot bars
        ax.bar(x + offset[i * 2], control_decoding_acc_mean, bar_width, yerr=control_decoding_acc_sem,
               capsize=5, label=f'Control {distractor_type.capitalize()}', color=control_color[distractor_type])
        ax.bar(x + offset[i * 2 + 1], APP_decoding_acc_mean, bar_width, yerr=APP_decoding_acc_sem,
               capsize=5, label=f'APP {distractor_type.capitalize()}', color=APP_color[distractor_type])

        del control_array_temp, control_temp, APP_array_temp, APP_temp, control_decoding_acc_mean, control_decoding_acc_sem, APP_decoding_acc_mean, APP_decoding_acc_sem

    # Customize plot appearance
    ax.set_xticks(x)
    ax.set_xticklabels(brain_region, fontsize=14)

    ax.set_ylabel('Relative decoding accuracy (%)', fontsize=14)
    ax.set_ylim([-50, 10])
    ax.set_yticks([-50, 0])
    ax.set_yticklabels([-50, 0], fontsize=14)

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(handles[:2], ['Control', 'APP-KI'], frameon=False, fontsize=14)

    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    ax.tick_params(direction='in', length=6, width=1)
    ax.tick_params(which='minor', bottom=False, left=False)

    return ax


# plot p value array
def plot_p_value_significance(p_value_array, ax):

    brain_region = ['ALM', 'M1a', 'M1p', 'M2', 'S1fl', 'vS1', 'RSC', 'PPC']
    # display p-value
    vector_temp = np.column_stack((
        p_value_array['early'],
        p_value_array['middle'],
        p_value_array['late']
    ))
    vector = np.zeros_like(vector_temp)
    vector[(vector_temp < 0.05) & (vector_temp >= 0.01)] = 1
    vector[(vector_temp < 0.01) & (vector_temp >= 0.001)] = 2
    vector[vector_temp < 0.001] = 3

    cmap = ListedColormap(['black', 'darkgray', 'lightgray', 'white'])
    bounds = [0, 1, 2, 3, 4]  # Define boundaries (4 ensures `3` maps to white)
    norm = BoundaryNorm(bounds, cmap.N)

    # Plot the data
    im = ax.imshow(vector, cmap=cmap, norm=norm)
    im.format_cursor_data = lambda x: ""
    ax.set_aspect('equal')

    # Set tick positions and labels
    ax.set_xticks(range(vector.shape[1]))
    ax.set_yticks(range(vector.shape[0]))
    ax.set_xticklabels(['Early', 'Middle', 'Late'], fontsize=14, rotation=45)
    ax.set_yticklabels(brain_region, fontsize=14)
    ax.tick_params(axis='both', which='both', length=0)

    # Add a discrete colorbar
    fig = ax.get_figure()
    cbar = fig.colorbar(im, ax=ax, boundaries=bounds, ticks=[0.5, 1.5, 2.5, 3.5])
    cbar.set_ticklabels(['ns', 'p < 0.05', 'p < 0.01', 'p < 0.001'], fontsize=14)
    cbar.ax.tick_params(length=0)
    return ax






