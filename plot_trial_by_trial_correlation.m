function plot_trial_by_trial_correlation

close all
clear all
clc

% Plot trial-by-trial pairwise activity correlation.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('behavior_control.mat')
load('activity_control.mat')
load('activity_iti_control.mat')
behavior = behavior_control;
activity = activity_control;
activity_iti = activity_iti_control;
clear behavior_control
clear activity_control
clear activity_iti_control

% Re-order activity based on the trial number.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for trial_type = 1:8
            trial_idx{animal_num}{session_num}{trial_type} = find(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type);
        end

        for region_num = 1:8
            for trial_type = 1:8
                if ~isempty(activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}) == 1 % If there are cells.
                    for trial_num = 1:numel(trial_idx{animal_num}{session_num}{trial_type})
                        if size(activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:),1) == 1 % If there is only 1 cell.
                            trial_by_trial_activity{animal_num}{session_num}{region_num}(1,trial_idx{animal_num}{session_num}{trial_type}(trial_num),:) = activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:);
                        else
                            trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_idx{animal_num}{session_num}{trial_type}(trial_num),:) = activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:);
                        end
                    end
                else
                    trial_by_trial_activity{animal_num}{session_num}{region_num} = [];
                end
            end

            concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [];
            for trial_num = 1:size(trial_by_trial_activity{animal_num}{session_num}{region_num},2)
                if size(trial_by_trial_activity{animal_num}{session_num}{region_num},1) == 1 % If there is only 1 cell.
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))'];
                else
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))];
                end
            end
        end
    end
end

% Pick cells with similar activity levels.
for animal_num = 1:numel(behavior)
    clearvars -except behavior activity_iti concat_trial_by_trial_activity animal_num mean_concat_trial_by_trial_activity cell_idx region_cell_idx

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior activity_iti concat_trial_by_trial_activity animal_num session_num mean_concat_trial_by_trial_activity cell_idx region_cell_idx

        for region_num = 1:8
            mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2);
            cell_idx{animal_num}{session_num}{region_num} = mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} > 0.024;
            region_cell_idx{animal_num}{session_num}{region_num} = activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(cell_idx{animal_num}{session_num}{region_num});
        end
    end
end

