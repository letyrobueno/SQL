-- Interesting queries

-- Aggregations
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

-- Recursive cte
-- From: https://www.linkedin.com/posts/davidkfreitag_sql-dataengineering-activity-7187786005481967616-_Py8?utm_source=share&utm_medium=member_desktop
-- Prints 1,2,3
WITH RECURSIVE cte_1 AS (
	-- base case
	(SELECT 1 AS iteration)

	UNION ALL

	--each recursive case
	(SELECT iteration + 1 AS iteration
		FROM cte_1
		WHERE iteration < 3 -- the stop sign
	)
)

SELECT iteration
FROM cte_1
ORDER BY 1;
