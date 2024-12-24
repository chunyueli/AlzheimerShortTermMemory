function plot_prediction_performance_across_epoch

close all
clear all
clc

% Plot prediction performance in each epoch by reduced-rank regression.
% Select a folder containing data.
folder_name = uigetdir;
cd(folder_name)

load('population_regression_control.mat')
load('population_regression_APP.mat')

% Stimulus.
% Control.
optDimLambdaReducedRankRegress = population_regression_control.stim.optDimLambdaReducedRankRegress;
y = population_regression_control.stim.y;

% Initialize.
for source = 1:8
    for target = 1:8
        y_animal_session{source}{target} = [];
        opt_dim_animal_session{source}{target} = [];
    end
end

for animal_num = 1:numel(optDimLambdaReducedRankRegress)
    clearvars -except population_regression_control population_regression_APP y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num

    % Initialize.
    for source = 1:8
        for target = 1:8
            y_session{source}{target} = [];
            opt_dim_session{source}{target} = [];
        end
    end

    for session_num = 1:numel(optDimLambdaReducedRankRegress{animal_num})
        clearvars -except population_regression_control population_regression_APP y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num ...
            y_session opt_dim_session session_num

        for source = 1:8
            y_temp1{animal_num}{session_num}{source} = [];
            opt_dim_temp1{animal_num}{session_num}{source} = [];
        end
        for source = 1:numel(optDimLambdaReducedRankRegress{animal_num}{session_num})
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

prediction_stim_control = y_animal_session;
opt_dim_stim_control = opt_dim_animal_session;
mean_prediction_stim_control = prediction;
mean_opt_dim_stim_control = opt_dim;
clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control

% APP.
optDimLambdaReducedRankRegress = population_regression_APP.stim.optDimLambdaReducedRankRegress;
y = population_regression_APP.stim.y;

% Initialize.
for source = 1:8
    for target = 1:8
        y_animal_session{source}{target} = [];
        opt_dim_animal_session{source}{target} = [];
    end
end

for animal_num = 1:numel(optDimLambdaReducedRankRegress)
    clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num

    % Initialize.
    for source = 1:8
        for target = 1:8
            y_session{source}{target} = [];
            opt_dim_session{source}{target} = [];
        end
    end

    for session_num = 1:numel(optDimLambdaReducedRankRegress{animal_num})
        clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num ...
            y_session opt_dim_session session_num

        for source = 1:8
            y_temp1{animal_num}{session_num}{source} = [];
            opt_dim_temp1{animal_num}{session_num}{source} = [];
        end
        for source = 1:numel(optDimLambdaReducedRankRegress{animal_num}{session_num})
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

prediction_stim_APP = y_animal_session;
opt_dim_stim_APP = opt_dim_animal_session;
mean_prediction_stim_APP = prediction;
mean_opt_dim_stim_APP = opt_dim;
clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP

% Delay.
% Control.
optDimLambdaReducedRankRegress = population_regression_control.delay.optDimLambdaReducedRankRegress;
y = population_regression_control.delay.y;

% Initialize.
for source = 1:8
    for target = 1:8
        y_animal_session{source}{target} = [];
        opt_dim_animal_session{source}{target} = [];
    end
end

for animal_num = 1:numel(optDimLambdaReducedRankRegress)
    clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
        y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num

    % Initialize.
    for source = 1:8
        for target = 1:8
            y_session{source}{target} = [];
            opt_dim_session{source}{target} = [];
        end
    end

    for session_num = 1:numel(optDimLambdaReducedRankRegress{animal_num})
        clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
            y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num ...
            y_session opt_dim_session session_num

        for source = 1:8
            y_temp1{animal_num}{session_num}{source} = [];
            opt_dim_temp1{animal_num}{session_num}{source} = [];
        end
        for source = 1:numel(optDimLambdaReducedRankRegress{animal_num}{session_num})
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

prediction_delay_control = y_animal_session;
opt_dim_delay_control = opt_dim_animal_session;
mean_prediction_delay_control = prediction;
mean_opt_dim_delay_control = opt_dim;
clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
    prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control