% Trial-by-trial pairwise activity correlations.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        activity_all_regions{animal_num}{session_num} = [];
        for region_num = 1:8
            activity_all_regions{animal_num}{session_num} = [activity_all_regions{animal_num}{session_num};concat_trial_by_trial_activity{animal_num}{session_num}{region_num}];
        end

        % Correlation coefficients.
        activity_corr_all_regions{animal_num}{session_num} = corr(activity_all_regions{animal_num}{session_num}');
    end
end

% Initialize.
mean_region_by_region_activity_corr_animal_session = [];

for animal_num = 1:numel(behavior)
    clearvars -except behavior region_cell_idx activity_corr_all_regions mean_region_by_region_activity_corr_animal_session animal_num

    % Initialize.
    mean_region_by_region_activity_corr_session = [];

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except behavior region_cell_idx activity_corr_all_regions mean_region_by_region_activity_corr_animal_session animal_num mean_region_by_region_activity_corr_session session_num

        for region_num = 1:8
            if isnan(region_cell_idx{animal_num}{session_num}{region_num}) == 1 | numel(region_cell_idx{animal_num}{session_num}{region_num}) < 10 % The cell number has to be at least 10 in each region.
                region_cell_idx{animal_num}{session_num}{region_num} = [];
            end
        end

        for region_num1 = 1:8
            for region_num2 = 1:8
                inter_regional_activity_corr{region_num1}{region_num2} = activity_corr_all_regions{animal_num}{session_num}(region_cell_idx{animal_num}{session_num}{region_num1},region_cell_idx{animal_num}{session_num}{region_num2});
            end
        end

        % Replace upper triangle with nan for intra-regional activity correlations.
        for region_num = 1:8
            intra_regional_activity_corr{region_num} = triu(nan(size(inter_regional_activity_corr{region_num}{region_num}))) + inter_regional_activity_corr{region_num}{region_num};
        end

        % Nan for intra-regional activity correlations.
        for region_num = 1:8
            inter_regional_activity_corr{region_num}{region_num} = nan(size(inter_regional_activity_corr{region_num}{region_num}));
        end

        % Average for each pair.
        for region_num1 = 1:8
            for region_num2 = 1:8
                mean_inter_regional_activity_corr(region_num1,region_num2) = nanmean(inter_regional_activity_corr{region_num1}{region_num2}(:));
            end
        end

        % Insert intra-regional functional connectivity.
        for region_num = 1:8
            mean_intra_regional_activity_corr(region_num) = nanmean(intra_regional_activity_corr{region_num}(:));
            mean_inter_regional_activity_corr(region_num,region_num) = mean_intra_regional_activity_corr(region_num);
        end

        mean_region_by_region_activity_corr = mean_inter_regional_activity_corr;

        % Concatenate.
        mean_region_by_region_activity_corr_session = cat(3,mean_region_by_region_activity_corr_session,mean_region_by_region_activity_corr);
    end

    % Concatenate.
    mean_region_by_region_activity_corr_animal_session = cat(3,mean_region_by_region_activity_corr_animal_session,mean_region_by_region_activity_corr_session);
end

mean_region_by_region_corr_animal_session_control = mean_region_by_region_activity_corr_animal_session;
clearvars -except mean_region_by_region_corr_animal_session_control

% APP.
load('behavior_APP.mat')
load('activity_APP.mat')
load('activity_iti_APP.mat')
behavior = behavior_APP;
activity = activity_APP;
activity_iti = activity_iti_APP;
clear behavior_APP
clear activity_APP
clear activity_iti_APP

% Re-order activity based on the trial number.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for trial_type = 1:8
            trial_idx{animal_num}{session_num}{trial_type} = find(behavior{animal_num}{session_num}.bpod.TrialTypes == trial_type);
        end

        for region_num = 1:8
            for trial_type = 1:8
                if ~isempty(activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}) == 1 % If there are cells.
                    for trial_num = 1:numel(trial_idx{animal_num}{session_num}{trial_type})
                        if size(activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:),1) == 1 % If there is only 1 cell.
                            trial_by_trial_activity{animal_num}{session_num}{region_num}(1,trial_idx{animal_num}{session_num}{trial_type}(trial_num),:) = activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:);
                        else
                            trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_idx{animal_num}{session_num}{trial_type}(trial_num),:) = activity{animal_num}{session_num}.correct_incorrect_response{region_num}{trial_type}(:,trial_num,:);
                        end
                    end
                else
                    trial_by_trial_activity{animal_num}{session_num}{region_num} = [];
                end
            end

            concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [];
            for trial_num = 1:size(trial_by_trial_activity{animal_num}{session_num}{region_num},2)
                if size(trial_by_trial_activity{animal_num}{session_num}{region_num},1) == 1 % If there is only 1 cell.
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))'];
                else
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))];
                end
            end
        end
    end
end

% Pick cells with similar activity levels.
for animal_num = 1:numel(behavior)
    clearvars -except mean_region_by_region_corr_animal_session_control behavior activity_iti concat_trial_by_trial_activity animal_num mean_concat_trial_by_trial_activity cell_idx region_cell_idx

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except mean_region_by_region_corr_animal_session_control behavior activity_iti concat_trial_by_trial_activity animal_num session_num mean_concat_trial_by_trial_activity cell_idx region_cell_idx

        for region_num = 1:8
            mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2);
            cell_idx{animal_num}{session_num}{region_num} = mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} > 0.024;
            region_cell_idx{animal_num}{session_num}{region_num} = activity_iti{animal_num}{session_num}.region_cell_idx{region_num}(cell_idx{animal_num}{session_num}{region_num});
        end
    end
end

