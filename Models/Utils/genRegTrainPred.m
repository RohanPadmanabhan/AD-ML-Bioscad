function [coeffs, yPred] = genRegTrainPred(xTrain, yTrain, xTest, maxPrediction)


% Train the model
model = fitglm(xTrain, yTrain);

% Predict the outputs
coeffs = model.Coefficients.Estimate;
yPred = genRegPred(coeffs, xTest, maxPrediction);
