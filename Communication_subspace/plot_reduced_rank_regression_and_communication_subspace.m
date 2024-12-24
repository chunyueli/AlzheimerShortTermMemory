function plot_reduced_rank_regression_and_communication_subspace

close all
clear all
clc

% Plot results of reduced-rank regression and communication subspace.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

% Control.
load('population_regression_control.mat')
optDimLambdaReducedRankRegress = population_regression_control.all_epoch.optDimLambdaReducedRankRegress;
y = population_regression_control.all_epoch.y;

% Initialize.
for source = 1:8
    for target = 1:8
        y_animal_session{source}{target} = [];
        opt_dim_animal_session{source}{target} = [];
    end
end

for animal_num = 1:numel(optDimLambdaReducedRankRegress)
    clearvars -except y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num

    % Initialize.
    for source = 1:8
        for target = 1:8
            y_session{source}{target} = [];
            opt_dim_session{source}{target} = [];
        end
    end

    for session_num = 1:numel(optDimLambdaReducedRankRegress{animal_num})
        clearvars -except y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num ...
            y_session opt_dim_session session_num

        for source = 1:8
            y_temp1{animal_num}{session_num}{source} = [];
            opt_dim_temp1{animal_num}{session_num}{source} = [];
        end
        for source = 1:numel(y{animal_num}{session_num})
            y_temp1{animal_num}{session_num}{source} = y{animal_num}{session_num}{source};
        end
        for source = 1:numel(optDimLambdaReducedRankRegress{animal_num}{session_num})
            opt_dim_temp1{animal_num}{session_num}{source} = optDimLambdaReducedRankRegress{animal_num}{session_num}{source};
        end

        for source = 1:8
            for target = 1:8
                y_temp2{animal_num}{session_num}{source}{target} = [];
                opt_dim_temp2{animal_num}{session_num}{source}{target} = [];
            end
            for target = 1:numel(y_temp1{animal_num}{session_num}{source})
                y_temp2{animal_num}{session_num}{source}{target} = y_temp1{animal_num}{session_num}{source}{target};
            end
            for target = 1:numel(opt_dim_temp1{animal_num}{session_num}{source})
                opt_dim_temp2{animal_num}{session_num}{source}{target} = opt_dim_temp1{animal_num}{session_num}{source}{target};
            end
        end

        for source = 1:8
            for target = 1:8
                if isempty(y_temp2{animal_num}{session_num}{source}{target})
                    y_temp2{animal_num}{session_num}{source}{target} = nan(20,11);
                end
                if isempty(opt_dim_temp2{animal_num}{session_num}{source}{target})
                    opt_dim_temp2{animal_num}{session_num}{source}{target} = nan(1,10);
                end
            end
        end

        % Concatenate.
        for source = 1:8
            for target = 1:8
                y_session{source}{target} = [y_session{source}{target};nanmean(y_temp2{animal_num}{session_num}{source}{target})];
                opt_dim_session{source}{target} = [opt_dim_session{source}{target};nanmean(opt_dim_temp2{animal_num}{session_num}{source}{target})];
            end
        end
    end

    % Concatenate.
    for source = 1:8
        for target = 1:8
            y_animal_session{source}{target} = [y_animal_session{source}{target};y_session{source}{target}];
            opt_dim_animal_session{source}{target} = [opt_dim_animal_session{source}{target};opt_dim_session{source}{target}];
        end
    end
end

for source = 1:8
    for target = 1:8
        prediction(source,target) = nanmean(y_animal_session{source}{target}(:,end));
        opt_dim(source,target) = nanmean(opt_dim_animal_session{source}{target});
    end
end

prediction_control = y_animal_session;
opt_dim_control = opt_dim_animal_session;
mean_prediction_control = prediction;
mean_opt_dim_control = opt_dim;
clearvars -except prediction_control opt_dim_control mean_prediction_control mean_opt_dim_control

% APP.
load('population_regression_APP.mat')
optDimLambdaReducedRankRegress = population_regression_APP.all_epoch.optDimLambdaReducedRankRegress;
y = population_regression_APP.all_epoch.y;

% Initialize.
for source = 1:8
    for target = 1:8
        y_animal_session{source}{target} = [];
        opt_dim_animal_session{source}{target} = [];
    end
end

