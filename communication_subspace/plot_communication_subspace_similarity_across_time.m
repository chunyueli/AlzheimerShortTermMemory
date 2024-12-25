function plot_communication_subspace_similarity_across_time

close all
clear all
clc

% Plot communication subspace similarity across time during delay.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

q = 3;

% Control.
load('behavior_control.mat')
behavior = behavior_control;

load('population_regression_control.mat')
switch q
    case 2
        Q = population_regression_control.similarity_across_time.q2.Q;
    case 3
        Q = population_regression_control.similarity_across_time.q3.Q;
    case 4
        Q = population_regression_control.similarity_across_time.q4.Q;
end
clearvars -except q behavior Q

% Compute similarity of subspaces.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for source = 1:8
            for target = 1:8
                for time_point1 = 1:7
                    for time_point2 = 1:7
                        for shuffle_num = 1:20
                            if ~isempty(Q{animal_num}{session_num}{source}{target}{time_point1}) && ~isempty(Q{animal_num}{session_num}{source}{target}{time_point2})
                                similarity_over_time{animal_num}{session_num}{source}{target}{time_point1}{time_point2}(shuffle_num) = cos(subspace(squeeze(Q{animal_num}{session_num}{source}{target}{time_point1}(shuffle_num,:,1:q)),squeeze(Q{animal_num}{session_num}{source}{target}{time_point2}(shuffle_num,:,1:q))));
                            else
                                similarity_over_time{animal_num}{session_num}{source}{target}{time_point1}{time_point2}(shuffle_num) = nan;
                            end
                        end

                        mean_similarity_over_time{animal_num}{session_num}{time_point1}{time_point2}(source,target) = nanmean(similarity_over_time{animal_num}{session_num}{source}{target}{time_point1}{time_point2});
                    end
                end
            end
        end
    end
end

% Concatenate across sessions and animals.
for time_point1 = 1:7
    for time_point2 = 1:7
        % Initialize.
        mean_similarity_over_time_animal_session{time_point1}{time_point2} = [];
        for animal_num = 1:numel(behavior)

            % Initialize.
            mean_similarity_over_time_session{time_point1}{time_point2} = [];
            for session_num = 1:numel(behavior{animal_num})
                mean_similarity_over_time_session{time_point1}{time_point2} = cat(3,mean_similarity_over_time_session{time_point1}{time_point2},mean_similarity_over_time{animal_num}{session_num}{time_point1}{time_point2});
            end

            mean_similarity_over_time_animal_session{time_point1}{time_point2} = cat(3,mean_similarity_over_time_animal_session{time_point1}{time_point2},mean_similarity_over_time_session{time_point1}{time_point2});
        end
    end
end

% Plot.
for time_point1 = 1:7
    for time_point2 = 1:7
        fig = figure('Position',[100*(time_point2),1400 - 175*(time_point1),100,100],'Color','w');
        set(gcf,'renderer','Painters')
        switch q
            case 2
                imagesc(nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3),[0.2,0.36])
            case 3
                imagesc(nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3),[0.16,0.24])
            case 4
                imagesc(nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3),[0.14,0.2])
        end
        colormap('viridis')
        axis square
        axis off
        %print(fig,['Subspace_similarity_between_time',num2str(time_point1),'_time',num2str(time_point2),'_q',num2str(q),'_control'],'-dsvg','-r0','-painters')
    end
end

if q == 3
    clear temp mean_mean_mean_similarity_over_time_animal_session
    for time_point1 = 1:7
        for time_point2 = 1:7
            temp{time_point1}{time_point2} = nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3);
            mean_mean_mean_similarity_over_time_animal_session(time_point1,time_point2) = mean(temp{time_point1}{time_point2}(:));
        end
    end

    figure('Position',[100,1225,100,100],'Color','w');
    imagesc(mean_mean_mean_similarity_over_time_animal_session,[0.19,0.24])
    colormap('viridis')
    axis square
    axis off
end

for time_point1 = 1:7
    mean_similarity_over_time_control{time_point1} = [];
    for time_point2 = 1:7
        mean_similarity_over_time_control{time_point1} = [mean_similarity_over_time_control{time_point1},reshape(nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3),[64,1])];
    end
end

mean_similarity_over_time_animal_session_control = mean_similarity_over_time_animal_session;

