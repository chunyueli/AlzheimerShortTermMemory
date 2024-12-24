function plot_distractor_modulation_neural_activity_task_var_cell

close all
clear all
clc

% Plot distractor modulations of trial-type-selective neurons for each task variable.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('activity_control.mat')
activity = activity_control;
clear activity_control

% Initialize.
for region_num = 1:8
    for trial_type = 1:8
        trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{trial_type} = [];
    end
end

for animal_num = 1:numel(activity)
    clearvars -except activity ...
        trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session ...
        trial_aver_corr_incorr_resp_left_delay_cell_animal_session trial_aver_corr_incorr_resp_right_delay_cell_animal_session ...
        trial_aver_corr_incorr_resp_left_action_cell_animal_session trial_aver_corr_incorr_resp_right_action_cell_animal_session ...
        animal_num

    % Initialize.
    for region_num = 1:8
        for trial_type = 1:8
            trial_aver_corr_incorr_resp_left_stimulus_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_right_stimulus_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_left_action_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_right_action_cell_session{region_num}{trial_type} = [];
        end
    end

    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity ...
            trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session ...
            trial_aver_corr_incorr_resp_left_delay_cell_animal_session trial_aver_corr_incorr_resp_right_delay_cell_animal_session ...
            trial_aver_corr_incorr_resp_left_action_cell_animal_session trial_aver_corr_incorr_resp_right_action_cell_animal_session ...
            animal_num ...
            trial_aver_corr_incorr_resp_left_stimulus_cell_session trial_aver_corr_incorr_resp_right_stimulus_cell_session ...
            trial_aver_corr_incorr_resp_left_delay_cell_session trial_aver_corr_incorr_resp_right_delay_cell_session ...
            trial_aver_corr_incorr_resp_left_action_cell_session trial_aver_corr_incorr_resp_right_action_cell_session ...
            session_num

        % Sampling frequency of Scanimage.
        fs_image = 9.35211;

        % Determine whether neurons are selective to task variables.
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) > 0
                for cell_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{1},1)
                    for trial_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{1},2)
                        stimulus_left{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,trial_num,round(fs_image.*1):round(fs_image.*2)),3);
                        delay_left{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,trial_num,round(fs_image.*2):round(fs_image.*6)),3);
                        action_left{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,trial_num,round(fs_image.*6):round(fs_image.*7)),3);
                    end
                    for trial_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{2},2)
                        stimulus_right{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,trial_num,round(fs_image.*1):round(fs_image.*2)),3);
                        delay_right{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,trial_num,round(fs_image.*2):round(fs_image.*6)),3);
                        action_right{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,trial_num,round(fs_image.*6):round(fs_image.*7)),3);
                    end

                    % Statistics.
                    stimulus_p_value{region_num}(cell_num) = ranksum(stimulus_left{region_num}(cell_num,:),stimulus_right{region_num}(cell_num,:),'tail','both');
                    delay_p_value{region_num}(cell_num) = ranksum(delay_left{region_num}(cell_num,:),delay_right{region_num}(cell_num,:),'tail','both');
                    action_p_value{region_num}(cell_num) = ranksum(action_left{region_num}(cell_num,:),action_right{region_num}(cell_num,:),'tail','both');
                end
            else
                stimulus_p_value{region_num} = [];
                delay_p_value{region_num} = [];
                action_p_value{region_num} = [];
            end
        end

        % Response profiles.
        p_value_thresh = 0.01;
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) > 0
                for trial_type = 1:8
                    trial_averaged_correct_incorrect_resp_left_stimulus_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((stimulus_p_value{region_num} < p_value_thresh)' & mean(stimulus_left{region_num},2) > mean(stimulus_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_right_stimulus_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((stimulus_p_value{region_num} < p_value_thresh)' & mean(stimulus_left{region_num},2) < mean(stimulus_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) > mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) < mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_left_action_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((action_p_value{region_num} < p_value_thresh)' & mean(action_left{region_num},2) > mean(action_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_right_action_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((action_p_value{region_num} < p_value_thresh)' & mean(action_left{region_num},2) < mean(action_right{region_num},2)),:);
                end
            else
                for trial_type = 1:8
                    trial_averaged_correct_incorrect_resp_left_stimulus_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_right_stimulus_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_left_action_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_right_action_cell{region_num}{trial_type} = [];
                end
            end
        end

        % Concatenate.
        for region_num = 1:8
            for trial_type = 1:8
                trial_aver_corr_incorr_resp_left_stimulus_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_stimulus_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_left_stimulus_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_right_stimulus_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_stimulus_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_right_stimulus_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_left_action_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_action_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_left_action_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_right_action_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_action_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_right_action_cell{region_num}{trial_type}];
            end
        end
    end

    % Concatenate.
    for region_num = 1:8
        for trial_type = 1:8
            trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_left_stimulus_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_right_stimulus_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_left_action_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_right_action_cell_session{region_num}{trial_type}];
        end
    end
