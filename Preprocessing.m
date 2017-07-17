%%Preprocessing the data

%% Clean slate
clear;
clc;

%% Load the data
filename = "AD-Non-Lesional.xlsx";
rawData = readtable(filename);