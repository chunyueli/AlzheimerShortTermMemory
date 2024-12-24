function plot_RNN_choice_switch

close all
clear all
clc

% Plot perturbation-induced choice switching in RNNs.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('RNN_choice_switch_trial_fraction.mat')

switch_trial_fraction_control_no_ablation = RNN_choice_switch_trial_fraction.control.no_ablation;
switch_trial_fraction_control_ablation_10_percent = RNN_choice_switch_trial_fraction.control.ablation_10_percent;
switch_trial_fraction_control_ablation_20_percent = RNN_choice_switch_trial_fraction.control.ablation_20_percent;
switch_trial_fraction_APP_no_ablation = RNN_choice_switch_trial_fraction.APP.no_ablation;
mean_switch_trial_fraction_control_no_ablation = mean(switch_trial_fraction_control_no_ablation);
mean_switch_trial_fraction_control_ablation_10_percent = mean(switch_trial_fraction_control_ablation_10_percent);
mean_switch_trial_fraction_control_ablation_20_percent = mean(switch_trial_fraction_control_ablation_20_percent);
mean_switch_trial_fraction_APP_no_ablation = mean(switch_trial_fraction_APP_no_ablation);
se_switch_trial_fraction_control_no_ablation = std(switch_trial_fraction_control_no_ablation)/(numel(switch_trial_fraction_control_no_ablation)^0.5);
se_switch_trial_fraction_control_ablation_10_percent = std(switch_trial_fraction_control_ablation_10_percent)/(numel(switch_trial_fraction_control_ablation_10_percent)^0.5);
se_switch_trial_fraction_control_ablation_20_percent = std(switch_trial_fraction_control_ablation_20_percent)/(numel(switch_trial_fraction_control_ablation_20_percent)^0.5);
se_switch_trial_fraction_APP_no_ablation = std(switch_trial_fraction_APP_no_ablation)/(numel(switch_trial_fraction_APP_no_ablation)^0.5);

% Plot.
figure('Position',[200,1000,200,200],'Color','w')
hold on
plot(switch_trial_fraction_control_no_ablation,switch_trial_fraction_APP_no_ablation,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
line([-5,105],[-5 105],'LineWidth',1,'Color',[0.25,0.25,0.25])
line([mean_switch_trial_fraction_control_no_ablation - se_switch_trial_fraction_control_no_ablation,mean_switch_trial_fraction_control_no_ablation + se_switch_trial_fraction_control_no_ablation],[mean_switch_trial_fraction_APP_no_ablation, mean_switch_trial_fraction_APP_no_ablation],'LineWidth',2,'Color',[0.64,0.08,0.18])
line([mean_switch_trial_fraction_control_no_ablation, mean_switch_trial_fraction_control_no_ablation],[mean_switch_trial_fraction_APP_no_ablation - se_switch_trial_fraction_APP_no_ablation,mean_switch_trial_fraction_APP_no_ablation + se_switch_trial_fraction_APP_no_ablation],'LineWidth',2,'Color',[0.64,0.08,0.18])
xlabel('Control');
ylabel('APP');
xlim([-5 105])
ylim([-5 105])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,50,100];
ax.YTick = [0,50,100];
ax.XTickLabel = {'0','50','100'};
ax.YTickLabel = {'0','50','100'};

figure('Position',[400,1000,200,200],'Color','w')
hold on;
bar(1,mean_switch_trial_fraction_control_no_ablation,0.6,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None')
bar(2,mean_switch_trial_fraction_APP_no_ablation,0.6,'FaceColor',[0.5,0.5,0.5],'EdgeColor','None')
line([1,1],[mean_switch_trial_fraction_control_no_ablation - se_switch_trial_fraction_control_no_ablation,mean_switch_trial_fraction_control_no_ablation + se_switch_trial_fraction_control_no_ablation],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_switch_trial_fraction_APP_no_ablation - se_switch_trial_fraction_APP_no_ablation,mean_switch_trial_fraction_APP_no_ablation + se_switch_trial_fraction_APP_no_ablation],'Color',[0.5,0.5,0.5],'LineWidth',1)
xlabel('');
ylabel('Trials switched (%)');
xlim([0,3])
ylim([0,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2];
ax.YTick = [0,50,100];
ax.XTickLabel = {'Control','APP'};
ax.YTickLabel = {'0','50','100'};

figure('Position',[600,1000,200,200],'Color','w')
hold on;
bar(1,mean_switch_trial_fraction_control_no_ablation,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None')
bar(2,mean_switch_trial_fraction_control_ablation_10_percent,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None')
bar(3,mean_switch_trial_fraction_control_ablation_20_percent,0.8,'FaceColor',[0.25,0.25,0.25],'EdgeColor','None')
bar(4,mean_switch_trial_fraction_APP_no_ablation,0.8,'FaceColor',[0.5,0.5,0.5],'EdgeColor','None')
line([1,1],[mean_switch_trial_fraction_control_no_ablation - se_switch_trial_fraction_control_no_ablation,mean_switch_trial_fraction_control_no_ablation + se_switch_trial_fraction_control_no_ablation],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([2,2],[mean_switch_trial_fraction_control_ablation_10_percent - se_switch_trial_fraction_control_ablation_10_percent,mean_switch_trial_fraction_control_ablation_10_percent + se_switch_trial_fraction_control_ablation_10_percent],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([3,3],[mean_switch_trial_fraction_control_ablation_20_percent - se_switch_trial_fraction_control_ablation_20_percent,mean_switch_trial_fraction_control_ablation_20_percent + se_switch_trial_fraction_control_ablation_20_percent],'Color',[0.25,0.25,0.25],'LineWidth',1)
line([4,4],[mean_switch_trial_fraction_APP_no_ablation - se_switch_trial_fraction_APP_no_ablation,mean_switch_trial_fraction_APP_no_ablation + se_switch_trial_fraction_APP_no_ablation],'Color',[0.5,0.5,0.5],'LineWidth',1)
xlabel('');
ylabel('Trials switched (%)');
xlim([0,5])
ylim([0,100])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4];
ax.YTick = [0,50,100];
ax.XTickLabel = {'0','10','20','0'};
ax.YTickLabel = {'0','50','100'};

end