end

trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session = trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session;
trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session = trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session;
trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session = trial_aver_corr_incorr_resp_left_delay_cell_animal_session;
trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session = trial_aver_corr_incorr_resp_right_delay_cell_animal_session;
trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_action_cell_animal_session = trial_aver_corr_incorr_resp_left_action_cell_animal_session;
trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_action_cell_animal_session = trial_aver_corr_incorr_resp_right_action_cell_animal_session;

clearvars -except trial_averaged_activity_control

% APP.
load('activity_APP.mat')
activity = activity_APP;
clear activity_APP

% Initialize.
for region_num = 1:8
    for trial_type = 1:8
        trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{trial_type} = [];
    end
end

for animal_num = 1:numel(activity)
    clearvars -except trial_averaged_activity_control ...
        activity ...
        trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session ...
        trial_aver_corr_incorr_resp_left_delay_cell_animal_session trial_aver_corr_incorr_resp_right_delay_cell_animal_session ...
        trial_aver_corr_incorr_resp_left_action_cell_animal_session trial_aver_corr_incorr_resp_right_action_cell_animal_session ...
        animal_num

    % Initialize.
    for region_num = 1:8
        for trial_type = 1:8
            trial_aver_corr_incorr_resp_left_stimulus_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_right_stimulus_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_left_action_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_right_action_cell_session{region_num}{trial_type} = [];
        end
    end

    for session_num = 1:numel(activity{animal_num})
        clearvars -except trial_averaged_activity_control ...
            activity ...
            trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session ...
            trial_aver_corr_incorr_resp_left_delay_cell_animal_session trial_aver_corr_incorr_resp_right_delay_cell_animal_session ...
            trial_aver_corr_incorr_resp_left_action_cell_animal_session trial_aver_corr_incorr_resp_right_action_cell_animal_session ...
            animal_num ...
            trial_aver_corr_incorr_resp_left_stimulus_cell_session trial_aver_corr_incorr_resp_right_stimulus_cell_session ...
            trial_aver_corr_incorr_resp_left_delay_cell_session trial_aver_corr_incorr_resp_right_delay_cell_session ...
            trial_aver_corr_incorr_resp_left_action_cell_session trial_aver_corr_incorr_resp_right_action_cell_session ...
            session_num

        % Sampling frequency of Scanimage.
        fs_image = 9.35211;

        % Determine whether neurons are selective to task variables.
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) > 0
                for cell_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{1},1)
                    for trial_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{1},2)
                        stimulus_left{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,trial_num,round(fs_image.*1):round(fs_image.*2)),3);
                        delay_left{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,trial_num,round(fs_image.*2):round(fs_image.*6)),3);
                        action_left{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,trial_num,round(fs_image.*6):round(fs_image.*7)),3);
                    end
                    for trial_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{2},2)
                        stimulus_right{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,trial_num,round(fs_image.*1):round(fs_image.*2)),3);
                        delay_right{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,trial_num,round(fs_image.*2):round(fs_image.*6)),3);
                        action_right{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,trial_num,round(fs_image.*6):round(fs_image.*7)),3);
                    end

                    % Statistics.
                    stimulus_p_value{region_num}(cell_num) = ranksum(stimulus_left{region_num}(cell_num,:),stimulus_right{region_num}(cell_num,:),'tail','both');
                    delay_p_value{region_num}(cell_num) = ranksum(delay_left{region_num}(cell_num,:),delay_right{region_num}(cell_num,:),'tail','both');
                    action_p_value{region_num}(cell_num) = ranksum(action_left{region_num}(cell_num,:),action_right{region_num}(cell_num,:),'tail','both');
                end
            else
                stimulus_p_value{region_num} = [];
                delay_p_value{region_num} = [];
                action_p_value{region_num} = [];
            end
        end

        % Response profiles.
        p_value_thresh = 0.01;
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) > 0
                for trial_type = 1:8
                    trial_averaged_correct_incorrect_resp_left_stimulus_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((stimulus_p_value{region_num} < p_value_thresh)' & mean(stimulus_left{region_num},2) > mean(stimulus_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_right_stimulus_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((stimulus_p_value{region_num} < p_value_thresh)' & mean(stimulus_left{region_num},2) < mean(stimulus_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) > mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) < mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_left_action_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((action_p_value{region_num} < p_value_thresh)' & mean(action_left{region_num},2) > mean(action_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_right_action_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((action_p_value{region_num} < p_value_thresh)' & mean(action_left{region_num},2) < mean(action_right{region_num},2)),:);
                end
            else
                for trial_type = 1:8
                    trial_averaged_correct_incorrect_resp_left_stimulus_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_right_stimulus_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_left_action_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_right_action_cell{region_num}{trial_type} = [];
                end
            end
        end

        % Concatenate.
        for region_num = 1:8
            for trial_type = 1:8
                trial_aver_corr_incorr_resp_left_stimulus_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_stimulus_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_left_stimulus_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_right_stimulus_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_stimulus_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_right_stimulus_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_left_action_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_action_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_left_action_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_right_action_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_action_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_right_action_cell{region_num}{trial_type}];
            end
        end
    end

    % Concatenate.
    for region_num = 1:8
        for trial_type = 1:8
            trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_left_stimulus_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_right_stimulus_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_left_action_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_right_action_cell_session{region_num}{trial_type}];
        end
    end
