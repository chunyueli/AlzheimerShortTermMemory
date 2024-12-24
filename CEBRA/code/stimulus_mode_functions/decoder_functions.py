import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import cebra


def knn_decoder_function(embedding_train, label_train, embedding_test, label_test, arglist, K_num=1):
    """
    Calculate temporal decoding accuracy for no-distractor trials (training and testing dataset).
    Parameters:
        - embedding_train: ndarray, shape (n_samples, n_features)
            Neural embedding from the training dataset.
        - label_train: dict with keys 'left_stimulus' and 'session_frame'. Values are ndarray, shape (n_samples,).
            Behavior labels from the training dataset.
        - embedding_test: ndarray, shape (n_samples, n_features)
            Neural embedding from the testing dataset.
        - label_test: dict with keys 'left_stimulus' and 'session_frame'. Values are ndarray, shape (n_samples,).
            Behavior labels from the testing dataset.
        - arglist: dict containing trial information.
        - K_num: int, default 1
            An integer indicating the K number of neighbors to consider for k-nearest neighbors decoder.
    Returns:
        - test_accuracy: ndarray
            The temporal decoding accuracy for the testing dataset.
        - train_accuracy: ndarray
            The temporal decoding accuracy for the training dataset.
        - KNN_decoder: KNNDecoder
            The trained KNN decoder object.
    """

    start_index = round(arglist.duration_start * arglist.fs_image) - 1
    end_index = round(arglist.duration_end * arglist.fs_image) - 1
    Trial_len = end_index - start_index + 1

    # KNN decoder is trained on the training dataset
    KNN_decoder = cebra.KNNDecoder(n_neighbors=K_num, metric="cosine")
    KNN_decoder.fit(embedding_train, label_train['left_stimulus'])
    predicted_label_train = KNN_decoder.predict(embedding_train)
    predicted_label_train_reshape = predicted_label_train.reshape(-1, Trial_len)
    train_label_reshape = label_train['left_stimulus'].reshape(-1, Trial_len)
    # calculate accuracy on the training dataset
    train_accuracy = (predicted_label_train_reshape == train_label_reshape).mean(axis=0)
    train_accuracy = train_accuracy * 100

    # use the trained KNN decoder to predict the stimuli label on testing dataset
    predicted_label_test = KNN_decoder.predict(embedding_test)
    predicted_label_test_reshape = predicted_label_test.reshape(-1, Trial_len)
    test_label_reshape = label_test['left_stimulus'].reshape(-1, Trial_len)
    # calculate accuracy on the testing dataset
    test_accuracy = (predicted_label_test_reshape == test_label_reshape).mean(axis=0)
    test_accuracy = test_accuracy * 100

    return train_accuracy, test_accuracy, KNN_decoder


def knn_decoder_function_ablation(embedding_original, label, embedding_ablation, test_label, arglist, K_num=1):
    """
    Calculate temporal decoding accuracy for ablated testing dataset.
    Parameters:
        - embedding_original: ndarray, shape (n_samples, n_features)
            Neural embedding of the intact training dataset.
        - label: dict with keys 'left_stimulus', 'session_frame'. Values are ndarray, shape (n_samples,).
            Behavior labels of training dataset.
        - embedding_ablation: dict with keys 'ALM', 'M1a', 'M1p', 'M2', 'S1fl', 'vS1', 'RSC', 'PPC'. Values are ndarray, shape (n_samples, n_features).
            Neural embedding of ablated testing dataset.
        - test_label: dict with keys 'left_stimulus', 'session_frame'. Values are ndarray, shape (n_samples,).
            Behavior labels of the testing dataset.
        - arglist: dict containing trial information.
        - K_num: int, default 1
            An integer indicating the K number of neighbors to consider for k-nearest neighbors decoder.
    Return:
        - decoding_ACC: dict with keys 'control', 'ALM', 'M1a', 'M1p', 'M2', 'S1fl', 'vS1', 'RSC', 'PPC'. Values are list.
            The list stores the temporal decoding accuracy for each ablation dataset.
        - KNN_decoder: KNNDecoder
            A trained KNN decoder.
    """

    start_index = round(arglist.duration_start * arglist.fs_image) - 1
    end_index = round(arglist.duration_end * arglist.fs_image) - 1
    Trial_len = end_index - start_index + 1

    # use the training dataset to train the KNN decoder
    KNN_decoder = cebra.KNNDecoder(n_neighbors=K_num, metric="cosine")
    KNN_decoder.fit(embedding_original, label['left_stimulus'])
    predicted_label_train = KNN_decoder.predict(embedding_original)
    predicted_label_train_reshape = predicted_label_train.reshape(-1, Trial_len)
    train_label_reshape = label['left_stimulus'].reshape(-1, Trial_len)
    accuracy_train = (predicted_label_train_reshape == train_label_reshape).mean(axis=0)

    # predict and calculate decoding accuracy for each ablation datasets
    decoding_ACC = {key: [] for key in embedding_ablation.keys()}
    test_label_reshape = test_label['left_stimulus'].reshape(-1, Trial_len)
    for region_index, region in enumerate(embedding_ablation.keys()):
        predicted_label_test = KNN_decoder.predict(embedding_ablation[region])
        predicted_label_test_reshape = predicted_label_test.reshape(-1, Trial_len)
        temp_acc = (predicted_label_test_reshape == test_label_reshape).mean(axis=0)
        decoding_ACC[region] = temp_acc*100

    return decoding_ACC, KNN_decoder


