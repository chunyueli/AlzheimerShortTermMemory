function plot_task_performance

close all
clear all
clc

% Plot task performance.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('behavior_control.mat')
behavior = behavior_control;
clear behavior_control

% Initialize.
correct_rate_animal_session = [];

for animal_num = 1:numel(behavior)
    clearvars -except behavior correct_rate_animal_session animal_num

    % Initialize.
    correct_rate_session{animal_num} = [];

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior correct_rate_animal_session animal_num correct_rate_session session_num

        % Correct rate.
        for trial_type = 1:8 % 1: control left; 2: control right; 3: distractor early left; 4: distractor early right; 5: distractor middle left; 6: distractor middle right; 7: distractor late left; 8: distractor late right
            correct_trial_num(trial_type) = sum(behavior{animal_num}{session_num}.bpod.Outcomes(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type) == 1);
            response_trial_num(trial_type) = sum(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type & behavior{animal_num}{session_num}.bpod.Outcomes ~= 3);
        end

        for distractor_type = 1:4
            correct_rate_session{animal_num}(session_num,distractor_type) = (correct_trial_num(distractor_type*2 - 1) + correct_trial_num(distractor_type*2))/(response_trial_num(distractor_type*2 - 1) + response_trial_num(distractor_type*2));
        end
        correct_rate_all_distractor{animal_num}(session_num) = sum(correct_trial_num(3:8))/sum(response_trial_num(3:8));
    end

    correct_rate_animal_session = [correct_rate_animal_session;correct_rate_session{animal_num}];
end

correct_rate_animal_session_control = correct_rate_animal_session;
clearvars -except correct_rate_animal_session_control

% APP.
load('behavior_APP.mat')
behavior = behavior_APP;
clear behavior_APP

% Initialize.
correct_rate_animal_session = [];

for animal_num = 1:numel(behavior)
    clearvars -except correct_rate_animal_session_control behavior correct_rate_animal_session animal_num

    % Initialize.
    correct_rate_session{animal_num} = [];

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except correct_rate_animal_session_control behavior correct_rate_animal_session animal_num correct_rate_session session_num

        % Correct rate.
        for trial_type = 1:8 % 1: control left; 2: control right; 3: distractor early left; 4: distractor early right; 5: distractor middle left; 6: distractor middle right; 7: distractor late left; 8: distractor late right
            correct_trial_num(trial_type) = sum(behavior{animal_num}{session_num}.bpod.Outcomes(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type) == 1);
            response_trial_num(trial_type) = sum(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type & behavior{animal_num}{session_num}.bpod.Outcomes ~= 3);
        end

        for distractor_type = 1:4
            correct_rate_session{animal_num}(session_num,distractor_type) = (correct_trial_num(distractor_type*2 - 1) + correct_trial_num(distractor_type*2))/(response_trial_num(distractor_type*2 - 1) + response_trial_num(distractor_type*2));
        end
        correct_rate_all_distractor{animal_num}(session_num) = sum(correct_trial_num(3:8))/sum(response_trial_num(3:8));
    end

    correct_rate_animal_session = [correct_rate_animal_session;correct_rate_session{animal_num}];
end

correct_rate_animal_session_APP = correct_rate_animal_session;
clearvars -except correct_rate_animal_session_control correct_rate_animal_session_APP

% Plot.
mean_correct_rate_animal_session_control = 100*mean(correct_rate_animal_session_control);
mean_correct_rate_animal_session_APP = 100*mean(correct_rate_animal_session_APP);
se_correct_rate_animal_session_control = 100*std(correct_rate_animal_session_control)/(size(correct_rate_animal_session_control,1)^0.5);
se_correct_rate_animal_session_APP = 100*std(correct_rate_animal_session_APP)/(size(correct_rate_animal_session_APP,1)^0.5);

figure('Position',[200,1000,150,200],'Color','w')
hold on
bar(1,mean_correct_rate_animal_session_control(1),0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None','FaceAlpha',0.6)
bar(2,mean_correct_rate_animal_session_APP(1),0.8,'FaceColor',[0.64,0.08,0.18],'EdgeColor','None','FaceAlpha',0.6)
line([1,1],[mean_correct_rate_animal_session_control(1) - se_correct_rate_animal_session_control(1),mean_correct_rate_animal_session_control(1) + se_correct_rate_animal_session_control(1)],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_correct_rate_animal_session_APP(1) - se_correct_rate_animal_session_APP(1),mean_correct_rate_animal_session_APP(1) + se_correct_rate_animal_session_APP(1)],'Color',[0.64,0.08,0.18],'LineWidth',1)
plot(0.8 + rand(size(correct_rate_animal_session_control,1),1)/2.5,100*correct_rate_animal_session_control(:,1),'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(1.8 + rand(size(correct_rate_animal_session_APP,1),1)/2.5,100*correct_rate_animal_session_APP(:,1),'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('');
ylabel('Correct rate (%)');
xlim([0,3])
ylim([0,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0,50,100];
ax.XTickLabel = {'Ctrl','APP'};
ax.YTickLabel = {'0','50','100'};

figure('Position',[350,1000,225,200],'Color','w')
hold on
plot(mean_correct_rate_animal_session_APP,'LineWidth',1,'Color',[0.64,0.08,0.18])
for trial_type = 1:4
    line([trial_type,trial_type],[mean_correct_rate_animal_session_APP(trial_type) - se_correct_rate_animal_session_APP(trial_type),mean_correct_rate_animal_session_APP(trial_type) + se_correct_rate_animal_session_APP(trial_type)],'LineWidth',1,'Color',[0.64,0.08,0.18])
end
plot(mean_correct_rate_animal_session_control,'LineWidth',1,'Color',[0.25,0.25,0.25])
for trial_type = 1:4
    line([trial_type,trial_type],[mean_correct_rate_animal_session_control(trial_type) - se_correct_rate_animal_session_control(trial_type),mean_correct_rate_animal_session_control(trial_type) + se_correct_rate_animal_session_control(trial_type)],'LineWidth',1,'Color',[0.25,0.25,0.25])
end
xlabel('');
ylabel('Correct rate (%)');
xlim([0.5,4.5])
ylim([55,85])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4];
ax.YTick = [60,70,80];
ax.XTickLabel = {'Ctrl','Dist1','Dist2','Dist3'};
ax.YTickLabel = {'60','70','80'};

end