end

trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session = trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session;
trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session = trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session;
trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session = trial_aver_corr_incorr_resp_left_delay_cell_animal_session;
trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session = trial_aver_corr_incorr_resp_right_delay_cell_animal_session;
trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_action_cell_animal_session = trial_aver_corr_incorr_resp_left_action_cell_animal_session;
trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_action_cell_animal_session = trial_aver_corr_incorr_resp_right_action_cell_animal_session;

clearvars -except trial_averaged_activity_control trial_averaged_activity_APP

fs_image = 9.35211;

% Control.
for region_num = 1:8
    for distractor_type = 1:4
        diff_left_stimulus_cell_control{region_num}{distractor_type} = trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_right_stimulus_cell_control{region_num}{distractor_type} = trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_left_delay_cell_control{region_num}{distractor_type} = trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_right_delay_cell_control{region_num}{distractor_type} = trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_left_action_cell_control{region_num}{distractor_type} = trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_right_action_cell_control{region_num}{distractor_type} = trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
    end
end

% APP.
for region_num = 1:8
    for distractor_type = 1:4
        diff_left_stimulus_cell_APP{region_num}{distractor_type} = trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_stimulus_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_right_stimulus_cell_APP{region_num}{distractor_type} = trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_stimulus_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_left_delay_cell_APP{region_num}{distractor_type} = trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_right_delay_cell_APP{region_num}{distractor_type} = trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_left_action_cell_APP{region_num}{distractor_type} = trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_action_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_right_action_cell_APP{region_num}{distractor_type} = trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_action_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
    end
end

