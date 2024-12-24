function plot_example_choice_mode_activity_RNN

close all
clear all
clc

% Plot choice mode activity of RNNs with distractors.

rng(0)

% Set parameters for example RNNs.
RNN_variable = get_example_choice_mode_activity_RNN;

% Control.
left_choice_mode_std_norm  = RNN_variable.control.choice_mode.left_choice_mode_std_norm;
right_choice_mode_std_norm = RNN_variable.control.choice_mode.right_choice_mode_std_norm;
L_pos_choice_mode_std_norm = RNN_variable.control.choice_mode.L_pos_choice_mode_std_norm;
L_pos_mid_point = RNN_variable.control.choice_mode.L_pos_mid_point;

% Randomly sample 40 trials out of 100.
rand_idx = randsample(1:numel(L_pos_mid_point),40);

figure('Position',[200,800,200,200],'Color','w')
hold on;
fs_image = 93.5;
x_lim = [1,round(fs_image*5.5)];
y_lim = [-1,1];
for sample_num = rand_idx
    if L_pos_mid_point(sample_num) < 0.5
        plot(L_pos_choice_mode_std_norm(sample_num,:),'Color',[0.25,0.25,0.25],'LineWidth',0.5);
    else
        plot(L_pos_choice_mode_std_norm(sample_num,:),':','Color',[0.75,0.75,0.75],'LineWidth',0.5);
    end
