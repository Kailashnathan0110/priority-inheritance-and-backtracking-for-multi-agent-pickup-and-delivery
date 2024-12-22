    clc; clear; close all;
    
    % Parameters
    gridSize = 10;                   % Size of the grid (10x10)
    numAgentsList = 5:5:50;          % Varying number of agents
    numTasks = 500;                  % Total number of tasks
    taskFrequency = 1;               % Number of tasks added per timestep
    maxTimesteps = 1000;             % Maximum number of timesteps
    epsilon = 0.1;                   % Small constant to avoid division by zero
    
    % Initialize Results
    runtimeList = zeros(size(numAgentsList)); % Store runtimes
    
    % Directions for movement
    directions = [0 1; 1 0; 0 -1; -1 0]; % Possible moves (up, right, down, left)
    
    % Loop through different agent configurations
    for idx = 1:length(numAgentsList)
        numAgents = numAgentsList(idx);
        agents = randi([1 gridSize], numAgents, 2); % Initial positions [x, y]
        goals = randi([1 gridSize], numAgents, 2);  % Random initial goals for agents
        tasks = [randi([1 gridSize], numTasks, 2), randi([1 gridSize], numTasks, 2)]; % [pickup, delivery]
        taskStatus = zeros(numTasks, 1); % 0 = unassigned, 1 = in-progress, 2 = completed
        taskAssignments = zeros(numAgents, 1); % Track assigned task for each agent
    
        % Start timer
        tic;
    
        for t = 1:maxTimesteps
            % Task assignment for free agents
            for i = 1:numAgents
                if taskAssignments(i) == 0 && any(taskStatus == 0)
                    taskIdx = find(taskStatus == 0, 1); % Find first unassigned task
                    taskAssignments(i) = taskIdx;
                    taskStatus(taskIdx) = 1; % Mark task as in-progress
                end
            end
    
            % Move agents towards their tasks (or goals if delivering)
            for i = 1:numAgents
                if taskAssignments(i) > 0
                    taskIdx = taskAssignments(i);
    
                    % Determine target: pickup or delivery
                    if isequal(agents(i, :), tasks(taskIdx, 1:2)) % If at pickup point
                        goals(i, :) = tasks(taskIdx, 3:4); % Set delivery point
                    else
                        goals(i, :) = tasks(taskIdx, 1:2); % Set pickup point
                    end
    
                    % Compute move direction
                    attraction = goals(i, :) - agents(i, :);
                    if norm(attraction) > 0
                        moveVector = round(attraction / norm(attraction)); % Quantized move
                    else
                        moveVector = [0, 0]; % Stay in place
                    end
    
                    % Update position
                    newPosition = agents(i, :) + moveVector;
    
                    % Ensure position is valid
                    if all(newPosition > 0 & newPosition <= gridSize)
                        agents(i, :) = newPosition;
                    end
    
                    % Check if delivery is completed
                    if isequal(agents(i, :), tasks(taskIdx, 3:4))
                        taskStatus(taskIdx) = 2; % Mark task as completed
                        taskAssignments(i) = 0; % Free the agent
                    end
                end
            end
    
            % Check for completion
            if all(taskStatus == 2)
                break;
            end
        end
    
        % Stop timer and record runtime
        runtimeList(idx) = toc;
    end
    
    % Plot the results
    figure;
    plot(numAgentsList, runtimeList, '-o', 'LineWidth', 2);
    xlabel('Number of Agents');
    ylabel('Total Runtime (seconds)');
    title('Runtime of PIBT Algorithm vs Number of Agents');
    grid on;
