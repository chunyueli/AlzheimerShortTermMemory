function plot_neural_selectivity_fraction

close all
clear all
clc

% Plot fractions of neurons showing task variable selectivity.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('activity_control.mat')
activity = activity_control;
clear activity_control

% Initialize.
for region_num = 1:8
    stimulus_left_right_fraction_animal_session{region_num} = [];
    delay_left_right_fraction_animal_session{region_num} = [];
    action_left_right_fraction_animal_session{region_num} = [];
end

for animal_num = 1:numel(activity)
    clearvars -except activity ...
        stimulus_left_right_fraction_animal_session delay_left_right_fraction_animal_session action_left_right_fraction_animal_session ...
        animal_num

    % Initialize.
    for region_num = 1:8
        stimulus_left_right_fraction_session{region_num} = [];
        delay_left_right_fraction_session{region_num} = [];
        action_left_right_fraction_session{region_num} = [];
    end

    for session_num = 1:numel(activity{animal_num})
        clearvars -except activity ...
            stimulus_left_right_fraction_animal_session delay_left_right_fraction_animal_session action_left_right_fraction_animal_session ...
            animal_num ...
            stimulus_left_right_fraction_session delay_left_right_fraction_session action_left_right_fraction_session ...
            session_num

        % Sampling frequency of Scanimage.
        fs_image = 9.35211;

        % Determine whether neurons are selective to task variables.
        for region_num = 1:8
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
        end

        % Fractions of task-variable-selective neurons.
        p_value_thresh = 0.01;
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) < 10 % The cell number has to be at least 10 in each region.
                stimulus_left_right_fraction(region_num) = nan;
                delay_left_right_fraction(region_num) = nan;
                action_left_right_fraction(region_num) = nan;
            else
                stimulus_left_right_fraction(region_num) = 100*sum(stimulus_p_value{region_num} < p_value_thresh)/numel(stimulus_p_value{region_num});
                delay_left_right_fraction(region_num) = 100*sum(delay_p_value{region_num} < p_value_thresh)/numel(delay_p_value{region_num});
                action_left_right_fraction(region_num) = 100*sum(action_p_value{region_num} < p_value_thresh)/numel(action_p_value{region_num});
            end
        end

        for region_num = 1:8
            stimulus_left_right_fraction_session{region_num} = [stimulus_left_right_fraction_session{region_num},stimulus_left_right_fraction(region_num)];
            delay_left_right_fraction_session{region_num} = [delay_left_right_fraction_session{region_num},delay_left_right_fraction(region_num)];
            action_left_right_fraction_session{region_num} = [action_left_right_fraction_session{region_num},action_left_right_fraction(region_num)];
        end
    end

    for region_num = 1:8
        stimulus_left_right_fraction_animal_session{region_num} = [stimulus_left_right_fraction_animal_session{region_num},stimulus_left_right_fraction_session{region_num}];
        delay_left_right_fraction_animal_session{region_num} = [delay_left_right_fraction_animal_session{region_num},delay_left_right_fraction_session{region_num}];
        action_left_right_fraction_animal_session{region_num} = [action_left_right_fraction_animal_session{region_num},action_left_right_fraction_session{region_num}];
    end
end

stimulus_left_right_fraction_animal_session_control = stimulus_left_right_fraction_animal_session;
delay_left_right_fraction_animal_session_control = delay_left_right_fraction_animal_session;
action_left_right_fraction_animal_session_control = action_left_right_fraction_animal_session;

clearvars -except stimulus_left_right_fraction_animal_session_control delay_left_right_fraction_animal_session_control action_left_right_fraction_animal_session_control

% APP.
load('activity_APP.mat')
activity = activity_APP;
clear activity_APP

% Initialize.
for region_num = 1:8
    stimulus_left_right_fraction_animal_session{region_num} = [];
    delay_left_right_fraction_animal_session{region_num} = [];
    action_left_right_fraction_animal_session{region_num} = [];
end

