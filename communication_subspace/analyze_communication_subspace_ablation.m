function analyze_communication_subspace_ablation(group)

close all
clearvars -except group
clc

% Analyze communication subspace with ablation.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

switch group
    case 'control'
        load('behavior_control.mat')
        load('activity_control.mat')
        behavior = behavior_control;
        activity = activity_control;
        clear behavior_control
        clear activity_control
    case 'APP'
        load('behavior_APP.mat')
        load('activity_APP.mat')
        behavior = behavior_APP;
        activity = activity_APP;
        clear behavior_APP
        clear activity_APP
end

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
    clearvars -except group behavior concat_trial_by_trial_activity animal_num mean_concat_trial_by_trial_activity cell_idx adj_concat_trial_by_trial_activity
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except group behavior concat_trial_by_trial_activity animal_num session_num mean_concat_trial_by_trial_activity cell_idx adj_concat_trial_by_trial_activity
        
        for region_num = 1:8
            mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2);
            cell_idx{animal_num}{session_num}{region_num} = mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} > 0.024;
            adj_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = concat_trial_by_trial_activity{animal_num}{session_num}{region_num}(cell_idx{animal_num}{session_num}{region_num},:);
        end
    end
end

cell_num_thresh = 10;

for animal_num = 1:numel(behavior)
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except group behavior adj_concat_trial_by_trial_activity cell_num_thresh animal_num session_num optDimLambdaReducedRankRegress source_activity target_activity predicted_activity x y e
        
        for dimension_num = 1:4
            clearvars -except group behavior adj_concat_trial_by_trial_activity cell_num_thresh animal_num session_num dimension_num optDimLambdaReducedRankRegress source_activity target_activity predicted_activity x y e
            
            for shuffle_num = 1:20
                disp(['Shuffle: ',num2str(shuffle_num)])
                clearvars -except group behavior adj_concat_trial_by_trial_activity cell_num_thresh animal_num session_num dimension_num shuffle_num optDimLambdaReducedRankRegress source_activity target_activity predicted_activity x y e
                
                for source = 1:8
                    for target = 1:8
                        clear B_ M V Q
                        
                        if source == target % If the source and target are the same region.
                            clear idx_temp1 idx1 idx2 X Y
                            if size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{source},1) >= 2*cell_num_thresh
                                idx_temp1 = randperm(size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{source},1));
                                idx1 = idx_temp1(1:cell_num_thresh);
                                idx2 = idx_temp1((cell_num_thresh + 1):2*cell_num_thresh);
                                X = adj_concat_trial_by_trial_activity{animal_num}{session_num}{source}(idx1,:)';
                                Y = adj_concat_trial_by_trial_activity{animal_num}{session_num}{target}(idx2,:)';
                            else
                                X = [];
                                Y = [];
                            end
                            
                        elseif source ~= target % If the source and target are not the same region.
                            clear idx_temp1 idx1 idx_temp2 idx2 X Y
                            if size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{source},1) >= cell_num_thresh && size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{target},1) >= cell_num_thresh
                                idx_temp1 = randperm(size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{source},1));
                                idx1 = idx_temp1(1:cell_num_thresh);
                                idx_temp2 = randperm(size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{target},1));
                                idx2 = idx_temp2(1:cell_num_thresh);
                                X = adj_concat_trial_by_trial_activity{animal_num}{session_num}{source}(idx1,:)';
                                Y = adj_concat_trial_by_trial_activity{animal_num}{session_num}{target}(idx2,:)';
                            else
                                X = [];
                                Y = [];
                            end
                        end
                        
                        %%%%% Semedo et al. %%%%%
                        [~,B_] = ReducedRankRegress(Y,X);
                        M = B_'*cov(X);
                        [~,~,V] = svd(M);
                        Q = V(:,dimension_num:end);
                        X = X*Q;
                        %%%%% Semedo et al. %%%%%
                        
                        for predicted = 1:8
                            clear cvl cvLoss
                            disp(['Animal: ',num2str(animal_num),' Session: ',num2str(session_num),' Dimension: ',num2str(dimension_num),' Source: ',num2str(source),' Target: ',num2str(target), ' Predicted: ',num2str(predicted)])
                            
                            if target == predicted % If the target and predicted are the same region.
                                clear Y2
                                Y2 = Y;
                            elseif target ~= predicted % If the target and predicted are not the same region.
                                if source == predicted % If the source and predicted are the same region.
                                    if size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{predicted},1) >= 2*cell_num_thresh && size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{target},1) >= cell_num_thresh
                                        clear idx2 Y2
                                        idx2 = idx_temp1((cell_num_thresh + 1):2*cell_num_thresh);
                                        Y2 = adj_concat_trial_by_trial_activity{animal_num}{session_num}{predicted}(idx2,:)';
                                    else
                                        Y2 = [];
                                    end
                                elseif source ~= predicted % If the source and predicted are not the same region.
                                    clear idx_temp idx Y2
                                    if size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{predicted},1) >= cell_num_thresh
                                        idx_temp = randperm(size(adj_concat_trial_by_trial_activity{animal_num}{session_num}{predicted},1));
                                        idx = idx_temp(1:cell_num_thresh);
                                        Y2 = adj_concat_trial_by_trial_activity{animal_num}{session_num}{predicted}(idx,:)';
                                    else
                                        Y2 = [];
                                    end
                                end
                            end
                            
                            % Initialize.
                            x{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(shuffle_num,:) = nan(1,11);
                            y{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(shuffle_num,:) = nan(1,11);
                            e{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(shuffle_num,:) = nan(1,11);
                            
                            if ~isempty(X) && ~isempty(Y) && ~isempty(Y2)
                                %%%%% Semedo et al. %%%%%
                                %% Cross-validate Lambda-Reduced Rank Regression (no scaling).
                                
                                numDimsUsedForPrediction = 0:10;
                                
                                cvNumFolds = 10;
                                
                                cvOptions = statset('crossval');
                                cvOptions.UseParallel = true;
                                
                                regressMethod = @ReducedRankRegress;
                                
                                % To use Lambda-Reduced Rank Regression, set 'RidgeInit' to 1.
                                cvFun = @(Ytrain, Xtrain, Ytest, Xtest) RegressFitAndPredict...
                                    (regressMethod, Ytrain, Xtrain, Ytest, Xtest, ...
                                    numDimsUsedForPrediction, 'LossMeasure', 'NSE', ...
                                    'RidgeInit', true, 'Scale', false);
                                
                                % Cross-validation routine.
                                cvl = crossval(cvFun, Y2, X, ...
                                    'KFold', cvNumFolds, ...
                                    'Options', cvOptions);
                                
                                % Stores cross-validation results: mean loss and standard error of the mean across folds.
                                cvLoss = [mean(cvl); std(cvl)/sqrt(cvNumFolds)];
                                
                                % To compute the optimal dimensionality for the regression model, call ModelSelect:
                                optDimLambdaReducedRankRegress{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(shuffle_num) = ModelSelect...
                                    (cvLoss, numDimsUsedForPrediction);
                                
                                source_activity{animal_num}{session_num}{dimension_num}{source}{target}{predicted}{shuffle_num} = X;
                                target_activity{animal_num}{session_num}{dimension_num}{source}{target}{predicted}{shuffle_num} = Y;
                                predicted_activity{animal_num}{session_num}{dimension_num}{source}{target}{predicted}{shuffle_num} = Y2;
                                x{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(shuffle_num,:) = numDimsUsedForPrediction;
                                y{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(shuffle_num,:) = 1-cvLoss(1,:);
                                e{animal_num}{session_num}{dimension_num}{source}{target}{predicted}(shuffle_num,:) = cvLoss(2,:);
                                %%%%% Semedo et al. %%%%%
                            end
                        end
                    end
                end
            end
        end
    end
end

clearvars -except group optDimLambdaReducedRankRegress source_activity target_activity x y e

% Save.
save(['population_regression_ablation_',group,'.mat'],'-v7.3')

end