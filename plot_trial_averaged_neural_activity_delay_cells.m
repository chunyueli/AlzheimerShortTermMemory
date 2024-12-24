function plot_trial_averaged_neural_activity_delay_cells

close all
clear all
clc

% Plot trial-averaged activity of delay cells.
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
        trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [];
    end
end

for animal_num = 1:numel(activity)
    clearvars -except activity ...
        trial_aver_corr_incorr_resp_left_delay_cell_animal_session trial_aver_corr_incorr_resp_right_delay_cell_animal_session trial_aver_corr_resp_left_delay_cell_animal_session trial_aver_corr_resp_right_delay_cell_animal_session trial_aver_incorr_resp_left_delay_cell_animal_session trial_aver_incorr_resp_right_delay_cell_animal_session ...
        animal_num

    % Initialize.
    for region_num = 1:8
        for trial_type = 1:8
            trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_resp_left_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_resp_right_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [];
        end
    end

    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity ...
            trial_aver_corr_incorr_resp_left_delay_cell_animal_session trial_aver_corr_incorr_resp_right_delay_cell_animal_session trial_aver_corr_resp_left_delay_cell_animal_session trial_aver_corr_resp_right_delay_cell_animal_session trial_aver_incorr_resp_left_delay_cell_animal_session trial_aver_incorr_resp_right_delay_cell_animal_session ...
            animal_num ...
            trial_aver_corr_incorr_resp_left_delay_cell_session trial_aver_corr_incorr_resp_right_delay_cell_session trial_aver_corr_resp_left_delay_cell_session trial_aver_corr_resp_right_delay_cell_session trial_aver_incorr_resp_left_delay_cell_session trial_aver_incorr_resp_right_delay_cell_session ...
            session_num

        % Sampling frequency of Scanimage.
        fs_image = 9.35211;

        % Determine whether neurons are selective to task variables.
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) > 0
                for cell_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{1},1)
                    for trial_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{1},2)
                        delay_left{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,trial_num,round(fs_image.*2):round(fs_image.*6)),3);
                    end
                    for trial_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{2},2)
                        delay_right{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,trial_num,round(fs_image.*2):round(fs_image.*6)),3);
                    end

                    % Statistics.
                    delay_p_value{region_num}(cell_num) = ranksum(delay_left{region_num}(cell_num,:),delay_right{region_num}(cell_num,:),'tail','both');
                end
            else
                delay_p_value{region_num} = [];
            end
        end

        % Response profiles.
        p_value_thresh = 0.01;
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) > 0
                for trial_type = 1:8
                    trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) > mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) < mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_resp_left_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) > mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_resp_right_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) < mean(delay_right{region_num},2)),:);
                    trial_averaged_incorrect_resp_left_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) > mean(delay_right{region_num},2)),:);
                    trial_averaged_incorrect_resp_right_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) < mean(delay_right{region_num},2)),:);
                end
            else
                for trial_type = 1:8
                    trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_resp_left_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_resp_right_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_incorrect_resp_left_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_incorrect_resp_right_delay_cell{region_num}{trial_type} = [];
                end
            end
        end

        % Concatenate.
        for region_num = 1:8
            for trial_type = 1:8
                trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type}];
                trial_aver_corr_resp_left_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_resp_left_delay_cell_session{region_num}{trial_type};trial_averaged_correct_resp_left_delay_cell{region_num}{trial_type}];
                trial_aver_corr_resp_right_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_resp_right_delay_cell_session{region_num}{trial_type};trial_averaged_correct_resp_right_delay_cell{region_num}{trial_type}];
                trial_aver_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [trial_aver_incorr_resp_left_delay_cell_session{region_num}{trial_type};trial_averaged_incorrect_resp_left_delay_cell{region_num}{trial_type}];
                trial_aver_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [trial_aver_incorr_resp_right_delay_cell_session{region_num}{trial_type};trial_averaged_incorrect_resp_right_delay_cell{region_num}{trial_type}];
            end
        end
    end

    % Concatenate.
    for region_num = 1:8
        for trial_type = 1:8
            trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_resp_left_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_resp_right_delay_cell_session{region_num}{trial_type}];
            trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type};trial_aver_incorr_resp_left_delay_cell_session{region_num}{trial_type}];
            trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type};trial_aver_incorr_resp_right_delay_cell_session{region_num}{trial_type}];
        end
    end
end

trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session = trial_aver_corr_incorr_resp_left_delay_cell_animal_session;
trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session = trial_aver_corr_incorr_resp_right_delay_cell_animal_session;
trial_averaged_activity_control.trial_aver_corr_resp_left_delay_cell_animal_session = trial_aver_corr_resp_left_delay_cell_animal_session;
trial_averaged_activity_control.trial_aver_corr_resp_right_delay_cell_animal_session = trial_aver_corr_resp_right_delay_cell_animal_session;
trial_averaged_activity_control.trial_aver_incorr_resp_left_delay_cell_animal_session = trial_aver_incorr_resp_left_delay_cell_animal_session;
trial_averaged_activity_control.trial_aver_incorr_resp_right_delay_cell_animal_session = trial_aver_incorr_resp_right_delay_cell_animal_session;

clearvars -except trial_averaged_activity_control

% APP.
load('activity_APP.mat')
activity = activity_APP;
clear activity_APP

% Initialize.
for region_num = 1:8
    for trial_type = 1:8
        trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [];
        trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [];
    end
end