% APP.
optDimLambdaReducedRankRegress = population_regression_APP.delay.optDimLambdaReducedRankRegress;
y = population_regression_APP.delay.y;

% Initialize.
for source = 1:8
    for target = 1:8
        y_animal_session{source}{target} = [];
        opt_dim_animal_session{source}{target} = [];
    end
end

for animal_num = 1:numel(optDimLambdaReducedRankRegress)
    clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
        prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num

    % Initialize.
    for source = 1:8
        for target = 1:8
            y_session{source}{target} = [];
            opt_dim_session{source}{target} = [];
        end
    end

    for session_num = 1:numel(optDimLambdaReducedRankRegress{animal_num})
        clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
            prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num ...
            y_session opt_dim_session session_num

        for source = 1:8
            y_temp1{animal_num}{session_num}{source} = [];
            opt_dim_temp1{animal_num}{session_num}{source} = [];
        end
        for source = 1:numel(optDimLambdaReducedRankRegress{animal_num}{session_num})
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

prediction_delay_APP = y_animal_session;
opt_dim_delay_APP = opt_dim_animal_session;
mean_prediction_delay_APP = prediction;
mean_opt_dim_delay_APP = opt_dim;
clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
    prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control prediction_delay_APP opt_dim_delay_APP mean_prediction_delay_APP mean_opt_dim_delay_APP

% Action.
% Control.
optDimLambdaReducedRankRegress = population_regression_control.action.optDimLambdaReducedRankRegress;
y = population_regression_control.action.y;

% Initialize.
for source = 1:8
    for target = 1:8
        y_animal_session{source}{target} = [];
        opt_dim_animal_session{source}{target} = [];
    end
end

for animal_num = 1:numel(optDimLambdaReducedRankRegress)
    clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
        prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control prediction_delay_APP opt_dim_delay_APP mean_prediction_delay_APP mean_opt_dim_delay_APP ...
        y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num

    % Initialize.
    for source = 1:8
        for target = 1:8
            y_session{source}{target} = [];
            opt_dim_session{source}{target} = [];
        end
    end

    for session_num = 1:numel(optDimLambdaReducedRankRegress{animal_num})
        clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
            prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control prediction_delay_APP opt_dim_delay_APP mean_prediction_delay_APP mean_opt_dim_delay_APP ...
            y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num ...
            y_session opt_dim_session session_num

        for source = 1:8
            y_temp1{animal_num}{session_num}{source} = [];
            opt_dim_temp1{animal_num}{session_num}{source} = [];
        end
        for source = 1:numel(optDimLambdaReducedRankRegress{animal_num}{session_num})
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

prediction_action_control = y_animal_session;
opt_dim_action_control = opt_dim_animal_session;
mean_prediction_action_control = prediction;
mean_opt_dim_action_control = opt_dim;
clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
    prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control prediction_delay_APP opt_dim_delay_APP mean_prediction_delay_APP mean_opt_dim_delay_APP ...
    prediction_action_control opt_dim_action_control mean_prediction_action_control mean_opt_dim_action_control

% APP.
optDimLambdaReducedRankRegress = population_regression_APP.action.optDimLambdaReducedRankRegress;
y = population_regression_APP.action.y;

% Initialize.
for source = 1:8
    for target = 1:8
        y_animal_session{source}{target} = [];
        opt_dim_animal_session{source}{target} = [];
    end
end

