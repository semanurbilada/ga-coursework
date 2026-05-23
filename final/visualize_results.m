function visualize_results(x_best, fval, nNodes, outputDir, coords, timestamp, traffic, capacityMatrix)

route = round(x_best);
route = route([true diff(route)~=0]); % remove repeats
route(1) = 1;
route(end) = 6;

figure;
scatter(coords(:,1), coords(:,2), 200, 'filled');
hold on;

% node labels
for i = 1:nNodes
    text(coords(i,1)+2, coords(i,2)+2, ['Node ' num2str(i)]);
end

% draw route
for i = 1:length(route)-1
    plot([coords(route(i),1), coords(route(i+1),1)], ...
         [coords(route(i),2), coords(route(i+1),2)], ...
         'r-', 'LineWidth', 2);
end

title('Routing Optimization (GA)');
grid on;

% save
fileName = sprintf('routing_%dnodes_%s.png', nNodes, timestamp);
exportgraphics(gcf, fullfile(outputDir, fileName), 'Resolution', 300);

fprintf('\nOptimal Route:\n');
disp(route);
fprintf('Total Cost: %.2f\n', fval);

fprintf('\n--- ROUTE DETAILS ---\n');

for i = 1:length(route)-1
    nodeA = route(i);
    nodeB = route(i+1);

    d = norm(coords(nodeA,:) - coords(nodeB,:));
    trafficWeight = (traffic(nodeA) + traffic(nodeB))/2;
    capacity = capacityMatrix(nodeA, nodeB);

    fprintf('Link %d -> %d | Dist: %.2f | Traffic: %.2f | Capacity: %d\n', ...
        nodeA, nodeB, d, trafficWeight, capacity);
end

fprintf('----------------------\n');

end