for animal_num = 1:numel(activity)
    clearvars -except trial_averaged_activity_control ...
        activity ...
        trial_aver_corr_incorr_resp_left_delay_cell_animal_session trial_aver_corr_incorr_resp_right_delay_cell_animal_session trial_aver_corr_resp_left_delay_cell_animal_session trial_aver_corr_resp_right_delay_cell_animal_session trial_aver_incorr_resp_left_delay_cell_animal_session trial_aver_incorr_resp_right_delay_cell_animal_session ...
        animal_num

    % Initialize.
    for region_num = 1:8
        for trial_type = 1:8
            trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_resp_left_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_corr_resp_right_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [];
            trial_aver_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [];
        end
    end

    for session_num = 1:numel(activity{animal_num})
        clearvars -except trial_averaged_activity_control ...
            activity ...
            trial_aver_corr_incorr_resp_left_delay_cell_animal_session trial_aver_corr_incorr_resp_right_delay_cell_animal_session trial_aver_corr_resp_left_delay_cell_animal_session trial_aver_corr_resp_right_delay_cell_animal_session trial_aver_incorr_resp_left_delay_cell_animal_session trial_aver_incorr_resp_right_delay_cell_animal_session ...
            animal_num ...
            trial_aver_corr_incorr_resp_left_delay_cell_session trial_aver_corr_incorr_resp_right_delay_cell_session trial_aver_corr_resp_left_delay_cell_session trial_aver_corr_resp_right_delay_cell_session trial_aver_incorr_resp_left_delay_cell_session trial_aver_incorr_resp_right_delay_cell_session ...
            session_num

        % Sampling frequency of Scanimage.
        fs_image = 9.35211;

        % Determine whether neurons are selective to task variables.
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) > 0
                for cell_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{1},1)
                    for trial_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{1},2)
                        delay_left{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{1}(cell_num,trial_num,round(fs_image.*2):round(fs_image.*6)),3);
                    end
                    for trial_num = 1:size(activity{animal_num}{session_num}.correct_response{region_num}{2},2)
                        delay_right{region_num}(cell_num,trial_num) = mean(activity{animal_num}{session_num}.correct_response{region_num}{2}(cell_num,trial_num,round(fs_image.*2):round(fs_image.*6)),3);
                    end

                    % Statistics.
                    delay_p_value{region_num}(cell_num) = ranksum(delay_left{region_num}(cell_num,:),delay_right{region_num}(cell_num,:),'tail','both');
                end
            else
                delay_p_value{region_num} = [];
            end
        end

        % Response profiles.
        p_value_thresh = 0.01;
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) > 0
                for trial_type = 1:8
                    trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) > mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) < mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_resp_left_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) > mean(delay_right{region_num},2)),:);
                    trial_averaged_correct_resp_right_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_correct_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) < mean(delay_right{region_num},2)),:);
                    trial_averaged_incorrect_resp_left_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) > mean(delay_right{region_num},2)),:);
                    trial_averaged_incorrect_resp_right_delay_cell{region_num}{trial_type} = activity{animal_num}{session_num}.trial_averaged_incorrect_response{region_num}{trial_type}(find((delay_p_value{region_num} < p_value_thresh)' & mean(delay_left{region_num},2) < mean(delay_right{region_num},2)),:);
                end
            else
                for trial_type = 1:8
                    trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_resp_left_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_correct_resp_right_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_incorrect_resp_left_delay_cell{region_num}{trial_type} = [];
                    trial_averaged_incorrect_resp_right_delay_cell{region_num}{trial_type} = [];
                end
            end
        end

        % Concatenate.
        for region_num = 1:8
            for trial_type = 1:8trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_left_delay_cell{region_num}{trial_type}];
                trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type};trial_averaged_correct_incorrect_resp_right_delay_cell{region_num}{trial_type}];
                trial_aver_corr_resp_left_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_resp_left_delay_cell_session{region_num}{trial_type};trial_averaged_correct_resp_left_delay_cell{region_num}{trial_type}];
                trial_aver_corr_resp_right_delay_cell_session{region_num}{trial_type} = [trial_aver_corr_resp_right_delay_cell_session{region_num}{trial_type};trial_averaged_correct_resp_right_delay_cell{region_num}{trial_type}];
                trial_aver_incorr_resp_left_delay_cell_session{region_num}{trial_type} = [trial_aver_incorr_resp_left_delay_cell_session{region_num}{trial_type};trial_averaged_incorrect_resp_left_delay_cell{region_num}{trial_type}];
                trial_aver_incorr_resp_right_delay_cell_session{region_num}{trial_type} = [trial_aver_incorr_resp_right_delay_cell_session{region_num}{trial_type};trial_averaged_incorrect_resp_right_delay_cell{region_num}{trial_type}];
            end
        end
    end

    % Concatenate.
    for region_num = 1:8
        for trial_type = 1:8
            trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_left_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_incorr_resp_right_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_resp_left_delay_cell_session{region_num}{trial_type}];
            trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{trial_type};trial_aver_corr_resp_right_delay_cell_session{region_num}{trial_type}];
            trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{trial_type};trial_aver_incorr_resp_left_delay_cell_session{region_num}{trial_type}];
            trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type} = [trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{trial_type};trial_aver_incorr_resp_right_delay_cell_session{region_num}{trial_type}];
        end
    end
end

trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session = trial_aver_corr_incorr_resp_left_delay_cell_animal_session;
trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session = trial_aver_corr_incorr_resp_right_delay_cell_animal_session;
trial_averaged_activity_APP.trial_aver_corr_resp_left_delay_cell_animal_session = trial_aver_corr_resp_left_delay_cell_animal_session;
trial_averaged_activity_APP.trial_aver_corr_resp_right_delay_cell_animal_session = trial_aver_corr_resp_right_delay_cell_animal_session;
trial_averaged_activity_APP.trial_aver_incorr_resp_left_delay_cell_animal_session = trial_aver_incorr_resp_left_delay_cell_animal_session;
trial_averaged_activity_APP.trial_aver_incorr_resp_right_delay_cell_animal_session = trial_aver_incorr_resp_right_delay_cell_animal_session;

clearvars -except trial_averaged_activity_control trial_averaged_activity_APP

% Plot.
fs_image = 9.35211;

% Concatenate across left and right trials.
for region_num = 1:8
    for distractor_num = 1:4
        trial_aver_corr_incorr_resp_left_delay_cell_dist_control{region_num}{distractor_num} = [trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_corr_incorr_resp_right_delay_cell_dist_control{region_num}{distractor_num} = [trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_corr_resp_left_delay_cell_dist_control{region_num}{distractor_num} = [trial_averaged_activity_control.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_control.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_corr_resp_right_delay_cell_dist_control{region_num}{distractor_num} = [trial_averaged_activity_control.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_control.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_incorr_resp_left_delay_cell_dist_control{region_num}{distractor_num} = [trial_averaged_activity_control.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_control.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_incorr_resp_right_delay_cell_dist_control{region_num}{distractor_num} = [trial_averaged_activity_control.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_control.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2}];

        trial_aver_corr_incorr_resp_left_delay_cell_dist_APP{region_num}{distractor_num} = [trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_corr_incorr_resp_right_delay_cell_dist_APP{region_num}{distractor_num} = [trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num} = [trial_averaged_activity_APP.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_APP.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num} = [trial_averaged_activity_APP.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_APP.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_incorr_resp_left_delay_cell_dist_APP{region_num}{distractor_num} = [trial_averaged_activity_APP.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_APP.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2}];
        trial_aver_incorr_resp_right_delay_cell_dist_APP{region_num}{distractor_num} = [trial_averaged_activity_APP.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1},trial_averaged_activity_APP.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2}];
    end
end

% Min-max normalize.
for region_num = 1:8
    for distractor_num = 1:4
        norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl{region_num}{distractor_num} = (trial_aver_corr_resp_left_delay_cell_dist_control{region_num}{distractor_num} - nanmin(trial_aver_corr_resp_left_delay_cell_dist_control{region_num}{distractor_num},[],2))./ ...
            (nanmax(trial_aver_corr_resp_left_delay_cell_dist_control{region_num}{distractor_num},[],2) - nanmin(trial_aver_corr_resp_left_delay_cell_dist_control{region_num}{distractor_num},[],2));
        norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl{region_num}{distractor_num} = (trial_aver_corr_resp_right_delay_cell_dist_control{region_num}{distractor_num} - nanmin(trial_aver_corr_resp_right_delay_cell_dist_control{region_num}{distractor_num},[],2))./ ...
            (nanmax(trial_aver_corr_resp_right_delay_cell_dist_control{region_num}{distractor_num},[],2) - nanmin(trial_aver_corr_resp_right_delay_cell_dist_control{region_num}{distractor_num},[],2));
        norm_trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num} = (trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num} - nanmin(trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num},[],2))./ ...
            (nanmax(trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num},[],2) - nanmin(trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num},[],2));
        norm_trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num} = (trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num} - nanmin(trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num},[],2))./ ...
            (nanmax(trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num},[],2) - nanmin(trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num},[],2));
    end
