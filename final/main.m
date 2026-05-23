%% Computer Network Optimization using Genetic Algorithm
% Goal: Optimize the physical placement of computers (nodes) in a 2D space using a genetic algorithm.
% Decision variables: x and y coordinates of each node
% Overall idea: GA searches for coordinate configurations that minimize communication cost while satisfying network constraints.
clc; clear; close all;

%% Output directory for saving figures
outputDir = '../outputs';

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% Generate unique timestamp-based log filename
timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
logFile = fullfile(outputDir, ...
    sprintf('run_log_%s.txt', timestamp));

diary(logFile);

%% Problem Parameters
nNodes = 10;                % Number of network nodes
routeLength = 8;            % max nodes in route
nvars = routeLength;        % decision variables = route nodes

%% Genetic Algorithm Configuration
options = gaoptimset(...
    'PopulationSize', 50, ...   % Number of individuals
    'Generations', 200, ...     % Number of iterations
    'Display', 'iter', ...      % Show progress in command window
    'PlotFcn', @gaplotbestf);   % Plot best fitness per generation

fprintf('====================================\n');
fprintf(' Computer Network Optimization Run\n');
fprintf('====================================\n');
% fprintf('Run Index      : %d\n', runIndex);
fprintf('Run Timestamp  : %s\n', timestamp);
fprintf('Number of Nodes: %d\n', nNodes);
fprintf('Population Size: %d\n', 50);
fprintf('Generations    : %d\n', 200);
fprintf('Timestamp      : %s\n', datestr(now));
fprintf('====================================\n');

%% Run Genetic Algorithm
% Calls custom fitness function to evaluate solutions
coords = rand(nNodes, 2) * 100;   % fixed node positions

% Adjacency matrix (connectivity graph)
adjMatrix = zeros(nNodes);
maxDist = 40;

for i = 1:nNodes
    for j = 1:nNodes
        if i ~= j
            d = norm(coords(i,:) - coords(j,:));
            if d <= maxDist
                adjMatrix(i,j) = 1;
            end
        end
    end
end

fprintf('\n========== ADJACENCY MATRIX ==========\n');
disp(adjMatrix);

% Link capacity matrix (random capacities)
capacityMatrix = randi([1 10], nNodes, nNodes);

fprintf('\n========== CAPACITY MATRIX ==========\n');
disp(capacityMatrix);

traffic = randi([1 5], nNodes, 1);

fprintf('\n========== NODE LOOKUP TABLE ==========\n');
fprintf('Node\tX\tY\tTraffic\n');

for i = 1:nNodes
    fprintf('%d\t%.2f\t%.2f\t%d\n', ...
        i, coords(i,1), coords(i,2), traffic(i));
end
fprintf('=======================================\n\n');


fitnessFcn = @(x) fitness_routing(x, coords, traffic, adjMatrix, capacityMatrix);
[x_best, fval] = ga(fitnessFcn, nvars, [], [], [], [], ...
    ones(1,nvars), nNodes*ones(1,nvars), [], options);

%% Save convergence plot (fitness vs generations)
figure(1);
title('GA Convergence Plot - Best Fitness per Generation');

% Generate unique filename
fileName = sprintf('convergence_plot_%dnodes_%s.png', ...
    nNodes, timestamp);

exportgraphics(gcf, ...
    fullfile(outputDir, fileName), ...
    'Resolution', 300);

%% Visualize results and print outputs
visualize_results(x_best, fval, nNodes, outputDir, coords, timestamp, traffic, capacityMatrix);

nodeTable = table((1:nNodes)', coords(:,1), coords(:,2), traffic, ...
    'VariableNames', {'Node','X','Y','Traffic'});

writetable(nodeTable, fullfile(outputDir, ...
    sprintf('node_table_%s.csv', timestamp)));

% Stop logging
diary off;