function plot_example_reduced_rank_regression

close all
clear all
clc

% Plot examples of reduced-rank regression.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('population_regression_control.mat')
y_control = population_regression_control.all_epoch.y;
e_control = population_regression_control.all_epoch.e;
optDimLambdaReducedRankRegress_control = population_regression_control.all_epoch.optDimLambdaReducedRankRegress;
clearvars -except y_control e_control optDimLambdaReducedRankRegress_control

load('population_regression_APP.mat')
y_APP = population_regression_APP.all_epoch.y;
e_APP = population_regression_APP.all_epoch.e;
optDimLambdaReducedRankRegress_APP = population_regression_APP.all_epoch.optDimLambdaReducedRankRegress;
clearvars -except y_control e_control optDimLambdaReducedRankRegress_control y_APP e_APP optDimLambdaReducedRankRegress_APP

% Control.
mean_y_intra_control = mean(y_control{5}{4}{1}{1});
mean_e_intra_control = mean(e_control{5}{4}{1}{1});
mean_optDimLambdaReducedRankRegress_intra_control = mean(optDimLambdaReducedRankRegress_control{5}{4}{1}{1});
mean_y_inter_control = mean(y_control{5}{4}{1}{7});
mean_e_inter_control = mean(e_control{5}{4}{1}{7});
mean_optDimLambdaReducedRankRegress_inter_control = mean(optDimLambdaReducedRankRegress_control{5}{4}{1}{7});

% Plot.
figure('Position',[200,800,175,150],'Color','w')
plot(mean_y_intra_control(2:end),'-','Color',[0.25,0.25,0.25],'LineWidth',1)
for dimension_num = 2:11
    line([dimension_num - 1,dimension_num - 1],[mean_y_intra_control(dimension_num) - mean_e_intra_control(dimension_num),mean_y_intra_control(dimension_num) + mean_e_intra_control(dimension_num)],'LineWidth',1,'Color',[0.25,0.25,0.25])
end
xlabel('Predictive dimensions');
ylabel('Performance');
xlim([0,11])
ylim([0.012,0.02])
ax = gca;
ax.FontSize = 14;
ax.XTick = [5,10];
ax.YTick = [0.012,0.02];
ax.XTickLabel = {'5','10'};
ax.YTickLabel = {'0.012','0.02'};

figure('Position',[375,800,175,150],'Color','w')
plot(mean_y_inter_control(2:end),'-','Color',[0.25,0.25,0.25],'LineWidth',1)
for dimension_num = 2:11
    line([dimension_num - 1,dimension_num - 1],[mean_y_inter_control(dimension_num) - mean_e_inter_control(dimension_num),mean_y_inter_control(dimension_num) + mean_e_inter_control(dimension_num)],'LineWidth',1,'Color',[0.25,0.25,0.25])
end
xlabel('Predictive dimensions');
ylabel('Performance');
xlim([0,11])
ylim([0.01,0.013])
ax = gca;
ax.FontSize = 14;
ax.XTick = [5,10];
ax.YTick = [0.01,0.013];
ax.XTickLabel = {'5','10'};
ax.YTickLabel = {'0.01','0.013'};

% APP.
mean_y_intra_APP = mean(y_APP{5}{4}{1}{1});
mean_e_intra_APP = mean(e_APP{5}{4}{1}{1});
mean_optDimLambdaReducedRankRegress_intra_APP = mean(optDimLambdaReducedRankRegress_APP{5}{4}{1}{1});
mean_y_inter_APP = mean(y_APP{5}{4}{1}{7});
mean_e_inter_APP = mean(e_APP{5}{4}{1}{7});
mean_optDimLambdaReducedRankRegress_inter_APP = mean(optDimLambdaReducedRankRegress_APP{5}{4}{1}{7});

% Plot.
figure('Position',[200,550,175,150],'Color','w')
plot(mean_y_intra_APP(2:end),'-','Color',[0.64,0.08,0.18],'LineWidth',1)
for dimension_num = 2:11
    line([dimension_num - 1,dimension_num - 1],[mean_y_intra_APP(dimension_num) - mean_e_intra_APP(dimension_num),mean_y_intra_APP(dimension_num) + mean_e_intra_APP(dimension_num)],'LineWidth',1,'Color',[0.64,0.08,0.18])
end
xlabel('Predictive dimensions');
ylabel('Performance');
xlim([0,11])
ylim([0.006,0.012])
ax = gca;
ax.FontSize = 14;
ax.XTick = [5,10];
ax.YTick = [0.006,0.012];
ax.XTickLabel = {'5','10'};
ax.YTickLabel = {'0.006','0.012'};

figure('Position',[375,550,175,150],'Color','w')
plot(mean_y_inter_APP(2:end),'-','Color',[0.64,0.08,0.18],'LineWidth',1)
for dimension_num = 2:11
    line([dimension_num - 1,dimension_num - 1],[mean_y_inter_APP(dimension_num) - mean_e_inter_APP(dimension_num),mean_y_inter_APP(dimension_num) + mean_e_inter_APP(dimension_num)],'LineWidth',1,'Color',[0.64,0.08,0.18])
end
xlabel('Predictive dimensions');
ylabel('Performance');
xlim([0,11])
ylim([0.002,0.005])
ax = gca;
ax.FontSize = 14;
ax.XTick = [5,10];
ax.YTick = [0.002,0.005];
ax.XTickLabel = {'5','10'};
ax.YTickLabel = {'0.002','0.005'};

end