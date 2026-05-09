function visualize_results(x_best, fval, nNodes, outputDir)

coords = reshape(x_best, [], 2);

fig = figure('Position', [100, 100, 1200, 500]);

%% Graph 1: Optimized Network Topology
subplot(1, 2, 1);
scatter(coords(:,1), coords(:,2), 200, 'filled', 'MarkerFaceColor', 'b');
hold on;

for i = 1:nNodes
    text(coords(i,1)+2, coords(i,2)+2, ...
        ['Node ' num2str(i)], 'FontSize', 10);
end

title('Optimized Network Topology', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('X Coordinate');
ylabel('Y Coordinate');
grid on;
axis([0 100 0 100]);

for i = 1:nNodes
    for j = i+1:nNodes
        d = norm(coords(i,:) - coords(j,:));
        if d <= 40
            plot([coords(i,1), coords(j,1)], ...
                 [coords(i,2), coords(j,2)], ...
                 'k--', 'LineWidth', 1.5);
        end
    end
end

%% Graph 2: Distance Distribution
subplot(1, 2, 2);
distances = [];

for i = 1:nNodes
    for j = i+1:nNodes
        distances = [distances, norm(coords(i,:) - coords(j,:))];
    end
end

histogram(distances, 10, 'FaceColor', 'cyan');
title('Distance Distribution', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Distance (unit)');
ylabel('Frequency');
hold on;
xline(40, 'r--', 'LineWidth', 2, 'Label', 'Max Connectivity (40)');

exportgraphics(fig, ...
    fullfile(outputDir, 'network_topology_results.png'), ...
    'Resolution', 300);

%% Command Window Output
fprintf('\n========================================\n');
fprintf('NETWORK TOPOLOGY OPTIMIZATION\n');
fprintf('========================================\n\n');

fprintf('Optimal Coordinates:\n');
for i = 1:nNodes
    fprintf('Node %d: (%.2f, %.2f)\n', ...
        i, coords(i,1), coords(i,2));
end

fprintf('\nDistance Summary:\n');
fprintf('Total Distance: %.2f\n', sum(distances));
fprintf('Average Distance: %.2f\n', mean(distances));
fprintf('Min Distance: %.2f\n', min(distances));
fprintf('Max Distance: %.2f\n', max(distances));

fprintf('\nFitness Value (Best): %.2f\n', fval);
fprintf('Connectivity Penalty: ');
penalty_count = sum(distances > 40);
fprintf('%d (40 units and above %d connection)\n', ...
        penalty_count*100, penalty_count);

fprintf('\n========================================\n');
end