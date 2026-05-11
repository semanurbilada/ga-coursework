%% Fitness Function
% Network Topology Optimization Fitness Function
% Input: x = [x1, y1, x2, y2, ..., xn, yn] (node coordinates)
% Output: score = fitness value (to be minimized)
% Objective:
%   - Minimize traffic-weighted communication cost
%   - Enforce connectivity constraints (max distance)
%   - Prevent node overlap (min separation)
%   - Maintain mandatory routing links
function score = fitness_network(x)
% Convert vector into coordinate matrix [x y]
coords = reshape(x, [], 2); 
n = size(coords,1);

%% Lookup Table (Node properties)
% Node properties: [traffic, jitter_weight]
% Automatically generated based on number of nodes
nodeProps = [ ...
    randi([1 5], n, 1), ... % Traffic, importance of node (1–5)
    0.5 + rand(n,1)         % Jitter weight (0.5–1.5)
];

%% Mandatory routing links (must remain connected)
% Node 1 acts as a central gateway
mandatoryLinks = [(1*ones(n-1,1)) (2:n)'];

% Sanity check (optional)
if size(nodeProps,1) ~= n
    error('nodeProps size must match number of nodes');
end

%% Distance constraints
maxDist = 40;        % Maximum allowed communication distance
minSeparation = 5;   % Minimum distance to prevent overlap

%% Initialize cost terms
totalCost = 0;              % Communication cost
connectivityPenalty = 0;    % Penalty for long links
overlapPenalty = 0;         % Penalty for overlapping nodes

%% Evaluate all node pairs
for i = 1:n
    for j = i+1:n
        d = norm(coords(i,:) - coords(j,:));  % Euclidean distance

        % Traffic-aware cost (important nodes get higher weight)
        trafficWeight = nodeProps(i,1) + nodeProps(j,1);
        totalCost = totalCost + trafficWeight * d;

        % Penalty if nodes are too far apart (breaks connectivity)
        if d > maxDist
            connectivityPenalty = connectivityPenalty + 200;
        end

        % Penalty if nodes are too close (physical overlap)
        if d < minSeparation
            overlapPenalty = overlapPenalty + 1000;
        end
    end
end

%% Enforce mandatory routing constraints
for k = 1:size(mandatoryLinks,1)
    i = mandatoryLinks(k,1);
    j = mandatoryLinks(k,2);
    d = norm(coords(i,:) - coords(j,:));

    % Additional penalty if mandatory link is broken
    if d > maxDist
        connectivityPenalty = connectivityPenalty + 500;
    end
end

%% Final fitness score (lower is better)
score = totalCost + connectivityPenalty + overlapPenalty;
end