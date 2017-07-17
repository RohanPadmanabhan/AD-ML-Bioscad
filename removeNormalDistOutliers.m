function [col] = removeNormalDistOutliers(col, numDeviations)

n = length(col);

stdDev = std(col);
avg = mean(col);

lowerBound = avg - (numDeviations * stdDev);
upperBound = avg + (numDeviations * stdDev);


parfor i=1:n
    if (col(i)<lowerBound || col(i)>upperBound)
        col(i) = NaN;
    end
end