% Trial-by-trial pairwise activity correlations.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        activity_all_regions{animal_num}{session_num} = [];
        for region_num = 1:8
            activity_all_regions{animal_num}{session_num} = [activity_all_regions{animal_num}{session_num};concat_trial_by_trial_activity{animal_num}{session_num}{region_num}];
        end

        % Correlation coefficients.
        activity_corr_all_regions{animal_num}{session_num} = corr(activity_all_regions{animal_num}{session_num}');
    end
end

% Initialize.
mean_region_by_region_activity_corr_animal_session = [];

for animal_num = 1:numel(behavior)
    clearvars -except mean_region_by_region_corr_animal_session_control behavior region_cell_idx activity_corr_all_regions mean_region_by_region_activity_corr_animal_session animal_num

    % Initialize.
    mean_region_by_region_activity_corr_session = [];

    for session_num = 1:numel(behavior{animal_num})
        clearvars -except mean_region_by_region_corr_animal_session_control behavior region_cell_idx activity_corr_all_regions mean_region_by_region_activity_corr_animal_session animal_num mean_region_by_region_activity_corr_session session_num

        for region_num = 1:8
            if isnan(region_cell_idx{animal_num}{session_num}{region_num}) == 1 | numel(region_cell_idx{animal_num}{session_num}{region_num}) < 10 % The cell number has to be at least 10 in each region.
                region_cell_idx{animal_num}{session_num}{region_num} = [];
            end
        end

        for region_num1 = 1:8
            for region_num2 = 1:8
                inter_regional_activity_corr{region_num1}{region_num2} = activity_corr_all_regions{animal_num}{session_num}(region_cell_idx{animal_num}{session_num}{region_num1},region_cell_idx{animal_num}{session_num}{region_num2});
            end
        end

        % Replace upper triangle with nan for intra-regional activity correlations.
        for region_num = 1:8
            intra_regional_activity_corr{region_num} = triu(nan(size(inter_regional_activity_corr{region_num}{region_num}))) + inter_regional_activity_corr{region_num}{region_num};
        end

        % Nan for intra-regional activity correlations.
        for region_num = 1:8
            inter_regional_activity_corr{region_num}{region_num} = nan(size(inter_regional_activity_corr{region_num}{region_num}));
        end

        % Average for each pair.
        for region_num1 = 1:8
            for region_num2 = 1:8
                mean_inter_regional_activity_corr(region_num1,region_num2) = nanmean(inter_regional_activity_corr{region_num1}{region_num2}(:));
            end
        end

        % Insert intra-regional functional connectivity.
        for region_num = 1:8
            mean_intra_regional_activity_corr(region_num) = nanmean(intra_regional_activity_corr{region_num}(:));
            mean_inter_regional_activity_corr(region_num,region_num) = mean_intra_regional_activity_corr(region_num);
        end

        mean_region_by_region_activity_corr = mean_inter_regional_activity_corr;

        % Concatenate.
        mean_region_by_region_activity_corr_session = cat(3,mean_region_by_region_activity_corr_session,mean_region_by_region_activity_corr);
    end

    % Concatenate.
    mean_region_by_region_activity_corr_animal_session = cat(3,mean_region_by_region_activity_corr_animal_session,mean_region_by_region_activity_corr_session);
end

mean_region_by_region_corr_animal_session_APP = mean_region_by_region_activity_corr_animal_session;
clearvars -except mean_region_by_region_corr_animal_session_control mean_region_by_region_corr_animal_session_APP

% Plot.
mean_mean_region_by_region_corr_animal_session_control = nanmean(mean_region_by_region_corr_animal_session_control,3);
mean_mean_region_by_region_corr_animal_session_APP = nanmean(mean_region_by_region_corr_animal_session_APP,3);

figure('Position',[200,800,200,200],'Color','w')
imagesc(mean_mean_region_by_region_corr_animal_session_control,[0.02,0.08])
axis square
xlabel('');
ylabel('');
axis off
colormap('magma')

figure('Position',[400,800,200,200],'Color','w')
imagesc(mean_mean_region_by_region_corr_animal_session_APP,[0.02,0.08])
axis square
xlabel('');
ylabel('');
axis off
colormap('magma')

% Two-way ANOVA.
intra_idx = [1:9:64];
inter_idx = [2:8,11:16,20:24,29:32,38:40,47:48,56];
reshaped_mean_region_by_region_corr_animal_session_ctrl = reshape(mean_region_by_region_corr_animal_session_control,[64,size(mean_region_by_region_corr_animal_session_control,3)]);
intra_reshaped_mean_region_by_region_corr_animal_session_ctrl = reshaped_mean_region_by_region_corr_animal_session_ctrl(intra_idx,:);
inter_reshaped_mean_region_by_region_corr_animal_session_ctrl = reshaped_mean_region_by_region_corr_animal_session_ctrl(inter_idx,:);
both_mean_region_by_region_corr_animal_session_ctrl_temp = [intra_reshaped_mean_region_by_region_corr_animal_session_ctrl(:);inter_reshaped_mean_region_by_region_corr_animal_session_ctrl(:)];
intra_inter_group_ctrl_temp = [repmat({'intra'},numel(intra_reshaped_mean_region_by_region_corr_animal_session_ctrl),1);repmat({'inter'},numel(inter_reshaped_mean_region_by_region_corr_animal_session_ctrl),1)];
both_mean_region_by_region_corr_animal_session_ctrl = both_mean_region_by_region_corr_animal_session_ctrl_temp(find(~isnan(both_mean_region_by_region_corr_animal_session_ctrl_temp)));
intra_inter_group_ctrl = intra_inter_group_ctrl_temp(find(~isnan(both_mean_region_by_region_corr_animal_session_ctrl_temp)));

reshaped_mean_region_by_region_corr_animal_session_APP = reshape(mean_region_by_region_corr_animal_session_APP,[64,size(mean_region_by_region_corr_animal_session_APP,3)]);
intra_reshaped_mean_region_by_region_corr_animal_session_APP = reshaped_mean_region_by_region_corr_animal_session_APP(intra_idx,:);
inter_reshaped_mean_region_by_region_corr_animal_session_APP = reshaped_mean_region_by_region_corr_animal_session_APP(inter_idx,:);
both_mean_region_by_region_corr_animal_session_APP_temp = [intra_reshaped_mean_region_by_region_corr_animal_session_APP(:);inter_reshaped_mean_region_by_region_corr_animal_session_APP(:)];
intra_inter_group_APP_temp = [repmat({'intra'},numel(intra_reshaped_mean_region_by_region_corr_animal_session_APP),1);repmat({'inter'},numel(inter_reshaped_mean_region_by_region_corr_animal_session_APP),1)];
both_mean_region_by_region_corr_animal_session_APP = both_mean_region_by_region_corr_animal_session_APP_temp(find(~isnan(both_mean_region_by_region_corr_animal_session_APP_temp)));
intra_inter_group_APP = intra_inter_group_APP_temp(find(~isnan(both_mean_region_by_region_corr_animal_session_APP_temp)));

data_all = [both_mean_region_by_region_corr_animal_session_ctrl;both_mean_region_by_region_corr_animal_session_APP];
group_genotype_all = [repmat({'control'},numel(both_mean_region_by_region_corr_animal_session_ctrl),1);repmat({'APP'},numel(both_mean_region_by_region_corr_animal_session_APP),1)];
group_intra_inter_all = [intra_inter_group_ctrl;intra_inter_group_APP];
[p,tbl,stats,terms] = anovan(data_all,{group_genotype_all,group_intra_inter_all},"Model","interaction","Varnames",["genotype","intra_inter"]);

% Save.
%save('trial_by_trial_correlation.mat','mean_region_by_region_corr_animal_session_control','mean_region_by_region_corr_animal_session_APP','-v7.3')

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
figure('Position',[200,500,200,200],'Color','k')
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

cMap_temp = magma;
cMap = cMap_temp(round(linspace(1,256,64)),:);
temp1 = round(rescale([mean_mean_region_by_region_corr_animal_session_control(:);min([mean_mean_region_by_region_corr_animal_session_control(:);mean_mean_region_by_region_corr_animal_session_APP(:)]);max([mean_mean_region_by_region_corr_animal_session_control(:);mean_mean_region_by_region_corr_animal_session_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate(region_num1,1),region_coordinate(region_num2,1)],[region_coordinate(region_num1,2),region_coordinate(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/10,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate(region_num,1),region_coordinate(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

clearvars -except bregma mean_region_by_region_corr_animal_session_control mean_region_by_region_corr_animal_session_APP cortical_area_boundaries mean_mean_region_by_region_corr_animal_session_control mean_mean_region_by_region_corr_animal_session_APP

% Get coordinates of all regions.
region_coordinate_temp = [290,380;350,270;450,370;465,500;490,280;630,200;640,490;690,340];
region_coordinate_temp  = region_coordinate_temp*10;
region_coordinate_middle(:,1) = region_coordinate_temp(:,2) - bregma(2); % Swap X with Y.
region_coordinate_middle(:,2) = region_coordinate_temp(:,1) - bregma(1);
region_coordinate = region_coordinate_temp - bregma;

% Plot.
figure('Position',[400,500,200,200],'Color','k')
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

cMap_temp = magma;
cMap = cMap_temp(round(linspace(1,256,64)),:);
temp1 = round(rescale([mean_mean_region_by_region_corr_animal_session_APP(:);min([mean_mean_region_by_region_corr_animal_session_control(:);mean_mean_region_by_region_corr_animal_session_APP(:)]);max([mean_mean_region_by_region_corr_animal_session_control(:);mean_mean_region_by_region_corr_animal_session_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate(region_num1,1),region_coordinate(region_num2,1)],[region_coordinate(region_num1,2),region_coordinate(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/10,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate(region_num,1),region_coordinate(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

% Statistics.
rng(0)

for region_num1 = 1:8
    for region_num2 = 1:8
        corr_control_temp{region_num1}{region_num2} = squeeze(mean_region_by_region_corr_animal_session_control(region_num1,region_num2,:));
        corr_control{region_num1}{region_num2} = corr_control_temp{region_num1}{region_num2}(~isnan(corr_control_temp{region_num1}{region_num2}));

        corr_APP_temp{region_num1}{region_num2} = squeeze(mean_region_by_region_corr_animal_session_APP(region_num1,region_num2,:));
        corr_APP{region_num1}{region_num2} = corr_APP_temp{region_num1}{region_num2}(~isnan(corr_APP_temp{region_num1}{region_num2}));

        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(corr_control{region_num1}{region_num2})
                sampled_corr_control{region_num1}{region_num2}(shuffle_num,session_num) = corr_control{region_num1}{region_num2}(randi(numel(corr_control{region_num1}{region_num2})));
            end
            for session_num = 1:numel(corr_APP{region_num1}{region_num2})
                sampled_corr_APP{region_num1}{region_num2}(shuffle_num,session_num) = corr_APP{region_num1}{region_num2}(randi(numel(corr_APP{region_num1}{region_num2})));
            end
        end
        p_value(region_num1,region_num2) = sum(mean(sampled_corr_control{region_num1}{region_num2},2) < mean(sampled_corr_APP{region_num1}{region_num2},2))/1000;
    end
end

% Make it symmetrical.
for region_num = 1:7
    p_value(region_num,(region_num + 1):8) = nan;
end
p_value = p_value(~isnan(p_value));

% False discovery rate.
[val,idx] = sort(p_value);
adjusted_p_value_005 = ((1:numel(p_value))*0.05)/numel(p_value);
adjusted_p_value_001 = ((1:numel(p_value))*0.01)/numel(p_value);
adjusted_p_value_0001 = ((1:numel(p_value))*0.001)/numel(p_value);
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

p_value_matrix = zeros(8,8);
p_value_matrix(1:8,1) = vector(1:8);
p_value_matrix(2:8,2) = vector(9:15);
p_value_matrix(3:8,3) = vector(16:21);
p_value_matrix(4:8,4) = vector(22:26);
p_value_matrix(5:8,5) = vector(27:30);
p_value_matrix(6:8,6) = vector(31:33);
p_value_matrix(7:8,7) = vector(34:35);
p_value_matrix(8,8) = vector(36);
p_value_matrix(1,1:8) = vector(1:8);
p_value_matrix(2,2:8) = vector(9:15);
p_value_matrix(3,3:8) = vector(16:21);
p_value_matrix(4,4:8) = vector(22:26);
p_value_matrix(5,5:8) = vector(27:30);
p_value_matrix(6,6:8) = vector(31:33);
p_value_matrix(7,7:8) = vector(34:35);
p_value_matrix(8,8) = vector(36);

% Plot.
figure('Position',[200,200,200,200],'Color','w')
imagesc(p_value_matrix,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

end