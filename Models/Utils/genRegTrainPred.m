function [coeffs, yPred] = genRegTrainPred(xTrain, yTrain, xTest, maxSCORAD)


% Train the model
model = fitglm(xTrain, yTrain);

% Predict results using model
coeffs = model.Coefficients.Estimate;
[n, ~] = size(xTest);
yPred = [ones(n,1), xTest] * coeffs;

% Remove high and low values from prediction
yPred = yPred .* (yPred > 0);
yPred = replaceHighValues(yPred, maxSCORAD);
