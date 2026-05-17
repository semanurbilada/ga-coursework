function visualize_results(x_best, fval, nNodes, outputDir, coords)

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
baseName = sprintf('routing_%dnodes', nNodes);
existingFiles = dir(fullfile(outputDir, [baseName '*.png']));
fileIndex = length(existingFiles) + 1;
fileName = sprintf('%s-%d.png', baseName, fileIndex);
exportgraphics(gcf, fullfile(outputDir, fileName), 'Resolution', 300);

fprintf('\nOptimal Route:\n');
disp(route);
fprintf('Total Cost: %.2f\n', fval);

end