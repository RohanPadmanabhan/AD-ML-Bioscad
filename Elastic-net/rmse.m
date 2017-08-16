function out = rmse(actual, prediction)

% Calculate the RMSE between two data sets

out=(actual-prediction).^2;
out=sqrt(sum(out)/length(out));

end