function drawResidualGraph(outData, residuals, scoradType)


% Plot the graph
figure('name', strcat('Residual vs Actual ', scoradType));
scatter(outData, residuals, 'x');

% Labels
title(strcat('Residual vs Actual ', scoradType));
xlabel(strcat('Actual ', scoradType));
ylabel(strcat('Residual ', scoradType));