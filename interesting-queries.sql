-- Interesting queries

SELECT yr,
    mth,
    COUNT(*)
FROM table1
GROUP BY CUBE(yr, mth) -- show years + months, years only, months only, total (all combos)
ORDER BY 1 DESC, 2 DESC;

SELECT yr,
    mth,
    COUNT(*)
FROM table1
GROUP BY GROUPING SETS(yr, mth) -- groups by years, then by months
ORDER BY 1 DESC, 2 DESC;

SELECT yr,
    mth,
    COUNT(*)
FROM table1
GROUP BY ROLLUP(yr, mth) -- years + months, years only, total (hierarchy intact)
ORDER BY 1 DESC, 2 DESC;
