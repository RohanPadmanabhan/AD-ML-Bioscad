% Preprocesses all three data sets

% Clean slate
clear;
clc;

[ppADLesional] = preprocessing('AD-lesional');
[ppADNonLesional] = preprocessing('AD-non-lesional');
[ppCombinedNonLesional] = preprocessing('combined-non-lesional');