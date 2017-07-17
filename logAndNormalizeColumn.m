function [col] = logAndNorm(col)
col = log(col);
col = normalizeColumn(col);