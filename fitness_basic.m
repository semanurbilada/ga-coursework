% MATLAB Docs
% Basic Fitness Function
% The basic fitness function is function of Rosenbrock, a common test function for optimizers.
% The function has a minimum value of zero at the point [1,1]. 
% Because the Rosenbrock function is quite steep, plot the logarithm of one plus the function.

fsurf(@(x,y)log(1 + 100*(x.^2 - y).^2 + (1 - x).^2),[0,2])
title("log(1 + 100*(x(1)^2 - x(2))^2 + (1 - x(1))^2)")
view(-13,78)
hold on
h1 = plot3(1,1,0.1,"r*",MarkerSize=12);
legend(h1,"Minimum",Location="best");
hold off