clearvars -except q mean_similarity_over_time_animal_session_control mean_similarity_over_time_control

% APP.
load('behavior_APP.mat')
behavior = behavior_APP;

load('population_regression_APP.mat')
switch q
    case 2
        Q = population_regression_APP.similarity_across_time.q2.Q;
    case 3
        Q = population_regression_APP.similarity_across_time.q3.Q;
    case 4
        Q = population_regression_APP.similarity_across_time.q4.Q;
end
clearvars -except q mean_similarity_over_time_animal_session_control mean_similarity_over_time_control behavior Q

% Compute similarity of subspaces.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for source = 1:8
            for target = 1:8
                for time_point1 = 1:7
                    for time_point2 = 1:7
                        for shuffle_num = 1:20
                            if ~isempty(Q{animal_num}{session_num}{source}{target}{time_point1}) && ~isempty(Q{animal_num}{session_num}{source}{target}{time_point2})
                                similarity_over_time{animal_num}{session_num}{source}{target}{time_point1}{time_point2}(shuffle_num) = cos(subspace(squeeze(Q{animal_num}{session_num}{source}{target}{time_point1}(shuffle_num,:,1:q)),squeeze(Q{animal_num}{session_num}{source}{target}{time_point2}(shuffle_num,:,1:q))));
                            else
                                similarity_over_time{animal_num}{session_num}{source}{target}{time_point1}{time_point2}(shuffle_num) = nan;
                            end
                        end

                        mean_similarity_over_time{animal_num}{session_num}{time_point1}{time_point2}(source,target) = nanmean(similarity_over_time{animal_num}{session_num}{source}{target}{time_point1}{time_point2});
                    end
                end
            end
        end
    end
end

% Concatenate across sessions and animals.
for time_point1 = 1:7
    for time_point2 = 1:7
        % Initialize.
        mean_similarity_over_time_animal_session{time_point1}{time_point2} = [];
        for animal_num = 1:numel(behavior)

            % Initialize.
            mean_similarity_over_time_session{time_point1}{time_point2} = [];
            for session_num = 1:numel(behavior{animal_num})
                mean_similarity_over_time_session{time_point1}{time_point2} = cat(3,mean_similarity_over_time_session{time_point1}{time_point2},mean_similarity_over_time{animal_num}{session_num}{time_point1}{time_point2});
            end

            mean_similarity_over_time_animal_session{time_point1}{time_point2} = cat(3,mean_similarity_over_time_animal_session{time_point1}{time_point2},mean_similarity_over_time_session{time_point1}{time_point2});
        end
    end
end

% Plot.
for time_point1 = 1:7
    for time_point2 = 1:7
        fig = figure('Position',[100*(time_point2) + 800,1400 - 175*(time_point1),100,100],'Color','w');
        set(gcf,'renderer','Painters')
        switch q
            case 2
                imagesc(nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3),[0.2,0.36])
            case 3
                imagesc(nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3),[0.16,0.24])
            case 4
                imagesc(nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3),[0.14,0.2])
        end
        colormap('viridis')
        axis square
        axis off
        %print(fig,['Subspace_similarity_between_time',num2str(time_point1),'_time',num2str(time_point2),'_q',num2str(q),'_APP'],'-dsvg','-r0','-painters')
    end
end

if q == 3
    clear temp mean_mean_mean_similarity_over_time_animal_session
    for time_point1 = 1:7
        for time_point2 = 1:7
            temp{time_point1}{time_point2} = nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3);
            mean_mean_mean_similarity_over_time_animal_session(time_point1,time_point2) = mean(temp{time_point1}{time_point2}(:));
        end
    end

    figure('Position',[900,1225,100,100],'Color','w');
    imagesc(mean_mean_mean_similarity_over_time_animal_session,[0.19,0.24])
    colormap('viridis')
    axis square
    axis off
end

for time_point1 = 1:7
    mean_similarity_over_time_APP{time_point1} = [];
    for time_point2 = 1:7
        mean_similarity_over_time_APP{time_point1} = [mean_similarity_over_time_APP{time_point1},reshape(nanmean(mean_similarity_over_time_animal_session{time_point1}{time_point2},3),[64,1])];
    end
end