end

% Concatenate across regions.
clear region_cell_number cumsum_region_cell_number
norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl_all1 = [];
norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl_all2 = [];
for region_num = 1:8
    for distractor_num = 1
        region_cell_number(region_num) = size(norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl{region_num}{distractor_num},1);
        clear max_idx_temp1 max_idx_temp2 max_idx idx
        max_idx_temp1 = norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl{region_num}{distractor_num}(:,round(2*fs_image):round(6*fs_image)) == max(norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl{region_num}{distractor_num}(:,round(2*fs_image):round(6*fs_image)),[],2);
        for cell_num = 1:size(max_idx_temp1,1)
            max_idx(cell_num) = nan;
            if ~isempty(find(max_idx_temp1(cell_num,:))) == 1
                max_idx_temp2{cell_num} = find(max_idx_temp1(cell_num,:));
                max_idx(cell_num) = max_idx_temp2{cell_num}(1);
            end
        end
        [~,idx] = sort(max_idx);
        norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl_all1 = [norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl_all1;norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl{region_num}{distractor_num}(idx,1:75)];
        norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl_all2 = [norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl_all2;norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl{region_num}{distractor_num}(idx,76:end)];
    end
end
cumsum_region_cell_number = cumsum(region_cell_number);
figure('Position',[200,800,200,600],'Color','w')
imagesc(norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl_all1,[0,1])
xlim([1,75])
for region_num = 1:7
    line([1,75],[cumsum_region_cell_number(region_num) + 0.5,cumsum_region_cell_number(region_num) + 0.5],'LineWidth',1,'Color','w')
end
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off
colormap('magma')

figure('Position',[400,800,200,600],'Color','w')
imagesc(norm_trial_aver_corr_resp_left_delay_cell_dist_ctrl_all2,[0,1])
xlim([1,75])
for region_num = 1:7
    line([1,75],[cumsum_region_cell_number(region_num) + 0.5,cumsum_region_cell_number(region_num) + 0.5],'LineWidth',1,'Color','w')
end
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off
colormap('magma')

clear region_cell_number cumsum_region_cell_number
norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl_all1 = [];
norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl_all2 = [];
for region_num = 1:8
    for distractor_num = 1
        region_cell_number(region_num) = size(norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl{region_num}{distractor_num},1);
        clear max_idx_temp1 max_idx_temp2 max_idx idx
        max_idx_temp1 = norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl{region_num}{distractor_num}(:,round(10*fs_image):round(14*fs_image)) == max(norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl{region_num}{distractor_num}(:,round(10*fs_image):round(14*fs_image)),[],2);
        for cell_num = 1:size(max_idx_temp1,1)
            max_idx(cell_num) = nan;
            if ~isempty(find(max_idx_temp1(cell_num,:))) == 1
                max_idx_temp2{cell_num} = find(max_idx_temp1(cell_num,:));
                max_idx(cell_num) = max_idx_temp2{cell_num}(1);
            end
        end
        [~,idx] = sort(max_idx);
        norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl_all1 = [norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl_all1;norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl{region_num}{distractor_num}(idx,1:75)];
        norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl_all2 = [norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl_all2;norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl{region_num}{distractor_num}(idx,76:end)];
    end
end
cumsum_region_cell_number = cumsum(region_cell_number);
figure('Position',[600,800,200,600],'Color','w')
imagesc(norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl_all1,[0,1])
xlim([1,75])
for region_num = 1:7
    line([1,75],[cumsum_region_cell_number(region_num) + 0.5,cumsum_region_cell_number(region_num) + 0.5],'LineWidth',1,'Color','w')
end
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off
colormap('magma')

figure('Position',[800,800,200,600],'Color','w')
imagesc(norm_trial_aver_corr_resp_right_delay_cell_dist_ctrl_all2,[0,1])
xlim([1,75])
for region_num = 1:7
    line([1,75],[cumsum_region_cell_number(region_num) + 0.5,cumsum_region_cell_number(region_num) + 0.5],'LineWidth',1,'Color','w')
end
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off
colormap('magma')

% Concatenate across regions.
clear region_cell_number cumsum_region_cell_number
norm_trial_aver_corr_resp_left_delay_cell_dist_APP_all1 = [];
norm_trial_aver_corr_resp_left_delay_cell_dist_APP_all2 = [];
for region_num = 1:8
    for distractor_num = 1
        region_cell_number(region_num) = size(norm_trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num},1);
        clear max_idx_temp1 max_idx_temp2 max_idx idx
        max_idx_temp1 = norm_trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num}(:,round(2*fs_image):round(6*fs_image)) == max(norm_trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num}(:,round(2*fs_image):round(6*fs_image)),[],2);
        for cell_num = 1:size(max_idx_temp1,1)
            max_idx(cell_num) = nan;
            if ~isempty(find(max_idx_temp1(cell_num,:))) == 1
                max_idx_temp2{cell_num} = find(max_idx_temp1(cell_num,:));
                max_idx(cell_num) = max_idx_temp2{cell_num}(1);
            end
        end
        [~,idx] = sort(max_idx);
        norm_trial_aver_corr_resp_left_delay_cell_dist_APP_all1 = [norm_trial_aver_corr_resp_left_delay_cell_dist_APP_all1;norm_trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num}(idx,1:75)];
        norm_trial_aver_corr_resp_left_delay_cell_dist_APP_all2 = [norm_trial_aver_corr_resp_left_delay_cell_dist_APP_all2;norm_trial_aver_corr_resp_left_delay_cell_dist_APP{region_num}{distractor_num}(idx,76:end)];
    end
end
cumsum_region_cell_number = cumsum(region_cell_number);
figure('Position',[1000,800,200,600],'Color','w')
imagesc(norm_trial_aver_corr_resp_left_delay_cell_dist_APP_all1,[0,1])
xlim([1,75])
for region_num = 1:7
    line([1,75],[cumsum_region_cell_number(region_num) + 0.5,cumsum_region_cell_number(region_num) + 0.5],'LineWidth',1,'Color','w')
end
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off
colormap('magma')

figure('Position',[1200,800,200,600],'Color','w')
imagesc(norm_trial_aver_corr_resp_left_delay_cell_dist_APP_all2,[0,1])
xlim([1,75])
for region_num = 1:7
    line([1,75],[cumsum_region_cell_number(region_num) + 0.5,cumsum_region_cell_number(region_num) + 0.5],'LineWidth',1,'Color','w')
