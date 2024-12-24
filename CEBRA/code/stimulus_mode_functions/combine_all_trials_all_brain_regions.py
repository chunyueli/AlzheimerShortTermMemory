import numpy as np


def concatenate_all_trial_type_within_region(data, cell_index, start_time, end_time, fs_image):
    """
      concatenate the neural activity of active cells across trials
      Parameter:
          - data: list of ndarray
              List of neural activity arrays for each trial type. Each array has shape [cell, trials, time].
          - cell_index: boolean ndarray with shape [cell num, ]
              Array containing boolean values for individual cells. True indicates that the cell is active.
          - start_time: int
              Start time of the delay period (in seconds).
          - end_time: int
              End time of the delay period (in seconds).
          - fs_image: float
              Sampling rate of the two-photon microscope (in Hz).

      Return:
          - data_reshaped: ndarray
              Neural activity array with shape [cell, trials * time].
          - behavior: dict
              Dictionary containing the behavior data for each trial.
      """
    duration_start = round(start_time * fs_image) - 1
    duration_end = round(end_time * fs_image) - 1
    trial_len = duration_end - duration_start + 1
    trial_frame = np.linspace(start_time - 2, end_time - 2, num=trial_len, endpoint=True)

    behavior = {'Trial_type': [], 'session_frame': [], 'left_stimulus': [], 'Trial_ID': []}
    data_reshaped = []

    # trial ID
    total_trial_num = 0

    k = 1
    # iterate over each trial type
    for i, temp_array in enumerate(data):
        if temp_array is None:
            continue
        if k == 1:
            delay_array, reshaped, array_orig = [], [], []
            array_orig = np.array(temp_array)
            if len(array_orig.shape) > 2:
                if cell_index.size == 1 and cell_index.item():
                    delay_array = array_orig[:, :, duration_start: duration_end + 1]
                else:
                    delay_array = array_orig[cell_index, :, duration_start: duration_end + 1]
                cell, trial, time = delay_array.shape
                reshaped = delay_array.reshape(cell, trial * time)
                data_reshaped = reshaped

            elif len(array_orig.shape) == 2:
                if cell_index.size > 1:
                    delay_array = array_orig[cell_index, duration_start: duration_end + 1]
                    cell, time = delay_array.shape
                    trial = 1
                    reshaped = delay_array
                elif cell_index.size == 1:
                    delay_array = array_orig[:, duration_start: duration_end + 1]
                    trial, time = delay_array.shape
                    reshaped = delay_array.reshape(trial * time)
                data_reshaped = reshaped

            elif len(array_orig.shape) == 1:
                delay_array = array_orig[duration_start: duration_end + 1]
                trial = 1
                time = delay_array.size
                reshaped = delay_array
                data_reshaped = reshaped

            behavior['Trial_type'] = i * np.ones(trial * time)
            behavior['session_frame'] = np.tile(trial_frame, trial)

            # left and right stimuli
            if i % 2 == 0:
                behavior['left_stimulus'] = np.ones(trial * time)
            else:
                behavior['left_stimulus'] = np.zeros(trial * time)

            k += 1
            total_trial_num += trial
        else:
            delay_array, reshaped, array_orig = [], [], []
            array_orig = np.array(temp_array)
            if len(array_orig.shape) > 2:
                if cell_index.size == 1 and cell_index.item():
                    delay_array = array_orig[:, :, duration_start: duration_end + 1]
                else:
                    delay_array = array_orig[cell_index, :, duration_start: duration_end + 1]
                cell, trial, time = delay_array.shape
                reshaped = delay_array.reshape(cell, trial * time)
                data_reshaped = np.concatenate((data_reshaped, reshaped), axis=1)
            elif len(array_orig.shape) == 2:
                if cell_index.size > 1:
                    delay_array = array_orig[cell_index, duration_start:duration_end + 1]
                    cell, time = delay_array.shape
                    trial = 1
                    reshaped = delay_array
                    data_reshaped = np.concatenate((data_reshaped, reshaped), axis=1)
                elif cell_index.size == 1:
                    delay_array = array_orig[:, duration_start:duration_end + 1]
                    trial, time = delay_array.shape
                    reshaped = delay_array.reshape(trial * time)
                    data_reshaped = np.concatenate((data_reshaped, reshaped), axis=0)
            elif len(array_orig.shape) == 1:
                delay_array = array_orig[duration_start:duration_end + 1]
                trial = 1
                time = delay_array.size
                reshaped = delay_array
                data_reshaped = np.concatenate((data_reshaped, reshaped), axis=0)

            behavior['Trial_type'] = np.concatenate((behavior['Trial_type'], i * np.ones(trial * time)), axis=0)
            behavior['session_frame'] = np.concatenate((behavior['session_frame'], np.tile(trial_frame, trial)), axis=0)

            # left and right stimulus
            if i % 2 == 0:
                behavior['left_stimulus'] = np.concatenate((behavior['left_stimulus'], np.ones(trial * time)), axis=0)
            else:
                behavior['left_stimulus'] = np.concatenate((behavior['left_stimulus'], np.zeros(trial * time)), axis=0)

            # calculate trial type
            total_trial_num += trial

    # trial ID
    behavior['Trial_ID'] = np.tile(np.arange(total_trial_num).reshape(total_trial_num, 1), (1, len(trial_frame))).flatten()

    return data_reshaped, behavior


