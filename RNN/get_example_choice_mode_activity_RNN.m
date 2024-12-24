function RNN_variable = get_example_choice_mode_activity_RNN

close all
clear all
clc

% Extract RNN variables.

% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)
load('example_RNN.mat');

% Control.
L = example_RNN.example_distractor_2_5_no_ablation_control.L;
L_pos = example_RNN.example_distractor_2_5_no_ablation_control.L_pos;
R = example_RNN.example_distractor_2_5_no_ablation_control.R;

[left_choice_mode_std_norm,right_choice_mode_std_norm,L_pos_choice_mode_std_norm,L_pos_mid_point] = get_choice_mode(L,L_pos,R);

RNN_variable.control.choice_mode.left_choice_mode_std_norm = left_choice_mode_std_norm;
RNN_variable.control.choice_mode.right_choice_mode_std_norm = right_choice_mode_std_norm;
RNN_variable.control.choice_mode.L_pos_choice_mode_std_norm = L_pos_choice_mode_std_norm;
RNN_variable.control.choice_mode.L_pos_mid_point = L_pos_mid_point;
RNN_variable.control.proportion_switch_left = sum(L_pos_mid_point > 0.5);

clearvars -except example_RNN RNN_variable

% APP.
L = example_RNN.example_distractor_2_5_no_ablation_APP.L;
L_pos = example_RNN.example_distractor_2_5_no_ablation_APP.L_pos;
R = example_RNN.example_distractor_2_5_no_ablation_APP.R;
[left_choice_mode_std_norm,right_choice_mode_std_norm,L_pos_choice_mode_std_norm,L_pos_mid_point] = get_choice_mode(L,L_pos,R);

RNN_variable.APP.choice_mode.left_choice_mode_std_norm = left_choice_mode_std_norm;
RNN_variable.APP.choice_mode.right_choice_mode_std_norm = right_choice_mode_std_norm;
RNN_variable.APP.choice_mode.L_pos_choice_mode_std_norm = L_pos_choice_mode_std_norm;
RNN_variable.APP.choice_mode.L_pos_mid_point = L_pos_mid_point;
RNN_variable.APP.proportion_switch_left = sum(L_pos_mid_point > 0.5);

clearvars -except example_RNN RNN_variable

% Control with 10% ablation.
L = example_RNN.example_distractor_2_5_10_percent_ablation_control.L;
L_pos = example_RNN.example_distractor_2_5_10_percent_ablation_control.L_pos;
R = example_RNN.example_distractor_2_5_10_percent_ablation_control.R;
[left_choice_mode_std_norm,right_choice_mode_std_norm,L_pos_choice_mode_std_norm,L_pos_mid_point] = get_choice_mode(L,L_pos,R);

RNN_variable.control_10_percent_ablation.choice_mode.left_choice_mode_std_norm = left_choice_mode_std_norm;
RNN_variable.control_10_percent_ablation.choice_mode.right_choice_mode_std_norm = right_choice_mode_std_norm;
RNN_variable.control_10_percent_ablation.choice_mode.L_pos_choice_mode_std_norm = L_pos_choice_mode_std_norm;
RNN_variable.control_10_percent_ablation.choice_mode.L_pos_mid_point = L_pos_mid_point;
RNN_variable.control_10_percent_ablation.proportion_switch_left = sum(L_pos_mid_point > 0.5);

clearvars -except example_RNN RNN_variable

% Control with 20% ablation.
L = example_RNN.example_distractor_2_5_20_percent_ablation_control.L;
L_pos = example_RNN.example_distractor_2_5_20_percent_ablation_control.L_pos;
R = example_RNN.example_distractor_2_5_20_percent_ablation_control.R;
[left_choice_mode_std_norm,right_choice_mode_std_norm,L_pos_choice_mode_std_norm,L_pos_mid_point] = get_choice_mode(L,L_pos,R);

RNN_variable.control_20_percent_ablation.choice_mode.left_choice_mode_std_norm = left_choice_mode_std_norm;
RNN_variable.control_20_percent_ablation.choice_mode.right_choice_mode_std_norm = right_choice_mode_std_norm;
RNN_variable.control_20_percent_ablation.choice_mode.L_pos_choice_mode_std_norm = L_pos_choice_mode_std_norm;
RNN_variable.control_20_percent_ablation.choice_mode.L_pos_mid_point = L_pos_mid_point;
RNN_variable.control_20_percent_ablation.proportion_switch_left = sum(L_pos_mid_point > 0.5);

end

% Get choice mode.
function [left_choice_mode_std_norm,right_choice_mode_std_norm,L_pos_choice_mode_std_norm,L_pos_mid_point] = get_choice_mode(L,L_pos,R);

num_units = 1024;
fs_image = 93.5;
pre_resp_epoch = 1:round(fs_image*5.5);
choice_epoch = round(fs_image*4.5):round(fs_image*5.5);
iti_epoch = 1:round(fs_image*0.5);

averaged_R = squeeze(mean(R,1));
averaged_L = squeeze(mean(L,1));

choice_diff = squeeze(mean(averaged_R(:,choice_epoch),2) - mean(averaged_L(:,choice_epoch),2));
norm_choice_diff = choice_diff./((sum(choice_diff.^2)).^0.5);
norm_choice_diff = norm_choice_diff(1:num_units);

for trial_num = 1:size(R,1)
    trial_R = squeeze(R(trial_num,1:num_units,:));
    trial_L = squeeze(L(trial_num,1:num_units,:));
    trial_L_pos = squeeze(L_pos(trial_num,1:num_units,:));

    % Project to choice mode.
    left_choice_mode = trial_L'*norm_choice_diff;
    right_choice_mode = trial_R'*norm_choice_diff;
    L_pos_choice_mode = trial_L_pos'*norm_choice_diff;

    % Substract baseline.
    left_choice_mode_substracted = left_choice_mode - nanmean(left_choice_mode(iti_epoch));
    right_choice_mode_substracted = right_choice_mode - nanmean(right_choice_mode(iti_epoch));
    L_pos_choice_mode_substracted = L_pos_choice_mode - nanmean(L_pos_choice_mode(iti_epoch));

    left_choice_mode_std_norm(trial_num,:) = left_choice_mode_substracted./max(right_choice_mode_substracted(pre_resp_epoch));
    right_choice_mode_std_norm(trial_num,:) = right_choice_mode_substracted./max(right_choice_mode_substracted(pre_resp_epoch));
    L_pos_choice_mode_std_norm(trial_num,:) = L_pos_choice_mode_substracted./max(right_choice_mode_substracted(pre_resp_epoch));

    if (L_pos_choice_mode_std_norm(trial_num,end) > left_choice_mode_std_norm(trial_num,end) ) & (right_choice_mode_std_norm(trial_num,end) > left_choice_mode_std_norm(trial_num,end))
        L_pos_mid_point(trial_num) = (L_pos_choice_mode_std_norm(trial_num,end) - left_choice_mode_std_norm(trial_num,end) ) / (right_choice_mode_std_norm(trial_num,end) - left_choice_mode_std_norm(trial_num,end));
    else
        L_pos_mid_point(trial_num) = 0;
    end
    if L_pos_mid_point(trial_num) > 1
        L_pos_mid_point(trial_num) = 1;
    end
end

end