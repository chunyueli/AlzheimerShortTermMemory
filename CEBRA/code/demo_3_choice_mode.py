import mat73
import argparse
import numpy as np
import cebra
from choice_mode_functions.combine_all_trials_all_brain_regions import dataset_all_sessions, choice_sampled_population
from choice_mode_functions.split_dataset import split_train_test_data, k_fold_split_data
from choice_mode_functions.model import cebra_model_function, hyperparameter_search
from choice_mode_functions.plot_functions import plot_embedding, plot_distractor_trials_decoding_accuracy, plot_bar_panel_control_vs_app_mice_decoding_accuracy
from choice_mode_functions.decoder_functions import knn_decoder_function, knn_decoder_distractor
from choice_mode_functions.default_ops import default_ops
from choice_mode_functions.bootstrap import one_tailed_bootstrap
from statsmodels.stats.multitest import multipletests
from pathlib import Path
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('TkAgg')


# parse arguments
def get_choice_mode_args():
    parser = argparse.ArgumentParser(description='choice mode')

    # load default arguments
    ops0 = default_ops()
    for k, v in ops0.items():
        if isinstance(v, bool):
            parser.add_argument(
                f"--{k}",
                type=str,
                default=str(v),
                choices=["True", "False"],
                help=f"{k} (default: {v})"
            )
        else:
            arg_config = {
                "default": v,
                "help": f"{k} : {v}"
            }
            if isinstance(v, (np.ndarray, list)) and len(v):
                arg_config["nargs"] = "+"
                arg_config["type"] = type(v[0])
            elif v is not None:
                arg_config["type"] = type(v)
            parser.add_argument(f"--{k}", **arg_config)

    # Parse the arguments
    args = parser.parse_args()

    # Convert boolean arguments back to Python bool
    for k, v in ops0.items():
        if isinstance(v, bool):
            setattr(args, k, args.__dict__[k] == "True")

    # modify the default arguments
    args.root_path = Path(args.root_path)
    args.data_path = Path(args.data_path)
    args.model_save_path = Path(args.model_save_path)

    return args