% Plot distractor-mediated activity modulation differences.
for region_num = 1:8
    for distractor_type = 1:4
        selectivity_all_stimulus_cell_control{region_num}{distractor_type} = mean(diff_right_stimulus_cell_control{region_num}{distractor_type}) - mean(diff_left_stimulus_cell_control{region_num}{distractor_type});
        selectivity_modulation_all_stimulus_cell_control(region_num,distractor_type) = mean(selectivity_all_stimulus_cell_control{region_num}{distractor_type}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image))) - mean(selectivity_all_stimulus_cell_control{region_num}{1}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)));
        selectivity_all_delay_cell_control{region_num}{distractor_type} = mean(diff_right_delay_cell_control{region_num}{distractor_type}) - mean(diff_left_delay_cell_control{region_num}{distractor_type});
        selectivity_modulation_all_delay_cell_control(region_num,distractor_type) = mean(selectivity_all_delay_cell_control{region_num}{distractor_type}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image))) - mean(selectivity_all_delay_cell_control{region_num}{1}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)));
        selectivity_all_action_cell_control{region_num}{distractor_type} = mean(diff_right_action_cell_control{region_num}{distractor_type}) - mean(diff_left_action_cell_control{region_num}{distractor_type});
        selectivity_modulation_all_action_cell_control(region_num,distractor_type) = mean(selectivity_all_action_cell_control{region_num}{distractor_type}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image))) - mean(selectivity_all_action_cell_control{region_num}{1}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)));

        selectivity_all_stimulus_cell_APP{region_num}{distractor_type} = mean(diff_right_stimulus_cell_APP{region_num}{distractor_type}) - mean(diff_left_stimulus_cell_APP{region_num}{distractor_type});
        selectivity_modulation_all_stimulus_cell_APP(region_num,distractor_type) = mean(selectivity_all_stimulus_cell_APP{region_num}{distractor_type}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image))) - mean(selectivity_all_stimulus_cell_APP{region_num}{1}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)));
        selectivity_all_delay_cell_APP{region_num}{distractor_type} = mean(diff_right_delay_cell_APP{region_num}{distractor_type}) - mean(diff_left_delay_cell_APP{region_num}{distractor_type});
        selectivity_modulation_all_delay_cell_APP(region_num,distractor_type) = mean(selectivity_all_delay_cell_APP{region_num}{distractor_type}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image))) - mean(selectivity_all_delay_cell_APP{region_num}{1}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)));
        selectivity_all_action_cell_APP{region_num}{distractor_type} = mean(diff_right_action_cell_APP{region_num}{distractor_type}) - mean(diff_left_action_cell_APP{region_num}{distractor_type});
        selectivity_modulation_all_action_cell_APP(region_num,distractor_type) = mean(selectivity_all_action_cell_APP{region_num}{distractor_type}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image))) - mean(selectivity_all_action_cell_APP{region_num}{1}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)));
    end
end

figure('Position',[200,800,200,200],'Color','w')
imagesc(selectivity_modulation_all_stimulus_cell_control,[-0.2,0])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'])

figure('Position',[400,800,200,200],'Color','w')
imagesc(selectivity_modulation_all_stimulus_cell_APP,[-0.2,0])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'])

figure('Position',[200,500,200,200],'Color','w')
imagesc(selectivity_modulation_all_delay_cell_control,[-0.2,0])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'])

figure('Position',[400,500,200,200],'Color','w')
imagesc(selectivity_modulation_all_delay_cell_APP,[-0.2,0])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'])

figure('Position',[200,200,200,200],'Color','w')
imagesc(selectivity_modulation_all_action_cell_control,[-0.2,0])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'])

figure('Position',[400,200,200,200],'Color','w')
imagesc(selectivity_modulation_all_action_cell_APP,[-0.2,0])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'])

rng(0)

% Stimulus.
clear p_value p_value_all_temp p_value_all val idx adjusted_p_value_005 adjusted_p_value_001 adjusted_p_value_0001 significant_comparison_idx_005 significant_comparison_idx_001 significant_comparison_idx_0001 vector
figure('Position',[600,800,200,200],'Color','w')
imagesc(selectivity_modulation_all_stimulus_cell_APP - selectivity_modulation_all_stimulus_cell_control,[-0.2,0.2])
axis square
xlabel('');
ylabel('');
axis off
colormap('redblue')