for animal_num = 1:numel(optDimLambdaReducedRankRegress)
    clearvars -except prediction_control opt_dim_control mean_prediction_control mean_opt_dim_control y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num

    % Initialize.
    for source = 1:8
        for target = 1:8
            y_session{source}{target} = [];
            opt_dim_session{source}{target} = [];
        end
    end

    for session_num = 1:numel(optDimLambdaReducedRankRegress{animal_num})
        clearvars -except prediction_control opt_dim_control mean_prediction_control mean_opt_dim_control y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num ...
            y_session opt_dim_session session_num

        for source = 1:8
            y_temp1{animal_num}{session_num}{source} = [];
            opt_dim_temp1{animal_num}{session_num}{source} = [];
        end
        for source = 1:numel(y{animal_num}{session_num})
            y_temp1{animal_num}{session_num}{source} = y{animal_num}{session_num}{source};
        end
        for source = 1:numel(optDimLambdaReducedRankRegress{animal_num}{session_num})
            opt_dim_temp1{animal_num}{session_num}{source} = optDimLambdaReducedRankRegress{animal_num}{session_num}{source};
        end

        for source = 1:8
            for target = 1:8
                y_temp2{animal_num}{session_num}{source}{target} = [];
                opt_dim_temp2{animal_num}{session_num}{source}{target} = [];
            end
            for target = 1:numel(y_temp1{animal_num}{session_num}{source})
                y_temp2{animal_num}{session_num}{source}{target} = y_temp1{animal_num}{session_num}{source}{target};
            end
            for target = 1:numel(opt_dim_temp1{animal_num}{session_num}{source})
                opt_dim_temp2{animal_num}{session_num}{source}{target} = opt_dim_temp1{animal_num}{session_num}{source}{target};
            end
        end

        for source = 1:8
            for target = 1:8
                if isempty(y_temp2{animal_num}{session_num}{source}{target})
                    y_temp2{animal_num}{session_num}{source}{target} = nan(20,11);
                end
                if isempty(opt_dim_temp2{animal_num}{session_num}{source}{target})
                    opt_dim_temp2{animal_num}{session_num}{source}{target} = nan(1,10);
                end
            end
        end

        % Concatenate.
        for source = 1:8
            for target = 1:8
                y_session{source}{target} = [y_session{source}{target};nanmean(y_temp2{animal_num}{session_num}{source}{target})];
                opt_dim_session{source}{target} = [opt_dim_session{source}{target};nanmean(opt_dim_temp2{animal_num}{session_num}{source}{target})];
            end
        end
    end

    % Concatenate.
    for source = 1:8
        for target = 1:8
            y_animal_session{source}{target} = [y_animal_session{source}{target};y_session{source}{target}];
            opt_dim_animal_session{source}{target} = [opt_dim_animal_session{source}{target};opt_dim_session{source}{target}];
        end
    end
end

for source = 1:8
    for target = 1:8
        prediction(source,target) = nanmean(y_animal_session{source}{target}(:,end));
        opt_dim(source,target) = nanmean(opt_dim_animal_session{source}{target});
    end
end

prediction_APP = y_animal_session;
opt_dim_APP = opt_dim_animal_session;
mean_prediction_APP = prediction;
mean_opt_dim_APP = opt_dim;
clearvars -except prediction_control opt_dim_control mean_prediction_control mean_opt_dim_control prediction_APP opt_dim_APP mean_prediction_APP mean_opt_dim_APP

% Plot.
figure('Position',[200,800,200,200],'Color','w')
imagesc(mean_prediction_control,[0,0.09])
axis square
xlabel('');
ylabel('');
axis off
colormap('magma')

figure('Position',[400,800,200,200],'Color','w')
imagesc(mean_prediction_APP,[0,0.09])
axis square
xlabel('');
ylabel('');
axis off
colormap('magma')

figure('Position',[700,800,200,200],'Color','w')
imagesc(mean_opt_dim_control,[1.8,3.7])
axis square
xlabel('');
ylabel('');
axis off
colormap('parula')

figure('Position',[900,800,200,200],'Color','w')
imagesc(mean_opt_dim_APP,[1.8,3.7])
axis square
xlabel('');
ylabel('');
axis off
colormap('parula')

intra_opt_dim_control = diag(mean_opt_dim_control);
intra_opt_dim_APP = diag(mean_opt_dim_APP);
inter_opt_dim_control = mean_opt_dim_control;
inter_opt_dim_APP = mean_opt_dim_APP;
for region_num = 1:8
    inter_opt_dim_control(region_num,region_num) = nan;
    inter_opt_dim_APP(region_num,region_num) = nan;
end
inter_opt_dim_control = inter_opt_dim_control(~isnan(inter_opt_dim_control));
inter_opt_dim_APP = inter_opt_dim_APP(~isnan(inter_opt_dim_APP));

