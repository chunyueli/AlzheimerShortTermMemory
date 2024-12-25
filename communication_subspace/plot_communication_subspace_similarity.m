function plot_communication_subspace_similarity

close all
clear all
clc

% Plot communication subspace similarity.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('population_regression_control.mat')
mean_similarity_animal_session_control = population_regression_control.similarity.mean_similarity_animal_session;
clearvars -except mean_similarity_animal_session_control

% APP.
load('population_regression_APP.mat')
mean_similarity_animal_session_APP = population_regression_APP.similarity.mean_similarity_animal_session;
clearvars -except mean_similarity_animal_session_control mean_similarity_animal_session_APP

for source = 1:8
    mean_mean_similarity_animal_session_control{source} = nanmean(mean_similarity_animal_session_control{source},3);
    mean_mean_similarity_animal_session_APP{source} = nanmean(mean_similarity_animal_session_APP{source},3);
    mean_mean_similarity_animal_session_diff{source} = mean_mean_similarity_animal_session_control{source} - mean_mean_similarity_animal_session_APP{source};
end

% Plot.
for source = 1:8
    figure('Position',[100*source,800,100,100],'Color','w')
    imagesc(mean_mean_similarity_animal_session_control{source},[0.16,0.21])
    colormap('viridis')
    axis square
    axis off

    figure('Position',[100*source,600,100,100],'Color','w')
    imagesc(mean_mean_similarity_animal_session_APP{source},[0.16,0.21])
    colormap('viridis')
    axis square
    axis off
end

% Two-way ANOVA.
inter_idx = [2:8,11:16,20:24,29:32,38:40,47:48,56];
reshaped_mean_similarity_animal_session_control_all = [];
group_source_control = [];
for source = 1:8
    reshaped_mean_similarity_animal_session_control{source} = reshape(mean_similarity_animal_session_control{source},[64,size(mean_similarity_animal_session_control{source},3)]);
    inter_reshaped_mean_similarity_animal_session_control_temp{source} = reshaped_mean_similarity_animal_session_control{source}(inter_idx,:);
    inter_reshaped_mean_similarity_animal_session_control{source} = inter_reshaped_mean_similarity_animal_session_control_temp{source}(find(~isnan(inter_reshaped_mean_similarity_animal_session_control_temp{source})));

    reshaped_mean_similarity_animal_session_control_all = [reshaped_mean_similarity_animal_session_control_all;inter_reshaped_mean_similarity_animal_session_control{source}];
    switch source
        case 1
            group_source_control = [group_source_control;repmat({'ALM'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 2
            group_source_control = [group_source_control;repmat({'M1a'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 3
            group_source_control = [group_source_control;repmat({'M1p'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 4
            group_source_control = [group_source_control;repmat({'M2'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 5
            group_source_control = [group_source_control;repmat({'S1fl'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 6
            group_source_control = [group_source_control;repmat({'vS1'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 7
            group_source_control = [group_source_control;repmat({'RSC'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
        case 8
            group_source_control = [group_source_control;repmat({'PPC'},numel(inter_reshaped_mean_similarity_animal_session_control{source}),1)];
    end
end

reshaped_mean_similarity_animal_session_APP_all = [];
group_source_APP = [];
for source = 1:8
    reshaped_mean_similarity_animal_session_APP{source} = reshape(mean_similarity_animal_session_APP{source},[64,size(mean_similarity_animal_session_APP{source},3)]);
    inter_reshaped_mean_similarity_animal_session_APP_temp{source} = reshaped_mean_similarity_animal_session_APP{source}(inter_idx,:);
    inter_reshaped_mean_similarity_animal_session_APP{source} = inter_reshaped_mean_similarity_animal_session_APP_temp{source}(find(~isnan(inter_reshaped_mean_similarity_animal_session_APP_temp{source})));

    reshaped_mean_similarity_animal_session_APP_all = [reshaped_mean_similarity_animal_session_APP_all;inter_reshaped_mean_similarity_animal_session_APP{source}];
    switch source
        case 1
            group_source_APP = [group_source_APP;repmat({'ALM'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 2
            group_source_APP = [group_source_APP;repmat({'M1a'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 3
            group_source_APP = [group_source_APP;repmat({'M1p'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 4
            group_source_APP = [group_source_APP;repmat({'M2'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 5
            group_source_APP = [group_source_APP;repmat({'S1fl'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 6
            group_source_APP = [group_source_APP;repmat({'vS1'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 7
            group_source_APP = [group_source_APP;repmat({'RSC'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
        case 8
            group_source_APP = [group_source_APP;repmat({'PPC'},numel(inter_reshaped_mean_similarity_animal_session_APP{source}),1)];
    end
end

data_all = [reshaped_mean_similarity_animal_session_control_all;reshaped_mean_similarity_animal_session_APP_all];
group_genotype_all = [repmat({'control'},numel(reshaped_mean_similarity_animal_session_control_all),1);repmat({'APP'},numel(reshaped_mean_similarity_animal_session_APP_all),1)];
group_source_all = [group_source_control;group_source_APP];
[p,tbl,stats,terms] = anovan(data_all,{group_genotype_all,group_source_all},"Model","interaction","Varnames",["genotype","source"]);
figure('Position',[1000,800,300,200],'Color','w')
[results,~,~,~] = multcompare(stats,"Alpha",0.001,"Dimension",[1,2]);

end