for animal_num = 1:numel(activity)
    clearvars -except stimulus_left_right_fraction_animal_session_control delay_left_right_fraction_animal_session_control action_left_right_fraction_animal_session_control ...
        activity ...
        stimulus_left_right_fraction_animal_session delay_left_right_fraction_animal_session action_left_right_fraction_animal_session ...
        animal_num

    % Initialize.
    for region_num = 1:8
        stimulus_left_right_fraction_session{region_num} = [];
        delay_left_right_fraction_session{region_num} = [];
        action_left_right_fraction_session{region_num} = [];
    end

    for session_num = 1:numel(activity{animal_num})
        clearvars -except stimulus_left_right_fraction_animal_session_control delay_left_right_fraction_animal_session_control action_left_right_fraction_animal_session_control ...
            activity ...
            stimulus_left_right_fraction_animal_session delay_left_right_fraction_animal_session action_left_right_fraction_animal_session ...
            animal_num ...
            stimulus_left_right_fraction_session delay_left_right_fraction_session action_left_right_fraction_session ...
            session_num

        % Sampling frequency of Scanimage.
        fs_image = 9.35211;

        % Determine whether neurons are selective to task variables.
        for region_num = 1:8
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
        end

        % Fractions of task-variable-selective neurons.
        p_value_thresh = 0.01;
        for region_num = 1:8
            if size(activity{animal_num}{session_num}.correct_response{region_num}{1},1) < 10 % The cell number has to be at least 10 in each region.
                stimulus_left_right_fraction(region_num) = nan;
                delay_left_right_fraction(region_num) = nan;
                action_left_right_fraction(region_num) = nan;
            else
                stimulus_left_right_fraction(region_num) = 100*sum(stimulus_p_value{region_num} < p_value_thresh)/numel(stimulus_p_value{region_num});
                delay_left_right_fraction(region_num) = 100*sum(delay_p_value{region_num} < p_value_thresh)/numel(delay_p_value{region_num});
                action_left_right_fraction(region_num) = 100*sum(action_p_value{region_num} < p_value_thresh)/numel(action_p_value{region_num});
            end
        end

        for region_num = 1:8
            stimulus_left_right_fraction_session{region_num} = [stimulus_left_right_fraction_session{region_num},stimulus_left_right_fraction(region_num)];
            delay_left_right_fraction_session{region_num} = [delay_left_right_fraction_session{region_num},delay_left_right_fraction(region_num)];
            action_left_right_fraction_session{region_num} = [action_left_right_fraction_session{region_num},action_left_right_fraction(region_num)];
        end
    end

    for region_num = 1:8
        stimulus_left_right_fraction_animal_session{region_num} = [stimulus_left_right_fraction_animal_session{region_num},stimulus_left_right_fraction_session{region_num}];
        delay_left_right_fraction_animal_session{region_num} = [delay_left_right_fraction_animal_session{region_num},delay_left_right_fraction_session{region_num}];
        action_left_right_fraction_animal_session{region_num} = [action_left_right_fraction_animal_session{region_num},action_left_right_fraction_session{region_num}];
    end
end

stimulus_left_right_fraction_animal_session_APP = stimulus_left_right_fraction_animal_session;
delay_left_right_fraction_animal_session_APP = delay_left_right_fraction_animal_session;
action_left_right_fraction_animal_session_APP = action_left_right_fraction_animal_session;

clearvars -except stimulus_left_right_fraction_animal_session_control delay_left_right_fraction_animal_session_control action_left_right_fraction_animal_session_control ...
    stimulus_left_right_fraction_animal_session_APP delay_left_right_fraction_animal_session_APP action_left_right_fraction_animal_session_APP ...

% Plot.
for region_num = 1:8
    % Stimulus.
    mean_stimulus_left_right_fraction_animal_session_control(region_num) = nanmean(stimulus_left_right_fraction_animal_session_control{region_num});
    mean_stimulus_left_right_fraction_animal_session_APP(region_num) = nanmean(stimulus_left_right_fraction_animal_session_APP{region_num});
    se_stimulus_left_right_fraction_animal_session_control(region_num) = nanstd(stimulus_left_right_fraction_animal_session_control{region_num})/(sum(~isnan(stimulus_left_right_fraction_animal_session_control{region_num}))^0.5);
    se_stimulus_left_right_fraction_animal_session_APP(region_num) = nanstd(stimulus_left_right_fraction_animal_session_APP{region_num})/(sum(~isnan(stimulus_left_right_fraction_animal_session_APP{region_num}))^0.5);

    % Delay.
    mean_delay_left_right_fraction_animal_session_control(region_num) = nanmean(delay_left_right_fraction_animal_session_control{region_num});
    mean_delay_left_right_fraction_animal_session_APP(region_num) = nanmean(delay_left_right_fraction_animal_session_APP{region_num});
    se_delay_left_right_fraction_animal_session_control(region_num) = nanstd(delay_left_right_fraction_animal_session_control{region_num})/(sum(~isnan(delay_left_right_fraction_animal_session_control{region_num}))^0.5);
    se_delay_left_right_fraction_animal_session_APP(region_num) = nanstd(delay_left_right_fraction_animal_session_APP{region_num})/(sum(~isnan(delay_left_right_fraction_animal_session_APP{region_num}))^0.5);

    % Action.
    mean_action_left_right_fraction_animal_session_control(region_num) = nanmean(action_left_right_fraction_animal_session_control{region_num});
    mean_action_left_right_fraction_animal_session_APP(region_num) = nanmean(action_left_right_fraction_animal_session_APP{region_num});
    se_action_left_right_fraction_animal_session_control(region_num) = nanstd(action_left_right_fraction_animal_session_control{region_num})/(sum(~isnan(action_left_right_fraction_animal_session_control{region_num}))^0.5);
    se_action_left_right_fraction_animal_session_APP(region_num) = nanstd(action_left_right_fraction_animal_session_APP{region_num})/(sum(~isnan(action_left_right_fraction_animal_session_APP{region_num}))^0.5);
end

