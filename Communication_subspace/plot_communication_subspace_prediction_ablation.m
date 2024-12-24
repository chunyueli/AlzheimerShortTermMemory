function plot_communication_subspace_prediction_ablation

close all
clear all
clc

% Plot prediction performance by reduced-rank regression after ablation.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Ablation dimensionality.
ablated_dim_num = 2; % 1, 2 or 3.

load('population_regression_control')
y_control = population_regression_control.ablation.y;
clearvars -except ablated_dim_num y_control

load('population_regression_APP')
y_APP = population_regression_APP.ablation.y;
clearvars -except ablated_dim_num y_control y_APP

% Control.
for animal_num = 1:numel(y_control)
    for session_num = 1:numel(y_control{animal_num})
        for dimension_num = 1:4
            for source = 1:8
                for target = 1:8
                    for predicted = 1:8
                        mean_y_control{animal_num}{session_num}{dimension_num}{source}{target}{predicted} = mean(y_control{animal_num}{session_num}{dimension_num}{source}{target}{predicted});
                        full_rank_mean_y_control{animal_num}{session_num}(dimension_num,source,target,predicted) = mean_y_control{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(end);
                    end
                end
            end
        end
    end
end

% Initialize.
for source = 1:8
    for target = 1:8
        for predicted = 1:8
            pred_change_control_animal_session{source}{target}{predicted} = [];
        end
    end
end
for animal_num = 1:numel(y_control)

    % Initialize.
    for source = 1:8
        for target = 1:8
            for predicted = 1:8
                pred_change_control_session{source}{target}{predicted} = [];
            end
        end
    end

    for session_num = 1:numel(y_control{animal_num})
        for source = 1:8
            for target = 1:8
                for predicted = 1:8
                    for dimension_num = 1:4
                        pred_change_control{animal_num}{session_num}{source}{target}{predicted}(dimension_num,:) = full_rank_mean_y_control{animal_num}{session_num}(dimension_num,source,target,predicted)./full_rank_mean_y_control{animal_num}{session_num}(1,source,target,predicted);
                    end
                end
            end
        end

        for source = 1:8
            for target = 1:8
                for predicted = 1:8
                    pred_change_control_session{source}{target}{predicted} = [pred_change_control_session{source}{target}{predicted},pred_change_control{animal_num}{session_num}{source}{target}{predicted}];
                end
            end
        end
    end

    for source = 1:8
        for target = 1:8
            for predicted = 1:8
                pred_change_control_animal_session{source}{target}{predicted} = [pred_change_control_animal_session{source}{target}{predicted},pred_change_control_session{source}{target}{predicted}];
            end
        end
    end
end

% APP.
for animal_num = 1:numel(y_APP)
    for session_num = 1:numel(y_APP{animal_num})
        for dimension_num = 1:4
            for source = 1:8
                for target = 1:8
                    for predicted = 1:8
                        mean_y_APP{animal_num}{session_num}{dimension_num}{source}{target}{predicted} = mean(y_APP{animal_num}{session_num}{dimension_num}{source}{target}{predicted});
                        full_rank_mean_y_APP{animal_num}{session_num}(dimension_num,source,target,predicted) = mean_y_APP{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(end);
                    end
                end
            end
        end
    end
end

% Initialize.
for source = 1:8
    for target = 1:8
        for predicted = 1:8
            pred_change_APP_animal_session{source}{target}{predicted} = [];
        end
    end
end
for animal_num = 1:numel(y_APP)

    % Initialize.
    for source = 1:8
        for target = 1:8
            for predicted = 1:8
                pred_change_APP_session{source}{target}{predicted} = [];
            end
        end
    end

    for session_num = 1:numel(y_APP{animal_num})
        for source = 1:8
            for target = 1:8
                for predicted = 1:8
                    for dimension_num = 1:4
                        pred_change_APP{animal_num}{session_num}{source}{target}{predicted}(dimension_num,:) = full_rank_mean_y_APP{animal_num}{session_num}(dimension_num,source,target,predicted)./full_rank_mean_y_APP{animal_num}{session_num}(1,source,target,predicted);
                    end
                end
            end
        end

        for source = 1:8
            for target = 1:8
                for predicted = 1:8
                    pred_change_APP_session{source}{target}{predicted} = [pred_change_APP_session{source}{target}{predicted},pred_change_APP{animal_num}{session_num}{source}{target}{predicted}];
                end
            end
        end
    end

    for source = 1:8
        for target = 1:8
            for predicted = 1:8
                pred_change_APP_animal_session{source}{target}{predicted} = [pred_change_APP_animal_session{source}{target}{predicted},pred_change_APP_session{source}{target}{predicted}];
            end
        end
    end
end

% Plot.
if ablated_dim_num == 2
    % Control.
    mean_PPC_ALM_ALM_control = nanmean(pred_change_control_animal_session{8}{1}{1},2);
    se_PPC_ALM_ALM_control = nanstd(pred_change_control_animal_session{8}{1}{1},[],2)./(sum(~isnan(pred_change_control_animal_session{8}{1}{1}(1,:)))^0.5);
    mean_PPC_ALM_PPC_control = nanmean(pred_change_control_animal_session{8}{1}{8},2);
    se_PPC_ALM_PPC_control = nanstd(pred_change_control_animal_session{8}{1}{8},[],2)./(sum(~isnan(pred_change_control_animal_session{8}{1}{8}(1,:)))^0.5);
    mean_PPC_ALM_M2_control = nanmean(pred_change_control_animal_session{8}{1}{4},2);
    se_PPC_ALM_M2_control = nanstd(pred_change_control_animal_session{8}{1}{4},[],2)./(sum(~isnan(pred_change_control_animal_session{8}{1}{4}(1,:)))^0.5);

    figure('Position',[100,800,125,100],'Color','w')
    hold on
    plot(mean_PPC_ALM_ALM_control,'-','Color',[0.64,0.08,0.18],'LineWidth',1)
    for dimension_num = 1:4
        line([dimension_num,dimension_num],[mean_PPC_ALM_ALM_control(dimension_num) - se_PPC_ALM_ALM_control(dimension_num),mean_PPC_ALM_ALM_control(dimension_num) + se_PPC_ALM_ALM_control(dimension_num)],'LineWidth',1,'Color',[0.64,0.08,0.18])
    end
    plot(mean_PPC_ALM_PPC_control,'-','Color',[0.00,0.45,0.74],'LineWidth',1)
    for dimension_num = 1:4
        line([dimension_num,dimension_num],[mean_PPC_ALM_PPC_control(dimension_num) - se_PPC_ALM_PPC_control(dimension_num),mean_PPC_ALM_PPC_control(dimension_num) + se_PPC_ALM_PPC_control(dimension_num)],'LineWidth',1,'Color',[0.00,0.45,0.74])
    end
    plot(mean_PPC_ALM_M2_control,'-','Color',[0.25,0.25,0.25],'LineWidth',1)
    for dimension_num = 1:4
        line([dimension_num,dimension_num],[mean_PPC_ALM_M2_control(dimension_num) - se_PPC_ALM_M2_control(dimension_num),mean_PPC_ALM_M2_control(dimension_num) + se_PPC_ALM_M2_control(dimension_num)],'LineWidth',1,'Color',[0.25,0.25,0.25])
    end
    xlabel('Number of predictive dimensions removed');
    ylabel('Normalized performance');
    xlim([0.5,4.5])
    ylim([-0.2,1.1])
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [1,2,3,4];
    ax.YTick = [0,0.5,1];
    ax.XTickLabel = {'0','1','2','3'};
    ax.YTickLabel = {'0','0.5','1'};

    % APP.
    mean_PPC_ALM_ALM_APP = nanmean(pred_change_APP_animal_session{8}{1}{1},2);
    se_PPC_ALM_ALM_APP = nanstd(pred_change_APP_animal_session{8}{1}{1},[],2)./(sum(~isnan(pred_change_APP_animal_session{8}{1}{1}(1,:)))^0.5);
    mean_PPC_ALM_PPC_APP = nanmean(pred_change_APP_animal_session{8}{1}{8},2);
    se_PPC_ALM_PPC_APP = nanstd(pred_change_APP_animal_session{8}{1}{8},[],2)./(sum(~isnan(pred_change_APP_animal_session{8}{1}{8}(1,:)))^0.5);
    mean_PPC_ALM_M2_APP = nanmean(pred_change_APP_animal_session{8}{1}{4},2);
    se_PPC_ALM_M2_APP = nanstd(pred_change_APP_animal_session{8}{1}{4},[],2)./(sum(~isnan(pred_change_APP_animal_session{8}{1}{4}(1,:)))^0.5);

    figure('Position',[225,800,125,100],'Color','w')
    hold on
    plot(mean_PPC_ALM_ALM_APP,'-','Color',[0.64,0.08,0.18],'LineWidth',1)
    for dimension_num = 1:4
        line([dimension_num,dimension_num],[mean_PPC_ALM_ALM_APP(dimension_num) - se_PPC_ALM_ALM_APP(dimension_num),mean_PPC_ALM_ALM_APP(dimension_num) + se_PPC_ALM_ALM_APP(dimension_num)],'LineWidth',1,'Color',[0.64,0.08,0.18])
    end
    plot(mean_PPC_ALM_PPC_APP,'-','Color',[0.00,0.45,0.74],'LineWidth',1)
    for dimension_num = 1:4
        line([dimension_num,dimension_num],[mean_PPC_ALM_PPC_APP(dimension_num) - se_PPC_ALM_PPC_APP(dimension_num),mean_PPC_ALM_PPC_APP(dimension_num) + se_PPC_ALM_PPC_APP(dimension_num)],'LineWidth',1,'Color',[0.00,0.45,0.74])
    end
    plot(mean_PPC_ALM_M2_APP,'-','Color',[0.25,0.25,0.25],'LineWidth',1)
    for dimension_num = 1:4
        line([dimension_num,dimension_num],[mean_PPC_ALM_M2_APP(dimension_num) - se_PPC_ALM_M2_APP(dimension_num),mean_PPC_ALM_M2_APP(dimension_num) + se_PPC_ALM_M2_APP(dimension_num)],'LineWidth',1,'Color',[0.25,0.25,0.25])
    end
    xlabel('Number of predictive dimensions removed');
    ylabel('Normalized performance');
    xlim([0.5,4.5])
    ylim([-0.2,1.1])
    ax = gca;
    ax.FontSize = 14;
    ax.XTick = [1,2,3,4];
    ax.YTick = [0,0.5,1];
    ax.XTickLabel = {'0','1','2','3'};
    ax.YTickLabel = {'0','0.5','1'};
end

for dimension_num = 1:4
    for source = 1:8
        for target = 1:8
            for predicted = 1:8
                mean_pred_change_control{dimension_num}(source,target,predicted) = nanmean(pred_change_control_animal_session{source}{target}{predicted}(dimension_num,:));
                mean_pred_change_APP{dimension_num}(source,target,predicted) = nanmean(pred_change_APP_animal_session{source}{target}{predicted}(dimension_num,:));
            end
        end
    end
end

for source = 1:8
    figure('Position',[100*source,600,100,100],'Color','w')
    imagesc(squeeze(mean_pred_change_control{ablated_dim_num + 1}(source,:,:)),[0,0.5]);
    colormap('magma')
    axis square
    axis off

    figure('Position',[100*source,400,100,100],'Color','w')
    imagesc(squeeze(mean_pred_change_APP{ablated_dim_num + 1}(source,:,:)),[0,0.5]);
    colormap('magma')
    axis square
    axis off
end

% Four-way ANOVA.
for source = 1:8
    for target = 1:8
        for predicted = 1:8
            pred_change_control_animal_session_concat{source}(target,predicted,:) = pred_change_control_animal_session{source}{target}{predicted}(ablated_dim_num + 1,:);
            pred_change_APP_animal_session_concat{source}(target,predicted,:) = pred_change_APP_animal_session{source}{target}{predicted}(ablated_dim_num + 1,:);
        end
    end
end
data_control = [];
group_source_same_as_target_control = [];
group_target_same_as_predicted_control = [];
group_source_same_as_predicted_control = [];
for source = 1:8
    for target = 1:8
        clear temp
        temp = squeeze(pred_change_control_animal_session_concat{source}(target,:,:));
        data_control = [data_control,temp(~isnan(temp))'];

        if source == target
            group_source_same_as_target_control = [group_source_same_as_target_control,repmat({'source_same_as_target'},numel(temp(~isnan(temp))),1)'];
        else
            group_source_same_as_target_control = [group_source_same_as_target_control,repmat({'source_not_same_as_target'},numel(temp(~isnan(temp))),1)'];
        end

        all_idx = [1:size(pred_change_control_animal_session_concat{source}(target,:,:),3)*8];
        target_same_as_predicted_idx = [target:8:size(pred_change_control_animal_session_concat{source}(target,:,:),3)*8];
        target_not_same_as_predicted_idx = all_idx(~ismember(all_idx,target_same_as_predicted_idx));
        for idx_num = 1:numel(target_same_as_predicted_idx)
            group_target_same_as_predicted_control_temp{target_same_as_predicted_idx(idx_num)} = 'target_same_as_predicted';
        end
        for idx_num = 1:numel(target_not_same_as_predicted_idx)
            group_target_same_as_predicted_control_temp{target_not_same_as_predicted_idx(idx_num)} = 'target_not_same_as_predicted';
        end
        group_target_same_as_predicted_control = [group_target_same_as_predicted_control,group_target_same_as_predicted_control_temp(~isnan(temp(:)))];

        source_same_as_predicted_idx = [source:8:size(pred_change_control_animal_session_concat{source}(target,:,:),3)*8];
        source_not_same_as_predicted_idx = all_idx(~ismember(all_idx,source_same_as_predicted_idx));
        for idx_num = 1:numel(source_same_as_predicted_idx)
            group_source_same_as_predicted_control_temp{source_same_as_predicted_idx(idx_num)} = 'source_same_as_predicted';
        end
        for idx_num = 1:numel(source_not_same_as_predicted_idx)
            group_source_same_as_predicted_control_temp{source_not_same_as_predicted_idx(idx_num)} = 'source_not_same_as_predicted';
        end
        group_source_same_as_predicted_control = [group_source_same_as_predicted_control,group_source_same_as_predicted_control_temp(~isnan(temp(:)))];
    end
end

data_APP = [];
group_source_same_as_target_APP = [];
group_target_same_as_predicted_APP = [];
group_source_same_as_predicted_APP = [];
for source = 1:8
    for target = 1:8
        clear temp
        temp = squeeze(pred_change_APP_animal_session_concat{source}(target,:,:));
        data_APP = [data_APP,temp(~isnan(temp))'];

        if source == target
            group_source_same_as_target_APP = [group_source_same_as_target_APP,repmat({'source_same_as_target'},numel(temp(~isnan(temp))),1)'];
        else
            group_source_same_as_target_APP = [group_source_same_as_target_APP,repmat({'source_not_same_as_target'},numel(temp(~isnan(temp))),1)'];
        end

        all_idx = [1:size(pred_change_APP_animal_session_concat{source}(target,:,:),3)*8];
        target_same_as_predicted_idx = [target:8:size(pred_change_APP_animal_session_concat{source}(target,:,:),3)*8];
        target_not_same_as_predicted_idx = all_idx(~ismember(all_idx,target_same_as_predicted_idx));
        for idx_num = 1:numel(target_same_as_predicted_idx)
            group_target_same_as_predicted_APP_temp{target_same_as_predicted_idx(idx_num)} = 'target_same_as_predicted';
        end
        for idx_num = 1:numel(target_not_same_as_predicted_idx)
            group_target_same_as_predicted_APP_temp{target_not_same_as_predicted_idx(idx_num)} = 'target_not_same_as_predicted';
        end
        group_target_same_as_predicted_APP = [group_target_same_as_predicted_APP,group_target_same_as_predicted_APP_temp(~isnan(temp(:)))];

        source_same_as_predicted_idx = [source:8:size(pred_change_APP_animal_session_concat{source}(target,:,:),3)*8];
        source_not_same_as_predicted_idx = all_idx(~ismember(all_idx,source_same_as_predicted_idx));
        for idx_num = 1:numel(source_same_as_predicted_idx)
            group_source_same_as_predicted_APP_temp{source_same_as_predicted_idx(idx_num)} = 'source_same_as_predicted';
        end
        for idx_num = 1:numel(source_not_same_as_predicted_idx)
            group_source_same_as_predicted_APP_temp{source_not_same_as_predicted_idx(idx_num)} = 'source_not_same_as_predicted';
        end
        group_source_same_as_predicted_APP = [group_source_same_as_predicted_APP,group_source_same_as_predicted_APP_temp(~isnan(temp(:)))];
    end
end

data_all = [data_control,data_APP];
group_genotype_all = [repmat({'control'},1,numel(data_control)),repmat({'APP'},1,numel(data_APP))];
group_source_same_as_target_all = [group_source_same_as_target_control,group_source_same_as_target_APP];
group_target_same_as_predicted_all = [group_target_same_as_predicted_control,group_target_same_as_predicted_APP];
group_source_same_as_predicted_all = [group_source_same_as_predicted_control,group_source_same_as_predicted_APP];
[p,tbl,stats,terms] = anovan(data_all,{group_genotype_all,group_source_same_as_target_all,group_target_same_as_predicted_all,group_source_same_as_predicted_all},"Varnames",["genotype","source_same_as_target","target_same_as_predicted","source_same_as_predicted"]);
figure('Position',[1000,800,300,200],'Color','w')
[results,~,~,~] = multcompare(stats,"Alpha",0.001,"Dimension",[1,2,3,4]);

end