def dataset_all_sessions(neural_sig, active_cell_index, arglist, mice_type='control'):
    """
    Group active cells from the same brain region together.

    Parameters:
        - neural_sig: A dictionary containing neural data for each brain region for all mice.
        - active_cell_index: A nested list containing the indices of active cells for each brain region for all sessions.
        - arglist: A dictionary containing the parameters for the analysis.
        - mice_type: A threshold value to determine whether a cell is active.

        Returns:
            - datas: A dictionary where keys are brain region names and values are stacked neural activity [cell_num, n_samples].
            - session_behavior: A dictionary containing the behavior data, keys are behavior variable names and values are the corresponding data [n_samples,].
    """

    # initialize variables to store neural activity and labels
    key_activity = 'activity_APP' if mice_type == 'APP' else 'activity_control'
    brain_region = ['ALM', 'M1a', 'M1p', 'M2', 'S1fl', 'vS1', 'RSC', 'PPC'] # name of recording brain regions
    datas = {key: [] for key in brain_region} # initialize a dictionary to store the neural activity for each brain region
    session_behavior = [] # initialize an empty list to store behavior data

    s = 1
    for i, region in enumerate(brain_region):
        k = 1
        # Iterate over each mouse
        for animal_ID in range(0, len(neural_sig[key_activity])):
            # Iterate over each session
            for session_ID in range(0, len(neural_sig[key_activity][animal_ID])):
                session_sig, session_neural_activity, session_label, session_cell_index = [], [], [], []
                session_cell_index = active_cell_index[animal_ID][session_ID]
                session_sig = neural_sig[key_activity][animal_ID][session_ID][arglist.behavior_outcome]

                # get cells in each region
                target_region_activity, region_cell_index = [], []
                target_region_activity = session_sig[i]
                if np.all(element for element in target_region_activity):
                    region_cell_index = np.array(session_cell_index[i])
                    if np.any(region_cell_index) == True:
                        target_region_all_trial_type_activity, target_behavior = concatenate_all_trial_type_within_region(target_region_activity, region_cell_index, arglist.duration_start, arglist.duration_end, arglist.fs_image)
                        if target_region_all_trial_type_activity.ndim == 1:
                            target_region_all_trial_type_activity = target_region_all_trial_type_activity.reshape(1, -1)

                        if k == 1:
                            datas[region] = target_region_all_trial_type_activity.copy()
                            if s == 1:
                                session_behavior = target_behavior.copy()
                                s += 1
                            k += 1
                        else:
                            datas[region] = np.concatenate((datas[region], target_region_all_trial_type_activity), axis=0)

                        del target_region_all_trial_type_activity, target_behavior

    return datas, session_behavior


