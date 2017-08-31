function displaySignificance(h, p, testSubject)

if (h)
    disp(['The ', testSubject, ' is better than average. Statistical significance of: ', num2str(p)]);
else
    disp(['The ', testSubject, ' is the same as the average. Statistical significance of: ', num2str(p)]);
end