function plot_functional_connectivity_task_var_cell

close all
clear all
clc

% Plot functional connectivity between task-variable cells.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('activity_control.mat')
load('activity_iti_control.mat')
activity = activity_control;
activity_iti = activity_iti_control;
clear activity_control
clear activity_iti_control

% Initialize.
stimulus_stimulus_fc_all_regions_animal_session = [];
delay_delay_fc_all_regions_animal_session = [];
action_action_fc_all_regions_animal_session = [];
stimulus_delay_fc_all_regions_animal_session = [];
stimulus_action_fc_all_regions_animal_session = [];
delay_action_fc_all_regions_animal_session = [];
stimulus_delay_action_fc_all_regions_animal_session = [];
for region_num1 = 1:8
    for region_num2 = 1:8
        stimulus_stimulus_fc_animal_session{region_num1}{region_num2} = [];
        delay_delay_fc_animal_session{region_num1}{region_num2} = [];
        action_action_fc_animal_session{region_num1}{region_num2} = [];
    end
end

for animal_num = 1:numel(activity_iti)
    clearvars -except activity activity_iti ...
        stimulus_stimulus_fc_all_regions_animal_session delay_delay_fc_all_regions_animal_session action_action_fc_all_regions_animal_session stimulus_delay_fc_all_regions_animal_session stimulus_action_fc_all_regions_animal_session delay_action_fc_all_regions_animal_session stimulus_delay_action_fc_all_regions_animal_session ...
        stimulus_stimulus_fc_animal_session delay_delay_fc_animal_session action_action_fc_animal_session ...
        animal_num

    % Initialize.
    stimulus_stimulus_fc_all_regions_session = [];
    delay_delay_fc_all_regions_session = [];
    action_action_fc_all_regions_session = [];
    stimulus_delay_fc_all_regions_session = [];
    stimulus_action_fc_all_regions_session = [];
    delay_action_fc_all_regions_session = [];
    stimulus_delay_action_fc_all_regions_session = [];
    for region_num1 = 1:8
        for region_num2 = 1:8
            stimulus_stimulus_fc_session{region_num1}{region_num2} = [];
            delay_delay_fc_session{region_num1}{region_num2} = [];
            action_action_fc_session{region_num1}{region_num2} = [];
        end
    end

    for session_num = 1:numel(activity_iti{animal_num})
        clearvars -except activity activity_iti ...
            stimulus_stimulus_fc_all_regions_animal_session delay_delay_fc_all_regions_animal_session action_action_fc_all_regions_animal_session stimulus_delay_fc_all_regions_animal_session stimulus_action_fc_all_regions_animal_session delay_action_fc_all_regions_animal_session stimulus_delay_action_fc_all_regions_animal_session ...
            stimulus_stimulus_fc_animal_session delay_delay_fc_animal_session action_action_fc_animal_session ...
            animal_num ...
            stimulus_stimulus_fc_all_regions_session delay_delay_fc_all_regions_session action_action_fc_all_regions_session stimulus_delay_fc_all_regions_session stimulus_action_fc_all_regions_session delay_action_fc_all_regions_session stimulus_delay_action_fc_all_regions_session ...
            stimulus_stimulus_fc_session delay_delay_fc_session action_action_fc_session ...
            session_num

        % Sampling frequency of Scanimage.
        fs_image = 9.35211;

        % Initialize.
        stimulus_cell_idx_all_regions = [];
        delay_cell_idx_all_regions = [];
        action_cell_idx_all_regions = [];

        % Determine whether neurons are selective to task variables.
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) ~= 0
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
            % Task-variable cell index.
            p_value_thresh = 0.01;
            stimulus_cell_idx_temp{region_num} = find(stimulus_p_value{region_num} < p_value_thresh);
            delay_cell_idx_temp{region_num} = find(delay_p_value{region_num} < p_value_thresh);
            action_cell_idx_temp{region_num} = find(action_p_value{region_num} < p_value_thresh);

            if ~isnan(activity_iti{animal_num}{session_num}.region_cell_idx{region_num})
                mean_activity_iti{region_num} = mean(activity_iti{animal_num}{session_num}.activity_iti_all_regions(activity_iti{animal_num}{session_num}.region_cell_idx{region_num},:),2);
            else
                mean_activity_iti{region_num} = [];
            end
            cell_idx{region_num} = find(mean_activity_iti{region_num} > -0.0275);

            stimulus_cell_idx{region_num} = intersect(stimulus_cell_idx_temp{region_num},cell_idx{region_num});
            delay_cell_idx{region_num} = intersect(delay_cell_idx_temp{region_num},cell_idx{region_num});
            action_cell_idx{region_num} = intersect(action_cell_idx_temp{region_num},cell_idx{region_num});

            stimulus_region_cell_idx_temp(region_num) = numel(stimulus_cell_idx{region_num});
            delay_region_cell_idx_temp(region_num) = numel(delay_cell_idx{region_num});
            action_region_cell_idx_temp(region_num) = numel(action_cell_idx{region_num});

            stimulus_cell_idx_all_regions = [stimulus_cell_idx_all_regions,activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(stimulus_cell_idx{region_num})];
            delay_cell_idx_all_regions = [delay_cell_idx_all_regions,activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(delay_cell_idx{region_num})];
            action_cell_idx_all_regions = [action_cell_idx_all_regions,activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(action_cell_idx{region_num})];
        end

        stimulus_stimulus_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(stimulus_cell_idx_all_regions,stimulus_cell_idx_all_regions);
        delay_delay_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(delay_cell_idx_all_regions,delay_cell_idx_all_regions);
        action_action_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(action_cell_idx_all_regions,action_cell_idx_all_regions);
        stimulus_delay_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(stimulus_cell_idx_all_regions,delay_cell_idx_all_regions);
        stimulus_action_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(stimulus_cell_idx_all_regions,action_cell_idx_all_regions);
        delay_action_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(delay_cell_idx_all_regions,action_cell_idx_all_regions);

        for cell_num = 1:size(stimulus_stimulus_fc_all_regions,1)
            stimulus_stimulus_fc_all_regions(cell_num,cell_num:end) = nan;
        end
        for cell_num = 1:size(delay_delay_fc_all_regions,1)
            delay_delay_fc_all_regions(cell_num,cell_num:end) = nan;
        end
        for cell_num = 1:size(action_action_fc_all_regions,1)
            action_action_fc_all_regions(cell_num,cell_num:end) = nan;
        end
        stimulus_delay_fc_all_regions(stimulus_delay_fc_all_regions == 1) = nan; % Remove autocorrelation.
        stimulus_action_fc_all_regions(stimulus_action_fc_all_regions == 1) = nan; % Remove autocorrelation.
        delay_action_fc_all_regions(delay_action_fc_all_regions == 1) = nan; % Remove autocorrelation.
        stimulus_delay_action_fc_all_regions = [stimulus_delay_fc_all_regions(:);stimulus_action_fc_all_regions(:);delay_action_fc_all_regions(:)];

        % Region-specific task-variable cell index.
        cumsum_stimulus_region_cell_idx1 = cumsum(stimulus_region_cell_idx_temp);
        cumsum_stimulus_region_cell_idx2 = cumsum_stimulus_region_cell_idx1 + 1;
        stimulus_region_cell_idx{1} = [1:cumsum_stimulus_region_cell_idx1(1)];
        for region_num = 2:8
            stimulus_region_cell_idx{region_num} = [cumsum_stimulus_region_cell_idx2(region_num - 1):cumsum_stimulus_region_cell_idx1(region_num)];
        end

        cumsum_delay_region_cell_idx1 = cumsum(delay_region_cell_idx_temp);
        cumsum_delay_region_cell_idx2 = cumsum_delay_region_cell_idx1 + 1;
        delay_region_cell_idx{1} = [1:cumsum_delay_region_cell_idx1(1)];
        for region_num = 2:8
            delay_region_cell_idx{region_num} = [cumsum_delay_region_cell_idx2(region_num - 1):cumsum_delay_region_cell_idx1(region_num)];
        end

        cumsum_action_region_cell_idx1 = cumsum(action_region_cell_idx_temp);
        cumsum_action_region_cell_idx2 = cumsum_action_region_cell_idx1 + 1;
        action_region_cell_idx{1} = [1:cumsum_action_region_cell_idx1(1)];
        for region_num = 2:8
            action_region_cell_idx{region_num} = [cumsum_action_region_cell_idx2(region_num - 1):cumsum_action_region_cell_idx1(region_num)];
        end

        % Reion-by-region analysis.
        for region_num1 = 1:8
            for region_num2 = 1:8
                stimulus_stimulus_fc{region_num1}{region_num2} = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(stimulus_cell_idx_all_regions(stimulus_region_cell_idx{region_num1}),stimulus_cell_idx_all_regions(stimulus_region_cell_idx{region_num2}));
                delay_delay_fc{region_num1}{region_num2} = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(delay_cell_idx_all_regions(delay_region_cell_idx{region_num1}),delay_cell_idx_all_regions(delay_region_cell_idx{region_num2}));
                action_action_fc{region_num1}{region_num2} = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(action_cell_idx_all_regions(action_region_cell_idx{region_num1}),action_cell_idx_all_regions(action_region_cell_idx{region_num2}));

                stimulus_stimulus_fc{region_num1}{region_num2}(stimulus_stimulus_fc{region_num1}{region_num2} == 1) = nan; % Remove autocorrelation.
                % At least 10 comparisons.
                if sum(~isnan(stimulus_stimulus_fc{region_num1}{region_num2}(:))) < 10
                    stimulus_stimulus_fc{region_num1}{region_num2} = [];
                end
                delay_delay_fc{region_num1}{region_num2}(delay_delay_fc{region_num1}{region_num2} == 1) = nan; % Remove autocorrelation.
                % At least 10 comparisons.
                if sum(~isnan(delay_delay_fc{region_num1}{region_num2}(:))) < 10
                    delay_delay_fc{region_num1}{region_num2} = [];
                end
                action_action_fc{region_num1}{region_num2}(action_action_fc{region_num1}{region_num2} == 1) = nan; % Remove autocorrelation.
                % At least 10 comparisons.
                if sum(~isnan(action_action_fc{region_num1}{region_num2}(:))) < 10
                    action_action_fc{region_num1}{region_num2} = [];
                end
            end
        end

        for region_num = 1:8
            % At least 5 cells in each region (at least 10 comparisons).
            if size(stimulus_stimulus_fc{region_num}{region_num},1) < 5
                stimulus_stimulus_fc{region_num}{region_num} = [];
            end
            if size(delay_delay_fc{region_num}{region_num},1) < 5
                delay_delay_fc{region_num}{region_num} = [];
            end
            if size(action_action_fc{region_num}{region_num},1) < 5
                action_action_fc{region_num}{region_num} = [];
            end

            % Remove autocorrelation and redundant correlation.
            for cell_num = 1:size(stimulus_stimulus_fc{region_num}{region_num},1)
                stimulus_stimulus_fc{region_num}{region_num}(cell_num,cell_num:end) = nan;
            end
            for cell_num = 1:size(delay_delay_fc{region_num}{region_num},1)
                delay_delay_fc{region_num}{region_num}(cell_num,cell_num:end) = nan;
            end
            for cell_num = 1:size(action_action_fc{region_num}{region_num},1)
                action_action_fc{region_num}{region_num}(cell_num,cell_num:end) = nan;
            end
        end

        % Concatenate.
        stimulus_stimulus_fc_all_regions_session = [stimulus_stimulus_fc_all_regions_session,nanmean(stimulus_stimulus_fc_all_regions(:))];
        delay_delay_fc_all_regions_session = [delay_delay_fc_all_regions_session,nanmean(delay_delay_fc_all_regions(:))];
        action_action_fc_all_regions_session = [action_action_fc_all_regions_session,nanmean(action_action_fc_all_regions(:))];
        stimulus_delay_fc_all_regions_session = [stimulus_delay_fc_all_regions_session,nanmean(stimulus_delay_fc_all_regions(:))];
        stimulus_action_fc_all_regions_session = [stimulus_action_fc_all_regions_session,nanmean(stimulus_action_fc_all_regions(:))];
        delay_action_fc_all_regions_session = [delay_action_fc_all_regions_session,nanmean(delay_action_fc_all_regions(:))];
        stimulus_delay_action_fc_all_regions_session = [stimulus_delay_action_fc_all_regions_session,nanmean(stimulus_delay_action_fc_all_regions)];
        for region_num1 = 1:8
            for region_num2 = 1:8
                stimulus_stimulus_fc_session{region_num1}{region_num2} = [stimulus_stimulus_fc_session{region_num1}{region_num2},nanmean(stimulus_stimulus_fc{region_num1}{region_num2}(:))];
                delay_delay_fc_session{region_num1}{region_num2} = [delay_delay_fc_session{region_num1}{region_num2},nanmean(delay_delay_fc{region_num1}{region_num2}(:))];
                action_action_fc_session{region_num1}{region_num2} = [action_action_fc_session{region_num1}{region_num2},nanmean(action_action_fc{region_num1}{region_num2}(:))];
            end
        end
    end

    % Concatenate.
    stimulus_stimulus_fc_all_regions_animal_session = [stimulus_stimulus_fc_all_regions_animal_session,stimulus_stimulus_fc_all_regions_session];
    delay_delay_fc_all_regions_animal_session = [delay_delay_fc_all_regions_animal_session,delay_delay_fc_all_regions_session];
    action_action_fc_all_regions_animal_session = [action_action_fc_all_regions_animal_session,action_action_fc_all_regions_session];
    stimulus_delay_fc_all_regions_animal_session = [stimulus_delay_fc_all_regions_animal_session,stimulus_delay_fc_all_regions_session];
    stimulus_action_fc_all_regions_animal_session = [stimulus_action_fc_all_regions_animal_session,stimulus_action_fc_all_regions_session];
    delay_action_fc_all_regions_animal_session = [delay_action_fc_all_regions_animal_session,delay_action_fc_all_regions_session];
    stimulus_delay_action_fc_all_regions_animal_session = [stimulus_delay_action_fc_all_regions_animal_session,stimulus_delay_action_fc_all_regions_session];
    for region_num1 = 1:8
        for region_num2 = 1:8
            stimulus_stimulus_fc_animal_session{region_num1}{region_num2} = [stimulus_stimulus_fc_animal_session{region_num1}{region_num2},stimulus_stimulus_fc_session{region_num1}{region_num2}];
            delay_delay_fc_animal_session{region_num1}{region_num2} = [delay_delay_fc_animal_session{region_num1}{region_num2},delay_delay_fc_session{region_num1}{region_num2}];
            action_action_fc_animal_session{region_num1}{region_num2} = [action_action_fc_animal_session{region_num1}{region_num2},action_action_fc_session{region_num1}{region_num2}];
        end
    end
