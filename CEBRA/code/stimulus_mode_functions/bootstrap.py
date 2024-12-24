import numpy as np


def one_tailed_bootstrap(sample1, sample2, iterations=1000, direction='greater'):

    # Perform bootstrap resampling
    resampled_mean_diffs = []
    one_tailed_p_value = []
    for _ in range(iterations):
        resampled_sample1 = np.random.choice(sample1, size=len(sample1), replace=True)
        resampled_sample2 = np.random.choice(sample2, size=len(sample2), replace=True)
        resampled_diffs = resampled_sample1.mean() - resampled_sample2.mean()
        resampled_mean_diffs.append(resampled_diffs)

    # Calculate the bootstrap p-value
    resampled_mean_diffs = np.array(resampled_mean_diffs)
    if direction == 'greater':
        one_tailed_p_value = np.sum(resampled_mean_diffs <= 0) / iterations
    elif direction == 'less':
        one_tailed_p_value = np.sum(resampled_mean_diffs >= 0) / iterations

    return one_tailed_p_value


# calculate P-value
def compute_p_value(decoding_accuracy_control_mice_summary, decoding_accuracy_app_mice_summary, arglist, distractor_type=None):

    brain_region = ['ALM', 'M1a', 'M1p', 'M2', 'S1fl', 'vS1', 'RSC', 'PPC']
    distractor = {'early': [], 'middle': [], 'late': []}
    distractor['early'] = round((arglist.distractor_early - arglist.duration_start) * arglist.fs_image) - 1
    distractor['middle'] = round((arglist.distractor_mid - arglist.duration_start) * arglist.fs_image) - 1
    distractor['late'] = round((arglist.distractor_late - arglist.duration_start) * arglist.fs_image) - 1

    distractor_1s_after = distractor[distractor_type] + round(1 * arglist.fs_image)

    # get seed array
    seed_array_control_mice = list(decoding_accuracy_control_mice_summary.keys())
    region_decoding_accuracy_control_mice = {region_name: [] for region_name in brain_region}
    region_decoding_accuracy_app_mice = {region_name: [] for region_name in brain_region}

    # get region data
    for region_name in brain_region:
        for seed_num in seed_array_control_mice:
            region_decoding_accuracy_control_mice[region_name].append(decoding_accuracy_control_mice_summary[seed_num][distractor_type][region_name])
            region_decoding_accuracy_app_mice[region_name].append(decoding_accuracy_app_mice_summary[seed_num][distractor_type][region_name])

    # compare control vs APP
    p_value = []
    for region_name in brain_region:
        control_array_temp = np.array(region_decoding_accuracy_control_mice[region_name])
        control_temp = np.mean(control_array_temp[:, distractor[distractor_type]:distractor_1s_after], axis=1)
        app_array_temp = np.array(region_decoding_accuracy_app_mice[region_name])
        app_temp = np.mean(app_array_temp[:, distractor[distractor_type]:distractor_1s_after], axis=1)
        p_value.append(one_tailed_bootstrap(control_temp, app_temp, iterations=1000, direction='greater'))
        del control_array_temp, control_temp, app_array_temp, app_temp

    return p_value
