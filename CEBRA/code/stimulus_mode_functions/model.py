import numpy as np
from cebra import CEBRA
import cebra
from pathlib import Path
import matplotlib.pyplot as plt
from stimulus_mode_functions.plot_functions import plot_embedding_cross_validation
from stimulus_mode_functions.utils import set_seed


# define cebra model
def cebra_model_function(arglist: object, lr: object, num_hidden_units: object, weight_decay: object) -> object:
    cebra_model = CEBRA(model_architecture=arglist.model_name,
                                     batch_size=arglist.batch_size,
                                     learning_rate=lr,
                                     temperature=arglist.temperature,
                                     output_dimension=arglist.output_dimension,
                                     max_iterations=arglist.max_iterations,
                                     distance=arglist.distance,
                                     conditional=arglist.conditional,
                                     device=arglist.device,
                                     verbose=True,
                                     hybrid=arglist.hybrid,
                                     num_hidden_units=num_hidden_units,
                                     time_offsets=arglist.time_offsets,
                                     optimizer_kwargs=(('weight_decay', weight_decay),))

    return cebra_model


def hyperparameter_search(folds_cv, arglist, save_path, seed_num, mice_type='control'):
    """
    Conduct a hyperparameter search for the CEBRA model.
    Parameters:
        - folds_cv: list
            Each element is a tuple (train_data, train_labels, test_data, test_labels).
        - arglist: dict
            A dictionary containing the parameters for the CEBRA model.
        - save_path: str
            The path to save model weights and the results of the hyperparameter search.
        - mice_type: str
            The type of mice: 'control' OR 'APP-KI'.
    Returns:
        - best_hyperparameters: dict
            The best hyperparameters that achieve the highest performance on the validation
    """

    # hyperparameter search
    lr_set = [0.001]
    weight_decay_set = [1e-4, 1e-5, 1e-6]
    num_hidden_units_set = [512]

    results_path = Path(save_path) / (mice_type + '_grid_search_results.txt')
    best_hyperparameters = {'lr': [], 'num_hidden_units': [], 'weight_decay': [], 'fold_scores': 100}
    with results_path.open('w') as file:
        k = 0
        for lr in lr_set:
            for num_hidden_units in num_hidden_units_set:
                for weight_decay in weight_decay_set:
                    k += 1
                    fold_scores, embeddings_train, embeddings_val = [], [], []
                    if arglist.set_seed_model_init:
                        set_seed(seed_num+k, device_id=arglist.device)
                    for fold_idx, (train_datas, train_label_dicts, val_datas, val_label_dicts) in enumerate(folds_cv):
                        # prepare label
                        train_labels = np.stack([v for key, v in train_label_dicts.items() if key not in {'Trial_ID', 'Trial_type'}], axis=1)
                        val_labels = np.stack([v for key, v in val_label_dicts.items() if key not in {'Trial_ID', 'Trial_type'}], axis=1)

                        # cebra model
                        cebra_model = CEBRA(model_architecture=arglist.model_name,
                                            batch_size=arglist.batch_size,
                                            learning_rate=lr,
                                            temperature=arglist.temperature,
                                            output_dimension=arglist.output_dimension,
                                            max_iterations=arglist.max_iterations,
                                            distance=arglist.distance,
                                            conditional=arglist.conditional,
                                            device=arglist.device,
                                            verbose=True,
                                            hybrid=arglist.hybrid,
                                            num_hidden_units=num_hidden_units,
                                            time_offsets=arglist.time_offsets,
                                            optimizer_kwargs=(('weight_decay', weight_decay),))

                        # fit model
                        cebra_model.fit(train_datas, train_labels)
                        cebra.plot_loss(cebra_model)

                        # Define and create the figure save path
                        fig_save_path = Path(save_path) / f'set_{k}'
                        fig_save_path.mkdir(parents=True, exist_ok=True)

                        # Save the loss plot
                        plt.savefig(fig_save_path / f'cebra_loss_folds_ID_{fold_idx}.svg')
                        plt.close()

                        if arglist.save_intermediate_results:
                            # Define and create the temporary file path
                            tmp_dir = fig_save_path / 'tmp'
                            tmp_dir.mkdir(parents=True, exist_ok=True)
                            tmp_file = tmp_dir / f'cebra_model_folds_ID_{fold_idx}.pt'
                            cebra_model.save(tmp_file)

                            # embeddings for the training set
                            embeddings_train = cebra_model.transform(train_datas)

                            # embeddings for the validation set
                            embeddings_val = cebra_model.transform(val_datas)

                            # plot embedding and save for the training set
                            save_trial_path = Path(save_path) / f'set_{k}'
                            save_trial_path.mkdir(parents=True, exist_ok=True)
                            save_file_name = save_trial_path / f'train_fold_ID_{fold_idx}.svg'
                            plot_embedding_cross_validation(embeddings_train, train_label_dicts, save_file_name, start_time=arglist.duration_start, end_time=arglist.duration_end, idx_order=(0, 1, 2))

                            # plot embedding and save for the testing set
                            save_file_name = save_trial_path / f'val_fold_ID_{fold_idx}.svg'
                            plot_embedding_cross_validation(embeddings_val, val_label_dicts, save_file_name, start_time=arglist.duration_start, end_time=arglist.duration_end, idx_order=(0, 1, 2))

                        # evaluate model performance on the validation set
                        goodness_of_fit = cebra.sklearn.metrics.infonce_loss(cebra_model, val_datas,val_labels, num_batches=500)
                        fold_scores.append(goodness_of_fit)

                    fold_scores = np.array(fold_scores)
                    # record the best hyperparameters
                    if fold_scores.mean() < best_hyperparameters['fold_scores']:
                        best_hyperparameters['lr'] = lr
                        best_hyperparameters['num_hidden_units'] = num_hidden_units
                        best_hyperparameters['weight_decay'] = weight_decay
                        best_hyperparameters['fold_scores'] = fold_scores.mean()

                    # print to console
                    output = (f'lr: {lr}, num_hidden_units: {num_hidden_units}, '
                              f'weight_decay: {weight_decay}, '
                              f'fold_scores: {np.mean(fold_scores)}')
                    print(output)
                    # write to file
                    file.write(output + '\n')

    return best_hyperparameters

