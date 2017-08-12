function [col] = replaceZeros(col)

% Pre-condition: The array must be entirely positive or zero
% Replaces zeros with a value 10 times less than the minimum positive number


% Find the minimum value greater than 0 and reduce it by one order of magnitude
minVal = min(col(col>0));
minVal = minVal / 10;

% Find the positions of the values equal to zero
zeroPos = eq(col, 0);

% Add the new minimum to the places where zero was found
zeroPos = zeroPos * minVal;
col = col + zeroPos;


