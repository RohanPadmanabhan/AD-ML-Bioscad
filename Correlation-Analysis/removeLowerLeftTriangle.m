function [reduced] = removeLowerLeftTriangle(mat)

% Removes the lower left triangle of a numric matrix
% Returns a matrix of strings (cell)

[m, n] = size(mat);
reduced = cell(m,n);

for i=1:n
    for j=1:m
        if i>=j
            reduced{i,j}= '';
        else
            reduced{i,j} = num2str(mat(i,j));
        end
    end
end