for animal_num = 1:numel(optDimLambdaReducedRankRegress)
    clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
        prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control prediction_delay_APP opt_dim_delay_APP mean_prediction_delay_APP mean_opt_dim_delay_APP ...
        prediction_action_control opt_dim_action_control mean_prediction_action_control mean_opt_dim_action_control y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num

    % Initialize.
    for source = 1:8
        for target = 1:8
            y_session{source}{target} = [];
            opt_dim_session{source}{target} = [];
        end
    end

    for session_num = 1:numel(optDimLambdaReducedRankRegress{animal_num})
        clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
            prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control prediction_delay_APP opt_dim_delay_APP mean_prediction_delay_APP mean_opt_dim_delay_APP ...
            prediction_action_control opt_dim_action_control mean_prediction_action_control mean_opt_dim_action_control y optDimLambdaReducedRankRegress y_animal_session opt_dim_animal_session animal_num ...
            y_session opt_dim_session session_num

        for source = 1:8
            y_temp1{animal_num}{session_num}{source} = [];
            opt_dim_temp1{animal_num}{session_num}{source} = [];
        end
        for source = 1:numel(optDimLambdaReducedRankRegress{animal_num}{session_num})
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

prediction_action_APP = y_animal_session;
opt_dim_action_APP = opt_dim_animal_session;
mean_prediction_action_APP = prediction;
mean_opt_dim_action_APP = opt_dim;
clearvars -except population_regression_control population_regression_APP prediction_stim_control opt_dim_stim_control mean_prediction_stim_control mean_opt_dim_stim_control prediction_stim_APP opt_dim_stim_APP mean_prediction_stim_APP mean_opt_dim_stim_APP ...
    prediction_delay_control opt_dim_delay_control mean_prediction_delay_control mean_opt_dim_delay_control prediction_delay_APP opt_dim_delay_APP mean_prediction_delay_APP mean_opt_dim_delay_APP ...
    prediction_action_control opt_dim_action_control mean_prediction_action_control mean_opt_dim_action_control prediction_action_APP opt_dim_action_APP mean_prediction_action_APP mean_opt_dim_action_APP

% Plot.
% Stimulus.
figure('Position',[200,800,200,200],'Color','w')
imagesc(mean_prediction_stim_control,[-0.01,0.05])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'])

figure('Position',[200,500,200,200],'Color','w')
imagesc(mean_prediction_stim_APP,[-0.01,0.05])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'])

% Delay.
figure('Position',[400,800,200,200],'Color','w')
imagesc(mean_prediction_delay_control,[-0.01,0.05])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'])

figure('Position',[400,500,200,200],'Color','w')
imagesc(mean_prediction_delay_APP,[-0.01,0.05])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'])

% Action.
figure('Position',[600,800,200,200],'Color','w')
imagesc(mean_prediction_action_control,[-0.01,0.05])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'])

figure('Position',[600,500,200,200],'Color','w')
imagesc(mean_prediction_action_APP,[-0.01,0.05])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'])

% Two-way ANOVA.
all_idx = [1:64];
intra_idx = [1:9:64];
inter_idx = all_idx(~ismember(all_idx,intra_idx));
% Prediction.
% Stimulus.
clear intra_inter_group_control_temp intra_inter_group_control data_all group_genotype_all group_intra_inter_all
for source = 1:8
    for target = 1:8
        prediction_stim_control_concat(source,target,:) = prediction_stim_control{source}{target}(:,end);
    end
end
reshaped_prediction_stim_control_concat = reshape(prediction_stim_control_concat,[64,size(prediction_stim_control_concat,3)]);
intra_reshaped_prediction_stim_control_concat = reshaped_prediction_stim_control_concat(intra_idx,:);
inter_reshaped_prediction_stim_control_concat = reshaped_prediction_stim_control_concat(inter_idx,:);
both_prediction_stim_control_concat_temp = [intra_reshaped_prediction_stim_control_concat(:);inter_reshaped_prediction_stim_control_concat(:)];
intra_inter_group_control_temp = [repmat({'intra'},numel(intra_reshaped_prediction_stim_control_concat),1);repmat({'inter'},numel(inter_reshaped_prediction_stim_control_concat),1)];
both_prediction_stim_control_concat = both_prediction_stim_control_concat_temp(find(~isnan(both_prediction_stim_control_concat_temp)));
intra_inter_group_control = intra_inter_group_control_temp(find(~isnan(both_prediction_stim_control_concat_temp)));

