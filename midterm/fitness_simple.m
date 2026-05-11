%% Simple Fitness Function for midterm project (clean version of fitnesscalc1.m)
% Objective: maximize f(x,y) = exp(-(x^2 + y^2))
clc; clear;
addpath('../lecture-codes')

%% GA Parameters
pop = genhav(30, 2, 8);   % initial population
maxGen = 200;             % number of generations
mutationRate = 0.02;

%% Main GA Loop
for epoch = 1:maxGen
    % Decode chromosome → real values
    [paramvalue, ~] = createchrm(pop, 2, 8);
    genvaluen = gendeg(paramvalue, [-5 -5], [5 5], 8);

    % Fitness evaluation
    [bstscore, score, bestchr, prmbest, pop] = fitnesscalc_simple(genvaluen, pop);

    % Store best fitness
    bestFitness(epoch) = bstscore;

    % GA operators
    pop1 = crossover(pop, bestchr);
    pop2 = mutation1(pop1, bestchr, mutationRate);

    % Update population
    pop = pop2;
end

%% Final result
fprintf('\nFINAL RESULT:\n');
fprintf('Best fitness value = %.4f\n', bstscore);
fprintf('Best x = %.4f, Best y = %.4f\n', prmbest(1), prmbest(2));

%% Plot convergence
figure;
plot(bestFitness, 'LineWidth', 2);
xlabel('Generation');
ylabel('Best Fitness');
title('GA Convergence');
grid on;

%% Fitness Function
function [bstscore, score, bestchr, prmbest, pop1] = fitnesscalc_simple(genvaluen, pop)

[r, ~] = size(genvaluen);
score = zeros(1, r);

for k = 1:r
    x = genvaluen(k,1);
    y = genvaluen(k,2);

    % Fitness calculation
    score(k) = exp(-(x^2 + y^2));
end

% Sort fitness values
[srtscore, indx] = sort(score);

% Best individual
bestchr = pop(indx(end), :);
prmbest = genvaluen(indx(end), :);

% Elitism: replace worst with best
pop1 = pop;
pop1(indx(1), :) = bestchr;

bstscore = srtscore(end);
end