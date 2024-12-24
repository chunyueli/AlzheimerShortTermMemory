function analyze_communication_subspace_subspace_similarity_epoch(group, epoch)

close all
clearvars -except group epoch
clc

% Analyze communication subspace similarity in each epoch.
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

% Sampling frequency of Scanimage.
fs_image = 9.35211;

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
            switch epoch
                case 'stimulus'
                    concat_trial_by_trial_activity_stim{animal_num}{session_num}{region_num} = [];
                case 'delay'
                    concat_trial_by_trial_activity_delay{animal_num}{session_num}{region_num} = [];
                case 'action'
                    concat_trial_by_trial_activity_action{animal_num}{session_num}{region_num} = [];
            end
            for trial_num = 1:size(trial_by_trial_activity{animal_num}{session_num}{region_num},2)
                if size(trial_by_trial_activity{animal_num}{session_num}{region_num},1) == 1 % If there is only 1 cell.
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))'];
                    switch epoch
                        case 'stimulus'
                            concat_trial_by_trial_activity_stim{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity_stim{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,round(1*fs_image):round(2*fs_image)))'];
                        case 'delay'
                            concat_trial_by_trial_activity_delay{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity_delay{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,round(2*fs_image):round(6*fs_image)))'];
                        case 'action'
                            concat_trial_by_trial_activity_action{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity_action{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,round(6*fs_image):round(7*fs_image)))'];
                    end
                else
                    concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,:))];
                    switch epoch
                        case 'stimulus'
                            concat_trial_by_trial_activity_stim{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity_stim{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,round(1*fs_image):round(2*fs_image)))];
                        case 'delay'
                            concat_trial_by_trial_activity_delay{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity_delay{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,round(2*fs_image):round(6*fs_image)))];
                        case 'action'
                            concat_trial_by_trial_activity_action{animal_num}{session_num}{region_num} = [concat_trial_by_trial_activity_action{animal_num}{session_num}{region_num},squeeze(trial_by_trial_activity{animal_num}{session_num}{region_num}(:,trial_num,round(6*fs_image):round(7*fs_image)))];
                    end
                end
            end
        end
    end
end

% Pick cells with similar activity levels.
for animal_num = 1:numel(behavior)
    clearvars -except group epoch behavior concat_trial_by_trial_activity animal_num mean_concat_trial_by_trial_activity cell_idx adj_concat_trial_by_trial_activity concat_trial_by_trial_activity_stim concat_trial_by_trial_activity_delay concat_trial_by_trial_activity_action
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except group epoch behavior concat_trial_by_trial_activity animal_num session_num mean_concat_trial_by_trial_activity cell_idx adj_concat_trial_by_trial_activity concat_trial_by_trial_activity_stim concat_trial_by_trial_activity_delay concat_trial_by_trial_activity_action
        
        for region_num = 1:8
            mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = mean(concat_trial_by_trial_activity{animal_num}{session_num}{region_num},2);
            cell_idx{animal_num}{session_num}{region_num} = mean_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} > 0.024;
            switch epoch
                case 'stimulus'
                    adj_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = concat_trial_by_trial_activity_stim{animal_num}{session_num}{region_num}(cell_idx{animal_num}{session_num}{region_num},:);
                case 'delay'
                    adj_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = concat_trial_by_trial_activity_delay{animal_num}{session_num}{region_num}(cell_idx{animal_num}{session_num}{region_num},:);
                case 'action'
                    adj_concat_trial_by_trial_activity{animal_num}{session_num}{region_num} = concat_trial_by_trial_activity_action{animal_num}{session_num}{region_num}(cell_idx{animal_num}{session_num}{region_num},:);
            end
        end
    end
end

cell_num_thresh = 10;
rng(0)

for animal_num = 1:numel(behavior)
    
    for session_num = 1:numel(behavior{animal_num})
        clearvars -except group epoch behavior adj_concat_trial_by_trial_activity cell_num_thresh animal_num session_num B_
        
        for shuffle_num = 1:20
            disp(['Shuffle: ',num2str(shuffle_num)])
            clearvars -except group epoch behavior adj_concat_trial_by_trial_activity cell_num_thresh animal_num session_num shuffle_num B_
            
            for source = 1:8
                for target = 1:8
                    
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
                    [~,B_{animal_num}{session_num}{source}{target}(shuffle_num,:,:)] = ReducedRankRegress(Y,X);
                    %%%%% Semedo et al. %%%%%
                end
            end
        end
    end
end

% Make columns of B_ linearly independent.
% Q provides an orthonormal basis for a q-dimensional predictive subspace.
q = 3;
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for source = 1:8
            for target = 1:8
                for shuffle_num = 1:20
                    if ~isempty(B_{animal_num}{session_num}{source}{target})
                        [Q{animal_num}{session_num}{source}{target}(shuffle_num,:,:),~] = qr(squeeze(B_{animal_num}{session_num}{source}{target}(shuffle_num,:,1:q)));
                    else
                        Q{animal_num}{session_num}{source}{target} = [];
                    end
                end
            end
        end
    end
end

% Compute cosine similarity of subspaces.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for source = 1:8
            for target1 = 1:8
                for target2 = 1:8
                    for shuffle_num = 1:20
                        if ~isempty(Q{animal_num}{session_num}{source}{target1}) && ~isempty(Q{animal_num}{session_num}{source}{target2})
                            similarity{animal_num}{session_num}{source}(target1,target2,shuffle_num) = cos(subspace(squeeze(Q{animal_num}{session_num}{source}{target1}(shuffle_num,:,1:q)),squeeze(Q{animal_num}{session_num}{source}{target2}(shuffle_num,:,1:q))));
                        else
                            similarity{animal_num}{session_num}{source}(target1,target2,shuffle_num) = nan;
                        end
                    end
                end
            end
        end
    end
end

% Average across shuffles.
for animal_num = 1:numel(behavior)
    for session_num = 1:numel(behavior{animal_num})
        for source = 1:8
            mean_similarity{animal_num}{session_num}{source} = squeeze(mean(similarity{animal_num}{session_num}{source},3));
        end
    end
end

% Concatenate across sessions and animals.
for source = 1:8
    
    % Initialize.
    mean_similarity_animal_session{source} = [];
    for animal_num = 1:numel(behavior)
        
        % Initialize.
        mean_similarity_session{source} = [];
        
        for session_num = 1:numel(behavior{animal_num})
            mean_similarity_session{source} = cat(3,mean_similarity_session{source},mean_similarity{animal_num}{session_num}{source});
        end
        mean_similarity_animal_session{source} = cat(3,mean_similarity_animal_session{source},mean_similarity_session{source});
    end
end

% Save.
save(['population_regression_',epoch,'_similarity_',group,'_q',num2str(q),'.mat'],'B_','Q','mean_similarity_animal_session','-v7.3')

end