for source = 1:8
    for target = 1:8
        prediction_stim_APP_concat(source,target,:) = prediction_stim_APP{source}{target}(:,end);
    end
end
reshaped_prediction_stim_APP_concat = reshape(prediction_stim_APP_concat,[64,size(prediction_stim_APP_concat,3)]);
intra_reshaped_prediction_stim_APP_concat = reshaped_prediction_stim_APP_concat(intra_idx,:);
inter_reshaped_prediction_stim_APP_concat = reshaped_prediction_stim_APP_concat(inter_idx,:);
both_prediction_stim_APP_concat_temp = [intra_reshaped_prediction_stim_APP_concat(:);inter_reshaped_prediction_stim_APP_concat(:)];
intra_inter_group_APP_temp = [repmat({'intra'},numel(intra_reshaped_prediction_stim_APP_concat),1);repmat({'inter'},numel(inter_reshaped_prediction_stim_APP_concat),1)];
both_prediction_stim_APP_concat = both_prediction_stim_APP_concat_temp(find(~isnan(both_prediction_stim_APP_concat_temp)));
intra_inter_group_APP = intra_inter_group_APP_temp(find(~isnan(both_prediction_stim_APP_concat_temp)));

data_all = [both_prediction_stim_control_concat;both_prediction_stim_APP_concat];
group_genotype_all = [repmat({'control'},numel(both_prediction_stim_control_concat),1);repmat({'APP'},numel(both_prediction_stim_APP_concat),1)];
group_intra_inter_all = [intra_inter_group_control;intra_inter_group_APP];
[p_prediction_stim,tbl_prediction_stim,stats_prediction_stim,terms_prediction_stim] = anovan(data_all,{group_genotype_all,group_intra_inter_all},"Model","interaction","Varnames",["genotype","intra_inter"]);

% Delay.
clear intra_inter_group_control_temp intra_inter_group_control data_all group_genotype_all group_intra_inter_all
for source = 1:8
    for target = 1:8
        prediction_delay_control_concat(source,target,:) = prediction_delay_control{source}{target}(:,end);
    end
end
reshaped_prediction_delay_control_concat = reshape(prediction_delay_control_concat,[64,size(prediction_delay_control_concat,3)]);
intra_reshaped_prediction_delay_control_concat = reshaped_prediction_delay_control_concat(intra_idx,:);
inter_reshaped_prediction_delay_control_concat = reshaped_prediction_delay_control_concat(inter_idx,:);
both_prediction_delay_control_concat_temp = [intra_reshaped_prediction_delay_control_concat(:);inter_reshaped_prediction_delay_control_concat(:)];
intra_inter_group_control_temp = [repmat({'intra'},numel(intra_reshaped_prediction_delay_control_concat),1);repmat({'inter'},numel(inter_reshaped_prediction_delay_control_concat),1)];
both_prediction_delay_control_concat = both_prediction_delay_control_concat_temp(find(~isnan(both_prediction_delay_control_concat_temp)));
intra_inter_group_control = intra_inter_group_control_temp(find(~isnan(both_prediction_delay_control_concat_temp)));

for source = 1:8
    for target = 1:8
        prediction_delay_APP_concat(source,target,:) = prediction_delay_APP{source}{target}(:,end);
    end
end
reshaped_prediction_delay_APP_concat = reshape(prediction_delay_APP_concat,[64,size(prediction_delay_APP_concat,3)]);
intra_reshaped_prediction_delay_APP_concat = reshaped_prediction_delay_APP_concat(intra_idx,:);
inter_reshaped_prediction_delay_APP_concat = reshaped_prediction_delay_APP_concat(inter_idx,:);
both_prediction_delay_APP_concat_temp = [intra_reshaped_prediction_delay_APP_concat(:);inter_reshaped_prediction_delay_APP_concat(:)];
intra_inter_group_APP_temp = [repmat({'intra'},numel(intra_reshaped_prediction_delay_APP_concat),1);repmat({'inter'},numel(inter_reshaped_prediction_delay_APP_concat),1)];
both_prediction_delay_APP_concat = both_prediction_delay_APP_concat_temp(find(~isnan(both_prediction_delay_APP_concat_temp)));
intra_inter_group_APP = intra_inter_group_APP_temp(find(~isnan(both_prediction_delay_APP_concat_temp)));

