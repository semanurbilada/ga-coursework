%% Network Topology Optimization using Genetic Algorithm
% Goal: Optimize the physical placement of 5 computers (nodes) in a 2D space using a genetic algorithm.
% Decision variables: x and y coordinates of each node
% Overall idea: GA searches for coordinate configurations that minimize communication cost while satisfying network constraints.
clc; clear; close all;

%% Output directory for saving figures
outputDir = '../outputs';

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% Problem Parameters
nNodes = 5;                 % Number of network nodes
nvars = nNodes * 2;         % Total variables: [x1 y1 x2 y2 ...]
lb = zeros(1, nvars);       % Lower bounds (0)
ub = ones(1, nvars) * 100;  % Upper bounds (100)

%% Genetic Algorithm Configuration
options = gaoptimset(...
    'PopulationSize', 50, ...   % Number of individuals
    'Generations', 200, ...     % Number of iterations
    'Display', 'iter', ...      % Show progress in command window
    'PlotFcn', @gaplotbestf);   % Plot best fitness per generation

%% Run Genetic Algorithm
% Calls custom fitness function to evaluate solutions
fitnessFcn = @fitness_network;
[x_best, fval] = ga(fitnessFcn, nvars, [], [], [], [], lb, ub, [], options);

%% Save convergence plot (fitness vs generations)
figure(1);
title('GA Convergence Plot - Best Fitness per Generation');
exportgraphics(gcf, ...
    fullfile(outputDir, 'convergence_plot.png'), ...
    'Resolution', 300);

%% Visualize results and print outputs
visualize_results(x_best, fval, nNodes, outputDir);