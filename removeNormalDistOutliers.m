function [col] = removeNormalDistOutliers(col, numDeviations)

% Removes the outliers from a normally distributed data set
% Input 1 : The array of data
% Input 2 : The number of standard deviations away from the mean permitted
% Output  : The data with outliers set to NaN 


% Find the mean and standard deviation (ignoring NaN)
stdDev = nanstd(col);
avg = nanmean(col);

% Calculate the highest and lowest possible values
lowerBound = avg - (numDeviations * stdDev);
upperBound = avg + (numDeviations * stdDev);

% Set outliers to NaN
n = length(col);
parfor i=1:n
    if (col(i)<lowerBound || col(i)>upperBound)
        col(i) = NaN;
    end
end