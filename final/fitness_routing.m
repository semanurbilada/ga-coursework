function score = fitness_routing(route, coords)

n = size(coords,1);

% Round to nearest integer node index
route = round(route);

% Force start and end nodes
route(1) = 1;     % source
route(end) = 6;   % destination

maxDist = 40;

totalCost = 0;
penalty = 0;

for i = 1:length(route)-1
    
    nodeA = route(i);
    nodeB = route(i+1);

    % Prevent invalid indices
    if nodeA < 1 || nodeA > n || nodeB < 1 || nodeB > n
        penalty = penalty + 1000;
        continue;
    end

    % Compute distance
    d = norm(coords(nodeA,:) - coords(nodeB,:));

    totalCost = totalCost + d;

    % Connectivity constraint
    if d > maxDist
        penalty = penalty + 200;
    end
end

% Penalize repeated nodes (bad routing)
if length(unique(route)) < length(route)
    penalty = penalty + 500;
end

score = totalCost + penalty;
end