end

functional_connectivity_control.stimulus_stimulus_fc_all_regions = stimulus_stimulus_fc_all_regions_animal_session;
functional_connectivity_control.delay_delay_fc_all_regions = delay_delay_fc_all_regions_animal_session;
functional_connectivity_control.action_action_fc_all_regions = action_action_fc_all_regions_animal_session;
functional_connectivity_control.stimulus_delay_fc_all_regions = stimulus_delay_fc_all_regions_animal_session;
functional_connectivity_control.stimulus_action_fc_all_regions = stimulus_action_fc_all_regions_animal_session;
functional_connectivity_control.delay_action_fc_all_regions = delay_action_fc_all_regions_animal_session;
functional_connectivity_control.stimulus_delay_action_fc_all_regions = stimulus_delay_action_fc_all_regions_animal_session;
functional_connectivity_control.stimulus_stimulus_fc = stimulus_stimulus_fc_animal_session;
functional_connectivity_control.delay_delay_fc = delay_delay_fc_animal_session;
functional_connectivity_control.action_action_fc = action_action_fc_animal_session;

clearvars -except functional_connectivity_control

% APP.
load('activity_APP.mat')
load('activity_iti_APP.mat')
activity = activity_APP;
activity_iti = activity_iti_APP;
clear activity_APP
clear activity_iti_APP

