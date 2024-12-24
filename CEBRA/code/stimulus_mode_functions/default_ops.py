from pathlib import Path


def default_ops():
    """ Default arguments to run stimulus and choice modes """
    return {
        # Paths for data and models
        "root_path": str(Path("/home/user/Documents/Cebra_code/")),  # Root directory containing all subfolders
        "data_path": str(Path("/home/user/Documents/Cebra_code/Data")),  # Directory containing .mat files
        "model_save_path": str(Path("/home/user/Documents/Cebra_code/Trained_models")),  # Directory to save trained models

        # experimental parameters
        "mice_type": ['control', 'APP'],  # Types of mice for analysis
        "fs_image": 9.35211,  # Imaging sampling rate (Hz)
        "duration_start": 2,  # Delay period start time (s)
        "duration_end": 6,  # Delay period end time (s)
        "distractor_early": 3,  # Early distractor onset (s)
        "distractor_mid": 4,  # Middle distractor onset (s)
        "distractor_late": 5,  # Late distractor onset (s)

        # data processing parameters
        "seed_cells": 86,  # Random seed for cell sampling
        "seed_behavior_trials": 2425,  # Random seed for behavior trial sampling (choice mode only)
        "save_intermediate_results": True,  # Save intermediate results (True/False)
        "number_population": 25,  # Number of neural population samples
        "train_ratio": 0.8,  # Fraction of data for training (rest for testing)
        "model_trained": False,  # Specify if the model has been trained (True/False)
        "set_seed_model_init": True,  # Random seed for model initialization
        "sampling_cell_num": 200,  # Number of cells sampled from each brain region
        "behavior_outcome": 'correct_incorrect_response',  # Choice mode: ['correct_response', 'incorrect_response']; Stimulus mode: 'correct_incorrect_response'
        "control_trial_num": None,  # Minimum number of no-distractor trials (choice mode only)
        "distractor_trial_num": None,  # Minimum number of trials per distractor type (choice mode only)
        "num_folds": 5,  # Cross-validation folds

        # CEBRA model parameters
        "model_name": 'offset1-model',  # CEBRA model name (e.g., 'offset1-model')
        "time_offsets": 1,  # Time difference between positive pairs
        "conditional": 'time_delta',  # Conditional distribution
        "max_iterations": 2000,  # Maximum number of training iterations
        "output_dimension": 3,  # Dimension of the output embedding space
        "batch_size": None,  # Training batch size (None: full dataset)
        "distance": 'cosine',  # Distance metric for loss calculation
        "temperature": 1,  # Temperature scaling parameter
        "device": 'cuda_if_available',  # GPU device (e.g., 'cuda:0')
        "hybrid": False,  # Use hybrid mode (True/False)

        # KNN decoder parameters
        "K_num": 5,  # Number of neighbors for KNN decoder
    }
