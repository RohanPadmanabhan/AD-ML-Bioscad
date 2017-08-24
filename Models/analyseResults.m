function [yTestFull, yPredFull, residuals, predPerf, predSucc] = analyseResults(yTestFull, yPredFull)

%% Analyse the results for unflattened data from parallelised regression

% Flatten the matrix
yTestFull = reshape(yTestFull, [], 1);
yPredFull = reshape(yPredFull, [], 1);

% Calculate the residuals
residuals = yTestFull - yPredFull;

% Test final performance
predPerf = rmse(yTestFull, yPredFull);
predSucc = proportionSuccessful(yTestFull, yPredFull, mcid);

