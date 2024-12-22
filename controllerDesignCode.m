clc; clear; close all;

% Parameters
numAgents = 20;                  % Number of agents
gridSize = 10;                   % Size of the grid (10x10)
maxTimesteps = 100;              % Maximum number of timesteps
directions = [0 1; 1 0; 0 -1; -1 0]; % Possible moves (up, right, down, left)
epsilon = 0.1;                   % Small constant for potential scaling

% Initialize Grid, Agents, Goals
agents = randi([1 gridSize], numAgents, 2); % Initial positions [x, y]
goals = randi([1 gridSize], numAgents, 2);  % Goal positions [x, y]
priorities = rand(numAgents, 1);           % Random initial priorities

% Visualization Setup
figure;
h = scatter(agents(:, 1), agents(:, 2), 'filled');
hold on;
scatter(goals(:, 1), goals(:, 2), 'x');
xlim([0.5, gridSize + 0.5]);
ylim([0.5, gridSize + 0.5]);
grid on;
set(gca, 'XTick', 1:gridSize, 'YTick', 1:gridSize);
title('Controller Design for PIBT Agents');

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

    % Control Law
    newPositions = agents;
    for i = 1:numAgents
        if ~isequal(agents(i, :), goals(i, :))
            % Compute potential field
            attraction = goals(i, :) - agents(i, :);
            attraction = attraction / norm(attraction);

            % Compute repulsion
            repulsion = [0, 0];
            for j = 1:numAgents
                if i ~= j
                    diff = agents(i, :) - agents(j, :);
                    dist = norm(diff);
                    if dist < 2 % Threshold for repulsion
                        repulsion = repulsion + diff / (dist^2 + epsilon);
                    end
                end
            end

            % Combine attraction and repulsion
            moveVector = attraction + repulsion;
            moveVector = round(moveVector / norm(moveVector)); % Quantize to grid directions

            % Determine next position
            nextPosition = agents(i, :) + moveVector;
            if all(nextPosition > 0 & nextPosition <= gridSize, 2) % Ensure within bounds
                newPositions(i, :) = nextPosition;
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
    h.XData = agents(:, 1);
    h.YData = agents(:, 2);
    pause(0.1);

    % Check termination
    if all(agents == goals, 'all')
        title(sprintf('Simulation Complete at Timestep %d', t));
        break;
    end
end

title('Simulation Ended');