% Initialize.
stimulus_stimulus_fc_all_regions_animal_session = [];
delay_delay_fc_all_regions_animal_session = [];
action_action_fc_all_regions_animal_session = [];
stimulus_delay_fc_all_regions_animal_session = [];
stimulus_action_fc_all_regions_animal_session = [];
delay_action_fc_all_regions_animal_session = [];
stimulus_delay_action_fc_all_regions_animal_session = [];
for region_num1 = 1:8
    for region_num2 = 1:8
        stimulus_stimulus_fc_animal_session{region_num1}{region_num2} = [];
        delay_delay_fc_animal_session{region_num1}{region_num2} = [];
        action_action_fc_animal_session{region_num1}{region_num2} = [];
    end
end

for animal_num = 1:numel(activity_iti)
    clearvars -except functional_connectivity_control ...
        activity activity_iti ...
        stimulus_stimulus_fc_all_regions_animal_session delay_delay_fc_all_regions_animal_session action_action_fc_all_regions_animal_session stimulus_delay_fc_all_regions_animal_session stimulus_action_fc_all_regions_animal_session delay_action_fc_all_regions_animal_session stimulus_delay_action_fc_all_regions_animal_session ...
        stimulus_stimulus_fc_animal_session delay_delay_fc_animal_session action_action_fc_animal_session ...
        animal_num

    % Initialize.
    stimulus_stimulus_fc_all_regions_session = [];
    delay_delay_fc_all_regions_session = [];
    action_action_fc_all_regions_session = [];
    stimulus_delay_fc_all_regions_session = [];
    stimulus_action_fc_all_regions_session = [];
    delay_action_fc_all_regions_session = [];
    stimulus_delay_action_fc_all_regions_session = [];
    for region_num1 = 1:8
        for region_num2 = 1:8
            stimulus_stimulus_fc_session{region_num1}{region_num2} = [];
            delay_delay_fc_session{region_num1}{region_num2} = [];
            action_action_fc_session{region_num1}{region_num2} = [];
        end
    end

    for session_num = 1:numel(activity_iti{animal_num})
        clearvars -except functional_connectivity_control ...
            activity activity_iti ...
            stimulus_stimulus_fc_all_regions_animal_session delay_delay_fc_all_regions_animal_session action_action_fc_all_regions_animal_session stimulus_delay_fc_all_regions_animal_session stimulus_action_fc_all_regions_animal_session delay_action_fc_all_regions_animal_session stimulus_delay_action_fc_all_regions_animal_session ...
            stimulus_stimulus_fc_animal_session delay_delay_fc_animal_session action_action_fc_animal_session ...
            animal_num ...
            stimulus_stimulus_fc_all_regions_session delay_delay_fc_all_regions_session action_action_fc_all_regions_session stimulus_delay_fc_all_regions_session stimulus_action_fc_all_regions_session delay_action_fc_all_regions_session stimulus_delay_action_fc_all_regions_session ...
            stimulus_stimulus_fc_session delay_delay_fc_session action_action_fc_session ...
            session_num

        % Sampling frequency of Scanimage.
        fs_image = 9.35211;

        % Initialize.
        stimulus_cell_idx_all_regions = [];
        delay_cell_idx_all_regions = [];
        action_cell_idx_all_regions = [];

        % Determine whether neurons are selective to task variables.
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) ~= 0
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
            % Task-variable cell index.
            p_value_thresh = 0.01;
            stimulus_cell_idx_temp{region_num} = find(stimulus_p_value{region_num} < p_value_thresh);
            delay_cell_idx_temp{region_num} = find(delay_p_value{region_num} < p_value_thresh);
            action_cell_idx_temp{region_num} = find(action_p_value{region_num} < p_value_thresh);

            if ~isnan(activity_iti{animal_num}{session_num}.region_cell_idx{region_num})
                mean_activity_iti{region_num} = mean(activity_iti{animal_num}{session_num}.activity_iti_all_regions(activity_iti{animal_num}{session_num}.region_cell_idx{region_num},:),2);
            else
                mean_activity_iti{region_num} = [];
            end
            cell_idx{region_num} = find(mean_activity_iti{region_num} > -0.0275);

            stimulus_cell_idx{region_num} = intersect(stimulus_cell_idx_temp{region_num},cell_idx{region_num});
            delay_cell_idx{region_num} = intersect(delay_cell_idx_temp{region_num},cell_idx{region_num});
            action_cell_idx{region_num} = intersect(action_cell_idx_temp{region_num},cell_idx{region_num});

            stimulus_region_cell_idx_temp(region_num) = numel(stimulus_cell_idx{region_num});
            delay_region_cell_idx_temp(region_num) = numel(delay_cell_idx{region_num});
            action_region_cell_idx_temp(region_num) = numel(action_cell_idx{region_num});

            stimulus_cell_idx_all_regions = [stimulus_cell_idx_all_regions,activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(stimulus_cell_idx{region_num})];
            delay_cell_idx_all_regions = [delay_cell_idx_all_regions,activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(delay_cell_idx{region_num})];
            action_cell_idx_all_regions = [action_cell_idx_all_regions,activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(action_cell_idx{region_num})];
        end

        stimulus_stimulus_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(stimulus_cell_idx_all_regions,stimulus_cell_idx_all_regions);
        delay_delay_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(delay_cell_idx_all_regions,delay_cell_idx_all_regions);
        action_action_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(action_cell_idx_all_regions,action_cell_idx_all_regions);
        stimulus_delay_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(stimulus_cell_idx_all_regions,delay_cell_idx_all_regions);
        stimulus_action_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(stimulus_cell_idx_all_regions,action_cell_idx_all_regions);
        delay_action_fc_all_regions = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(delay_cell_idx_all_regions,action_cell_idx_all_regions);

        for cell_num = 1:size(stimulus_stimulus_fc_all_regions,1)
            stimulus_stimulus_fc_all_regions(cell_num,cell_num:end) = nan;
        end
        for cell_num = 1:size(delay_delay_fc_all_regions,1)
            delay_delay_fc_all_regions(cell_num,cell_num:end) = nan;
        end
        for cell_num = 1:size(action_action_fc_all_regions,1)
            action_action_fc_all_regions(cell_num,cell_num:end) = nan;
        end
        stimulus_delay_fc_all_regions(stimulus_delay_fc_all_regions == 1) = nan; % Remove autocorrelation.
        stimulus_action_fc_all_regions(stimulus_action_fc_all_regions == 1) = nan; % Remove autocorrelation.
        delay_action_fc_all_regions(delay_action_fc_all_regions == 1) = nan; % Remove autocorrelation.
        stimulus_delay_action_fc_all_regions = [stimulus_delay_fc_all_regions(:);stimulus_action_fc_all_regions(:);delay_action_fc_all_regions(:)];

        % Region-specific task-variable cell index.
        cumsum_stimulus_region_cell_idx1 = cumsum(stimulus_region_cell_idx_temp);
        cumsum_stimulus_region_cell_idx2 = cumsum_stimulus_region_cell_idx1 + 1;
        stimulus_region_cell_idx{1} = [1:cumsum_stimulus_region_cell_idx1(1)];
        for region_num = 2:8
            stimulus_region_cell_idx{region_num} = [cumsum_stimulus_region_cell_idx2(region_num - 1):cumsum_stimulus_region_cell_idx1(region_num)];
        end

        cumsum_delay_region_cell_idx1 = cumsum(delay_region_cell_idx_temp);
        cumsum_delay_region_cell_idx2 = cumsum_delay_region_cell_idx1 + 1;
        delay_region_cell_idx{1} = [1:cumsum_delay_region_cell_idx1(1)];
        for region_num = 2:8
            delay_region_cell_idx{region_num} = [cumsum_delay_region_cell_idx2(region_num - 1):cumsum_delay_region_cell_idx1(region_num)];
        end

        cumsum_action_region_cell_idx1 = cumsum(action_region_cell_idx_temp);
        cumsum_action_region_cell_idx2 = cumsum_action_region_cell_idx1 + 1;
        action_region_cell_idx{1} = [1:cumsum_action_region_cell_idx1(1)];
        for region_num = 2:8
            action_region_cell_idx{region_num} = [cumsum_action_region_cell_idx2(region_num - 1):cumsum_action_region_cell_idx1(region_num)];
        end

        % Reion-by-region analysis.
        for region_num1 = 1:8
            for region_num2 = 1:8
                stimulus_stimulus_fc{region_num1}{region_num2} = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(stimulus_cell_idx_all_regions(stimulus_region_cell_idx{region_num1}),stimulus_cell_idx_all_regions(stimulus_region_cell_idx{region_num2}));
                delay_delay_fc{region_num1}{region_num2} = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(delay_cell_idx_all_regions(delay_region_cell_idx{region_num1}),delay_cell_idx_all_regions(delay_region_cell_idx{region_num2}));
                action_action_fc{region_num1}{region_num2} = activity_iti{animal_num}{session_num}.functional_connectivity_all_regions(action_cell_idx_all_regions(action_region_cell_idx{region_num1}),action_cell_idx_all_regions(action_region_cell_idx{region_num2}));

                stimulus_stimulus_fc{region_num1}{region_num2}(stimulus_stimulus_fc{region_num1}{region_num2} == 1) = nan; % Remove autocorrelation.
                % At least 10 comparisons.
                if sum(~isnan(stimulus_stimulus_fc{region_num1}{region_num2}(:))) < 10
                    stimulus_stimulus_fc{region_num1}{region_num2} = [];
                end
                delay_delay_fc{region_num1}{region_num2}(delay_delay_fc{region_num1}{region_num2} == 1) = nan; % Remove autocorrelation.
                % At least 10 comparisons.
                if sum(~isnan(delay_delay_fc{region_num1}{region_num2}(:))) < 10
                    delay_delay_fc{region_num1}{region_num2} = [];
                end
                action_action_fc{region_num1}{region_num2}(action_action_fc{region_num1}{region_num2} == 1) = nan; % Remove autocorrelation.
                % At least 10 comparisons.
                if sum(~isnan(action_action_fc{region_num1}{region_num2}(:))) < 10
                    action_action_fc{region_num1}{region_num2} = [];
                end
            end
        end

        for region_num = 1:8
            % At least 5 cells in each region (at least 10 comparisons).
            if size(stimulus_stimulus_fc{region_num}{region_num},1) < 5
                stimulus_stimulus_fc{region_num}{region_num} = [];
            end
            if size(delay_delay_fc{region_num}{region_num},1) < 5
                delay_delay_fc{region_num}{region_num} = [];
            end
            if size(action_action_fc{region_num}{region_num},1) < 5
                action_action_fc{region_num}{region_num} = [];
            end

            % Remove autocorrelation and redundant correlation.
            for cell_num = 1:size(stimulus_stimulus_fc{region_num}{region_num},1)
                stimulus_stimulus_fc{region_num}{region_num}(cell_num,cell_num:end) = nan;
            end
            for cell_num = 1:size(delay_delay_fc{region_num}{region_num},1)
                delay_delay_fc{region_num}{region_num}(cell_num,cell_num:end) = nan;
            end
            for cell_num = 1:size(action_action_fc{region_num}{region_num},1)
                action_action_fc{region_num}{region_num}(cell_num,cell_num:end) = nan;
            end
        end

        % Concatenate.
        stimulus_stimulus_fc_all_regions_session = [stimulus_stimulus_fc_all_regions_session,nanmean(stimulus_stimulus_fc_all_regions(:))];
        delay_delay_fc_all_regions_session = [delay_delay_fc_all_regions_session,nanmean(delay_delay_fc_all_regions(:))];
        action_action_fc_all_regions_session = [action_action_fc_all_regions_session,nanmean(action_action_fc_all_regions(:))];
        stimulus_delay_fc_all_regions_session = [stimulus_delay_fc_all_regions_session,nanmean(stimulus_delay_fc_all_regions(:))];
        stimulus_action_fc_all_regions_session = [stimulus_action_fc_all_regions_session,nanmean(stimulus_action_fc_all_regions(:))];
        delay_action_fc_all_regions_session = [delay_action_fc_all_regions_session,nanmean(delay_action_fc_all_regions(:))];
        stimulus_delay_action_fc_all_regions_session = [stimulus_delay_action_fc_all_regions_session,nanmean(stimulus_delay_action_fc_all_regions)];
        for region_num1 = 1:8
            for region_num2 = 1:8
                stimulus_stimulus_fc_session{region_num1}{region_num2} = [stimulus_stimulus_fc_session{region_num1}{region_num2},nanmean(stimulus_stimulus_fc{region_num1}{region_num2}(:))];
                delay_delay_fc_session{region_num1}{region_num2} = [delay_delay_fc_session{region_num1}{region_num2},nanmean(delay_delay_fc{region_num1}{region_num2}(:))];
                action_action_fc_session{region_num1}{region_num2} = [action_action_fc_session{region_num1}{region_num2},nanmean(action_action_fc{region_num1}{region_num2}(:))];
            end
        end
    end

    % Concatenate.
    stimulus_stimulus_fc_all_regions_animal_session = [stimulus_stimulus_fc_all_regions_animal_session,stimulus_stimulus_fc_all_regions_session];
    delay_delay_fc_all_regions_animal_session = [delay_delay_fc_all_regions_animal_session,delay_delay_fc_all_regions_session];
    action_action_fc_all_regions_animal_session = [action_action_fc_all_regions_animal_session,action_action_fc_all_regions_session];
    stimulus_delay_fc_all_regions_animal_session = [stimulus_delay_fc_all_regions_animal_session,stimulus_delay_fc_all_regions_session];
    stimulus_action_fc_all_regions_animal_session = [stimulus_action_fc_all_regions_animal_session,stimulus_action_fc_all_regions_session];
    delay_action_fc_all_regions_animal_session = [delay_action_fc_all_regions_animal_session,delay_action_fc_all_regions_session];
    stimulus_delay_action_fc_all_regions_animal_session = [stimulus_delay_action_fc_all_regions_animal_session,stimulus_delay_action_fc_all_regions_session];
    for region_num1 = 1:8
        for region_num2 = 1:8
            stimulus_stimulus_fc_animal_session{region_num1}{region_num2} = [stimulus_stimulus_fc_animal_session{region_num1}{region_num2},stimulus_stimulus_fc_session{region_num1}{region_num2}];
            delay_delay_fc_animal_session{region_num1}{region_num2} = [delay_delay_fc_animal_session{region_num1}{region_num2},delay_delay_fc_session{region_num1}{region_num2}];
            action_action_fc_animal_session{region_num1}{region_num2} = [action_action_fc_animal_session{region_num1}{region_num2},action_action_fc_session{region_num1}{region_num2}];
        end
    end