% Stimulus.
figure('Position',[200,1000,400,200],'Color','w')
hold on
for region_num = 1:8
    bar(1 + (region_num - 1)*3,mean_stimulus_left_right_fraction_animal_session_control(region_num),0.8,'FaceColor',[0.47,0.67,0.19],'EdgeColor','None','FaceAlpha',1)
    bar(2 + (region_num - 1)*3,mean_stimulus_left_right_fraction_animal_session_APP(region_num),0.8,'FaceColor',[0.47,0.67,0.19],'EdgeColor','None','FaceAlpha',0.4)
    line([1 + (region_num - 1)*3,1 + (region_num - 1)*3],[mean_stimulus_left_right_fraction_animal_session_control(region_num) - se_stimulus_left_right_fraction_animal_session_control(region_num),mean_stimulus_left_right_fraction_animal_session_control(region_num) + se_stimulus_left_right_fraction_animal_session_control(region_num)],'Color',[0.47,0.67,0.19,1],'LineWidth',1)
    line([2 + (region_num - 1)*3,2 + (region_num - 1)*3],[mean_stimulus_left_right_fraction_animal_session_APP(region_num) - se_stimulus_left_right_fraction_animal_session_APP(region_num),mean_stimulus_left_right_fraction_animal_session_APP(region_num) + se_stimulus_left_right_fraction_animal_session_APP(region_num)],'Color',[0.47,0.67,0.19,0.4],'LineWidth',1)
end
xlabel('');
ylabel('Cell (%)');
xlim([0,24])
ylim([0,30])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1.5,4.5,7.5,10.5,13.5,16.5,19.5,22.5];
ax.YTick = [0,10,20,30];
ax.XTickLabel = {'ALM','M1a','M1p','M2','S1fl','vS1','RSC','PPC'};
ax.YTickLabel = {'0','10','20','30'};

% Delay.
figure('Position',[600,1000,400,200],'Color','w')
hold on
for region_num = 1:8
    bar(1 + (region_num - 1)*3,mean_delay_left_right_fraction_animal_session_control(region_num),0.8,'FaceColor',[0.00,0.45,0.74],'EdgeColor','None','FaceAlpha',1)
    bar(2 + (region_num - 1)*3,mean_delay_left_right_fraction_animal_session_APP(region_num),0.8,'FaceColor',[0.00,0.45,0.74],'EdgeColor','None','FaceAlpha',0.4)
    line([1 + (region_num - 1)*3,1 + (region_num - 1)*3],[mean_delay_left_right_fraction_animal_session_control(region_num) - se_delay_left_right_fraction_animal_session_control(region_num),mean_delay_left_right_fraction_animal_session_control(region_num) + se_delay_left_right_fraction_animal_session_control(region_num)],'Color',[0.00,0.45,0.74,1],'LineWidth',1)
    line([2 + (region_num - 1)*3,2 + (region_num - 1)*3],[mean_delay_left_right_fraction_animal_session_APP(region_num) - se_delay_left_right_fraction_animal_session_APP(region_num),mean_delay_left_right_fraction_animal_session_APP(region_num) + se_delay_left_right_fraction_animal_session_APP(region_num)],'Color',[0.00,0.45,0.74,0.4],'LineWidth',1)
end
xlabel('');
ylabel('Cell (%)');
xlim([0,24])
ylim([0,20])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1.5,4.5,7.5,10.5,13.5,16.5,19.5,22.5];
ax.YTick = [0,10,20];
ax.XTickLabel = {'ALM','M1a','M1p','M2','S1fl','vS1','RSC','PPC'};
ax.YTickLabel = {'0','10','20'};

% Action.
figure('Position',[1000,1000,400,200],'Color','w')
hold on
for region_num = 1:8
    bar(1 + (region_num - 1)*3,mean_action_left_right_fraction_animal_session_control(region_num),0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',1)
    bar(2 + (region_num - 1)*3,mean_action_left_right_fraction_animal_session_APP(region_num),0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.4)
    line([1 + (region_num - 1)*3,1 + (region_num - 1)*3],[mean_action_left_right_fraction_animal_session_control(region_num) - se_action_left_right_fraction_animal_session_control(region_num),mean_action_left_right_fraction_animal_session_control(region_num) + se_action_left_right_fraction_animal_session_control(region_num)],'Color',[0.64,0.08,0.18,1],'LineWidth',1)
    line([2 + (region_num - 1)*3,2 + (region_num - 1)*3],[mean_action_left_right_fraction_animal_session_APP(region_num) - se_action_left_right_fraction_animal_session_APP(region_num),mean_action_left_right_fraction_animal_session_APP(region_num) + se_action_left_right_fraction_animal_session_APP(region_num)],'Color',[0.64,0.08,0.18,0.4],'LineWidth',1)
end
xlabel('');
ylabel('Cell (%)');
xlim([0,24])
ylim([0,50])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1.5,4.5,7.5,10.5,13.5,16.5,19.5,22.5];
ax.YTick = [0,10,20,30,40,50];
ax.XTickLabel = {'ALM','M1a','M1p','M2','S1fl','vS1','RSC','PPC'};
ax.YTickLabel = {'0','10','20','30','40','50'};

end