mean_similarity_over_time_animal_session_APP = mean_similarity_over_time_animal_session;

clearvars -except q mean_similarity_over_time_animal_session_control mean_similarity_over_time_control mean_similarity_over_time_animal_session_APP mean_similarity_over_time_APP

% Plot.
reference_all = 4;
for reference_num = 1:numel(reference_all)

    clearvars -except q mean_similarity_over_time_animal_session_control mean_similarity_over_time_control mean_similarity_over_time_animal_session_APP mean_similarity_over_time_APP reference_all reference_num
    reference = reference_all(reference_num);

    for time_point = 1:7
        for region_num1 = 1:8
            for region_num2 = 1:8
                similarity_control_region{time_point}{region_num1}{region_num2} = squeeze(mean_similarity_over_time_animal_session_control{reference}{time_point}(region_num1,region_num2,:));
                similarity_APP_region{time_point}{region_num1}{region_num2} = squeeze(mean_similarity_over_time_animal_session_APP{reference}{time_point}(region_num1,region_num2,:));
                mean_similarity_control_region{region_num1}{region_num2}(time_point) = nanmean(similarity_control_region{time_point}{region_num1}{region_num2});
                mean_similarity_APP_region{region_num1}{region_num2}(time_point) = nanmean(similarity_APP_region{time_point}{region_num1}{region_num2});
                mean_similarity_control_region{region_num1}{region_num2}(reference) = nan;
                mean_similarity_APP_region{region_num1}{region_num2}(reference) = nan;
                se_similarity_control_region{region_num1}{region_num2}(time_point) = nanstd(similarity_control_region{time_point}{region_num1}{region_num2})/(sum(~isnan(similarity_control_region{time_point}{region_num1}{region_num2}))^0.5);
                se_similarity_APP_region{region_num1}{region_num2}(time_point) = nanstd(similarity_APP_region{time_point}{region_num1}{region_num2})/(sum(~isnan(similarity_APP_region{time_point}{region_num1}{region_num2}))^0.5);
                se_similarity_control_region{region_num1}{region_num2}(reference) = nan;
                se_similarity_APP_region{region_num1}{region_num2}(reference) = nan;
            end
        end
    end

    % Control.
    for source = 1:8
        fig = figure('Position',[100 + (source - 1)*150,900 - (reference_num - 1)*200,150,100],'Color','w');
        set(gcf,'renderer','Painters')
        hold on
        for target = 1:8
            if source == target % Intra.
                plot(mean_similarity_control_region{source}{target},'Color',[0.25,0.25,0.25],'LineWidth',0.5)
                for time_point = 1:7
                    line([time_point,time_point],[mean_similarity_control_region{source}{target}(time_point) - se_similarity_control_region{source}{target}(time_point),mean_similarity_control_region{source}{target}(time_point) + se_similarity_control_region{source}{target}(time_point)],'Color',[0.25,0.25,0.25],'LineWidth',0.5)
                end
            end
        end
        xlabel('Time');
        ylabel('Subspace similarity');
        xlim([0.5,7.5])
        switch q
            case 2
                ylim([0.1,0.7])
            case 3
                ylim([0.1,0.5])
            case 4
                ylim([0.1,0.35])
        end
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,4.5,7];
        switch q
            case 2
                ax.YTick = [0.1,0.3,0.5,0.7];
            case 3
                ax.YTick = [0.1,0.2,0.3,0.4,0.5];
            case 4
                ax.YTick = [0.1,0.2,0.3];
        end
        ax.XTickLabel = {'ITI','Stimulus','Delay','Action'};
        switch q
            case 2
                ax.YTickLabel = {'0.1','0.3','0.5','0.7'};
            case 3
                ax.YTickLabel = {'0.1','0.2','0.3','0.4','0.5'};
            case 4
                ax.YTickLabel = {'0.1','0.2','0.3'};
        end
        %print(fig,['Subspace_similarity_reference',num2str(reference),'_source',num2str(source),'_q',num2str(q),'_intra_control'],'-dsvg','-r0','-painters')

        fig = figure('Position',[100 + (source - 1)*150,700 - (reference_num - 1)*200,150,100],'Color','w');
        set(gcf,'renderer','Painters')
        hold on
        for target = 1:8
            if source ~= target % Inter.
                plot(mean_similarity_control_region{source}{target},'Color',[0.25,0.25,0.25],'LineWidth',0.5)
                for time_point = 1:7
                    line([time_point,time_point],[mean_similarity_control_region{source}{target}(time_point) - se_similarity_control_region{source}{target}(time_point),mean_similarity_control_region{source}{target}(time_point) + se_similarity_control_region{source}{target}(time_point)],'Color',[0.25,0.25,0.25],'LineWidth',0.5)
                end
            end
        end
        xlabel('Time');
        ylabel('Subspace similarity');
        xlim([0.5,7.5])
        switch q
            case 2
                ylim([0.1,0.5])
            case 3
                ylim([0.1,0.3])
            case 4
                ylim([0.1,0.25])
        end
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,4.5,7];
        switch q
            case 2
                ax.YTick = [0.1,0.3,0.5];
            case 3
                ax.YTick = [0.1,0.2,0.3];
            case 4
                ax.YTick = [0.1,0.2];
        end
        ax.XTickLabel = {'ITI','Stimulus','Delay','Action'};
        switch q
            case 2
                ax.YTickLabel = {'0.1','0.3','0.5'};
            case 3
                ax.YTickLabel = {'0.1','0.2','0.3'};
            case 4
                ax.YTickLabel = {'0.1','0.2'};
        end
        %print(fig,['Subspace_similarity_reference',num2str(reference),'_source',num2str(source),'_q',num2str(q),'_inter_control'],'-dsvg','-r0','-painters')
    end

    % APP.
    for source = 1:8
        fig = figure('Position',[100 + (source - 1)*150,500 - (reference_num - 1)*200,150,100],'Color','w');
        set(gcf,'renderer','Painters')
        hold on
        for target = 1:8
            if source == target % Intra.
                plot(mean_similarity_APP_region{source}{target},'Color',[0.25,0.25,0.25],'LineWidth',0.5)
                for time_point = 1:7
                    line([time_point,time_point],[mean_similarity_APP_region{source}{target}(time_point) - se_similarity_APP_region{source}{target}(time_point),mean_similarity_APP_region{source}{target}(time_point) + se_similarity_APP_region{source}{target}(time_point)],'Color',[0.25,0.25,0.25],'LineWidth',0.5)
                end
            end
        end
        xlabel('Time');
        ylabel('Subspace similarity');
        xlim([0.5,7.5])
        switch q
            case 2
                ylim([0.1,0.7])
            case 3
                ylim([0.1,0.5])
            case 4
                ylim([0.1,0.35])
        end
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,4.5,7];
        switch q
            case 2
                ax.YTick = [0.1,0.3,0.5,0.7];
            case 3
                ax.YTick = [0.1,0.2,0.3,0.4,0.5];
            case 4
                ax.YTick = [0.1,0.2,0.3];
        end
        ax.XTickLabel = {'ITI','Stimulus','Delay','Action'};
        switch q
            case 2
                ax.YTickLabel = {'0.1','0.3','0.5','0.7'};
            case 3
                ax.YTickLabel = {'0.1','0.2','0.3','0.4','0.5'};
            case 4
                ax.YTickLabel = {'0.1','0.2','0.3'};
        end
        %print(fig,['Subspace_similarity_reference',num2str(reference),'_source',num2str(source),'_q',num2str(q),'_intra_APP'],'-dsvg','-r0','-painters')

        fig = figure('Position',[100 + (source - 1)*150,300 - (reference_num - 1)*200,150,100],'Color','w');
        set(gcf,'renderer','Painters')
        hold on
        for target = 1:8
            if source ~= target % Inter.
                plot(mean_similarity_APP_region{source}{target},'Color',[0.25,0.25,0.25],'LineWidth',0.5)
                for time_point = 1:7
                    line([time_point,time_point],[mean_similarity_APP_region{source}{target}(time_point) - se_similarity_APP_region{source}{target}(time_point),mean_similarity_APP_region{source}{target}(time_point) + se_similarity_APP_region{source}{target}(time_point)],'Color',[0.25,0.25,0.25],'LineWidth',0.5)
                end
            end
        end
        xlabel('Time');
        ylabel('Subspace similarity');
        xlim([0.5,7.5])
        switch q
            case 2
                ylim([0.1,0.5])
            case 3
                ylim([0.1,0.3])
            case 4
                ylim([0.1,0.25])
        end
        ax = gca;
        ax.FontSize = 14;
        ax.XTick = [1,2,4.5,7];
        switch q
            case 2
                ax.YTick = [0.1,0.3,0.5];
            case 3
                ax.YTick = [0.1,0.2,0.3];
            case 4
                ax.YTick = [0.1,0.2];
        end
        ax.XTickLabel = {'ITI','Stimulus','Delay','Action'};
        switch q
            case 2
                ax.YTickLabel = {'0.1','0.3','0.5'};
            case 3
                ax.YTickLabel = {'0.1','0.2','0.3'};
            case 4
                ax.YTickLabel = {'0.1','0.2'};
        end
        %print(fig,['Subspace_similarity_reference',num2str(reference),'_source',num2str(source),'_q',num2str(q),'_inter_APP'],'-dsvg','-r0','-painters')
    end
