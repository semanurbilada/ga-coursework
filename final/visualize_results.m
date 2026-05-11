function visualize_results(x_best, fval, nNodes, outputDir, coords)

coords = rand(nNodes, 2) * 100;  % same coords should be used!

route = round(x_best);
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
fileName = sprintf('routing_%dnodes.png', nNodes);
exportgraphics(gcf, fullfile(outputDir, fileName), 'Resolution', 300);

fprintf('\nOptimal Route:\n');
disp(route);
fprintf('Total Cost: %.2f\n', fval);

end