end

functional_connectivity_APP.stimulus_stimulus_fc_all_regions = stimulus_stimulus_fc_all_regions_animal_session;
functional_connectivity_APP.delay_delay_fc_all_regions = delay_delay_fc_all_regions_animal_session;
functional_connectivity_APP.action_action_fc_all_regions = action_action_fc_all_regions_animal_session;
functional_connectivity_APP.stimulus_delay_fc_all_regions = stimulus_delay_fc_all_regions_animal_session;
functional_connectivity_APP.stimulus_action_fc_all_regions = stimulus_action_fc_all_regions_animal_session;
functional_connectivity_APP.delay_action_fc_all_regions = delay_action_fc_all_regions_animal_session;
functional_connectivity_APP.stimulus_delay_action_fc_all_regions = stimulus_delay_action_fc_all_regions_animal_session;
functional_connectivity_APP.stimulus_stimulus_fc = stimulus_stimulus_fc_animal_session;
functional_connectivity_APP.delay_delay_fc = delay_delay_fc_animal_session;
functional_connectivity_APP.action_action_fc = action_action_fc_animal_session;

clearvars -except functional_connectivity_control functional_connectivity_APP

% Plot.
mean_fc_stimulus_stimulus_control = nanmean(functional_connectivity_control.stimulus_stimulus_fc_all_regions);
mean_fc_delay_delay_control = nanmean(functional_connectivity_control.delay_delay_fc_all_regions);
mean_fc_action_action_control = nanmean(functional_connectivity_control.action_action_fc_all_regions);
mean_fc_stimulus_delay_action_control = nanmean(functional_connectivity_control.stimulus_delay_action_fc_all_regions);
se_fc_stimulus_stimulus_control = nanstd(functional_connectivity_control.stimulus_stimulus_fc_all_regions)/(sum(~isnan(functional_connectivity_control.stimulus_stimulus_fc_all_regions))^0.5);
se_fc_delay_delay_control = nanstd(functional_connectivity_control.delay_delay_fc_all_regions)/(sum(~isnan(functional_connectivity_control.delay_delay_fc_all_regions))^0.5);
se_fc_action_action_control = nanstd(functional_connectivity_control.action_action_fc_all_regions)/(sum(~isnan(functional_connectivity_control.action_action_fc_all_regions))^0.5);
se_fc_stimulus_delay_action_control = nanstd(functional_connectivity_control.stimulus_delay_action_fc_all_regions)/(sum(~isnan(functional_connectivity_control.stimulus_delay_action_fc_all_regions))^0.5);