def knn_decoder_distractor(KNN_decoder, decoding_ACC_test, embedding_distractor, label_distractor, decoding_ACC_AVG_set, decoding_ACC_curve_dict, arglist):
    """
    Calculate temporal decoding accuracy for distractor trials.
    Parameters:
        - KNN_decoder: KNNDecoder
            A trained KNN decoder.
        - decoding_ACC_test: ndarray, shape (n_samples,)
            Temporal decoding accuracy for the testing dataset.
        - embedding_distractor: ndarray, shape (n_samples, n_features)
            Neural embedding from the distractor trials.
        - label_distractor: dict with keys 'left_stimulus' and 'session_frame'. Values are ndarray, shape (n_samples,).
            Behavior labels from the distractor trials.
        - decoding_ACC_AVG_set: dict with keys 'early', 'middle', 'late'. Values are list.
            The averaged decoding accuracy during 1s after distractor onset for each distractor type.
        - decoding_ACC_curve_dict: dict with keys 'train', 'test', 'early', 'middle', 'late'. Values are list.
            Temporal decoding accuracy for each distractor type.
    Returns:
        - decoding_ACC_AVG_set: dict with keys 'early', 'middle', 'late'. Values are list.
        - decoding_ACC_curve_dict: dict with keys 'train', 'test', 'early', 'middle', 'late'. Values are list.
    """

    start_index = round(arglist.duration_start * arglist.fs_image) - 1
    end_index = round(arglist.duration_end * arglist.fs_image) - 1
    Trial_len = end_index - start_index + 1

    distractor = {'early': [], 'middle': [], 'late': []}
    distractor['early'] = round((arglist.distractor_early - arglist.duration_start) * arglist.fs_image) - 1
    distractor['middle'] = round((arglist.distractor_mid - arglist.duration_start) * arglist.fs_image) - 1
    distractor['late'] = round((arglist.distractor_late - arglist.duration_start) * arglist.fs_image) - 1

    for key in embedding_distractor.keys():
        predicted_label_test = KNN_decoder.predict(embedding_distractor[key])
        predicted_label_test_reshape = predicted_label_test.reshape(-1, Trial_len)
        test_label_reshape = label_distractor[key]['left_stimulus'].reshape(-1, Trial_len)

        accuracy_distractor = (predicted_label_test_reshape == test_label_reshape).mean(axis=0)
        accuracy_distractor = accuracy_distractor * 100
        decoding_ACC_curve_dict[key].append(accuracy_distractor)
        decoding_ACC_relative_to_test = accuracy_distractor - decoding_ACC_test

        # calculate average decoding accuracy during 1s after distractor onset
        distractor_1s_after = distractor[key] + round(1 * arglist.fs_image)
        distractor_ACC_AVG = np.mean(decoding_ACC_relative_to_test[distractor[key]:distractor_1s_after])
        decoding_ACC_AVG_set[key].append(distractor_ACC_AVG)

    return decoding_ACC_AVG_set, decoding_ACC_curve_dict


def knn_decoder_distractor_ablation(KNN_decoder, embedding_test, label_test, arglist):
    """
    Calculate the temporal decoding accuracy for ablated dataset of distractor trials.
    Parameters:
        - KNN_decoder: KNNDecoder
            A trained KNN decoder.
        - embedding_test: ndarray, shape (n_samples, n_features)
            Neural embedding from the distractor dataset.
        - label_test: dict with keys 'left_stimulus' and 'session_frame'. Values are ndarray, shape (n_samples,).
            Behavior labels from the distractor dataset.
        - arglist: dict containing trial information.
    Returns:
        - accuracy_test: dict with keys 'control', 'ALM', 'M1a', 'M1p', 'M2', 'S1fl', 'vS1', 'RSC', 'PPC'. Values are list.
            Temporal decoding accuracy of ablated neural embeddings of distractor trials.
    """

    start_index = round(arglist.duration_start * arglist.fs_image) - 1
    end_index = round(arglist.duration_end * arglist.fs_image) - 1
    Trial_len = end_index - start_index + 1

    # predict and calculate decoding accuracy
    accuracy_test = {key: [] for key in embedding_test.keys()}
    for region in embedding_test.keys():
        predicted_label_test = KNN_decoder.predict(embedding_test[region])
        predicted_label_test_reshape = predicted_label_test.reshape(-1, Trial_len)
        test_label_reshape = label_test['left_stimulus'].reshape(-1, Trial_len)
        temp_acc = (predicted_label_test_reshape == test_label_reshape).mean(axis=0)
        accuracy_test[region] = temp_acc*100

    return accuracy_test