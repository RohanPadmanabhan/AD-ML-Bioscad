function drawCoefficientPlot(coeffsFull, varNames)

% Initialise the figure
figure('name', 'Coefficient values');
set(gcf, 'Position', [100, 800, 1200, 400])

% Find the locations of non-zero coefficients
nonZeroLocs = coeffsFull ~= 0;
coeffs = coeffsFull(nonZeroLocs);
varNames = varNames(nonZeroLocs);

% Remove the constant coefficients
varNames(1) = [];
coeffs(1) = [];

% Plot the bar graph
varNames = categorical(varNames);
bar(varNames, coeffs);

% Labels
title('Coefficient values');
xlabel('Attribute');
ylabel('Coeffient value');
grid on