if __name__ == '__main__':
    arglist = get_choice_mode_args()

    # create a folder to save figures
    save_path_root = arglist.root_path / "figures"
    save_path_root.mkdir(parents=True, exist_ok=True)

    # create a dictionary to store decoding accuracy.
    decoding_accuracy_summary = {mice: {'train': [], 'test': [], 'early': [], 'middle': [], 'late': []} for mice in arglist.mice_type}

    # create a dictionary to store the average decoding accuracy for the 1-second period after distractor presentation.
    decoding_accuracy_average_summary = {
        mice: {
            'early': [], 'middle': [], 'late': [],
        }
        for mice in arglist.mice_type
    }

    # get random seeds to sample neural populations
    np.random.seed(arglist.seed_cells)
    seed_array = np.random.choice(1000, arglist.number_population, replace=False)
    seed_behavior_trials = arglist.seed_behavior_trials

    # create a dictionary to store neural embeddings and labels
    embedding_seeds = {
        mice: {
            seed_value: {'train': {'embedding': [], 'label': []}, 'test': {'embedding': [], 'label': []},
                   'early': {'embedding': [], 'label': []}, 'middle': {'embedding': [], 'label': []},
                   'late': {'embedding': [], 'label': []}}
            for seed_value in seed_array
        }
        for mice in arglist.mice_type
    }

    for mice in arglist.mice_type:
        print('processing data for ' + mice + ' mice')
        model_save_path = arglist.model_save_path / mice
        model_save_path.mkdir(parents=True, exist_ok=True)

        # load calcium neural activity and active cell index
        neural_activity = mat73.loadmat(arglist.data_path / f'deconvolved_calcium_signal_{mice}.mat')
        active_cell_index = mat73.loadmat(arglist.data_path / 'cell_idx.mat')
        cell_index = active_cell_index['cell_idx'][mice]
        del active_cell_index

        for i, seed_num in enumerate(seed_array):
            # use different seeds to sample behavior trials
            arglist.seed_behavior_trials = seed_behavior_trials + seed_num

            # group active cells of the same brain region across sessions
            all_subjects_data, all_subjects_label = dataset_all_sessions(neural_activity, cell_index, arglist, mice_type=mice)
            data_seed, label_seed, _ = choice_sampled_population(all_subjects_data, all_subjects_label, seed_num, arglist)
            distractor_embedding = {'early': [], 'middle': [], 'late': []}

            for key in data_seed.keys():
                if key == 'control':
                    # split training and testing datasets
                    train_datas_set, train_labels_set, test_datas_set, test_labels_set = split_train_test_data(
                        data_seed[key], label_seed[key], ratio=arglist.train_ratio, random_state=42 + seed_num)
                    temp_save_path = Path(model_save_path) / f'seed_ID_{seed_num}' / key
                    tmp_dir = temp_save_path / 'tmp'
                    tmp_file = tmp_dir / 'train_cebra_model.pt'

                    # Ensure directories exist
                    tmp_dir.mkdir(parents=True, exist_ok=True)

                    # If the model has been trained, load the model from the saved file, otherwise train the model.
                    if arglist.model_trained:
                        train_labels = np.stack(
                            [v for k, v in train_labels_set.items() if k not in {'Trial_ID', 'Trial_type'}],
                            axis=1)
                        cebra_model = cebra.CEBRA.load(tmp_file)
                    else:
                        # choose the best hyperparameter set using cross validation
                        control_cross_validation_folds = k_fold_split_data(train_datas_set, train_labels_set, k_folds=arglist.num_folds)
                        control_best_hyperparameters = hyperparameter_search(control_cross_validation_folds, arglist, temp_save_path, seed_num, mice_type=mice)

                        # train and evaluate the model with best hyperparameters
                        lr = control_best_hyperparameters['lr']
                        num_hidden_units = control_best_hyperparameters['num_hidden_units']
                        weight_decay = control_best_hyperparameters['weight_decay']

                        # initialize a cebra model with the best hyperparameters
                        cebra_model = cebra_model_function(arglist, lr, num_hidden_units, weight_decay)

                        # train the model on the training dataset
                        train_labels = np.stack([v for k, v in train_labels_set.items() if k not in {'Trial_ID', 'Trial_type'}], axis=1)
                        cebra_model.fit(train_datas_set, train_labels)
                        cebra_model.save(tmp_file)
                        cebra.plot_loss(cebra_model)
                        plt.savefig(temp_save_path / 'control_cebra_loss.svg')
                        plt.close()
                        
                    # get embeddings for train and test datasets
                    train_embedding = cebra_model.transform(train_datas_set)
                    test_embedding = cebra_model.transform(test_datas_set)

                    # save neural embeddings and labels for train and test datasets
                    embedding_seeds[mice][seed_num]['train']['embedding'] = train_embedding
                    embedding_seeds[mice][seed_num]['test']['embedding'] = test_embedding
                    embedding_seeds[mice][seed_num]['train']['label'] = train_labels_set
                    embedding_seeds[mice][seed_num]['test']['label'] = test_labels_set

                    # decode left and right choice for train and test datasets
                    train_decoding_accuracy, test_decoding_accuracy, KNN_decoder = knn_decoder_function(train_embedding, train_labels_set, test_embedding, test_labels_set, arglist, K_num=arglist.K_num)
                    decoding_accuracy_summary[mice]['train'].append(train_decoding_accuracy)
                    decoding_accuracy_summary[mice]['test'].append(test_decoding_accuracy)

                else:
                    # get embeddings for distractor trials
                    distractor_embedding[key] = cebra_model.transform(data_seed[key])

                    # save neural embeddings and labels for distractor trials
                    embedding_seeds[mice][seed_num][key]['embedding'] = distractor_embedding[key]
                    embedding_seeds[mice][seed_num][key]['label'] = label_seed[key]

            decoding_accuracy_average_summary[mice], decoding_accuracy_summary[mice] = knn_decoder_distractor(KNN_decoder, test_decoding_accuracy, distractor_embedding, label_seed, decoding_accuracy_average_summary[mice], decoding_accuracy_summary[mice], arglist)

    # plot example neural embeddings
    fig1 = plt.figure(figsize=(10, 3), constrained_layout=True)
    for mice in arglist.mice_type:
        if mice == 'control':
            seed_num = 855
            fig_id = 0
        else:
            seed_num = 336
            fig_id = 4

        ax = fig1.add_subplot(2, 4, fig_id+1, projection='3d')
        ax = plot_embedding(ax, embedding_seeds[mice][seed_num]['test']['embedding'], embedding_seeds[mice][seed_num]['test']['label'], 'no distractor', mice)
        ax = fig1.add_subplot(2, 4, fig_id+2, projection='3d')
        ax = plot_embedding(ax, embedding_seeds[mice][seed_num]['early']['embedding'], embedding_seeds[mice][seed_num]['early']['label'], 'early', mice)
        ax = fig1.add_subplot(2, 4, fig_id+3, projection='3d')
        ax = plot_embedding(ax, embedding_seeds[mice][seed_num]['middle']['embedding'], embedding_seeds[mice][seed_num]['middle']['label'], 'middle', mice)
        ax = fig1.add_subplot(2, 4, fig_id+4, projection='3d')
        ax = plot_embedding(ax, embedding_seeds[mice][seed_num]['late']['embedding'], embedding_seeds[mice][seed_num]['late']['label'], 'late', mice)
    plt.savefig(save_path_root / 'choice_mode_neural_embedding_examples.svg', format='svg')
    # plt.close()

    # plot relative decoding accuracy
    fig2 = plt.figure(figsize=(10, 5))
    fig_id = 0
    for mice in arglist.mice_type:
        ax = fig2.add_subplot(1, 2, fig_id + 1)
        decoding_accuracy_early = np.array(decoding_accuracy_summary[mice]['early']) - np.array(decoding_accuracy_summary[mice]['test'])
        decoding_accuracy_middle = np.array(decoding_accuracy_summary[mice]['middle']) - np.array(decoding_accuracy_summary[mice]['test'])
        decoding_accuracy_late = np.array(decoding_accuracy_summary[mice]['late']) - np.array(decoding_accuracy_summary[mice]['test'])
        ax = plot_distractor_trials_decoding_accuracy(ax, arglist, decoding_accuracy_early, decoding_accuracy_middle, decoding_accuracy_late, len(seed_array), mice)
        fig_id += 1
    plt.savefig(save_path_root / 'choice_mode_relative_decoding_accuracy.svg', format='svg')
    # plt.close()

    # bar plot of relative decoding accuracy
    fig3 = plt.figure(figsize=(6, 4))
    ax = fig3.add_subplot(111)
    ax = plot_bar_panel_control_vs_app_mice_decoding_accuracy(ax, decoding_accuracy_average_summary['control'], decoding_accuracy_average_summary['APP'])
    plt.savefig(save_path_root / 'choice_mode_relative_decoding_accuracy_bar_graph.svg', format='svg')
    # plt.close()

    # Perform bootstrap test to compare the average decoding accuracy between control and APP mice
    p_value_decoding_accuracy_average = {'early': [], 'middle': [], 'late': []}
    for distractor_type in ['early', 'middle', 'late']:
        p_value_decoding_accuracy_average[distractor_type] = one_tailed_bootstrap(decoding_accuracy_average_summary['control'][distractor_type], decoding_accuracy_average_summary['APP'][distractor_type], iterations=1000, direction='greater')

    # FDR correction
    p_value_decoding_accuracy_average_list = [p_value_decoding_accuracy_average[distractor_type] for distractor_type in ['early', 'middle', 'late']]
    _, fdr_corrected_p_value_decoding_accuracy_average, _, _ = multipletests(p_value_decoding_accuracy_average_list, alpha=0.05, method='fdr_bh')

    # display p-value
    print('FDR corrected p value (early, middle, late):', fdr_corrected_p_value_decoding_accuracy_average)


    # show the plot
    plt.show()