mean_fc_stimulus_stimulus_APP = nanmean(functional_connectivity_APP.stimulus_stimulus_fc_all_regions);
mean_fc_delay_delay_APP = nanmean(functional_connectivity_APP.delay_delay_fc_all_regions);
mean_fc_action_action_APP = nanmean(functional_connectivity_APP.action_action_fc_all_regions);
mean_fc_stimulus_delay_action_APP = nanmean(functional_connectivity_APP.stimulus_delay_action_fc_all_regions);
se_fc_stimulus_stimulus_APP = nanstd(functional_connectivity_APP.stimulus_stimulus_fc_all_regions)/(sum(~isnan(functional_connectivity_APP.stimulus_stimulus_fc_all_regions))^0.5);
se_fc_delay_delay_APP = nanstd(functional_connectivity_APP.delay_delay_fc_all_regions)/(sum(~isnan(functional_connectivity_APP.delay_delay_fc_all_regions))^0.5);
se_fc_action_action_APP = nanstd(functional_connectivity_APP.action_action_fc_all_regions)/(sum(~isnan(functional_connectivity_APP.action_action_fc_all_regions))^0.5);
se_fc_stimulus_delay_action_APP = nanstd(functional_connectivity_APP.stimulus_delay_action_fc_all_regions)/(sum(~isnan(functional_connectivity_APP.stimulus_delay_action_fc_all_regions))^0.5);

