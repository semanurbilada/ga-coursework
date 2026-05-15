function score = fitness_routing(route, coords, traffic)

n = size(coords,1);

% Round to integer
route = round(route);

% Clamp values (extra safety)
route(route < 1) = 1;
route(route > n) = n;

% Remove duplicates
route = unique(route, 'stable');

% Ensure start and end nodes
route(1) = 1;
route(end) = 6;

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

    % Traffic-aware cost
    trafficWeight = (traffic(nodeA) + traffic(nodeB)) / 2;
    totalCost = totalCost + d * trafficWeight;

    % Connectivity constraint
    if d > maxDist
        penalty = penalty + 200;
    end
end

% Penalize repeated nodes (bad routing)
if length(route) < 3
    penalty = penalty + 500;
end

score = totalCost + penalty;

end