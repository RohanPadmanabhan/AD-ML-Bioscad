function [k] = kappaCoeff(acc, nullAcc)

k = (acc - nullAcc) / (1 - nullAcc);

