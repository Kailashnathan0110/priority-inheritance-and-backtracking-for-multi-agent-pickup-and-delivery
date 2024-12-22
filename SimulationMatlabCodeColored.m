clc; clear; close all;

% Parameters
numAgents = 10;                  % Number of agents
gridSize = 20;                   % Size of the grid (10x10)
maxTimesteps = 100;              % Maximum number of timesteps
goalTolerance = 0;               % Tolerance for reaching the goal

% Initialize Grid, Agents, Goals
grid = zeros(gridSize);          % Grid representation
agents = randi([1 gridSize], numAgents, 2); % Initial positions [x, y]
goals = randi([1 gridSize], numAgents, 2);  % Goal positions [x, y]
priorities = rand(numAgents, 1); % Random initial priorities
directions = [0 1; 1 0; 0 -1; -1 0]; % Possible moves (up, right, down, left)

% Assign unique colors to each agent
colors = lines(numAgents); % Generate a colormap for agents

% Visualization Setup
figure;
hold on;
hAgents = gobjects(numAgents, 1); % Array to hold scatter handles for agents
for i = 1:numAgents
    hAgents(i) = scatter(agents(i, 1), agents(i, 2), 100, 'filled', 'MarkerFaceColor', colors(i, :));
end
scatter(goals(:, 1), goals(:, 2), 100, 'x', 'k', 'LineWidth', 1.5); % Goals in black
xlim([0.5, gridSize + 0.5]);
ylim([0.5, gridSize + 0.5]);
grid on;
set(gca, 'XTick', 1:gridSize, 'YTick', 1:gridSize);
title('PIBT Algorithm Simulation');

% Simulation Loop
for t = 1:maxTimesteps
    % Update priorities without reordering agents
    for i = 1:numAgents
        if isequal(agents(i, :), goals(i, :))
            priorities(i) = rand(); % Reset priority if at goal
        else
            priorities(i) = priorities(i) + 1;
        end
    end

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

    % Update visualization
    for i = 1:numAgents
        hAgents(i).XData = agents(i, 1);
        hAgents(i).YData = agents(i, 2);
    end
    pause(0.1);

    % Check termination
    if all(agents == goals, 'all')
        title(sprintf('Simulation Complete at Timestep %d', t));
        break;
    end
end

title('Simulation Ended');
hold off;