figure('Position',[1100,800,200,200],'Color','w')
hold on
plot(intra_opt_dim_control,intra_opt_dim_APP,'+','MarkerSize',6,'Color',[0.25,0.25,0.25],'LineWidth',2.5)
plot(inter_opt_dim_control,inter_opt_dim_APP,'o','MarkerSize',6,'MarkerFaceColor',[0.25,0.25,0.25],'MarkerEdgeColor','none')
line([1,4],[1,4],'LineWidth',1,'Color',[0.25,0.25,0.25])
xlabel('Control');
ylabel('APP');
xlim([1,4])
ylim([1,4])
ax = gca;
ax.FontSize = 14;
ax.XTick = [1,2,3,4];
ax.YTick = [1,2,3,4];
ax.XTickLabel = {'1','2','3','4'};
ax.YTickLabel = {'1','2','3','4'};

% Two-way ANOVA.
all_idx = [1:64];
intra_idx = [1:9:64];
inter_idx = all_idx(~ismember(all_idx,intra_idx));
% Prediction.
for source = 1:8
    for target = 1:8
        prediction_control_concat(source,target,:) = prediction_control{source}{target}(:,end);
    end
end
reshaped_prediction_control_concat = reshape(prediction_control_concat,[64,size(prediction_control_concat,3)]);
intra_reshaped_prediction_control_concat = reshaped_prediction_control_concat(intra_idx,:);
inter_reshaped_prediction_control_concat = reshaped_prediction_control_concat(inter_idx,:);
both_prediction_control_concat_temp = [intra_reshaped_prediction_control_concat(:);inter_reshaped_prediction_control_concat(:)];
intra_inter_group_control_temp = [repmat({'intra'},numel(intra_reshaped_prediction_control_concat),1);repmat({'inter'},numel(inter_reshaped_prediction_control_concat),1)];
both_prediction_control_concat = both_prediction_control_concat_temp(find(~isnan(both_prediction_control_concat_temp)));
intra_inter_group_control = intra_inter_group_control_temp(find(~isnan(both_prediction_control_concat_temp)));

for source = 1:8
    for target = 1:8
        prediction_APP_concat(source,target,:) = prediction_APP{source}{target}(:,end);
    end
end
reshaped_prediction_APP_concat = reshape(prediction_APP_concat,[64,size(prediction_APP_concat,3)]);
intra_reshaped_prediction_APP_concat = reshaped_prediction_APP_concat(intra_idx,:);
inter_reshaped_prediction_APP_concat = reshaped_prediction_APP_concat(inter_idx,:);
both_prediction_APP_concat_temp = [intra_reshaped_prediction_APP_concat(:);inter_reshaped_prediction_APP_concat(:)];
intra_inter_group_APP_temp = [repmat({'intra'},numel(intra_reshaped_prediction_APP_concat),1);repmat({'inter'},numel(inter_reshaped_prediction_APP_concat),1)];
both_prediction_APP_concat = both_prediction_APP_concat_temp(find(~isnan(both_prediction_APP_concat_temp)));
intra_inter_group_APP = intra_inter_group_APP_temp(find(~isnan(both_prediction_APP_concat_temp)));

data_all = [both_prediction_control_concat;both_prediction_APP_concat];
group_genotype_all = [repmat({'control'},numel(both_prediction_control_concat),1);repmat({'APP'},numel(both_prediction_APP_concat),1)];
group_intra_inter_all = [intra_inter_group_control;intra_inter_group_APP];
[p_prediction,tbl_prediction,stats_prediction,terms_prediction] = anovan(data_all,{group_genotype_all,group_intra_inter_all},"Model","interaction","Varnames",["genotype","intra_inter"]);
figure('Position',[1400,1000,300,200],'Color','w')
[results_prediction,~,~,~] = multcompare(stats_prediction,"Alpha",0.001,"Dimension",[1,2]);

% Optimal dimension.
for source = 1:8
    for target = 1:8
        opt_dim_control_concat(source,target,:) = opt_dim_control{source}{target};
    end
end
reshaped_opt_dim_control_concat = reshape(opt_dim_control_concat,[64,size(opt_dim_control_concat,3)]);
intra_reshaped_opt_dim_control_concat = reshaped_opt_dim_control_concat(intra_idx,:);
inter_reshaped_opt_dim_control_concat = reshaped_opt_dim_control_concat(inter_idx,:);
both_opt_dim_control_concat_temp = [intra_reshaped_opt_dim_control_concat(:);inter_reshaped_opt_dim_control_concat(:)];
intra_inter_group_control_temp = [repmat({'intra'},numel(intra_reshaped_opt_dim_control_concat),1);repmat({'inter'},numel(inter_reshaped_opt_dim_control_concat),1)];
both_opt_dim_control_concat = both_opt_dim_control_concat_temp(find(~isnan(both_opt_dim_control_concat_temp)));
intra_inter_group_control = intra_inter_group_control_temp(find(~isnan(both_opt_dim_control_concat_temp)));

for source = 1:8
    for target = 1:8
        opt_dim_APP_concat(source,target,:) = opt_dim_APP{source}{target};
    end