data_all = [both_prediction_delay_control_concat;both_prediction_delay_APP_concat];
group_genotype_all = [repmat({'control'},numel(both_prediction_delay_control_concat),1);repmat({'APP'},numel(both_prediction_delay_APP_concat),1)];
group_intra_inter_all = [intra_inter_group_control;intra_inter_group_APP];
[p_prediction_delay,tbl_prediction_delay,stats_prediction_delay,terms_prediction_delay] = anovan(data_all,{group_genotype_all,group_intra_inter_all},"Model","interaction","Varnames",["genotype","intra_inter"]);

% Action.
clear intra_inter_group_control_temp intra_inter_group_control data_all group_genotype_all group_intra_inter_all
for source = 1:8
    for target = 1:8
        prediction_action_control_concat(source,target,:) = prediction_action_control{source}{target}(:,end);
    end
end
reshaped_prediction_action_control_concat = reshape(prediction_action_control_concat,[64,size(prediction_action_control_concat,3)]);
intra_reshaped_prediction_action_control_concat = reshaped_prediction_action_control_concat(intra_idx,:);
inter_reshaped_prediction_action_control_concat = reshaped_prediction_action_control_concat(inter_idx,:);
both_prediction_action_control_concat_temp = [intra_reshaped_prediction_action_control_concat(:);inter_reshaped_prediction_action_control_concat(:)];
intra_inter_group_control_temp = [repmat({'intra'},numel(intra_reshaped_prediction_action_control_concat),1);repmat({'inter'},numel(inter_reshaped_prediction_action_control_concat),1)];
both_prediction_action_control_concat = both_prediction_action_control_concat_temp(find(~isnan(both_prediction_action_control_concat_temp)));
intra_inter_group_control = intra_inter_group_control_temp(find(~isnan(both_prediction_action_control_concat_temp)));

for source = 1:8
    for target = 1:8
        prediction_action_APP_concat(source,target,:) = prediction_action_APP{source}{target}(:,end);
    end
end
reshaped_prediction_action_APP_concat = reshape(prediction_action_APP_concat,[64,size(prediction_action_APP_concat,3)]);
intra_reshaped_prediction_action_APP_concat = reshaped_prediction_action_APP_concat(intra_idx,:);
inter_reshaped_prediction_action_APP_concat = reshaped_prediction_action_APP_concat(inter_idx,:);
both_prediction_action_APP_concat_temp = [intra_reshaped_prediction_action_APP_concat(:);inter_reshaped_prediction_action_APP_concat(:)];
intra_inter_group_APP_temp = [repmat({'intra'},numel(intra_reshaped_prediction_action_APP_concat),1);repmat({'inter'},numel(inter_reshaped_prediction_action_APP_concat),1)];
both_prediction_action_APP_concat = both_prediction_action_APP_concat_temp(find(~isnan(both_prediction_action_APP_concat_temp)));
intra_inter_group_APP = intra_inter_group_APP_temp(find(~isnan(both_prediction_action_APP_concat_temp)));

data_all = [both_prediction_action_control_concat;both_prediction_action_APP_concat];
group_genotype_all = [repmat({'control'},numel(both_prediction_action_control_concat),1);repmat({'APP'},numel(both_prediction_action_APP_concat),1)];
group_intra_inter_all = [intra_inter_group_control;intra_inter_group_APP];
[p_prediction_action,tbl_prediction_action,stats_prediction_action,terms_prediction_action] = anovan(data_all,{group_genotype_all,group_intra_inter_all},"Model","interaction","Varnames",["genotype","intra_inter"]);

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
% Stimulus.
clearvars -except bregma cortical_area_boundaries region_coordinate ...
    prediction_stim_control prediction_stim_APP prediction_delay_control prediction_delay_APP prediction_action_control prediction_action_APP ...
    mean_prediction_stim_control mean_prediction_stim_APP mean_prediction_delay_control mean_prediction_delay_APP mean_prediction_action_control mean_prediction_action_APP

