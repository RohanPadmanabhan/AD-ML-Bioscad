function drawScatterPredictions(scoradType, yTest, yPred)

% Plot the graph
figure('name', strcat('Predicted vs Actual ', scoradType));
scatter(yTest, yPred, 'x');
title(strcat('Model Predicted vs Actual ', scoradType));
xlabel(strcat('Actual ', scoradType));
ylabel(strcat('Predicted ', scoradType));

% Add upper reference lines
upperLine = refline([1, 10]);
upperLine.Color = 'r';
upperLine.LineStyle = '--';

% Add middle reference lines
middleLine = refline([1, 0]);
middleLine.Color = 'r';

% Add lower reference lines
lowerLine = refline([1, -10]);
lowerLine.Color = 'r';
lowerLine.LineStyle = '--';

% Set the axes
maxAxis = max(max(yTest), max(yPred));
axis([0, maxAxis, 0, maxAxis]);
axis square