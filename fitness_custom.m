%% Run
fitnessFcn = @fitness_network;
[x_best, fval] = ga(fitnessFcn, nvars, [], [], [], [], lb, ub, [], options);

%% Fitness Function
% Network Topology Optimization Fitness Function
% Input: x = [x1, y1, x2, y2, x3, y3, ...] (coordinates)
% Output: score = fitness value (target to reduce)
% Target:
% 1. Minimize total distance (energy saving)
% 2. Nodes should not be more than 40 units apart (connectivity)
function score = fitness_network(x)
    % Convert coordinates to 2D shape: [x1 y1; x2 y2; ...]
    coords = reshape(x, [], 2);
    n = size(coords, 1);     % Node count
    
    totalDistance = 0;       % Total distance (minimize)
    connectivityPenalty = 0;
    
    % Calculate the distance between all node pairs
    for i = 1:n
        for j = i+1:n
            % Euclidean distance: sqrt((x2-x1)² + (y2-y1)²)
            distance = norm(coords(i,:) - coords(j,:));
            
            % Add to total distance (to minimize)
            totalDistance = totalDistance + distance;
            
            % Connectivity constraint: Penalty if it's too far
            if distance > 40
                % A penalty of 100 for each unit exceeding 40 units
                connectivityPenalty = connectivityPenalty + 100;
            end
        end
    end
    
    % Total fitness score
    score = totalDistance + connectivityPenalty;
    % Low score = good network
    % High score = bad network (too far away or penalized)
end