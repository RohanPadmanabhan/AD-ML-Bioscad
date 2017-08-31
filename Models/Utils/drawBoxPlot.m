function drawBoxPlot(predPerf, predSucc, rmseTitle, accTitle)

figure('name', 'Prediction Evaluation');
set(gcf, 'Position', [100, 800, 1000, 400])

% Create a boxplot of the RMSE
subplot(1,2,1);
boxplot(predPerf);
title(rmseTitle);
grid on;
ylabel('RMSE');

% Create a boxplot of the prediction success
subplot(1,2,2);
boxplot(predSucc);
title(accTitle);
grid on;
ylabel('Proportion successful predictions');