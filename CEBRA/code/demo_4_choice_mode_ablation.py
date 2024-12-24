import mat73
import argparse
import numpy as np
import cebra
from pathlib import Path
from choice_mode_functions.combine_all_trials_all_brain_regions import dataset_all_sessions, choice_sampled_population, ablate_all_regions_except_one
from choice_mode_functions.split_dataset import split_train_test_data
from choice_mode_functions.plot_functions import decoding_accuracy_control_vs_app_mice_ablation, plot_bar_panel_control_vs_app_mice_decoding_accuracy_ablation, plot_p_value_significance
from choice_mode_functions.decoder_functions import knn_decoder_function_ablation, knn_decoder_distractor_ablation
from choice_mode_functions.bootstrap import compute_p_value
from choice_mode_functions.default_ops import default_ops
from statsmodels.stats.multitest import multipletests
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

    # get random seeds to sample neural populations
    np.random.seed(arglist.seed_cells)
    seed_array = np.random.choice(1000, arglist.number_population, replace=False)
    seed_behavior_trials = arglist.seed_behavior_trials

    # create a dictionary to store decoding accuracy for test sets.
    decoding_accuracy_summary = {mice: {seed_value: [] for seed_value in seed_array} for mice in arglist.mice_type}
    # create a dictionary to store decoding accuracy of distractor trials
    distractor_decoding_accuracy_summary = {mice: {seed_value: {distractor_type: [] for distractor_type in ['early', 'middle', 'late']} for seed_value in seed_array} for mice in arglist.mice_type}
    # create a dictionary to store relative decoding accuracy
    distractor_relative_decoding_accuracy_summary = {
        mice: {seed_value: {distractor_type: {} for distractor_type in ['early', 'middle', 'late']} for seed_value in
               seed_array} for mice in arglist.mice_type}

    for mice in arglist.mice_type:
        print('Processing data for ' + mice + ' mice')
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
            data_seed, label_seed, brain_region_index = choice_sampled_population(all_subjects_data, all_subjects_label, seed_num, arglist)

            for key in data_seed.keys():
                if key == 'control':
                    # split training and testing sets
                    train_datas_set, train_labels_set, test_datas_set, test_labels_set = split_train_test_data(data_seed[key], label_seed[key], ratio=arglist.train_ratio, random_state=42 + seed_num)
                    temp_save_path = Path(model_save_path) / f'seed_ID_{seed_num}' / key
                    tmp_dir = temp_save_path / 'tmp'
                    tmp_file = tmp_dir / 'train_cebra_model.pt'

                    # load the trained cebra model
                    cebra_model = cebra.CEBRA.load(tmp_file)

                    # get the neural embedding for the training and testing datasets
                    embeddings_train = cebra_model.transform(train_datas_set)
                    embeddings_test = cebra_model.transform(test_datas_set)

                    # perform ablation in the testing dataset
                    ablation_test_dataset = {region: [] for region in brain_region_index.keys()}
                    ablation_test_embedding = {region: [] for region in brain_region_index.keys()}
                    ablation_test_embedding['Original'] = embeddings_test

                    for region_index, region in enumerate(brain_region_index.keys()):
                        ablation_test_dataset[region] = ablate_all_regions_except_one(test_datas_set, brain_region_index[region])
                        ablation_test_embedding[region] = cebra_model.transform(ablation_test_dataset[region])

                    # decoding accuracy of ablated embeddings of test set
                    decoding_accuracy_summary[mice][seed_num], KNN_decoder = knn_decoder_function_ablation(embeddings_train, train_labels_set, ablation_test_embedding, test_labels_set, arglist, K_num=arglist.K_num)

                else:
                    # perform ablation in distractor datasets
                    ablation_distractor_dataset = {region: [] for region in brain_region_index.keys()}
                    ablation_distractor_embedding = {region: [] for region in brain_region_index.keys()}

                    # get embeddings from distractor datasets
                    embedding_distractor_original = cebra_model.transform(data_seed[key])
                    ablation_distractor_embedding['Original'] = embedding_distractor_original

                    for region_index, region in enumerate(brain_region_index.keys()):
                        ablation_distractor_dataset[region] = ablate_all_regions_except_one(data_seed[key], brain_region_index[region])
                        ablation_distractor_embedding[region] = cebra_model.transform(ablation_distractor_dataset[region])

                    # decoding accuracy of ablated embeddings on distractor datasets
                    distractor_decoding_accuracy_summary[mice][seed_num][key] = knn_decoder_distractor_ablation(KNN_decoder, ablation_distractor_embedding, label_seed[key], arglist)

    # calculate relative decoding accuracy
    for mice in arglist.mice_type:
        for seed_num in seed_array:
            for region in decoding_accuracy_summary[mice][seed_num].keys():
                distractor_relative_decoding_accuracy_summary[mice][seed_num]['early'][region] = distractor_decoding_accuracy_summary[mice][seed_num]['early'][region] - decoding_accuracy_summary[mice][seed_num][region]
                distractor_relative_decoding_accuracy_summary[mice][seed_num]['middle'][region] = distractor_decoding_accuracy_summary[mice][seed_num]['middle'][region] - decoding_accuracy_summary[mice][seed_num][region]
                distractor_relative_decoding_accuracy_summary[mice][seed_num]['late'][region] = distractor_decoding_accuracy_summary[mice][seed_num]['late'][region] - decoding_accuracy_summary[mice][seed_num][region]

    # plot relative decoding accuracy
    brain_region = ['ALM', 'M1a', 'M1p', 'M2', 'S1fl', 'vS1', 'RSC', 'PPC']
    index = 0
    fig1 = plt.figure(figsize=(24, 12))
    for mice in arglist.mice_type:
        for region in brain_region:
            ax = fig1.add_subplot(2, 8, index + 1)
            ax = decoding_accuracy_control_vs_app_mice_ablation(ax, distractor_relative_decoding_accuracy_summary[mice], arglist, region, mice)
            index += 1
    plt.savefig(save_path_root / 'choice_mode_relative_decoding_accuracy_ablation.svg')
    # plt.close()

    # bar plot of relative decoding accuracy
    fig2 = plt.figure(figsize=(12, 4))
    ax = fig2.add_subplot(111)
    ax = plot_bar_panel_control_vs_app_mice_decoding_accuracy_ablation(ax, distractor_relative_decoding_accuracy_summary['control'], distractor_relative_decoding_accuracy_summary['APP'], arglist)
    plt.savefig(save_path_root / 'choice_mode_relative_decoding_accuracy_bar_graph_ablation.svg')
    # plt.close()

    # calculate P-value
    p_value_decoding_accuracy_average = {'early': [], 'middle': [], 'late': []}
    p_value_combined = []
    distractors = ['early', 'middle', 'late']
    for type_distractor in distractors:
        p_value_temp = compute_p_value(distractor_relative_decoding_accuracy_summary['control'], distractor_relative_decoding_accuracy_summary['APP'], arglist, distractor_type=type_distractor)
        p_value_combined.extend(p_value_temp)
        del p_value_temp

    # FDR correction
    p_value_combined = np.array(p_value_combined)
    _, fdr_corrected_p_value, _, _ = multipletests(p_value_combined, alpha=0.05, method='fdr_bh')
    p_value_decoding_accuracy_average['early'] = fdr_corrected_p_value[:8]
    p_value_decoding_accuracy_average['middle'] = fdr_corrected_p_value[8:16]
    p_value_decoding_accuracy_average['late'] = fdr_corrected_p_value[16:]

    # display p-value
    fig3, ax = plt.subplots(figsize=(4, 4))
    ax = plot_p_value_significance(p_value_decoding_accuracy_average, ax)
    plt.tight_layout()
    plt.savefig(save_path_root / 'choice_mode_relative_decoding_accuracy_ablation_p_value.svg')

    # show the plot
    plt.show()


