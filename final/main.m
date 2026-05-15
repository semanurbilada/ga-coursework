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

%% Run Genetic Algorithm
% Calls custom fitness function to evaluate solutions
coords = rand(nNodes, 2) * 100;   % fixed node positions

fitnessFcn = @(x) fitness_routing(x, coords);
[x_best, fval] = ga(fitnessFcn, nvars, [], [], [], [], ...
    ones(1,nvars), nNodes*ones(1,nvars), [], options);

%% Save convergence plot (fitness vs generations)
figure(1);
title('GA Convergence Plot - Best Fitness per Generation');

fileName = sprintf('convergence_plot_%dnodes.png', nNodes);
exportgraphics(gcf, ...
    fullfile(outputDir, fileName), ...
    'Resolution', 300);

%% Visualize results and print outputs
visualize_results(x_best, fval, nNodes, outputDir, coords);