for region_num1 = 1:8
    for region_num2 = 1:8
        stimulus_fc_control(region_num1,region_num2) = nanmean(functional_connectivity_control.stimulus_stimulus_fc{region_num1}{region_num2});
        stimulus_fc_APP(region_num1,region_num2) = nanmean(functional_connectivity_APP.stimulus_stimulus_fc{region_num1}{region_num2});
        delay_fc_control(region_num1,region_num2) = nanmean(functional_connectivity_control.delay_delay_fc{region_num1}{region_num2});
        delay_fc_APP(region_num1,region_num2) = nanmean(functional_connectivity_APP.delay_delay_fc{region_num1}{region_num2});
        action_fc_control(region_num1,region_num2) = nanmean(functional_connectivity_control.action_action_fc{region_num1}{region_num2});
        action_fc_APP(region_num1,region_num2) = nanmean(functional_connectivity_APP.action_action_fc{region_num1}{region_num2});
    end
end

figure('Position',[200,800,200,200],'Color','w')
imagesc(stimulus_fc_control,[0,0.008])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'])

figure('Position',[400,800,200,200],'Color','w')
imagesc(delay_fc_control,[0,0.008])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'])

figure('Position',[600,800,200,200],'Color','w')
imagesc(action_fc_control,[0,0.008])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'])

figure('Position',[200,500,200,200],'Color','w')
imagesc(stimulus_fc_APP,[0,0.008])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'])

figure('Position',[400,500,200,200],'Color','w')
imagesc(delay_fc_APP,[0,0.008])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'])

figure('Position',[600,500,200,200],'Color','w')
imagesc(action_fc_APP,[0,0.008])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'])

% Plot in the coordinate.
% Bregma.
bregma = [540,570];
bregma = bregma*10;

% Load cortical map.
load('cortex_top_view.mat')

% Get coordinates of all regions.
region_coordinate_temp = [290,380;350,270;450,370;465,500;490,280;630,200;640,490;690,340];
region_coordinate_temp  = region_coordinate_temp*10;
region_coordinate_middle(:,1) = region_coordinate_temp(:,2) - bregma(2); % Swap X with Y.
region_coordinate_middle(:,2) = region_coordinate_temp(:,1) - bregma(1);
region_coordinate = region_coordinate_temp - bregma;

% Plot.
% Stimulus.
clearvars -except functional_connectivity_control functional_connectivity_APP bregma cortical_area_boundaries region_coordinate stimulus_fc_control stimulus_fc_APP delay_fc_control delay_fc_APP action_fc_control action_fc_APP
figure('Position',[900,800,200,200],'Color','k')
hold on;
for area_num = 1:size(cortical_area_boundaries)
    for hemi_num = 1:size(cortical_area_boundaries{area_num})
        plot(cortical_area_boundaries{area_num}{hemi_num}(:,1) - (bregma(1)./10),cortical_area_boundaries{area_num}{hemi_num}(:,2) - (bregma(2)./10),'LineWidth',2,'Color',[0.75,0.75,0.75])
    end
end
xlim([-275 225]);
ylim([-425 75]);
box on
axis square
ax = gca;
set(gca,'XDir','reverse');
set(gca,'YDir','reverse')
set(ax,'XTick',[])
set(ax,'YTick',[])
camroll(-270)
ax.Color = [0.4,0.4,0.4];