end
plot(nanmean(left_choice_mode_std_norm,1),'Color',[0.00,0.45,0.74],'LineWidth',2);
plot(nanmean(right_choice_mode_std_norm,1),'Color',[0.64,0.08,0.18],'LineWidth',2);
line([0.5.*fs_image,0.5.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([1.5.*fs_image,1.5.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([3.2.*fs_image,3.2.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([3.7.*fs_image,3.7.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
xlabel('Time to go cue (s)')
ylabel('Choice activity');
xlim(x_lim)
ylim(y_lim)
ax = gca;
ax.FontSize = 14;
ax.XTick = [0.5.*fs_image,1.5.*fs_image];
ax.YTick = [-1,0,1];
ax.XTickLabel = {'-5','-4'};
ax.YTickLabel = {'-1','0','1'};

clearvars -except RNN_variable

% APP.
left_choice_mode_std_norm  = RNN_variable.APP.choice_mode.left_choice_mode_std_norm;
right_choice_mode_std_norm = RNN_variable.APP.choice_mode.right_choice_mode_std_norm;
L_pos_choice_mode_std_norm = RNN_variable.APP.choice_mode.L_pos_choice_mode_std_norm;
L_pos_mid_point = RNN_variable.APP.choice_mode.L_pos_mid_point;

% Randomly sample 40 trials out of 100.
rand_idx = randsample(1:numel(L_pos_mid_point),40);

figure('Position',[400,800,200,200],'Color','w')
hold on;
fs_image = 93.5;
x_lim = [1,round(fs_image*5.5)];
y_lim = [-1,1];
for sample_num = rand_idx
    if L_pos_mid_point(sample_num) < 0.5
        plot(L_pos_choice_mode_std_norm(sample_num,:),'Color',[0.25,0.25,0.25],'LineWidth',0.5);
    else
        plot(L_pos_choice_mode_std_norm(sample_num,:),':','Color',[0.75,0.75,0.75],'LineWidth',0.5);
    end
end
plot(nanmean(left_choice_mode_std_norm,1),'Color',[0.00,0.45,0.74],'LineWidth',2);
plot(nanmean(right_choice_mode_std_norm,1),'Color',[0.64,0.08,0.18],'LineWidth',2);
line([0.5.*fs_image,0.5.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([1.5.*fs_image,1.5.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([3.2.*fs_image,3.2.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([3.7.*fs_image,3.7.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
xlabel('Time to go cue (s)')
ylabel('Choice activity');
xlim(x_lim)
ylim(y_lim)
ax = gca;
ax.FontSize = 14;
ax.XTick = [0.5.*fs_image,1.5.*fs_image];
ax.YTick = [-1,0,1];
ax.XTickLabel = {'-5','-4'};
ax.YTickLabel = {'-1','0','1'};

clearvars -except RNN_variable

% Control with 10% ablation.
left_choice_mode_std_norm  = RNN_variable.control_10_percent_ablation.choice_mode.left_choice_mode_std_norm;
right_choice_mode_std_norm = RNN_variable.control_10_percent_ablation.choice_mode.right_choice_mode_std_norm;
L_pos_choice_mode_std_norm = RNN_variable.control_10_percent_ablation.choice_mode.L_pos_choice_mode_std_norm;
L_pos_mid_point = RNN_variable.control_10_percent_ablation.choice_mode.L_pos_mid_point;

% Randomly sample 40 trials out of 100.
rand_idx = randsample(1:numel(L_pos_mid_point),40);

figure('Position',[600,800,200,200],'Color','w')
hold on;
fs_image = 93.5;
x_lim = [1,round(fs_image*5.5)];
y_lim = [-1,1];
for sample_num = rand_idx
    if L_pos_mid_point(sample_num) < 0.5
        plot(L_pos_choice_mode_std_norm(sample_num,:),'Color',[0.25,0.25,0.25],'LineWidth',0.5);
    else
        plot(L_pos_choice_mode_std_norm(sample_num,:),':','Color',[0.75,0.75,0.75],'LineWidth',0.5);
    end
end
plot(nanmean(left_choice_mode_std_norm,1),'Color',[0.00,0.45,0.74],'LineWidth',2);
plot(nanmean(right_choice_mode_std_norm,1),'Color',[0.64,0.08,0.18],'LineWidth',2);
line([0.5.*fs_image,0.5.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([1.5.*fs_image,1.5.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([3.2.*fs_image,3.2.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([3.7.*fs_image,3.7.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
xlabel('Time to go cue (s)')
ylabel('Choice activity');
xlim(x_lim)
ylim(y_lim)
ax = gca;
ax.FontSize = 14;
ax.XTick = [0.5.*fs_image,1.5.*fs_image];
ax.YTick = [-1,0,1];
ax.XTickLabel = {'-5','-4'};
ax.YTickLabel = {'-1','0','1'};

clearvars -except RNN_variable

% Control with 20% ablation.
left_choice_mode_std_norm  = RNN_variable.control_20_percent_ablation.choice_mode.left_choice_mode_std_norm;
right_choice_mode_std_norm = RNN_variable.control_20_percent_ablation.choice_mode.right_choice_mode_std_norm;
L_pos_choice_mode_std_norm = RNN_variable.control_20_percent_ablation.choice_mode.L_pos_choice_mode_std_norm;
L_pos_mid_point = RNN_variable.control_20_percent_ablation.choice_mode.L_pos_mid_point;

% Randomly sample 40 trials out of 100.
rand_idx = randsample(1:numel(L_pos_mid_point),40);

figure('Position',[800,800,200,200],'Color','w')
hold on;
fs_image = 93.5;
x_lim = [1,round(fs_image*5.5)];
y_lim = [-1,1];
for sample_num = rand_idx
    if L_pos_mid_point(sample_num) < 0.5
        plot(L_pos_choice_mode_std_norm(sample_num,:),'Color',[0.25,0.25,0.25],'LineWidth',0.5);
    else
        plot(L_pos_choice_mode_std_norm(sample_num,:),':','Color',[0.75,0.75,0.75],'LineWidth',0.5);
    end
end
plot(nanmean(left_choice_mode_std_norm,1),'Color',[0.00,0.45,0.74],'LineWidth',2);
plot(nanmean(right_choice_mode_std_norm,1),'Color',[0.64,0.08,0.18],'LineWidth',2);
line([0.5.*fs_image,0.5.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([1.5.*fs_image,1.5.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([3.2.*fs_image,3.2.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
line([3.7.*fs_image,3.7.*fs_image],y_lim,'Color',[0.25,0.25,0.25]);
xlabel('Time to go cue (s)')
ylabel('Choice activity');
xlim(x_lim)
ylim(y_lim)
ax = gca;
ax.FontSize = 14;
ax.XTick = [0.5.*fs_image,1.5.*fs_image];
ax.YTick = [-1,0,1];
ax.XTickLabel = {'-5','-4'};
ax.YTickLabel = {'-1','0','1'};

end