figure('Position',[900,800,200,200],'Color','k')
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

cMap = [linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'];
temp1 = round(rescale([mean_prediction_stim_control(:);min([mean_prediction_stim_control(:);mean_prediction_stim_APP(:)]);max([mean_prediction_stim_control(:);mean_prediction_stim_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

clearvars -except bregma cortical_area_boundaries region_coordinate ...
    prediction_stim_control prediction_stim_APP prediction_delay_control prediction_delay_APP prediction_action_control prediction_action_APP ...
    mean_prediction_stim_control mean_prediction_stim_APP mean_prediction_delay_control mean_prediction_delay_APP mean_prediction_action_control mean_prediction_action_APP

figure('Position',[900,500,200,200],'Color','k')
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

cMap = [linspace(0,0.47,64)',linspace(0,0.67,64)',linspace(0,0.19,64)'];
temp1 = round(rescale([mean_prediction_stim_APP(:);min([mean_prediction_stim_control(:);mean_prediction_stim_APP(:)]);max([mean_prediction_stim_control(:);mean_prediction_stim_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

% Delay.
clearvars -except bregma cortical_area_boundaries region_coordinate ...
    prediction_stim_control prediction_stim_APP prediction_delay_control prediction_delay_APP prediction_action_control prediction_action_APP ...
    mean_prediction_stim_control mean_prediction_stim_APP mean_prediction_delay_control mean_prediction_delay_APP mean_prediction_action_control mean_prediction_action_APP

figure('Position',[1100,800,200,200],'Color','k')
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

cMap = [linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'];
temp1 = round(rescale([mean_prediction_delay_control(:);min([mean_prediction_delay_control(:);mean_prediction_delay_APP(:)]);max([mean_prediction_delay_control(:);mean_prediction_delay_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

clearvars -except bregma cortical_area_boundaries region_coordinate ...
    prediction_stim_control prediction_stim_APP prediction_delay_control prediction_delay_APP prediction_action_control prediction_action_APP ...
    mean_prediction_stim_control mean_prediction_stim_APP mean_prediction_delay_control mean_prediction_delay_APP mean_prediction_action_control mean_prediction_action_APP

figure('Position',[1100,500,200,200],'Color','k')
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

cMap = [linspace(0,0,64)',linspace(0,0.45,64)',linspace(0,0.74,64)'];
temp1 = round(rescale([mean_prediction_delay_APP(:);min([mean_prediction_delay_control(:);mean_prediction_delay_APP(:)]);max([mean_prediction_delay_control(:);mean_prediction_delay_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

% Action.
clearvars -except bregma cortical_area_boundaries region_coordinate ...
    prediction_stim_control prediction_stim_APP prediction_delay_control prediction_delay_APP prediction_action_control prediction_action_APP ...
    mean_prediction_stim_control mean_prediction_stim_APP mean_prediction_delay_control mean_prediction_delay_APP mean_prediction_action_control mean_prediction_action_APP

figure('Position',[1300,800,200,200],'Color','k')
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

cMap = [linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'];
temp1 = round(rescale([mean_prediction_action_control(:);min([mean_prediction_action_control(:);mean_prediction_action_APP(:)]);max([mean_prediction_action_control(:);mean_prediction_action_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

clearvars -except bregma cortical_area_boundaries region_coordinate ...
    prediction_stim_control prediction_stim_APP prediction_delay_control prediction_delay_APP prediction_action_control prediction_action_APP ...
    mean_prediction_stim_control mean_prediction_stim_APP mean_prediction_delay_control mean_prediction_delay_APP mean_prediction_action_control mean_prediction_action_APP

figure('Position',[1300,500,200,200],'Color','k')
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

cMap = [linspace(0,0.64,64)',linspace(0,0.08,64)',linspace(0,0.18,64)'];
temp1 = round(rescale([mean_prediction_action_APP(:);min([mean_prediction_action_control(:);mean_prediction_action_APP(:)]);max([mean_prediction_action_control(:);mean_prediction_action_APP(:)])],1,64));
temp2 = temp1(1:end - 2);
color_idx = reshape(temp2,[8,8]);

region_coordinate_corrected = (region_coordinate + 250)/10;
for region_num1 = 1:8
    for region_num2 = 1:8
        line([region_coordinate_corrected(region_num1,1),region_coordinate_corrected(region_num2,1)],[region_coordinate_corrected(region_num1,2),region_coordinate_corrected(region_num2,2)],'LineWidth',color_idx(region_num1,region_num2)/5,'Color',cMap(color_idx(region_num1,region_num2),:))
    end
end
for region_num = 1:8
    plot(region_coordinate_corrected(region_num,1),region_coordinate_corrected(region_num,2),'o','MarkerSize',color_idx(region_num,region_num)*0.2,'MarkerFaceColor',cMap(color_idx(region_num,region_num),:),'MarkerEdgeColor','None')
end

% Statistics.
rng(0)
for source = 1:8
    for target = 1:8
        prediction_stim_control_full{source}{target} = prediction_stim_control{source}{target}(:,end);
        prediction_stim_APP_full{source}{target} = prediction_stim_APP{source}{target}(:,end);
        prediction_delay_control_full{source}{target} = prediction_delay_control{source}{target}(:,end);
        prediction_delay_APP_full{source}{target} = prediction_delay_APP{source}{target}(:,end);
        prediction_action_control_full{source}{target} = prediction_action_control{source}{target}(:,end);
        prediction_action_APP_full{source}{target} = prediction_action_APP{source}{target}(:,end);
    end
end

for source = 1:8
    for target = 1:8
        prediction_stim_control{source}{target} = prediction_stim_control_full{source}{target}(~isnan(prediction_stim_control_full{source}{target}));
        prediction_stim_APP{source}{target} = prediction_stim_APP_full{source}{target}(~isnan(prediction_stim_APP_full{source}{target}));
        prediction_delay_control{source}{target} = prediction_delay_control_full{source}{target}(~isnan(prediction_delay_control_full{source}{target}));
        prediction_delay_APP{source}{target} = prediction_delay_APP_full{source}{target}(~isnan(prediction_delay_APP_full{source}{target}));
        prediction_action_control{source}{target} = prediction_action_control_full{source}{target}(~isnan(prediction_action_control_full{source}{target}));
        prediction_action_APP{source}{target} = prediction_action_APP_full{source}{target}(~isnan(prediction_action_APP_full{source}{target}));
    end
end

for source = 1:8
    for target = 1:8
        % Stimulus.
        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(prediction_stim_control{source}{target})
                sampled_prediction_stim_control{source}{target}(shuffle_num,session_num) = prediction_stim_control{source}{target}(randi(numel(prediction_stim_control{source}{target})));
            end
            for session_num = 1:numel(prediction_stim_APP{source}{target})
                sampled_prediction_stim_APP{source}{target}(shuffle_num,session_num) = prediction_stim_APP{source}{target}(randi(numel(prediction_stim_APP{source}{target})));
            end
        end
        p_value_stim(source,target) = sum(mean(sampled_prediction_stim_control{source}{target},2) < mean(sampled_prediction_stim_APP{source}{target},2))/1000;

        % Delay.
        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(prediction_delay_control{source}{target})
                sampled_prediction_delay_control{source}{target}(shuffle_num,session_num) = prediction_delay_control{source}{target}(randi(numel(prediction_delay_control{source}{target})));
            end
            for session_num = 1:numel(prediction_delay_APP{source}{target})
                sampled_prediction_delay_APP{source}{target}(shuffle_num,session_num) = prediction_delay_APP{source}{target}(randi(numel(prediction_delay_APP{source}{target})));
            end
        end
        p_value_delay(source,target) = sum(mean(sampled_prediction_delay_control{source}{target},2) < mean(sampled_prediction_delay_APP{source}{target},2))/1000;

        % Action.
        % Bootstrap.
        for shuffle_num = 1:1000
            for session_num = 1:numel(prediction_action_control{source}{target})
                sampled_prediction_action_control{source}{target}(shuffle_num,session_num) = prediction_action_control{source}{target}(randi(numel(prediction_action_control{source}{target})));
            end
            for session_num = 1:numel(prediction_action_APP{source}{target})
                sampled_prediction_action_APP{source}{target}(shuffle_num,session_num) = prediction_action_APP{source}{target}(randi(numel(prediction_action_APP{source}{target})));
            end
        end
        p_value_action(source,target) = sum(mean(sampled_prediction_action_control{source}{target},2) < mean(sampled_prediction_action_APP{source}{target},2))/1000;
    end
end

% False discovery rate.
% Stimulus.
clear val idx adjusted_p_value_005 adjusted_p_value_001 adjusted_p_value_0001 significant_comparison_idx_005 significant_comparison_idx_001 significant_comparison_idx_0001 vector
[val,idx] = sort(p_value_stim(:));
adjusted_p_value_005 = ((1:numel(p_value_stim(:)))*0.05)/numel(p_value_stim(:));
adjusted_p_value_001 = ((1:numel(p_value_stim(:)))*0.01)/numel(p_value_stim(:));
adjusted_p_value_0001 = ((1:numel(p_value_stim(:)))*0.001)/numel(p_value_stim(:));
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value_stim(:)),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

p_value_matrix_stim = reshape(vector,[8,8]);

% Delay.
clear val idx adjusted_p_value_005 adjusted_p_value_001 adjusted_p_value_0001 significant_comparison_idx_005 significant_comparison_idx_001 significant_comparison_idx_0001 vector
[val,idx] = sort(p_value_delay(:));
adjusted_p_value_005 = ((1:numel(p_value_delay(:)))*0.05)/numel(p_value_delay(:));
adjusted_p_value_001 = ((1:numel(p_value_delay(:)))*0.01)/numel(p_value_delay(:));
adjusted_p_value_0001 = ((1:numel(p_value_delay(:)))*0.001)/numel(p_value_delay(:));
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value_delay(:)),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

p_value_matrix_delay = reshape(vector,[8,8]);

% Action.
clear val idx adjusted_p_value_005 adjusted_p_value_001 adjusted_p_value_0001 significant_comparison_idx_005 significant_comparison_idx_001 significant_comparison_idx_0001 vector
[val,idx] = sort(p_value_action(:));
adjusted_p_value_005 = ((1:numel(p_value_action(:)))*0.05)/numel(p_value_action(:));
adjusted_p_value_001 = ((1:numel(p_value_action(:)))*0.01)/numel(p_value_action(:));
adjusted_p_value_0001 = ((1:numel(p_value_action(:)))*0.001)/numel(p_value_action(:));
significant_comparison_idx_005 = idx(val < adjusted_p_value_005');
significant_comparison_idx_001 = idx(val < adjusted_p_value_001');
significant_comparison_idx_0001 = idx(val < adjusted_p_value_0001');

vector = zeros(numel(p_value_action(:)),1);
vector(significant_comparison_idx_005) = 1;
vector(significant_comparison_idx_001) = 2;
vector(significant_comparison_idx_0001) = 3;

p_value_matrix_action = reshape(vector,[8,8]);

% Plot.
figure('Position',[200,200,200,200],'Color','w')
imagesc(p_value_matrix_stim,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

figure('Position',[400,200,200,200],'Color','w')
imagesc(p_value_matrix_delay,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

figure('Position',[600,200,200,200],'Color','w')
imagesc(p_value_matrix_action,[0,3])
axis square
xlabel('');
ylabel('');
axis off
colormap([linspace(0,1,64)',linspace(0,1,64)',linspace(0,1,64)'])

end