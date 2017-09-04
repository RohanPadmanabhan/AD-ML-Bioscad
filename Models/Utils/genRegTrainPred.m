function [coeffs, yPred] = genRegTrainPred(xTrain, yTrain, xTest, maxSCORAD)


% Train the model
model = fitglm(xTrain, yTrain);

% Predict the outputs
[yPred, coeffs] = genRegPred(model, xTest, maxSCORAD);
