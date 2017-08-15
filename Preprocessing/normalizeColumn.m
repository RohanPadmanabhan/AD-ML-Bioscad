function [col] = normalizeColumn(col)

% Input 1 : The array of data
% Output : The normalized data with mean 0 and standard deviation 1

% Find the mean and standard deviation
mu = nanmean(col);
sigma = nanstd(col);

% Move the mean to zero
col = col - mu;

% Make the standard deviation 1;
col = col/sigma;