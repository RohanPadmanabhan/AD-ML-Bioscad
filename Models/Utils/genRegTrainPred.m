function [coeffs, yPred] = genRegTrainPred(xTrain, yTrain, xTest, maxSCORAD)


% Train the model
model = fitglm(xTrain, yTrain);

% Predict the outputs
coeffs = model.Coefficients.Estimate;
yPred = genRegPred(coeffs, xTest, maxSCORAD);