% Control.
for region_num = 1:8
    for distractor_type = 1:4
        for shuffle_num = 1:1000
            disp(['Shuffle: ',num2str(shuffle_num)])
            for cell_num = 1:size(diff_left_stimulus_cell_control{region_num}{distractor_type},1)
                sampled_diff_left_stimulus_cell_control{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_left_stimulus_cell_control{region_num}{distractor_type}(randi(size(diff_left_stimulus_cell_control{region_num}{distractor_type},1)),:);
            end
            for cell_num = 1:size(diff_right_stimulus_cell_control{region_num}{distractor_type},1)
                sampled_diff_right_stimulus_cell_control{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_right_stimulus_cell_control{region_num}{distractor_type}(randi(size(diff_right_stimulus_cell_control{region_num}{distractor_type},1)),:);
            end
        end
    end
end

for region_num = 1:8
    for distractor_type = 1:4
        selectivity_stimulus_cell_control{region_num}{distractor_type} = squeeze(mean(sampled_diff_right_stimulus_cell_control{region_num}{distractor_type},2) - mean(sampled_diff_left_stimulus_cell_control{region_num}{distractor_type},2));
        selectivity_modulation_stimulus_cell_control{region_num}{distractor_type} = mean(selectivity_stimulus_cell_control{region_num}{distractor_type}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2) - mean(selectivity_stimulus_cell_control{region_num}{1}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2);
    end
end

% APP.
for region_num = 1:8
    for distractor_type = 1:4
        for shuffle_num = 1:1000
            disp(['Shuffle: ',num2str(shuffle_num)])
            for cell_num = 1:size(diff_left_stimulus_cell_APP{region_num}{distractor_type},1)
                sampled_diff_left_stimulus_cell_APP{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_left_stimulus_cell_APP{region_num}{distractor_type}(randi(size(diff_left_stimulus_cell_APP{region_num}{distractor_type},1)),:);
            end
            for cell_num = 1:size(diff_right_stimulus_cell_APP{region_num}{distractor_type},1)
                sampled_diff_right_stimulus_cell_APP{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_right_stimulus_cell_APP{region_num}{distractor_type}(randi(size(diff_right_stimulus_cell_APP{region_num}{distractor_type},1)),:);
            end
        end
    end
end

for region_num = 1:8
    for distractor_type = 1:4
        selectivity_stimulus_cell_APP{region_num}{distractor_type} = squeeze(mean(sampled_diff_right_stimulus_cell_APP{region_num}{distractor_type},2) - mean(sampled_diff_left_stimulus_cell_APP{region_num}{distractor_type},2));
        selectivity_modulation_stimulus_cell_APP{region_num}{distractor_type} = mean(selectivity_stimulus_cell_APP{region_num}{distractor_type}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2) - mean(selectivity_stimulus_cell_APP{region_num}{1}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2);
    end
end

% P-values.
for region_num = 1:8
    for distractor_type = 1:4
        p_value(region_num,distractor_type) = sum(selectivity_modulation_stimulus_cell_control{region_num}{distractor_type} < selectivity_modulation_stimulus_cell_APP{region_num}{distractor_type})/1000;
    end
end

% False discovery rate.
p_value_all_temp = p_value(:,2:4);
p_value_all = p_value_all_temp(:);
[val,idx] = sort(p_value_all);
adjusted_p_value_005 = ((1:numel(p_value_all))*0.05)/numel(p_value_all);
adjusted_p_value_001 = ((1:numel(p_value_all))*0.01)/numel(p_value_all);
adjusted_p_value_0001 = ((1:numel(p_value_all))*0.001)/numel(p_value_all);
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value_all),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

% Plot.
figure('Position',[800,800,200,200],'Color','w')
imagesc([zeros(8,1),reshape(vector,[8,3])],[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

% Delay.
clear p_value p_value_all_temp p_value_all val idx adjusted_p_value_005 adjusted_p_value_001 adjusted_p_value_0001 significant_comparison_idx_005 significant_comparison_idx_001 significant_comparison_idx_0001 vector
figure('Position',[600,500,200,200],'Color','w')
imagesc(selectivity_modulation_all_delay_cell_APP - selectivity_modulation_all_delay_cell_control,[-0.2,0.2])
axis square
xlabel('');
ylabel('');
axis off
colormap('redblue')

% Control.
for region_num = 1:8
    for distractor_type = 1:4
        for shuffle_num = 1:1000
            disp(['Shuffle: ',num2str(shuffle_num)])
            for cell_num = 1:size(diff_left_delay_cell_control{region_num}{distractor_type},1)
                sampled_diff_left_delay_cell_control{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_left_delay_cell_control{region_num}{distractor_type}(randi(size(diff_left_delay_cell_control{region_num}{distractor_type},1)),:);
            end
            for cell_num = 1:size(diff_right_delay_cell_control{region_num}{distractor_type},1)
                sampled_diff_right_delay_cell_control{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_right_delay_cell_control{region_num}{distractor_type}(randi(size(diff_right_delay_cell_control{region_num}{distractor_type},1)),:);
            end
        end
    end
end

for region_num = 1:8
    for distractor_type = 1:4
        selectivity_delay_cell_control{region_num}{distractor_type} = squeeze(mean(sampled_diff_right_delay_cell_control{region_num}{distractor_type},2) - mean(sampled_diff_left_delay_cell_control{region_num}{distractor_type},2));
        selectivity_modulation_delay_cell_control{region_num}{distractor_type} = mean(selectivity_delay_cell_control{region_num}{distractor_type}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2) - mean(selectivity_delay_cell_control{region_num}{1}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2);
    end
end

% APP.
for region_num = 1:8
    for distractor_type = 1:4
        for shuffle_num = 1:1000
            disp(['Shuffle: ',num2str(shuffle_num)])
            for cell_num = 1:size(diff_left_delay_cell_APP{region_num}{distractor_type},1)
                sampled_diff_left_delay_cell_APP{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_left_delay_cell_APP{region_num}{distractor_type}(randi(size(diff_left_delay_cell_APP{region_num}{distractor_type},1)),:);
            end
            for cell_num = 1:size(diff_right_delay_cell_APP{region_num}{distractor_type},1)
                sampled_diff_right_delay_cell_APP{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_right_delay_cell_APP{region_num}{distractor_type}(randi(size(diff_right_delay_cell_APP{region_num}{distractor_type},1)),:);
            end
        end
    end
end

for region_num = 1:8
    for distractor_type = 1:4
        selectivity_delay_cell_APP{region_num}{distractor_type} = squeeze(mean(sampled_diff_right_delay_cell_APP{region_num}{distractor_type},2) - mean(sampled_diff_left_delay_cell_APP{region_num}{distractor_type},2));
        selectivity_modulation_delay_cell_APP{region_num}{distractor_type} = mean(selectivity_delay_cell_APP{region_num}{distractor_type}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2) - mean(selectivity_delay_cell_APP{region_num}{1}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2);
    end
end

% P-values.
for region_num = 1:8
    for distractor_type = 1:4
        p_value(region_num,distractor_type) = sum(selectivity_modulation_delay_cell_control{region_num}{distractor_type} < selectivity_modulation_delay_cell_APP{region_num}{distractor_type})/1000;
    end
end

% False discovery rate.
p_value_all_temp = p_value(:,2:4);
p_value_all = p_value_all_temp(:);
[val,idx] = sort(p_value_all);
adjusted_p_value_005 = ((1:numel(p_value_all))*0.05)/numel(p_value_all);
adjusted_p_value_001 = ((1:numel(p_value_all))*0.01)/numel(p_value_all);
adjusted_p_value_0001 = ((1:numel(p_value_all))*0.001)/numel(p_value_all);
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value_all),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

% Plot.
figure('Position',[800,500,200,200],'Color','w')
imagesc([zeros(8,1),reshape(vector,[8,3])],[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

% Action.
clear p_value p_value_all_temp p_value_all val idx adjusted_p_value_005 adjusted_p_value_001 adjusted_p_value_0001 significant_comparison_idx_005 significant_comparison_idx_001 significant_comparison_idx_0001 vector
figure('Position',[600,200,200,200],'Color','w')
imagesc(selectivity_modulation_all_action_cell_APP - selectivity_modulation_all_action_cell_control,[-0.2,0.2])
axis square
xlabel('');
ylabel('');
axis off
colormap('redblue')

% Control.
for region_num = 1:8
    for distractor_type = 1:4
        for shuffle_num = 1:1000
            disp(['Shuffle: ',num2str(shuffle_num)])
            for cell_num = 1:size(diff_left_action_cell_control{region_num}{distractor_type},1)
                sampled_diff_left_action_cell_control{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_left_action_cell_control{region_num}{distractor_type}(randi(size(diff_left_action_cell_control{region_num}{distractor_type},1)),:);
            end
            for cell_num = 1:size(diff_right_action_cell_control{region_num}{distractor_type},1)
                sampled_diff_right_action_cell_control{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_right_action_cell_control{region_num}{distractor_type}(randi(size(diff_right_action_cell_control{region_num}{distractor_type},1)),:);
            end
        end
    end
end

for region_num = 1:8
    for distractor_type = 1:4
        selectivity_action_cell_control{region_num}{distractor_type} = squeeze(mean(sampled_diff_right_action_cell_control{region_num}{distractor_type},2) - mean(sampled_diff_left_action_cell_control{region_num}{distractor_type},2));
        selectivity_modulation_action_cell_control{region_num}{distractor_type} = mean(selectivity_action_cell_control{region_num}{distractor_type}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2) - mean(selectivity_action_cell_control{region_num}{1}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2);
    end
end

% APP.
for region_num = 1:8
    for distractor_type = 1:4
        for shuffle_num = 1:1000
            disp(['Shuffle: ',num2str(shuffle_num)])
            for cell_num = 1:size(diff_left_action_cell_APP{region_num}{distractor_type},1)
                sampled_diff_left_action_cell_APP{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_left_action_cell_APP{region_num}{distractor_type}(randi(size(diff_left_action_cell_APP{region_num}{distractor_type},1)),:);
            end
            for cell_num = 1:size(diff_right_action_cell_APP{region_num}{distractor_type},1)
                sampled_diff_right_action_cell_APP{region_num}{distractor_type}(shuffle_num,cell_num,:) = diff_right_action_cell_APP{region_num}{distractor_type}(randi(size(diff_right_action_cell_APP{region_num}{distractor_type},1)),:);
            end
        end
    end
end

for region_num = 1:8
    for distractor_type = 1:4
        selectivity_action_cell_APP{region_num}{distractor_type} = squeeze(mean(sampled_diff_right_action_cell_APP{region_num}{distractor_type},2) - mean(sampled_diff_left_action_cell_APP{region_num}{distractor_type},2));
        selectivity_modulation_action_cell_APP{region_num}{distractor_type} = mean(selectivity_action_cell_APP{region_num}{distractor_type}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2) - mean(selectivity_action_cell_APP{region_num}{1}(:,round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)),2);
    end
end

% P-values.
for region_num = 1:8
    for distractor_type = 1:4
        p_value(region_num,distractor_type) = sum(selectivity_modulation_action_cell_control{region_num}{distractor_type} < selectivity_modulation_action_cell_APP{region_num}{distractor_type})/1000;
    end
end

% False discovery rate.
p_value_all_temp = p_value(:,2:4);
p_value_all = p_value_all_temp(:);
[val,idx] = sort(p_value_all);
adjusted_p_value_005 = ((1:numel(p_value_all))*0.05)/numel(p_value_all);
adjusted_p_value_001 = ((1:numel(p_value_all))*0.01)/numel(p_value_all);
adjusted_p_value_0001 = ((1:numel(p_value_all))*0.001)/numel(p_value_all);
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value_all),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

% Plot.
figure('Position',[800,200,200,200],'Color','w')
imagesc([zeros(8,1),reshape(vector,[8,3])],[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

end