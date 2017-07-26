function [numGenders]=makeNumericGender(genders, gender1)

% Input 1 : The list of strings of gender
% Input 2 : String - One of the two genders
% Output : Double array with 1 where the gender matched input 1. 0
%          otherwise.

% Number of data points
n = length(genders);

% Initialise array
numGenders = zeros(n,1);

% Replace matches with 1. Replace others with 0.
parfor i=1:n
    numGenders(i) = strcmp(genders(i), gender1);
end