end
reshaped_opt_dim_APP_concat = reshape(opt_dim_APP_concat,[64,size(opt_dim_APP_concat,3)]);
intra_reshaped_opt_dim_APP_concat = reshaped_opt_dim_APP_concat(intra_idx,:);
inter_reshaped_opt_dim_APP_concat = reshaped_opt_dim_APP_concat(inter_idx,:);
both_opt_dim_APP_concat_temp = [intra_reshaped_opt_dim_APP_concat(:);inter_reshaped_opt_dim_APP_concat(:)];
intra_inter_group_APP_temp = [repmat({'intra'},numel(intra_reshaped_opt_dim_APP_concat),1);repmat({'inter'},numel(inter_reshaped_opt_dim_APP_concat),1)];
both_opt_dim_APP_concat = both_opt_dim_APP_concat_temp(find(~isnan(both_opt_dim_APP_concat_temp)));
intra_inter_group_APP = intra_inter_group_APP_temp(find(~isnan(both_opt_dim_APP_concat_temp)));

data_all = [both_opt_dim_control_concat;both_opt_dim_APP_concat];
group_genotype_all = [repmat({'control'},numel(both_opt_dim_control_concat),1);repmat({'APP'},numel(both_opt_dim_APP_concat),1)];
group_intra_inter_all = [intra_inter_group_control;intra_inter_group_APP];
[p_opt_dim,tbl_opt_dim,stats_opt_dim,terms_opt_dim] = anovan(data_all,{group_genotype_all,group_intra_inter_all},"Model","interaction","Varnames",["genotype","intra_inter"]);
figure('Position',[1700,1000,300,200],'Color','w')
[results_opt_dim,~,~,~] = multcompare(stats_opt_dim,"Alpha",0.001,"Dimension",[1,2]);

% Save.
for source = 1:8
    for target = 1:8
        regression_control(source,target,:) = prediction_control{source}{target}(:,end);
        regression_APP(source,target,:) = prediction_APP{source}{target}(:,end);
    end
end
%save('regression.mat','regression_control','regression_APP','-v7.3')

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
temp1 = round(rescale([mean_prediction_control(:);min([mean_prediction_control(:);mean_prediction_APP(:)]);max([mean_prediction_control(:);mean_prediction_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate(region_num1,1),region_coordinate(region_num2,1)],[region_coordinate(region_num1,2),region_coordinate(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate(region_num,1),region_coordinate(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

clearvars -except prediction_control opt_dim_control mean_prediction_control mean_opt_dim_control prediction_APP opt_dim_APP mean_prediction_APP mean_opt_dim_APP ...
    bregma cortical_area_boundaries

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
temp1 = round(rescale([mean_prediction_APP(:);min([mean_prediction_control(:);mean_prediction_APP(:)]);max([mean_prediction_control(:);mean_prediction_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate(region_num1,1),region_coordinate(region_num2,1)],[region_coordinate(region_num1,2),region_coordinate(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate(region_num,1),region_coordinate(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

% Statistics.
rng(0)
for region_num1 = 1:8
    for region_num2 = 1:8
        control_temp{region_num1}{region_num2} = prediction_control{region_num1}{region_num2}(:,end);
        control{region_num1}{region_num2} = control_temp{region_num1}{region_num2}(~isnan(control_temp{region_num1}{region_num2}));

        APP_temp{region_num1}{region_num2} = prediction_APP{region_num1}{region_num2}(:,end);
        APP{region_num1}{region_num2} = APP_temp{region_num1}{region_num2}(~isnan(APP_temp{region_num1}{region_num2}));

        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(control{region_num1}{region_num2})
                sampled_control{region_num1}{region_num2}(shuffle_num,session_num) = control{region_num1}{region_num2}(randi(numel(control{region_num1}{region_num2})));
            end
            for session_num = 1:numel(APP{region_num1}{region_num2})
                sampled_APP{region_num1}{region_num2}(shuffle_num,session_num) = APP{region_num1}{region_num2}(randi(numel(APP{region_num1}{region_num2})));
            end
        end
        p_value(region_num1,region_num2) = sum(mean(sampled_control{region_num1}{region_num2},2) < mean(sampled_APP{region_num1}{region_num2},2))/1000;
    end
end

% False discovery rate.
[val,idx] = sort(p_value(:));
adjusted_p_value_005 = ((1:numel(p_value(:)))*0.05)/numel(p_value(:));
adjusted_p_value_001 = ((1:numel(p_value(:)))*0.01)/numel(p_value(:));
adjusted_p_value_0001 = ((1:numel(p_value(:)))*0.001)/numel(p_value(:));
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value(:)),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

p_value_matrix = reshape(vector,[8,8]);

% Plot.
figure('Position',[200,200,200,200],'Color','w')
imagesc(p_value_matrix,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

end