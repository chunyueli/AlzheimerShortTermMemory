import FORCE
import numpy as np
import numpy.random as npr
import matplotlib.pyplot as plt
import os
from scipy.io import loadmat, savemat

if __name__ == '__main__':
    data_types = ['control', 'APP']
    ramp = [0.0]
    for seed in range(20):
        for r in ramp:
            for d in data_types:
                # Folder where activity_for_RNN_training_control.mat or activity_for_RNN_training_APP.mat neural activity is saved
                datadir = f'data/{d}_data.mat'
                # Folder to save RNNs
                logdir = 'data/RNNs'
                savedir = os.path.join(logdir, f'{d}_RNN{r}_{seed}')
                print(os.path.basename(savedir))
                region = 0
                
                if os.path.exists(logdir) is False:
                    os.mkdir(logdir)

                p = FORCE.create_hyperparameters(datadir, savedir, region, seed, r)
                net = FORCE.RNN(p, savedir)
                training = True
                if os.path.exists(savedir):
                    if len(os.listdir(savedir)) > 1:
                        training = False  
                if training:
                    net.train()
                
                testdir = os.path.join(savedir, 'r_t')
                if os.path.exists(testdir) is False:
                    net.test(saveplots=True)