def stimulus_sampled_population(datas, labels, seed_num, arglist):
    """
        Sample the same number of cells from each brain region and form a population.
        Parameters:
            - datas: A dictionary containing neural data for each brain region. Keys are brain regions.
            - labels: A dictionary containing the behavior data. Keys are the behavior variable names and values are the corresponding data.
            - seed_num: Random seed for generating an array of seeds to sample cells from brain regions.
            - arglist: A dictionary containing the parameters for the analysis.

        Return:
            - pseudo_datas_set: A dictionary containing the neural activity for control and distractor trials.
            - pseudo_label_set: A dictionary containing the behavior data.
            - area_index: A dictionary containing the start and end indices of each brain region in the pseudo population.
        """
    area_index = {key: [] for key in datas.keys()}
    pseudo_datas = []
    # generate 8 random seeds to sample cells from 8 brain regions, respectively.
    np.random.seed(seed_num)
    seed_array = np.random.choice(1000, 8, replace=False)

    # sample the same number of cells from each brain region and stack them together.
    for i, key in enumerate(datas.keys()):
        region_data = []
        region_data = datas[key].T
        np.random.seed(seed_array[i])
        selected_cell_index = np.random.choice(region_data.shape[1], arglist.sampling_cell_num, replace=False)
        if i == 0:
            pseudo_datas = region_data[:, selected_cell_index]
            area_index[key] = [0, pseudo_datas.shape[1]]
        else:
            pseudo_datas = np.concatenate((pseudo_datas, region_data[:, selected_cell_index]), axis=1)
            area_index[key] = [area_index[list(datas.keys())[i-1]][1], pseudo_datas.shape[1]]

    # separate data into 'control', 'early', 'middle', and 'late' distractor types.
    pseudo_datas_set = {'control': [], 'early': [], 'middle': [], 'late': []}
    pseudo_label_set = {'control': {}, 'early': {}, 'middle': {}, 'late': {}}
    # get frame indexes for 'control', 'early', 'middle', and 'late' distractor trials.
    LR_control_index = np.where((labels['Trial_type'] == 0) | (labels['Trial_type'] == 1))[0]
    LR_early_index = np.where((labels['Trial_type'] == 2) | (labels['Trial_type'] == 3))[0]
    LR_mid_index = np.where((labels['Trial_type'] == 4) | (labels['Trial_type'] == 5))[0]
    LR_late_index = np.where((labels['Trial_type'] == 6) | (labels['Trial_type'] == 7))[0]
    for key in pseudo_datas_set.keys():
        if key == 'control':
            pseudo_datas_set[key] = pseudo_datas[LR_control_index, :]
            for k, v in labels.items():
                pseudo_label_set[key][k] = v[LR_control_index]
        elif key == 'early':
            pseudo_datas_set[key] = pseudo_datas[LR_early_index, :]
            for k, v in labels.items():
                pseudo_label_set[key][k] = v[LR_early_index]
        elif key == 'middle':
            pseudo_datas_set[key] = pseudo_datas[LR_mid_index, :]
            for k, v in labels.items():
                pseudo_label_set[key][k] = v[LR_mid_index]
        elif key == 'late':
            pseudo_datas_set[key] = pseudo_datas[LR_late_index, :]
            for k, v in labels.items():
                pseudo_label_set[key][k] = v[LR_late_index]

    return pseudo_datas_set, pseudo_label_set, area_index


def ablate_all_regions_except_one(datas, brain_region_index):
    """
    Keep only the specified brain region as intact and ablate all other brain regions.
    Parameters:
        - datas: ndarray
            Neural activity data with shape [n_samples, cell_num].
        - brain_region_index: tuple
            Start and end indices of the specified brain region.
    Returns:
        - ablated_datas: ndarray
            Neural activity data after the ablation procedure with shape [n_samples, cell_num].
    """

    # Extract the specified brain region
    start_idx, end_idx = brain_region_index
    keep_region = datas[:, start_idx:end_idx].copy()

    # ablate all regions except the specified brain region
    ablated_datas_temp = datas.copy()

    # Calculate the mean of each column within the extracted brain region
    column_means = np.mean(ablated_datas_temp, axis=0)

    # Create an ablated region where each column is the mean of the original column
    ablated_datas = np.tile(column_means, (ablated_datas_temp.shape[0], 1))

    # Replace the specified brain region in the copied data with the ablated region
    ablated_datas[:, start_idx:end_idx] = keep_region
    return ablated_datas
