clc; clear; close all;

% Parameters
numAgents = 5;                  % Number of agents
gridSize = 10;                  % Size of the grid (10x10)
maxTimesteps = 100;             % Maximum number of timesteps
epsilon = 0.1;                  % Small constant to avoid division by zero
k_attr = 1;                     % Attraction scaling factor
k_rep = 2;                      % Repulsion scaling factor
threshold = 2;                  % Distance threshold for repulsion

% Initialize Agents and Goals
agents = randi([1 gridSize], numAgents, 2); % Initial positions [x, y]
goals = randi([1 gridSize], numAgents, 2);  % Goal positions [x, y]
traces = cell(numAgents, 1);               % Store paths for trace lines

for i = 1:numAgents
    traces{i} = agents(i, :); % Initialize traces with starting positions
end

% Visualization Setup
figure;
hold on;
hAgents = scatter(agents(:, 1), agents(:, 2), 'filled');
hGoals = scatter(goals(:, 1), goals(:, 2), 'x');
xlim([0.5, gridSize + 0.5]);
ylim([0.5, gridSize + 0.5]);
grid on;
set(gca, 'XTick', 1:gridSize, 'YTick', 1:gridSize);
title('Repulsive Potential Field Control with Trace Lines');
legend('Agents', 'Goals');

% Plot Trace Lines
tracePlots = gobjects(numAgents, 1);
for i = 1:numAgents
    tracePlots(i) = plot(traces{i}(:, 1), traces{i}(:, 2), '-');
end

% Simulation Loop
for t = 1:maxTimesteps
    % Initialize new positions
    newPositions = agents;
    
    for i = 1:numAgents
        % If the agent has reached its goal, skip it
        if isequal(agents(i, :), goals(i, :))
            continue;
        end
        
        % Compute Attractive Potential
        attraction = k_attr * (goals(i, :) - agents(i, :));
        if norm(attraction) > 0
            attraction = attraction / norm(attraction); % Normalize
        end
        
        % Compute Repulsive Potential
        repulsion = [0, 0];
        for j = 1:numAgents
            if i ~= j
                diff = agents(i, :) - agents(j, :);
                dist = norm(diff);
                if dist < threshold && dist > 0 % Repulsion if within threshold
                    repulsion = repulsion + k_rep * diff / (dist^2 + epsilon);
                end
            end
        end
        
        % Normalize repulsion if it exists
        if norm(repulsion) > 0
            repulsion = repulsion / norm(repulsion);
        end
        
        % Total Control Input
        control = attraction + repulsion;
        if norm(control) > 0
            control = round(control / norm(control)); % Quantize to grid directions
        end
        
        % Update Position
        nextPosition = agents(i, :) + control;
        
        % Ensure new position is within bounds
        if all(nextPosition > 0 & nextPosition <= gridSize)
            newPositions(i, :) = nextPosition;
        end
    end
    
    % Check for collisions and resolve them
    for i = 1:numAgents
        conflicting = find(ismember(newPositions, newPositions(i, :), 'rows'));
        if numel(conflicting) > 1
            % Revert to previous position if conflict occurs
            newPositions(conflicting, :) = agents(conflicting, :);
        end
    end
    
    % Update agent positions
    agents = newPositions;
    
    % Update Traces
    for i = 1:numAgents
        traces{i} = [traces{i}; agents(i, :)];
        set(tracePlots(i), 'XData', traces{i}(:, 1), 'YData', traces{i}(:, 2));
    end
    
    % Update Visualization
    hAgents.XData = agents(:, 1);
    hAgents.YData = agents(:, 2);
    pause(1); % Slower visualization
    
    % Check if all agents have reached their goals
    if all(agents == goals, 'all')
        title(sprintf('Simulation Complete at Timestep %d', t));
        break;
    end
end

title('Simulation Ended');
