clc; clear; close all;

% Parameters
gridSize = 50;                   % Size of the grid (30x30)
maxTimesteps = 100;              % Maximum number of timesteps
numTrials = 50;                  % Number of trials per agent count
agentCounts = 5:5:50;            % Varying number of agents
successRates = zeros(size(agentCounts)); % Store success rates

% Directions for movement
directions = [0 1; 1 0; 0 -1; -1 0]; % Possible moves (up, right, down, left)

% Simulate for varying numbers of agents
for aIdx = 1:length(agentCounts)
    numAgents = agentCounts(aIdx);
    successCount = 0;

    for trial = 1:numTrials
        % Initialize Agents and Goals
        agents = randi([1 gridSize], numAgents, 2); % Initial positions [x, y]
        goals = randi([1 gridSize], numAgents, 2);  % Goal positions [x, y]
        priorities = rand(numAgents, 1);           % Random initial priorities

        success = false;

        % Simulation Loop
        for t = 1:maxTimesteps
            % Update priorities
            for i = 1:numAgents
                if isequal(agents(i, :), goals(i, :))
                    priorities(i) = rand(); % Reset priority if at goal
                else
                    priorities(i) = priorities(i) + 1;
                end
            end

            % Sort agents by priorities (descending)
            [~, order] = sort(priorities, 'descend');
            agents = agents(order, :);
            goals = goals(order, :);

            % Plan moves
            newPositions = agents;
            for i = 1:numAgents
                if ~isequal(agents(i, :), goals(i, :))
                    % Compute valid moves
                    candidatePositions = agents(i, :) + directions;
                    candidatePositions = candidatePositions(all(candidatePositions > 0 & candidatePositions <= gridSize, 2), :);

                    % Remove conflicts
                    candidatePositions = setdiff(candidatePositions, newPositions, 'rows');

                    % Choose closest move to goal
                    if ~isempty(candidatePositions)
                        [~, idx] = min(vecnorm(candidatePositions - goals(i, :), 2, 2));
                        newPositions(i, :) = candidatePositions(idx, :);
                    end
                end
            end

            % Resolve conflicts with priority inheritance
            for i = 1:numAgents
                conflicting = find(ismember(newPositions, newPositions(i, :), 'rows'));
                if numel(conflicting) > 1
                    [~, highest] = max(priorities(conflicting));
                    newPositions(conflicting(conflicting ~= conflicting(highest)), :) = agents(conflicting(conflicting ~= conflicting(highest)), :);
                end
            end

            % Update positions
            agents = newPositions;

            % Check termination
            if all(agents == goals, 'all')
                success = true;
                break;
            end
        end

        % Record success
        if success
            successCount = successCount + 1;
        end
    end

    % Compute success rate
    successRates(aIdx) = successCount / numTrials;
end

% Plot Success Rate
figure;
plot(agentCounts, successRates, '-o', 'LineWidth', 2);
xlabel('Number of Agents');
ylabel('Success Rate');
title('Success Rate of PIBT Algorithm vs. Number of Agents');
ylim([0 1]);
grid on;
