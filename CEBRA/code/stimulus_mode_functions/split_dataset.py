import numpy as np


def split_train_test_data(data, label, ratio, random_state=42):
    """
    Split the data into training and test sets. Ensure that the data within individual trials remain intact.
    Parameters:
        - data: ndarray, shape (n_samples, cell_number).
            Calcium neural activity from no-distractor trials.
        - label: dict. keys are 'session_frame', 'left_stimulus'. Values are ndarray, shape (n_samples,).
        - ratio: float. The ratio of the training set.
        - random_state: int. Random seed.
    Returns:
        - train_datas: ndarray, shape (n_samples_train, cell_number).
            Calcium neural activity of the training set.
        - train_labels: dict. keys are 'session_frame', 'left_stimulus'. Values are ndarray, shape (n_samples_train,).
        - test_datas: ndarray, shape (n_samples_test, cell_number).
            Calcium neural activity of the testing set.
        - test_labels: dict. keys are 'session_frame', 'left_stimulus'. Values are ndarray, shape (n_samples_test,).
    """
    np.random.seed(random_state)
    
    train_datas, train_labels, test_datas, test_labels = [], [], [], []

    for i in range(2):
        trial_type_index = np.where(label['Trial_type'] == i)[0]
        trial_ID_index = np.unique(label['Trial_ID'][trial_type_index]).astype(int)

        np.random.shuffle(trial_ID_index)
        split_index = int(len(trial_ID_index) * ratio)
        trial_ID_train = trial_ID_index[:split_index]
        trial_ID_test = trial_ID_index[split_index:]

        train_indices = np.concatenate(
            [np.where(label['Trial_ID'] == trial_ID)[0] for trial_ID in trial_ID_train])
        test_indices = np.concatenate(
                [np.where(label['Trial_ID'] == trial_ID)[0] for trial_ID in trial_ID_test])

        if len(train_datas) == 0:
            train_datas, train_labels = data[train_indices, :], {k: v[train_indices] for k, v in label.items()}
        else:
            train_datas = np.concatenate((train_datas, data[train_indices, :]), axis=0)
            train_labels = {k: np.concatenate((v, label[k][train_indices]), axis=0) for k, v in train_labels.items()}

        if len(test_datas) == 0:
            test_datas, test_labels = data[test_indices, :], {k: v[test_indices] for k, v in label.items()}
        else:
            test_datas = np.concatenate((test_datas, data[test_indices, :]), axis=0)
            test_labels = {k: np.concatenate((v, label[k][test_indices]), axis=0) for k, v in test_labels.items()}

    return train_datas, train_labels, test_datas, test_labels


def k_fold_split_data(data, label,  k_folds=5):
    """
    Split the data into k folds. Ensure that the data within individual trials remain intact.

    Parameters:
        - data: ndarray, shape (n_samples, cell_number)
            Calcium neural activity from the training dataset.
        - label: dict
            Keys: 'session_frame', 'left_stimulus'
            Values: ndarray, shape (n_samples,)
        - k_folds: int
            The number of folds.

    Returns:
        - folds: list
            Each element is a tuple (train_data, train_labels, test_data, test_labels).
            - train_data: ndarray, shape (sample_num, cell_number)
                Calcium neural activity from (k-1) folds.
            - train_labels: dict
                Keys: 'session_frame', 'left_stimulus'
                Values: ndarray, shape (sample_num,)
            - test_data: ndarray, shape (sample_num, cell_number)
                Calcium neural activity from the remaining fold.
            - test_labels: dict
                Keys: 'session_frame', 'left_stimulus'
                Values: ndarray, shape (sample_num,)
"""
    folds = []

    for fold in range(k_folds):

        train_datas, train_labels, test_datas, test_labels = [], {}, [], {}

        for i in range(2):
            trial_type_index = np.where(label['Trial_type'] == i)[0]
            trial_ID_index, unique_indices = np.unique(label['Trial_ID'][trial_type_index], return_index=True)
            trial_ID_index = trial_ID_index[np.argsort(unique_indices)]

            split_index = int(len(trial_ID_index) / k_folds)
            fold_start = fold * split_index
            fold_end = fold_start + split_index if fold < k_folds - 1 else len(trial_ID_index)

            trial_ID_test = trial_ID_index[fold_start:fold_end]
            trial_ID_train = np.concatenate([trial_ID_index[:fold_start], trial_ID_index[fold_end:]])

            train_indices = np.concatenate(
                [np.where(label['Trial_ID'] == trial_ID)[0] for trial_ID in trial_ID_train])
            test_indices = np.concatenate(
                [np.where(label['Trial_ID'] == trial_ID)[0] for trial_ID in trial_ID_test])

            if len(train_datas) == 0:
                train_datas = data[train_indices, :]
                train_labels = {k: v[train_indices] for k, v in label.items()}
            else:
                train_datas = np.concatenate((train_datas, data[train_indices, :]), axis=0)
                train_labels = {k: np.concatenate((train_labels[k], v[train_indices]), axis=0) for k, v in label.items()}

            if len(test_datas) == 0:
                test_datas = data[test_indices, :]
                test_labels = {k: v[test_indices] for k, v in label.items()}
            else:
                test_datas = np.concatenate((test_datas, data[test_indices, :]), axis=0)
                test_labels = {k: np.concatenate((test_labels[k], v[test_indices]), axis=0) for k, v in label.items()}

        folds.append((train_datas, train_labels, test_datas, test_labels))

    return folds