end
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off
colormap('magma')

clear region_cell_number cumsum_region_cell_number
norm_trial_aver_corr_resp_right_delay_cell_dist_APP_all1 = [];
norm_trial_aver_corr_resp_right_delay_cell_dist_APP_all2 = [];
for region_num = 1:8
    for distractor_num = 1
        region_cell_number(region_num) = size(norm_trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num},1);
        clear max_idx_temp1 max_idx_temp2 max_idx idx
        max_idx_temp1 = norm_trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num}(:,round(10*fs_image):round(14*fs_image)) == max(norm_trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num}(:,round(10*fs_image):round(14*fs_image)),[],2);
        for cell_num = 1:size(max_idx_temp1,1)
            max_idx(cell_num) = nan;
            if ~isempty(find(max_idx_temp1(cell_num,:))) == 1
                max_idx_temp2{cell_num} = find(max_idx_temp1(cell_num,:));
                max_idx(cell_num) = max_idx_temp2{cell_num}(1);
            end
        end
        [~,idx] = sort(max_idx);
        norm_trial_aver_corr_resp_right_delay_cell_dist_APP_all1 = [norm_trial_aver_corr_resp_right_delay_cell_dist_APP_all1;norm_trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num}(idx,1:75)];
        norm_trial_aver_corr_resp_right_delay_cell_dist_APP_all2 = [norm_trial_aver_corr_resp_right_delay_cell_dist_APP_all2;norm_trial_aver_corr_resp_right_delay_cell_dist_APP{region_num}{distractor_num}(idx,76:end)];
    end
end
cumsum_region_cell_number = cumsum(region_cell_number);
figure('Position',[1400,800,200,600],'Color','w')
imagesc(norm_trial_aver_corr_resp_right_delay_cell_dist_APP_all1,[0,1])
xlim([1,75])
for region_num = 1:7
    line([1,75],[cumsum_region_cell_number(region_num) + 0.5,cumsum_region_cell_number(region_num) + 0.5],'LineWidth',1,'Color','w')
end
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off
colormap('magma')

figure('Position',[1600,800,200,600],'Color','w')
imagesc(norm_trial_aver_corr_resp_right_delay_cell_dist_APP_all2,[0,1])
xlim([1,75])
for region_num = 1:7
    line([1,75],[cumsum_region_cell_number(region_num) + 0.5,cumsum_region_cell_number(region_num) + 0.5],'LineWidth',1,'Color','w')
end
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off
colormap('magma')

for region_num = 1:8
    for distractor_num = 1:4
        % Correct and incorrect (all) response.
        mean_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num} = nanmean(trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1});
        mean_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num} = nanmean(trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1});
        mean_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num} = nanmean(trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1});
        mean_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num} = nanmean(trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1});
        se_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num} = nanstd(trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1})./ ...
            (sum(~isnan(trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2}(:,1) - trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1}(:,1)))^0.5);
        se_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num} = nanstd(trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1})./ ...
            (sum(~isnan(trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2}(:,1) - trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1}(:,1)))^0.5);
        se_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num} = nanstd(trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1})./ ...
            (sum(~isnan(trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2}(:,1) - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1}(:,1)))^0.5);
        se_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num} = nanstd(trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1})./ ...
            (sum(~isnan(trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2}(:,1) - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1}(:,1)))^0.5);
    end
end

