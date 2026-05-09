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
    'PopulationSize', 50, ...
    'Generations', 200, ...
    'Display', 'iter', ...
    'PlotFcn', @gaplotbestf);

%% Run Genetic Algorithm
fitnessFcn = @fitness_network;
[x_best, fval] = ga(fitnessFcn, nvars, [], [], [], [], lb, ub, [], options);

%% Save convergence plot
figure(1);
title('GA Convergence Plot - Best Fitness per Generation');
exportgraphics(gcf, ...
    fullfile(outputDir, 'convergence_plot.png'), ...
    'Resolution', 300);

%% Visualize and report results
visualize_results(x_best, fval, nNodes, outputDir);