end

% Four-way ANOVA.
reference = 4;
data_control = [];
group_time_point_control = [];
group_intra_inter_control = [];
group_source_control = [];
for time_point = 1:7
    for source = 1:8
        clear temp
        if time_point == reference
            temp = [];
        else
            temp = squeeze(mean_similarity_over_time_animal_session_control{reference}{time_point}(source,:,:));
        end
        data_control = [data_control,temp(~isnan(temp))'];
        switch time_point
            case 1
                if reference ~= time_point
                    group_time_point_control = [group_time_point_control,repmat({'time_point1'},1,numel(temp(~isnan(temp))))];
                end
            case 2
                if reference ~= time_point
                    group_time_point_control = [group_time_point_control,repmat({'time_point2'},1,numel(temp(~isnan(temp))))];
                end
            case 3
                if reference ~= time_point
                    group_time_point_control = [group_time_point_control,repmat({'time_point3'},1,numel(temp(~isnan(temp))))];
                end
            case 4
                if reference ~= time_point
                    group_time_point_control = [group_time_point_control,repmat({'time_point4'},1,numel(temp(~isnan(temp))))];
                end
            case 5
                if reference ~= time_point
                    group_time_point_control = [group_time_point_control,repmat({'time_point5'},1,numel(temp(~isnan(temp))))];
                end
            case 6
                if reference ~= time_point
                    group_time_point_control = [group_time_point_control,repmat({'time_point6'},1,numel(temp(~isnan(temp))))];
                end
            case 7
                if reference ~= time_point
                    group_time_point_control = [group_time_point_control,repmat({'time_point7'},1,numel(temp(~isnan(temp))))];
                end
        end
        clear all_idx intra_idx inter_idx
        all_idx = [1:size(mean_similarity_over_time_animal_session_control{reference}{time_point},3)*8];
        intra_idx = [source:8:size(mean_similarity_over_time_animal_session_control{reference}{time_point},3)*8];
        inter_idx = all_idx(~ismember(all_idx,intra_idx));
        for idx_num = 1:numel(intra_idx)
            group_intra_inter_control_temp{intra_idx(idx_num)} = 'intra';
        end
        for idx_num = 1:numel(inter_idx)
            group_intra_inter_control_temp{inter_idx(idx_num)} = 'inter';
        end
        group_intra_inter_control = [group_intra_inter_control,group_intra_inter_control_temp(~isnan(temp(:)))];
        switch source
            case 1
                group_source_control = [group_source_control,repmat({'ALM'},1,sum(~isnan(temp(:))))];
            case 2
                group_source_control = [group_source_control,repmat({'M1a'},1,sum(~isnan(temp(:))))];
            case 3
                group_source_control = [group_source_control,repmat({'M1p'},1,sum(~isnan(temp(:))))];
            case 4
                group_source_control = [group_source_control,repmat({'M2'},1,sum(~isnan(temp(:))))];
            case 5
                group_source_control = [group_source_control,repmat({'S1fl'},1,sum(~isnan(temp(:))))];
            case 6
                group_source_control = [group_source_control,repmat({'vS1'},1,sum(~isnan(temp(:))))];
            case 7
                group_source_control = [group_source_control,repmat({'RSC'},1,sum(~isnan(temp(:))))];
            case 8
                group_source_control = [group_source_control,repmat({'PPC'},1,sum(~isnan(temp(:))))];
        end
    end
end

data_APP = [];
group_time_point_APP = [];
group_intra_inter_APP = [];
group_source_APP = [];
for time_point = 1:7
    for source = 1:8
        clear temp
        if time_point == reference
            temp = [];
        else
            temp = squeeze(mean_similarity_over_time_animal_session_APP{reference}{time_point}(source,:,:));
        end
        data_APP = [data_APP,temp(~isnan(temp))'];
        switch time_point
            case 1
                if reference ~= time_point
                    group_time_point_APP = [group_time_point_APP,repmat({'time_point1'},1,numel(temp(~isnan(temp))))];
                end
            case 2
                if reference ~= time_point
                    group_time_point_APP = [group_time_point_APP,repmat({'time_point2'},1,numel(temp(~isnan(temp))))];
                end
            case 3
                if reference ~= time_point
                    group_time_point_APP = [group_time_point_APP,repmat({'time_point3'},1,numel(temp(~isnan(temp))))];
                end
            case 4
                if reference ~= time_point
                    group_time_point_APP = [group_time_point_APP,repmat({'time_point4'},1,numel(temp(~isnan(temp))))];
                end
            case 5
                if reference ~= time_point
                    group_time_point_APP = [group_time_point_APP,repmat({'time_point5'},1,numel(temp(~isnan(temp))))];
                end
            case 6
                if reference ~= time_point
                    group_time_point_APP = [group_time_point_APP,repmat({'time_point6'},1,numel(temp(~isnan(temp))))];
                end
            case 7
                if reference ~= time_point
                    group_time_point_APP = [group_time_point_APP,repmat({'time_point7'},1,numel(temp(~isnan(temp))))];
                end
        end
        clear all_idx intra_idx inter_idx
        all_idx = [1:size(mean_similarity_over_time_animal_session_APP{reference}{time_point},3)*8];
        intra_idx = [source:8:size(mean_similarity_over_time_animal_session_APP{reference}{time_point},3)*8];
        inter_idx = all_idx(~ismember(all_idx,intra_idx));
        for idx_num = 1:numel(intra_idx)
            group_intra_inter_APP_temp{intra_idx(idx_num)} = 'intra';
        end
        for idx_num = 1:numel(inter_idx)
            group_intra_inter_APP_temp{inter_idx(idx_num)} = 'inter';
        end
        group_intra_inter_APP = [group_intra_inter_APP,group_intra_inter_APP_temp(~isnan(temp(:)))];
        switch source
            case 1
                group_source_APP = [group_source_APP,repmat({'ALM'},1,sum(~isnan(temp(:))))];
            case 2
                group_source_APP = [group_source_APP,repmat({'M1a'},1,sum(~isnan(temp(:))))];
            case 3
                group_source_APP = [group_source_APP,repmat({'M1p'},1,sum(~isnan(temp(:))))];
            case 4
                group_source_APP = [group_source_APP,repmat({'M2'},1,sum(~isnan(temp(:))))];
            case 5
                group_source_APP = [group_source_APP,repmat({'S1fl'},1,sum(~isnan(temp(:))))];
            case 6
                group_source_APP = [group_source_APP,repmat({'vS1'},1,sum(~isnan(temp(:))))];
            case 7
                group_source_APP = [group_source_APP,repmat({'RSC'},1,sum(~isnan(temp(:))))];
            case 8
                group_source_APP = [group_source_APP,repmat({'PPC'},1,sum(~isnan(temp(:))))];
        end
    end
end

data_all = [data_control,data_APP];
group_genotype_all = [repmat({'control'},1,numel(data_control)),repmat({'APP'},1,numel(data_APP))];
group_time_point_all = [group_time_point_control,group_time_point_APP];
group_intra_inter_all = [group_intra_inter_control,group_intra_inter_APP];
group_source_all = [group_source_control,group_source_APP];
[p,tbl,stats,terms] = anovan(data_all,{group_genotype_all,group_time_point_all,group_intra_inter_all,group_source_all},"Model","interaction","Varnames",["genotype","time_point","intra_inter","source"]);
figure('Position',[1700,800,300,200],'Color','w')
[results,~,~,~] = multcompare(stats,"Dimension",[1,2,3,4]);

end