function plot_region_by_region_interactions_across_analyses

close all
clear all
clc

% Plot region-by-region interaction relationships across analyses.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('functional_connectivity.mat')
load('trial_by_trial_correlation.mat')
load('regression.mat')

mean_mean_region_by_region_fc_animal_session_control = nanmean(mean_region_by_region_fc_animal_session_control,3);
mean_mean_region_by_region_fc_animal_session_APP = nanmean(mean_region_by_region_fc_animal_session_APP,3);

mean_mean_region_by_region_corr_animal_session_control = nanmean(mean_region_by_region_corr_animal_session_control,3);
mean_mean_region_by_region_corr_animal_session_APP = nanmean(mean_region_by_region_corr_animal_session_APP,3);

mean_regression_control = nanmean(regression_control,3);
mean_regression_APP = nanmean(regression_APP,3);

% Intra vs. inter-regional.
intra_mean_mean_region_by_region_fc_animal_session_control = diag(mean_mean_region_by_region_fc_animal_session_control);
for region_num = 1:8
    mean_mean_region_by_region_fc_animal_session_control(region_num,region_num) = nan;
end
inter_mean_mean_region_by_region_fc_animal_session_control = mean_mean_region_by_region_fc_animal_session_control(~isnan(mean_mean_region_by_region_fc_animal_session_control));
intra_mean_mean_region_by_region_fc_animal_session_APP = diag(mean_mean_region_by_region_fc_animal_session_APP);
for region_num = 1:8
    mean_mean_region_by_region_fc_animal_session_APP(region_num,region_num) = nan;
end
inter_mean_mean_region_by_region_fc_animal_session_APP = mean_mean_region_by_region_fc_animal_session_APP(~isnan(mean_mean_region_by_region_fc_animal_session_APP));

intra_mean_mean_region_by_region_corr_animal_session_control = diag(mean_mean_region_by_region_corr_animal_session_control);
for region_num = 1:8
    mean_mean_region_by_region_corr_animal_session_control(region_num,region_num) = nan;
end
inter_mean_mean_region_by_region_corr_animal_session_control = mean_mean_region_by_region_corr_animal_session_control(~isnan(mean_mean_region_by_region_corr_animal_session_control));
intra_mean_mean_region_by_region_corr_animal_session_APP = diag(mean_mean_region_by_region_corr_animal_session_APP);
for region_num = 1:8
    mean_mean_region_by_region_corr_animal_session_APP(region_num,region_num) = nan;
end
inter_mean_mean_region_by_region_corr_animal_session_APP = mean_mean_region_by_region_corr_animal_session_APP(~isnan(mean_mean_region_by_region_corr_animal_session_APP));

intra_mean_regression_control = diag(mean_regression_control);
for region_num = 1:8
    mean_regression_control(region_num,region_num) = nan;
end
inter_mean_regression_control = mean_regression_control(~isnan(mean_regression_control));
intra_mean_regression_APP = diag(mean_regression_APP);
for region_num = 1:8
    mean_regression_APP(region_num,region_num) = nan;
end
inter_mean_regression_APP = mean_regression_APP(~isnan(mean_regression_APP));

% Plot.
figure('Position',[200,800,200,200],'Color','w')
hold on
plot(intra_mean_mean_region_by_region_fc_animal_session_control,intra_mean_mean_region_by_region_corr_animal_session_control,'+','MarkerSize',6,'Color',[0.25,0.25,0.25],'LineWidth',2.5)
plot(inter_mean_mean_region_by_region_fc_animal_session_control,inter_mean_mean_region_by_region_corr_animal_session_control,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(intra_mean_mean_region_by_region_fc_animal_session_APP,intra_mean_mean_region_by_region_corr_animal_session_APP,'+','MarkerSize',6,'Color',[0.64,0.08,0.18],'LineWidth',2.5)
plot(inter_mean_mean_region_by_region_fc_animal_session_APP,inter_mean_mean_region_by_region_corr_animal_session_APP,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('Functional connectivity');
ylabel('Trial-by-trial correlation');
xlim([-0.001,0.01])
ylim([-0.01,0.1])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.005,0.01];
ax.YTick = [0,0.05,0.1];
ax.XTickLabel = {'0','0.005','0.01'};
ax.YTickLabel = {'0','0.05','0.1'};

figure('Position',[400,800,200,200],'Color','w')
hold on
plot(intra_mean_mean_region_by_region_fc_animal_session_control,intra_mean_regression_control,'+','MarkerSize',6,'Color',[0.25,0.25,0.25],'LineWidth',2.5)
plot(inter_mean_mean_region_by_region_fc_animal_session_control,inter_mean_regression_control,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(intra_mean_mean_region_by_region_fc_animal_session_APP,intra_mean_regression_APP,'+','MarkerSize',6,'Color',[0.64,0.08,0.18],'LineWidth',2.5)
plot(inter_mean_mean_region_by_region_fc_animal_session_APP,inter_mean_regression_APP,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('Functional connectivity');
ylabel('Regression');
xlim([-0.001,0.01])
ylim([-0.01,0.15])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.005,0.01];
ax.YTick = [0,0.05,0.1,0.15];
ax.XTickLabel = {'0','0.005','0.01'};
ax.YTickLabel = {'0','0.05','0.1','0.15'};

figure('Position',[600,800,200,200],'Color','w')
hold on
plot(intra_mean_mean_region_by_region_corr_animal_session_control,intra_mean_regression_control,'+','MarkerSize',6,'Color',[0.25,0.25,0.25],'LineWidth',2.5)
plot(inter_mean_mean_region_by_region_corr_animal_session_control,inter_mean_regression_control,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
plot(intra_mean_mean_region_by_region_corr_animal_session_APP,intra_mean_regression_APP,'+','MarkerSize',6,'Color',[0.64,0.08,0.18],'LineWidth',2.5)
plot(inter_mean_mean_region_by_region_corr_animal_session_APP,inter_mean_regression_APP,'o','MarkerSize',6,'MarkerFaceColor',[0.64,0.08,0.18],'MarkerEdgeColor','none')
xlabel('Trial-by-trial correlation');
ylabel('Regression');
xlim([-0.01,0.1])
ylim([-0.01,0.15])
ax = gca;
ax.FontSize = 14;
ax.XTick = [0,0.05,0.1];
ax.YTick = [0,0.05,0.1,0.15];
ax.XTickLabel = {'0','0.05','0.1'};
ax.YTickLabel = {'0','0.05','0.1','0.15'};

% Statistics.
fc_all = [intra_mean_mean_region_by_region_fc_animal_session_control;inter_mean_mean_region_by_region_fc_animal_session_control;intra_mean_mean_region_by_region_fc_animal_session_APP;inter_mean_mean_region_by_region_fc_animal_session_APP];
corr_all = [intra_mean_mean_region_by_region_corr_animal_session_control;inter_mean_mean_region_by_region_corr_animal_session_control;intra_mean_mean_region_by_region_corr_animal_session_APP;inter_mean_mean_region_by_region_corr_animal_session_APP];
regression_all = [intra_mean_regression_control;inter_mean_regression_control;intra_mean_regression_APP;inter_mean_regression_APP];

[rho_fc_corr,p_value_fc_corr] = corr(fc_all,corr_all);
[rho_fc_regression,p_value_fc_regression] = corr(fc_all,regression_all);
[rho_corr_regression,p_value_corr_regression] = corr(corr_all,regression_all);

end