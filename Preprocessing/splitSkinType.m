function [table] = splitSkinType(table)

% Split out the skin type column
skinTypeCol = 12;
skinType = table2array(table(:, skinTypeCol));

% Number of elements and attributes
[n, p] = size(table);

% Save columns to the left and right
lhs = table(:, 1:skinTypeCol-1);
rhs = table(:, skinTypeCol+1:p);

% Preallocate space for arrays
skinType2 = zeros(n,1);
skinType4 = zeros(n,1);
skinType6 = zeros(n,1);
skinTypeOther = zeros(n,1);


% Filter the values
parfor i=1:length(skinType)
    switch skinType(i)
        
        case (2)
            skinType2(i) = 1;
        case (4)
            skinType4(i) = 1;
        case (6)
            skinType6(i) = 1;
        otherwise
            skinTypeOther(i) = 1;
            
    end
end


% Convert skin types to a table
skinType2 = array2table(skinType2);
skinType4 = array2table(skinType4);
skinType6 = array2table(skinType6);
skinTypeOther = array2table(skinTypeOther);

% Combine the table again
table = [lhs, skinType2, skinType4, skinType6, skinTypeOther, rhs];