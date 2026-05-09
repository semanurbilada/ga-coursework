%% Simple fitness function for midterm project (clean version of fitnesscalc1.m)
% Objective: maximize f(x,y) = exp(-(x^2 + y^2))
pop = genhav(30, 2, 8);

[paramvalue, ~] = createchrm(pop, 2, 8);

genvaluen = gendeg(paramvalue, [-5 -5], [5 5], 8);

[bstscore, score, bestchr, prmbest, pop1] = fitnesscalc_simple(genvaluen, pop);

function [bstscore, score, bestchr, prmbest, pop1] = fitnesscalc_simple(genvaluen, pop)

[r, ~] = size(genvaluen);
score = zeros(1, r);

for k = 1:r
    x = genvaluen(k,1);
    y = genvaluen(k,2);

    % Fitness calculation
    score(k) = exp(-(x^2 + y^2));
end

% Sort fitness values (ascending)
[srtscore, indx] = sort(score);

% Best individual (maximum fitness)
bestchr = pop(indx(end), :);
prmbest = genvaluen(indx(end), :);

% Elitism: replace worst individual with best
pop1 = pop;
pop1(indx(1), :) = bestchr;

bstscore = srtscore(end);

fprintf('Best fitness value = %.4f\n', bstscore);
fprintf('Best x = %.4f, Best y = %.4f\n', prmbest(1), prmbest(2));

end