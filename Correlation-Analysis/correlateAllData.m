% Correlate all non-lesional data

% Clean slate
clear
clc


% Define filenames
adNonLesional = 'AD-non-lesional';
combinedNonLesional = 'combined-non-lesional';
adLesional = 'AD-lesional';

% Correlate the data
[adNonLesionalPMCC, adNonLesionalSpearman] = correlateAttributes(adNonLesional);
[combinedNonLesionalPMCC, combinedNonLesionalSpearman] = correlateAttributes(combinedNonLesional);
[adLesionalPMCC, adLesionalSpearman] = correlateAttributes(adLesional);


% Garbage collection
clear adNonLesional combinedNonLesional adLesional


