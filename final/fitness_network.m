%% Fitness Function
% Network Topology Optimization Fitness Function
% Input: x = [x1, y1, x2, y2, x3, y3, ...] (coordinates)
% Output: score = fitness value (target to reduce)
% Target:
% 1. Minimize total distance (energy saving)
% 2. Nodes should not be more than 40 units apart (connectivity)
function score = fitness_network(x)

coords = reshape(x, [], 2);
n = size(coords,1);

% Node properties: [traffic, jitter_weight]
nodeProps = [
    5 1.2;
    3 1.0;
    4 1.1;
    2 0.8;
    1 0.6
];

mandatoryLinks = [
    1 2;
    1 3;
    1 4;
    1 5
];

maxDist = 40;
minSeparation = 5;

totalCost = 0;
connectivityPenalty = 0;
overlapPenalty = 0;

for i = 1:n
    for j = i+1:n
        d = norm(coords(i,:) - coords(j,:));

        % Traffic-weighted distance
        trafficWeight = nodeProps(i,1) + nodeProps(j,1);
        totalCost = totalCost + trafficWeight * d;

        % Too far penalty
        if d > maxDist
            connectivityPenalty = connectivityPenalty + 200;
        end

        % Overlap prevention
        if d < minSeparation
            overlapPenalty = overlapPenalty + 1000;
        end
    end
end

% Mandatory routing constraint
for k = 1:size(mandatoryLinks,1)
    i = mandatoryLinks(k,1);
    j = mandatoryLinks(k,2);
    d = norm(coords(i,:) - coords(j,:));
    if d > maxDist
        connectivityPenalty = connectivityPenalty + 500;
    end
end

score = totalCost + connectivityPenalty + overlapPenalty;
end