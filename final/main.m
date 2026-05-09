%% Network Topology Optimization
% Goal: Find the optimal physical placement of 5 computers
% Optimize x,y coordinates with GA
% Constraint: Computers should not be more than 40 units apart
clc; clear; close all;

outputDir = '../outputs';

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% Parameters
nNodes = 5;                 % Node count (computer)
nvars = nNodes * 2;         % Variable count (x1,y1,x2,y2,...)
lb = zeros(1, nvars);       % Lower limit: 0
ub = ones(1, nvars) * 100;  % Upper limit: 100

%% Configs
options = gaoptimset(...
    'PopulationSize', 50, ...       % Population size
    'Generations', 200, ...         % Generation count
    'Display', 'iter', ...          % Print at each iteration
    'PlotFcn', @gaplotbestf);       % Convergence graph

%% Run
fitnessFcn = @fitness_network;
[x_best, fval] = ga(fitnessFcn, nvars, [], [], [], [], lb, ub, [], options);

figure(1);
title('GA Convergence Plot - Best Fitness per Generation');

exportgraphics(gcf, ...
    fullfile(outputDir, 'convergence_plot.png'), ...
    'Resolution', 300);

%% Visualize results
coords = reshape(x_best, [], 2);

fig2 = figure('Position', [100, 100, 1200, 500]);

% Graph 1: Network Tolopogy
subplot(1, 2, 1);
scatter(coords(:,1), coords(:,2), 200, 'filled', 'MarkerFaceColor', 'b');
hold on;

for i = 1:nNodes
    text(coords(i,1)+2, coords(i,2)+2, ['Node ' num2str(i)], 'FontSize', 10);
end

title('Optimized Network Topology', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('X Coordinate');
ylabel('Y Coordinate');
grid on;
axis([0 100 0 100]);

% Draw nodes
for i = 1:nNodes
    for j = i+1:nNodes
        d = norm(coords(i,:) - coords(j,:));
        if d <= 40  % Only draw connected ones
            plot([coords(i,1), coords(j,1)], [coords(i,2), coords(j,2)], ...
                'k--', 'LineWidth', 1.5);
        end
    end
end

% Graph 2: Showing Distances
subplot(1, 2, 2);
distances = [];
for i = 1:nNodes
    for j = i+1:nNodes
        d = norm(coords(i,:) - coords(j,:));
        distances = [distances, d];
    end
end

histogram(distances, 10, 'FaceColor', 'cyan');
title('Distance Distribution', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Distance (unit)');
ylabel('Frequency');
hold on;
xline(40, 'r--', 'LineWidth', 2, 'Label', 'Max Connectivity (40)');

exportgraphics(fig2, ...
    fullfile(outputDir, 'network_topology_results.png'), ...
    'Resolution', 300);

%% Print results
fprintf('\n========================================\n');
fprintf('NETWORK TOPOLOGY OPTIMIZATION\n');
fprintf('========================================\n\n');
fprintf('Optimal Coordinates:\n');

for i = 1:nNodes
    fprintf('Node %d: (%.2f, %.2f)\n', i, coords(i,1), coords(i,2));
end

fprintf('\nDistance Summary:\n');
fprintf('Total Distance: %.2f\n', sum(distances));
fprintf('Average Distance: %.2f\n', mean(distances));
fprintf('Min Distance: %.2f\n', min(distances));
fprintf('Max Distance: %.2f\n', max(distances));

fprintf('\nFitness Value (Best): %.2f\n', fval);
fprintf('Connectivity Penalty: ');
penalty_count = sum(distances > 40);
fprintf('%d (40 units and above %d connection)\n', penalty_count*100, penalty_count);
fprintf('\n========================================\n');

%% Fitness Function
% Network Topology Optimization Fitness Function
% Input: x = [x1, y1, x2, y2, x3, y3, ...] (coordinates)
% Output: score = fitness value (target to reduce)
% Target:
% 1. Minimize total distance (energy saving)
% 2. Nodes should not be more than 40 units apart (connectivity)
function score = fitness_network_final(x)

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