% Correct and incorrect (all) response.
% Control.
for region_num = 1:8
    y_lower_limit = [];
    y_upper_limit = [];
    for distractor_num = 1:4
        % Smooth.
        mean_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num} = smooth(mean_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num},fs_image/2)';
        se_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num} = smooth(se_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num},fs_image/2)';
        mean_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num} = smooth(mean_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num},fs_image/2)';
        se_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num} = smooth(se_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num},fs_image/2)';

        curve1_1{distractor_num} = mean_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num} + se_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num};
        curve1_2{distractor_num} = mean_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num} - se_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num};
        curve2_1{distractor_num} = mean_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num} + se_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num};
        curve2_2{distractor_num} = mean_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num} - se_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num};

        y_lower_limit = min([y_lower_limit,-1.5*max([max(abs(curve1_1{distractor_num})),max(abs(curve1_2{distractor_num})),max(abs(curve2_1{distractor_num})),max(abs(curve2_2{distractor_num}))])]);
        y_upper_limit = max([y_upper_limit,1.5*max([max(abs(curve1_1{distractor_num})),max(abs(curve1_2{distractor_num})),max(abs(curve2_1{distractor_num})),max(abs(curve2_2{distractor_num}))])]);
    end

    for distractor_num = 1:4
        clear x1 x2 in_between1 in_between2
        x1 = [1:75];
        x2 = [x1,fliplr(x1)];
        in_between1 = [curve1_1{distractor_num},fliplr(curve1_2{distractor_num})];
        in_between2 = [curve2_1{distractor_num},fliplr(curve2_2{distractor_num})];
        clear fig
        fig = figure('Position',[200*region_num,1200 - 200*(distractor_num - 1),200,100],'Color','w');
        set(gcf,'renderer','Painters')
        hold on
        h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
        set(h1,'facealpha',0.2)
        plot(mean_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num},'Color',[0.00,0.45,0.74])
        h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
        set(h2,'facealpha',0.2)
        plot(mean_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num},'Color',[0.64,0.08,0.18])
        line([1.*fs_image,1.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
        line([2.*fs_image,2.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
        line([6.*fs_image,6.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
        xlim([1,75])
        ylim([y_lower_limit,y_upper_limit])
        ax = gca;
        ax.XTickLabel = {''};
        ax.YTickLabel = {''};
        axis off
        %print(fig,['Region',num2str(region_num),'_distractor_type',num2str(distractor_num),'_corr_incorr_control'],'-dsvg','-r0','-painters')
    end
end

% APP.
for region_num = 1:8
    y_lower_limit = [];
    y_upper_limit = [];
    for distractor_num = 1:4
        % Smooth.
        mean_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num} = smooth(mean_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num},fs_image/2)';
        se_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num} = smooth(se_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num},fs_image/2)';
        mean_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num} = smooth(mean_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num},fs_image/2)';
        se_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num} = smooth(se_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num},fs_image/2)';

        curve1_1{distractor_num} = mean_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num} + se_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num};
        curve1_2{distractor_num} = mean_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num} - se_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num};
        curve2_1{distractor_num} = mean_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num} + se_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num};
        curve2_2{distractor_num} = mean_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num} - se_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num};

        y_lower_limit = min([y_lower_limit,-1.5*max([max(abs(curve1_1{distractor_num})),max(abs(curve1_2{distractor_num})),max(abs(curve2_1{distractor_num})),max(abs(curve2_2{distractor_num}))])]);
        y_upper_limit = max([y_upper_limit,1.5*max([max(abs(curve1_1{distractor_num})),max(abs(curve1_2{distractor_num})),max(abs(curve2_1{distractor_num})),max(abs(curve2_2{distractor_num}))])]);
    end

    for distractor_num = 1:4
        clear x1 x2 in_between1 in_between2
        x1 = [1:75];
        x2 = [x1,fliplr(x1)];
        in_between1 = [curve1_1{distractor_num},fliplr(curve1_2{distractor_num})];
        in_between2 = [curve2_1{distractor_num},fliplr(curve2_2{distractor_num})];
        clear fig
        fig = figure('Position',[200*region_num,1200 - 200*(distractor_num - 1),200,100],'Color','w');
        set(gcf,'renderer','Painters')
        hold on
        h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
        set(h1,'facealpha',0.2)
        plot(mean_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num},'Color',[0.00,0.45,0.74])
        h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
        set(h2,'facealpha',0.2)
        plot(mean_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num},'Color',[0.64,0.08,0.18])
        line([1.*fs_image,1.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
        line([2.*fs_image,2.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
        line([6.*fs_image,6.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
        xlim([1,75])
        ylim([y_lower_limit,y_upper_limit])
        ax = gca;
        ax.XTickLabel = {''};
        ax.YTickLabel = {''};
        axis off
        %print(fig,['Region',num2str(region_num),'_distractor_type',num2str(distractor_num),'_corr_incorr_APP'],'-dsvg','-r0','-painters')
    end
end

clear y_lower_limit y_upper_limit
for region_num = 1:8
    y_lower_limit_temp{region_num} = [];
    y_upper_limit_temp{region_num} = [];
    for distractor_num = 1:4
        mean_corr_incorr_resp_selectivity_delay_cell_control{region_num}{distractor_num} = mean_corr_incorr_resp_right_delay_cell_control{region_num}{distractor_num} - mean_corr_incorr_resp_left_delay_cell_control{region_num}{distractor_num};
        mean_corr_incorr_resp_selectivity_delay_cell_APP{region_num}{distractor_num} = mean_corr_incorr_resp_right_delay_cell_APP{region_num}{distractor_num} - mean_corr_incorr_resp_left_delay_cell_APP{region_num}{distractor_num};
        y_lower_limit_temp{region_num} = [y_lower_limit_temp{region_num},min(min(mean_corr_incorr_resp_selectivity_delay_cell_control{region_num}{distractor_num}),min(mean_corr_incorr_resp_selectivity_delay_cell_APP{region_num}{distractor_num}))];
        y_upper_limit_temp{region_num} = [y_upper_limit_temp{region_num},max(max(mean_corr_incorr_resp_selectivity_delay_cell_control{region_num}{distractor_num}),max(mean_corr_incorr_resp_selectivity_delay_cell_APP{region_num}{distractor_num}))];
    end
    y_lower_limit(region_num) = 1.1*min(y_lower_limit_temp{region_num});
    y_upper_limit(region_num) = 1.1*max(y_upper_limit_temp{region_num});
end
for region_num = 1:8
    figure('Position',[200*region_num,1100,200,200],'Color','w');
    hold on
    for distractor_num = 4:-1:1
        plot(mean_corr_incorr_resp_selectivity_delay_cell_control{region_num}{distractor_num},'Color',[0,0,0,1 - (distractor_num - 1)*0.25],'LineWidth',1.5)
        line([1,75],[0,0],'Color',[0.25,0.25,0.25])
        line([1.*fs_image,1.*fs_image],[y_lower_limit(region_num),y_upper_limit(region_num)],'Color',[0.25,0.25,0.25])
        line([2.*fs_image,2.*fs_image],[y_lower_limit(region_num),y_upper_limit(region_num)],'Color',[0.25,0.25,0.25])
        line([6.*fs_image,6.*fs_image],[y_lower_limit(region_num),y_upper_limit(region_num)],'Color',[0.25,0.25,0.25])
        xlim([1,75])
        ylim([y_lower_limit(region_num),y_upper_limit(region_num)])
        ax = gca;
        ax.XTickLabel = {''};
        ax.YTickLabel = {''};
        axis off
    end

    figure('Position',[200*region_num,800,200,200],'Color','w');
    hold on
    for distractor_num = 4:-1:1
        plot(mean_corr_incorr_resp_selectivity_delay_cell_APP{region_num}{distractor_num},'Color',[0.64,0.08,0.018,1 - (distractor_num - 1)*0.25],'LineWidth',1.5)
        line([1,75],[0,0],'Color',[0.25,0.25,0.25])
        line([1.*fs_image,1.*fs_image],[y_lower_limit(region_num),y_upper_limit(region_num)],'Color',[0.25,0.25,0.25])
        line([2.*fs_image,2.*fs_image],[y_lower_limit(region_num),y_upper_limit(region_num)],'Color',[0.25,0.25,0.25])
        line([6.*fs_image,6.*fs_image],[y_lower_limit(region_num),y_upper_limit(region_num)],'Color',[0.25,0.25,0.25])
        xlim([1,75])
        ylim([y_lower_limit(region_num),y_upper_limit(region_num)])
        ax = gca;
        ax.XTickLabel = {''};
        ax.YTickLabel = {''};
        axis off
    end
end

for region_num = 1:8
    mean_delay_selectivity_corr_control(region_num) = mean(nanmean(trial_averaged_activity_control.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{2}(:,round(2*fs_image):round(6*fs_image)) - trial_averaged_activity_control.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{1}(:,round(2*fs_image):round(6*fs_image))) - ...
        nanmean(trial_averaged_activity_control.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{2}(:,round(2*fs_image):round(6*fs_image)) - trial_averaged_activity_control.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{1}(:,round(2*fs_image):round(6*fs_image))));
    mean_delay_selectivity_incorr_control(region_num) = mean(nanmean(trial_averaged_activity_control.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{2}(:,round(2*fs_image):round(6*fs_image)) - trial_averaged_activity_control.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{1}(:,round(2*fs_image):round(6*fs_image))) - ...
        nanmean(trial_averaged_activity_control.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{2}(:,round(2*fs_image):round(6*fs_image)) - trial_averaged_activity_control.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{1}(:,round(2*fs_image):round(6*fs_image))));

    mean_delay_selectivity_corr_APP(region_num) = mean(nanmean(trial_averaged_activity_APP.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{2}(:,round(2*fs_image):round(6*fs_image)) - trial_averaged_activity_APP.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{1}(:,round(2*fs_image):round(6*fs_image))) - ...
        nanmean(trial_averaged_activity_APP.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{2}(:,round(2*fs_image):round(6*fs_image)) - trial_averaged_activity_APP.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{1}(:,round(2*fs_image):round(6*fs_image))));
    mean_delay_selectivity_incorr_APP(region_num) = mean(nanmean(trial_averaged_activity_APP.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{2}(:,round(2*fs_image):round(6*fs_image)) - trial_averaged_activity_APP.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{1}(:,round(2*fs_image):round(6*fs_image))) - ...
        nanmean(trial_averaged_activity_APP.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{2}(:,round(2*fs_image):round(6*fs_image)) - trial_averaged_activity_APP.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{1}(:,round(2*fs_image):round(6*fs_image))));
end

figure('Position',[1000,300,200,200],'Color','w')
hold on
plot(mean_delay_selectivity_corr_control,mean_delay_selectivity_incorr_control,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(mean_delay_selectivity_corr_APP,mean_delay_selectivity_incorr_APP,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
line([-0.1,0.4],[-0.1,0.4],'Color',[0.25,0.25,0.25])
xlabel('Correct');
ylabel('Incorrect');
xlim([-0.1,0.4])
ylim([-0.1,0.4])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.2,0.4];
ax.YTick = [0,0.2,0.4];
ax.XTickLabel = {'0','0.2','0.4'};
ax.YTickLabel = {'0','0.2','0.4'};

% Concatenate across regions.
% Control.
for distractor_num = 1:4
    selectivity_left_corr_incorr_control{distractor_num} = [];
    selectivity_right_corr_incorr_control{distractor_num} = [];
    selectivity_left_corr_control{distractor_num} = [];
    selectivity_right_corr_control{distractor_num} = [];
    selectivity_left_incorr_control{distractor_num} = [];
    selectivity_right_incorr_control{distractor_num} = [];
end
for region_num = 1:8
    for distractor_num = 1:4
        selectivity_left_corr_incorr_control{distractor_num} = [selectivity_left_corr_incorr_control{distractor_num};trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_right_corr_incorr_control{distractor_num} = [selectivity_right_corr_incorr_control{distractor_num};trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_left_corr_control{distractor_num} = [selectivity_left_corr_control{distractor_num};trial_averaged_activity_control.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_right_corr_control{distractor_num} = [selectivity_right_corr_control{distractor_num};trial_averaged_activity_control.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_left_incorr_control{distractor_num} = [selectivity_left_incorr_control{distractor_num};trial_averaged_activity_control.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_right_incorr_control{distractor_num} = [selectivity_right_incorr_control{distractor_num};trial_averaged_activity_control.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_control.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
    end
end
for distractor_num = 1:4
    mean_selectivity_left_corr_incorr_control{distractor_num} = nanmean(selectivity_left_corr_incorr_control{distractor_num});
    mean_selectivity_right_corr_incorr_control{distractor_num} = nanmean(selectivity_right_corr_incorr_control{distractor_num});
    se_selectivity_left_corr_incorr_control{distractor_num} = nanstd(selectivity_left_corr_incorr_control{distractor_num})/(sum(~isnan(selectivity_left_corr_incorr_control{distractor_num}(:,1)))^0.5);
    se_selectivity_right_corr_incorr_control{distractor_num} = nanstd(selectivity_right_corr_incorr_control{distractor_num})/(sum(~isnan(selectivity_right_corr_incorr_control{distractor_num}(:,1)))^0.5);
    mean_selectivity_left_corr_control{distractor_num} = nanmean(selectivity_left_corr_control{distractor_num});
    mean_selectivity_right_corr_control{distractor_num} = nanmean(selectivity_right_corr_control{distractor_num});
    se_selectivity_left_corr_control{distractor_num} = nanstd(selectivity_left_corr_control{distractor_num})/(sum(~isnan(selectivity_left_corr_control{distractor_num}(:,1)))^0.5);
    se_selectivity_right_corr_control{distractor_num} = nanstd(selectivity_right_corr_control{distractor_num})/(sum(~isnan(selectivity_right_corr_control{distractor_num}(:,1)))^0.5);
    mean_selectivity_left_incorr_control{distractor_num} = nanmean(selectivity_left_incorr_control{distractor_num});
    mean_selectivity_right_incorr_control{distractor_num} = nanmean(selectivity_right_incorr_control{distractor_num});
    se_selectivity_left_incorr_control{distractor_num} = nanstd(selectivity_left_incorr_control{distractor_num})/(sum(~isnan(selectivity_left_incorr_control{distractor_num}(:,1)))^0.5);
    se_selectivity_right_incorr_control{distractor_num} = nanstd(selectivity_right_incorr_control{distractor_num})/(sum(~isnan(selectivity_right_incorr_control{distractor_num}(:,1)))^0.5);
end

% Smooth.
for distractor_num = 1:4
    mean_selectivity_left_corr_incorr_control{distractor_num} = smooth(mean_selectivity_left_corr_incorr_control{distractor_num},fs_image/2)';
    mean_selectivity_right_corr_incorr_control{distractor_num} = smooth(mean_selectivity_right_corr_incorr_control{distractor_num},fs_image/2)';
    se_selectivity_left_corr_incorr_control{distractor_num} = smooth(se_selectivity_left_corr_incorr_control{distractor_num},fs_image/2)';
    se_selectivity_right_corr_incorr_control{distractor_num} = smooth(se_selectivity_right_corr_incorr_control{distractor_num},fs_image/2)';
    mean_selectivity_left_corr_control{distractor_num} = smooth(mean_selectivity_left_corr_control{distractor_num},fs_image/2)';
    mean_selectivity_right_corr_control{distractor_num} = smooth(mean_selectivity_right_corr_control{distractor_num},fs_image/2)';
    se_selectivity_left_corr_control{distractor_num} = smooth(se_selectivity_left_corr_control{distractor_num},fs_image/2)';
    se_selectivity_right_corr_control{distractor_num} = smooth(se_selectivity_right_corr_control{distractor_num},fs_image/2)';
    mean_selectivity_left_incorr_control{distractor_num} = smooth(mean_selectivity_left_incorr_control{distractor_num},fs_image/2)';
    mean_selectivity_right_incorr_control{distractor_num} = smooth(mean_selectivity_right_incorr_control{distractor_num},fs_image/2)';
    se_selectivity_left_incorr_control{distractor_num} = smooth(se_selectivity_left_incorr_control{distractor_num},fs_image/2)';
    se_selectivity_right_incorr_control{distractor_num} = smooth(se_selectivity_right_incorr_control{distractor_num},fs_image/2)';
end

figure('Position',[600,400,200,100],'Color','w');
hold on
plot(mean_selectivity_right_corr_control{1} - mean_selectivity_left_corr_control{1},'Color',[0.25,0.25,0.25],'LineWidth',1)
plot(mean_selectivity_right_incorr_control{1} - mean_selectivity_left_incorr_control{1},'Color',[0.25,0.25,0.25],'LineWidth',1)
line([1.*fs_image,1.*fs_image],[-0.6,0.6],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[-0.6,0.6],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[-0.6,0.6],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([-0.6,0.6])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

clear curve1_1_corr_incorr curve1_2_corr_incorr curve2_1_corr_incorr curve2_2_corr_incorr
y_lower_limit = [];
y_upper_limit = [];
for distractor_num = 1:4
    curve1_1_corr_incorr{distractor_num} = mean_selectivity_left_corr_incorr_control{distractor_num} + se_selectivity_left_corr_incorr_control{distractor_num};
    curve1_2_corr_incorr{distractor_num} = mean_selectivity_left_corr_incorr_control{distractor_num} - se_selectivity_left_corr_incorr_control{distractor_num};
    curve2_1_corr_incorr{distractor_num} = mean_selectivity_right_corr_incorr_control{distractor_num} + se_selectivity_right_corr_incorr_control{distractor_num};
    curve2_2_corr_incorr{distractor_num} = mean_selectivity_right_corr_incorr_control{distractor_num} - se_selectivity_right_corr_incorr_control{distractor_num};

    y_lower_limit = min([y_lower_limit,-1.5*max([max(abs(curve1_1_corr_incorr{distractor_num})),max(abs(curve1_2_corr_incorr{distractor_num})),max(abs(curve2_1_corr_incorr{distractor_num})),max(abs(curve2_2_corr_incorr{distractor_num}))])]);
    y_upper_limit = max([y_upper_limit,1.5*max([max(abs(curve1_1_corr_incorr{distractor_num})),max(abs(curve1_2_corr_incorr{distractor_num})),max(abs(curve2_1_corr_incorr{distractor_num})),max(abs(curve2_2_corr_incorr{distractor_num}))])]);
end

y_lower_limit = [];
y_upper_limit = [];
for distractor_num = 1
    curve1_1_corr{distractor_num} = mean_selectivity_left_corr_control{distractor_num} + se_selectivity_left_corr_control{distractor_num};
    curve1_2_corr{distractor_num} = mean_selectivity_left_corr_control{distractor_num} - se_selectivity_left_corr_control{distractor_num};
    curve2_1_corr{distractor_num} = mean_selectivity_right_corr_control{distractor_num} + se_selectivity_right_corr_control{distractor_num};
    curve2_2_corr{distractor_num} = mean_selectivity_right_corr_control{distractor_num} - se_selectivity_right_corr_control{distractor_num};
    curve1_1_incorr{distractor_num} = mean_selectivity_left_incorr_control{distractor_num} + se_selectivity_left_incorr_control{distractor_num};
    curve1_2_incorr{distractor_num} = mean_selectivity_left_incorr_control{distractor_num} - se_selectivity_left_incorr_control{distractor_num};
    curve2_1_incorr{distractor_num} = mean_selectivity_right_incorr_control{distractor_num} + se_selectivity_right_incorr_control{distractor_num};
    curve2_2_incorr{distractor_num} = mean_selectivity_right_incorr_control{distractor_num} - se_selectivity_right_incorr_control{distractor_num};

    y_lower_limit = min([y_lower_limit,-1.5*max([max(abs(curve1_1_corr{distractor_num})),max(abs(curve1_2_corr{distractor_num})),max(abs(curve2_1_corr{distractor_num})),max(abs(curve2_2_corr{distractor_num})) ...
        max(abs(curve1_1_incorr{distractor_num})),max(abs(curve1_2_incorr{distractor_num})),max(abs(curve2_1_incorr{distractor_num})),max(abs(curve2_2_incorr{distractor_num}))])]);
    y_upper_limit = min([y_upper_limit,1.5*max([max(abs(curve1_1_corr{distractor_num})),max(abs(curve1_2_corr{distractor_num})),max(abs(curve2_1_corr{distractor_num})),max(abs(curve2_2_corr{distractor_num})) ...
        max(abs(curve1_1_incorr{distractor_num})),max(abs(curve1_2_incorr{distractor_num})),max(abs(curve2_1_incorr{distractor_num})),max(abs(curve2_2_incorr{distractor_num}))])]);

    clear x1 x2 in_between1 in_between2
    x1 = [1:75];
    x2 = [x1,fliplr(x1)];
    in_between1 = [curve1_1_corr{distractor_num},fliplr(curve1_2_corr{distractor_num})];
    in_between2 = [curve2_1_corr{distractor_num},fliplr(curve2_2_corr{distractor_num})];
    figure('Position',[200,400,200,100],'Color','w');
    hold on
    h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
    set(h1,'facealpha',0.2)
    plot(mean_selectivity_left_corr_control{distractor_num},'Color',[0.00,0.45,0.74])
    h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
    set(h2,'facealpha',0.2)
    plot(mean_selectivity_right_corr_control{distractor_num},'Color',[0.64,0.08,0.18])
    line([1.*fs_image,1.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
    line([2.*fs_image,2.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
    line([6.*fs_image,6.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
    xlim([1,75])
    ylim([y_lower_limit,y_upper_limit])
    ax = gca;
    ax.XTickLabel = {''};
    ax.YTickLabel = {''};
    axis off

    clear x1 x2 in_between1 in_between2
    x1 = [1:75];
    x2 = [x1,fliplr(x1)];
    in_between1 = [curve1_1_incorr{distractor_num},fliplr(curve1_2_incorr{distractor_num})];
    in_between2 = [curve2_1_incorr{distractor_num},fliplr(curve2_2_incorr{distractor_num})];
    figure('Position',[400,400,200,100],'Color','w');
    hold on
    h1 = fill(x2,in_between1,[0.00,0.45,0.74],'LineStyle','none');
    set(h1,'facealpha',0.2)
    plot(mean_selectivity_left_incorr_control{distractor_num},'Color',[0.00,0.45,0.74])
    h2 = fill(x2,in_between2,[0.64,0.08,0.18],'LineStyle','none');
    set(h2,'facealpha',0.2)
    plot(mean_selectivity_right_incorr_control{distractor_num},'Color',[0.64,0.08,0.18])
    line([1.*fs_image,1.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
    line([2.*fs_image,2.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
    line([6.*fs_image,6.*fs_image],[y_lower_limit,y_upper_limit],'Color',[0.25,0.25,0.25])
    xlim([1,75])
    ylim([y_lower_limit,y_upper_limit])
    ax = gca;
    ax.XTickLabel = {''};
    ax.YTickLabel = {''};
    axis off
end

% APP.
for distractor_num = 1:4
    selectivity_left_corr_incorr_APP{distractor_num} = [];
    selectivity_right_corr_incorr_APP{distractor_num} = [];
    selectivity_left_corr_APP{distractor_num} = [];
    selectivity_right_corr_APP{distractor_num} = [];
    selectivity_left_incorr_APP{distractor_num} = [];
    selectivity_right_incorr_APP{distractor_num} = [];
end
for region_num = 1:8
    for distractor_num = 1:4
        selectivity_left_corr_incorr_APP{distractor_num} = [selectivity_left_corr_incorr_APP{distractor_num};trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_right_corr_incorr_APP{distractor_num} = [selectivity_right_corr_incorr_APP{distractor_num};trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_left_corr_APP{distractor_num} = [selectivity_left_corr_APP{distractor_num};trial_averaged_activity_APP.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_corr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_right_corr_APP{distractor_num} = [selectivity_right_corr_APP{distractor_num};trial_averaged_activity_APP.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_corr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_left_incorr_APP{distractor_num} = [selectivity_left_incorr_APP{distractor_num};trial_averaged_activity_APP.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
        selectivity_right_incorr_APP{distractor_num} = [selectivity_right_incorr_APP{distractor_num};trial_averaged_activity_APP.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2} - trial_averaged_activity_APP.trial_aver_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_num*2 - 1}];
    end
end
for distractor_num = 1:4
    mean_selectivity_left_corr_incorr_APP{distractor_num} = nanmean(selectivity_left_corr_incorr_APP{distractor_num});
    mean_selectivity_right_corr_incorr_APP{distractor_num} = nanmean(selectivity_right_corr_incorr_APP{distractor_num});
    se_selectivity_left_corr_incorr_APP{distractor_num} = nanstd(selectivity_left_corr_incorr_APP{distractor_num})/(sum(~isnan(selectivity_left_corr_incorr_APP{distractor_num}(:,1)))^0.5);
    se_selectivity_right_corr_incorr_APP{distractor_num} = nanstd(selectivity_right_corr_incorr_APP{distractor_num})/(sum(~isnan(selectivity_right_corr_incorr_APP{distractor_num}(:,1)))^0.5);
    mean_selectivity_left_corr_APP{distractor_num} = nanmean(selectivity_left_corr_APP{distractor_num});
    mean_selectivity_right_corr_APP{distractor_num} = nanmean(selectivity_right_corr_APP{distractor_num});
    se_selectivity_left_corr_APP{distractor_num} = nanstd(selectivity_left_corr_APP{distractor_num})/(sum(~isnan(selectivity_left_corr_APP{distractor_num}(:,1)))^0.5);
    se_selectivity_right_corr_APP{distractor_num} = nanstd(selectivity_right_corr_APP{distractor_num})/(sum(~isnan(selectivity_right_corr_APP{distractor_num}(:,1)))^0.5);
    mean_selectivity_left_incorr_APP{distractor_num} = nanmean(selectivity_left_incorr_APP{distractor_num});
    mean_selectivity_right_incorr_APP{distractor_num} = nanmean(selectivity_right_incorr_APP{distractor_num});
    se_selectivity_left_incorr_APP{distractor_num} = nanstd(selectivity_left_incorr_APP{distractor_num})/(sum(~isnan(selectivity_left_incorr_APP{distractor_num}(:,1)))^0.5);
    se_selectivity_right_incorr_APP{distractor_num} = nanstd(selectivity_right_incorr_APP{distractor_num})/(sum(~isnan(selectivity_right_incorr_APP{distractor_num}(:,1)))^0.5);
end

% Smooth.
for distractor_num = 1:4
    mean_selectivity_left_corr_incorr_APP{distractor_num} = smooth(mean_selectivity_left_corr_incorr_APP{distractor_num},fs_image/2)';
    mean_selectivity_right_corr_incorr_APP{distractor_num} = smooth(mean_selectivity_right_corr_incorr_APP{distractor_num},fs_image/2)';
    se_selectivity_left_corr_incorr_APP{distractor_num} = smooth(se_selectivity_left_corr_incorr_APP{distractor_num},fs_image/2)';
    se_selectivity_right_corr_incorr_APP{distractor_num} = smooth(se_selectivity_right_corr_incorr_APP{distractor_num},fs_image/2)';
    mean_selectivity_left_corr_APP{distractor_num} = smooth(mean_selectivity_left_corr_APP{distractor_num},fs_image/2)';
    mean_selectivity_right_corr_APP{distractor_num} = smooth(mean_selectivity_right_corr_APP{distractor_num},fs_image/2)';
    se_selectivity_left_corr_APP{distractor_num} = smooth(se_selectivity_left_corr_APP{distractor_num},fs_image/2)';
    se_selectivity_right_corr_APP{distractor_num} = smooth(se_selectivity_right_corr_APP{distractor_num},fs_image/2)';
    mean_selectivity_left_incorr_APP{distractor_num} = smooth(mean_selectivity_left_incorr_APP{distractor_num},fs_image/2)';
    mean_selectivity_right_incorr_APP{distractor_num} = smooth(mean_selectivity_right_incorr_APP{distractor_num},fs_image/2)';
    se_selectivity_left_incorr_APP{distractor_num} = smooth(se_selectivity_left_incorr_APP{distractor_num},fs_image/2)';
    se_selectivity_right_incorr_APP{distractor_num} = smooth(se_selectivity_right_incorr_APP{distractor_num},fs_image/2)';
end

figure('Position',[800,400,200,100],'Color','w');
hold on
plot(mean_selectivity_right_corr_APP{1} - mean_selectivity_left_corr_APP{1},'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(mean_selectivity_right_incorr_APP{1} - mean_selectivity_left_incorr_APP{1},'Color',[0.64,0.08,0.18],'LineWidth',1)
line([1.*fs_image,1.*fs_image],[-0.6,0.6],'Color',[0.25,0.25,0.25])
line([2.*fs_image,2.*fs_image],[-0.6,0.6],'Color',[0.25,0.25,0.25])
line([6.*fs_image,6.*fs_image],[-0.6,0.6],'Color',[0.25,0.25,0.25])
xlim([1,75])
ylim([-0.6,0.6])
ax = gca;
ax.XTickLabel = {''};
ax.YTickLabel = {''};
axis off

rng(0)

% Control.
for region_num = 1:8
    for distractor_type = 1:4
        diff_left_delay_cell_control{region_num}{distractor_type} = trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_right_delay_cell_control{region_num}{distractor_type} = trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_control.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
    end
end

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
        diff_left_delay_cell_APP{region_num}{distractor_type} = trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_left_delay_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
        diff_right_delay_cell_APP{region_num}{distractor_type} = trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{distractor_type*2} - trial_averaged_activity_APP.trial_aver_corr_incorr_resp_right_delay_cell_animal_session{region_num}{(distractor_type - 1)*2 + 1};
    end
end

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

% Plot distractor-mediated activity modulation differences.
for region_num = 1:8
    for distractor_type = 1:4
        selectivity_all_delay_cell_control{region_num}{distractor_type} = mean(diff_right_delay_cell_control{region_num}{distractor_type}) - mean(diff_left_delay_cell_control{region_num}{distractor_type});
        selectivity_modulation_all_delay_cell_control(region_num,distractor_type) = mean(selectivity_all_delay_cell_control{region_num}{distractor_type}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image))) - mean(selectivity_all_delay_cell_control{region_num}{1}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)));

        selectivity_all_delay_cell_APP{region_num}{distractor_type} = mean(diff_right_delay_cell_APP{region_num}{distractor_type}) - mean(diff_left_delay_cell_APP{region_num}{distractor_type});
        selectivity_modulation_all_delay_cell_APP(region_num,distractor_type) = mean(selectivity_all_delay_cell_APP{region_num}{distractor_type}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image))) - mean(selectivity_all_delay_cell_APP{region_num}{1}(round((distractor_type + 1)*fs_image):round((distractor_type + 2)*fs_image)));
    end
end

figure('Position',[1400,300,200,200],'Color','w')
imagesc(selectivity_modulation_all_delay_cell_APP - selectivity_modulation_all_delay_cell_control,[-0.2,0.2])
axis square
xlabel('');
ylabel('');
axis off
colormap('redblue')

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
figure('Position',[1600,300,200,200],'Color','w')
imagesc([zeros(8,1),reshape(vector,[8,3])],[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

end