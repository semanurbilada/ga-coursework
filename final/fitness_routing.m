function score = fitness_routing(route, coords, traffic, adjMatrix, capacityMatrix)

n = size(coords,1);

% Round to integer
route = round(route);

% Clamp values (extra safety)
route(route < 1) = 1;
route(route > n) = n;
% remove only consecutive duplicates
route = route([true diff(route)~=0]);

% Force start & end
route(1) = 1;
route(end) = 6;

totalCost = 0;
penalty = 0;

for i = 1:length(route)-1
    
    nodeA = route(i);
    nodeB = route(i+1);

    % Check connectivity using adjacency matrix
    if adjMatrix(nodeA, nodeB) == 0
        penalty = penalty + 150;
    end

    % Compute distance
    d = norm(coords(nodeA,:) - coords(nodeB,:));

    % Traffic-aware cost
    trafficWeight = (traffic(nodeA) + traffic(nodeB)) / 2;

    % Capacity constraint
    capacity = capacityMatrix(nodeA, nodeB);
    
    if capacity < trafficWeight
        penalty = penalty + 200;  % congestion penalty
    end

    totalCost = totalCost + d * trafficWeight;
end

% Penalize short route
if length(route) < 3
    penalty = penalty + 500;
end

score = totalCost + penalty;

end