cMap = [linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'];
temp1 = round(rescale([stimulus_fc_control(:);min([stimulus_fc_control(:);stimulus_fc_APP(:)]);max([stimulus_fc_control(:);stimulus_fc_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

clearvars -except functional_connectivity_control functional_connectivity_APP bregma cortical_area_boundaries region_coordinate stimulus_fc_control stimulus_fc_APP delay_fc_control delay_fc_APP action_fc_control action_fc_APP
figure('Position',[900,500,200,200],'Color','k')
hold on;
for area_num = 1:size(cortical_area_boundaries)
    for hemi_num = 1:size(cortical_area_boundaries{area_num})
        plot(cortical_area_boundaries{area_num}{hemi_num}(:,1) - (bregma(1)./10),cortical_area_boundaries{area_num}{hemi_num}(:,2) - (bregma(2)./10),'LineWidth',2,'Color',[0.75,0.75,0.75])
    end
end
xlim([-275 225]);
ylim([-425 75]);
box on
axis square
ax = gca;
set(gca,'XDir','reverse');
set(gca,'YDir','reverse')
set(ax,'XTick',[])
set(ax,'YTick',[])
camroll(-270)
ax.Color = [0.4,0.4,0.4];

cMap = [linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'];
temp1 = round(rescale([stimulus_fc_APP(:);min([stimulus_fc_control(:);stimulus_fc_APP(:)]);max([stimulus_fc_control(:);stimulus_fc_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

% Delay.
clearvars -except functional_connectivity_control functional_connectivity_APP bregma cortical_area_boundaries region_coordinate stimulus_fc_control stimulus_fc_APP delay_fc_control delay_fc_APP action_fc_control action_fc_APP
figure('Position',[1100,800,200,200],'Color','k')
hold on;
for area_num = 1:size(cortical_area_boundaries)
    for hemi_num = 1:size(cortical_area_boundaries{area_num})
        plot(cortical_area_boundaries{area_num}{hemi_num}(:,1) - (bregma(1)./10),cortical_area_boundaries{area_num}{hemi_num}(:,2) - (bregma(2)./10),'LineWidth',2,'Color',[0.75,0.75,0.75])
    end
end
xlim([-275 225]);
ylim([-425 75]);
box on
axis square
ax = gca;
set(gca,'XDir','reverse');
set(gca,'YDir','reverse')
set(ax,'XTick',[])
set(ax,'YTick',[])
camroll(-270)
ax.Color = [0.4,0.4,0.4];

cMap = [linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'];
temp1 = round(rescale([delay_fc_control(:);min([delay_fc_control(:);delay_fc_APP(:)]);max([delay_fc_control(:);delay_fc_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

clearvars -except functional_connectivity_control functional_connectivity_APP bregma cortical_area_boundaries region_coordinate stimulus_fc_control stimulus_fc_APP delay_fc_control delay_fc_APP action_fc_control action_fc_APP
figure('Position',[1100,500,200,200],'Color','k')
hold on;
for area_num = 1:size(cortical_area_boundaries)
    for hemi_num = 1:size(cortical_area_boundaries{area_num})
        plot(cortical_area_boundaries{area_num}{hemi_num}(:,1) - (bregma(1)./10),cortical_area_boundaries{area_num}{hemi_num}(:,2) - (bregma(2)./10),'LineWidth',2,'Color',[0.75,0.75,0.75])
    end
end
xlim([-275 225]);
ylim([-425 75]);
box on
axis square
ax = gca;
set(gca,'XDir','reverse');
set(gca,'YDir','reverse')
set(ax,'XTick',[])
set(ax,'YTick',[])
camroll(-270)
ax.Color = [0.4,0.4,0.4];

cMap = [linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'];
temp1 = round(rescale([delay_fc_APP(:);min([delay_fc_control(:);delay_fc_APP(:)]);max([delay_fc_control(:);delay_fc_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

% Action.
clearvars -except functional_connectivity_control functional_connectivity_APP bregma cortical_area_boundaries region_coordinate stimulus_fc_control stimulus_fc_APP delay_fc_control delay_fc_APP action_fc_control action_fc_APP
figure('Position',[1300,800,200,200],'Color','k')
hold on;
for area_num = 1:size(cortical_area_boundaries)
    for hemi_num = 1:size(cortical_area_boundaries{area_num})
        plot(cortical_area_boundaries{area_num}{hemi_num}(:,1) - (bregma(1)./10),cortical_area_boundaries{area_num}{hemi_num}(:,2) - (bregma(2)./10),'LineWidth',2,'Color',[0.75,0.75,0.75])
    end
end
xlim([-275 225]);
ylim([-425 75]);
box on
axis square
ax = gca;
set(gca,'XDir','reverse');
set(gca,'YDir','reverse')
set(ax,'XTick',[])
set(ax,'YTick',[])
camroll(-270)
ax.Color = [0.4,0.4,0.4];

cMap = [linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'];
temp1 = round(rescale([action_fc_control(:);min([action_fc_control(:);action_fc_APP(:)]);max([action_fc_control(:);action_fc_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

clearvars -except functional_connectivity_control functional_connectivity_APP bregma cortical_area_boundaries region_coordinate stimulus_fc_control stimulus_fc_APP delay_fc_control delay_fc_APP action_fc_control action_fc_APP
figure('Position',[1300,500,200,200],'Color','k')
hold on;
for area_num = 1:size(cortical_area_boundaries)
    for hemi_num = 1:size(cortical_area_boundaries{area_num})
        plot(cortical_area_boundaries{area_num}{hemi_num}(:,1) - (bregma(1)./10),cortical_area_boundaries{area_num}{hemi_num}(:,2) - (bregma(2)./10),'LineWidth',2,'Color',[0.75,0.75,0.75])
    end
end
xlim([-275 225]);
ylim([-425 75]);
box on
axis square
ax = gca;
set(gca,'XDir','reverse');
set(gca,'YDir','reverse')
set(ax,'XTick',[])
set(ax,'YTick',[])
camroll(-270)
ax.Color = [0.4,0.4,0.4];

cMap = [linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'];
temp1 = round(rescale([action_fc_APP(:);min([action_fc_control(:);action_fc_APP(:)]);max([action_fc_control(:);action_fc_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

% Statistics.
rng(0)
for region_num1 = 1:8
    for region_num2 = 1:8
        fc_stimulus_control{region_num1}{region_num2} = functional_connectivity_control.stimulus_stimulus_fc{region_num1}{region_num2}(~isnan(functional_connectivity_control.stimulus_stimulus_fc{region_num1}{region_num2}));
        fc_stimulus_APP{region_num1}{region_num2} = functional_connectivity_APP.stimulus_stimulus_fc{region_num1}{region_num2}(~isnan(functional_connectivity_APP.stimulus_stimulus_fc{region_num1}{region_num2}));
        fc_delay_control{region_num1}{region_num2} = functional_connectivity_control.delay_delay_fc{region_num1}{region_num2}(~isnan(functional_connectivity_control.delay_delay_fc{region_num1}{region_num2}));
        fc_delay_APP{region_num1}{region_num2} = functional_connectivity_APP.delay_delay_fc{region_num1}{region_num2}(~isnan(functional_connectivity_APP.delay_delay_fc{region_num1}{region_num2}));
        fc_action_control{region_num1}{region_num2} = functional_connectivity_control.action_action_fc{region_num1}{region_num2}(~isnan(functional_connectivity_control.action_action_fc{region_num1}{region_num2}));
        fc_action_APP{region_num1}{region_num2} = functional_connectivity_APP.action_action_fc{region_num1}{region_num2}(~isnan(functional_connectivity_APP.action_action_fc{region_num1}{region_num2}));
    end
end

for region_num1 = 1:8
    for region_num2 = 1:8
        % Stimulus.
        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(fc_stimulus_control{region_num1}{region_num2})
                sampled_fc_stimulus_control{region_num1}{region_num2}(shuffle_num,session_num) = fc_stimulus_control{region_num1}{region_num2}(randi(numel(fc_stimulus_control{region_num1}{region_num2})));
            end
            for session_num = 1:numel(fc_stimulus_APP{region_num1}{region_num2})
                sampled_fc_stimulus_APP{region_num1}{region_num2}(shuffle_num,session_num) = fc_stimulus_APP{region_num1}{region_num2}(randi(numel(fc_stimulus_APP{region_num1}{region_num2})));
            end
        end
        p_value_stimulus(region_num1,region_num2) = sum(mean(sampled_fc_stimulus_control{region_num1}{region_num2},2) < mean(sampled_fc_stimulus_APP{region_num1}{region_num2},2))/1000;

        % Delay.
        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(fc_delay_control{region_num1}{region_num2})
                sampled_fc_delay_control{region_num1}{region_num2}(shuffle_num,session_num) = fc_delay_control{region_num1}{region_num2}(randi(numel(fc_delay_control{region_num1}{region_num2})));
            end
            for session_num = 1:numel(fc_delay_APP{region_num1}{region_num2})
                sampled_fc_delay_APP{region_num1}{region_num2}(shuffle_num,session_num) = fc_delay_APP{region_num1}{region_num2}(randi(numel(fc_delay_APP{region_num1}{region_num2})));
            end
        end
        p_value_delay(region_num1,region_num2) = sum(mean(sampled_fc_delay_control{region_num1}{region_num2},2) < mean(sampled_fc_delay_APP{region_num1}{region_num2},2))/1000;

        % Action.
        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(fc_action_control{region_num1}{region_num2})
                sampled_fc_action_control{region_num1}{region_num2}(shuffle_num,session_num) = fc_action_control{region_num1}{region_num2}(randi(numel(fc_action_control{region_num1}{region_num2})));
            end
            for session_num = 1:numel(fc_action_APP{region_num1}{region_num2})
                sampled_fc_action_APP{region_num1}{region_num2}(shuffle_num,session_num) = fc_action_APP{region_num1}{region_num2}(randi(numel(fc_action_APP{region_num1}{region_num2})));
            end
        end
        p_value_action(region_num1,region_num2) = sum(mean(sampled_fc_action_control{region_num1}{region_num2},2) < mean(sampled_fc_action_APP{region_num1}{region_num2},2))/1000;
    end
end

% Make it symmetrical.
for region_num = 1:7
    p_value_stimulus(region_num,(region_num + 1):8) = nan;
    p_value_delay(region_num,(region_num + 1):8) = nan;
    p_value_action(region_num,(region_num + 1):8) = nan;
end
p_value_stimulus = p_value_stimulus(~isnan(p_value_stimulus));
p_value_delay = p_value_delay(~isnan(p_value_delay));
p_value_action = p_value_action(~isnan(p_value_action));
p_value_all = [p_value_stimulus;p_value_delay;p_value_action];

% False discovery rate.
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

vector_stimulus = vector(1:36);
vector_delay = vector(37:72);
vector_action = vector(73:108);

p_value_matrix_stimulus = zeros(8,8);
p_value_matrix_stimulus(1:8,1) = vector_stimulus(1:8);
p_value_matrix_stimulus(2:8,2) = vector_stimulus(9:15);
p_value_matrix_stimulus(3:8,3) = vector_stimulus(16:21);
p_value_matrix_stimulus(4:8,4) = vector_stimulus(22:26);
p_value_matrix_stimulus(5:8,5) = vector_stimulus(27:30);
p_value_matrix_stimulus(6:8,6) = vector_stimulus(31:33);
p_value_matrix_stimulus(7:8,7) = vector_stimulus(34:35);
p_value_matrix_stimulus(8,8) = vector_stimulus(36);
p_value_matrix_stimulus(1,1:8) = vector_stimulus(1:8);
p_value_matrix_stimulus(2,2:8) = vector_stimulus(9:15);
p_value_matrix_stimulus(3,3:8) = vector_stimulus(16:21);
p_value_matrix_stimulus(4,4:8) = vector_stimulus(22:26);
p_value_matrix_stimulus(5,5:8) = vector_stimulus(27:30);
p_value_matrix_stimulus(6,6:8) = vector_stimulus(31:33);
p_value_matrix_stimulus(7,7:8) = vector_stimulus(34:35);
p_value_matrix_stimulus(8,8) = vector_stimulus(36);

p_value_matrix_delay = zeros(8,8);
p_value_matrix_delay(1:8,1) = vector_delay(1:8);
p_value_matrix_delay(2:8,2) = vector_delay(9:15);
p_value_matrix_delay(3:8,3) = vector_delay(16:21);
p_value_matrix_delay(4:8,4) = vector_delay(22:26);
p_value_matrix_delay(5:8,5) = vector_delay(27:30);
p_value_matrix_delay(6:8,6) = vector_delay(31:33);
p_value_matrix_delay(7:8,7) = vector_delay(34:35);
p_value_matrix_delay(8,8) = vector_delay(36);
p_value_matrix_delay(1,1:8) = vector_delay(1:8);
p_value_matrix_delay(2,2:8) = vector_delay(9:15);
p_value_matrix_delay(3,3:8) = vector_delay(16:21);
p_value_matrix_delay(4,4:8) = vector_delay(22:26);
p_value_matrix_delay(5,5:8) = vector_delay(27:30);
p_value_matrix_delay(6,6:8) = vector_delay(31:33);
p_value_matrix_delay(7,7:8) = vector_delay(34:35);
p_value_matrix_delay(8,8) = vector_delay(36);

p_value_matrix_action = zeros(8,8);
p_value_matrix_action(1:8,1) = vector_action(1:8);
p_value_matrix_action(2:8,2) = vector_action(9:15);
p_value_matrix_action(3:8,3) = vector_action(16:21);
p_value_matrix_action(4:8,4) = vector_action(22:26);
p_value_matrix_action(5:8,5) = vector_action(27:30);
p_value_matrix_action(6:8,6) = vector_action(31:33);
p_value_matrix_action(7:8,7) = vector_action(34:35);
p_value_matrix_action(8,8) = vector_action(36);
p_value_matrix_action(1,1:8) = vector_action(1:8);
p_value_matrix_action(2,2:8) = vector_action(9:15);
p_value_matrix_action(3,3:8) = vector_action(16:21);
p_value_matrix_action(4,4:8) = vector_action(22:26);
p_value_matrix_action(5,5:8) = vector_action(27:30);
p_value_matrix_action(6,6:8) = vector_action(31:33);
p_value_matrix_action(7,7:8) = vector_action(34:35);
p_value_matrix_action(8,8) = vector_action(36);

% Plot.
figure('Position',[200,200,200,200],'Color','w')
imagesc(p_value_matrix_stimulus,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

figure('Position',[400,200,200,200],'Color','w')
imagesc(p_value_matrix_delay,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

figure('Position',[600,200,200,200],'Color','w')
imagesc(p_value_matrix_action,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

end