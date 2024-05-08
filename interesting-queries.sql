-- Interesting queries

-- Advanced aggregations
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


-- ***************************************************************************************
-- In case of duplicates, get the customer that was created first according to creation_date in ascending order
select customer_id, customer_name, creation_date
from customers
qualify row_number() over (partition by customer_id order by creation_date) = 1;

-- Some options to choose from instead of using distinct:

-- (1) group by without metrics:
-- though we are not aggregating any metrics, this gets those 2 columns with no duplicates
-- known to have better performance than using distinct
select customer_name, customer_id
from whatever_table
group by customer_name, customer_id 

-- (2) window function:
with 
	
cte as (
    select 
	col1, 
	col2, 
	col3,
	row_number() over (partition by col1, col2, col3 order by col1) as row_num
    from table1
)

-- select * from cte where row_num > 1 -- show only duplicates
select * from cte where row_num = 1 -- gets result with no duplicates
	

-- ***************************************************************************************
-- See % of each value in a category column grouped by year
select 
    year(release_date) as year,
    sum(case when status = 'Released' then 1 else 0 end) / count(*) as perc_released,
    sum(case when status = 'Planned' then 1 else 0 end) / count(*) as perc_planned,
    sum(case when status = 'Post Production' then 1 else 0 end) / count(*) as perc_postprod,
    sum(case when status = 'Rumored' then 1 else 0 end) / count(*) as perc_rumored,
    sum(case when status = 'In Production' then 1 else 0 end) / count(*) as perc_inprod,
    sum(case when status = 'Canceled' then 1 else 0 end) / count(*) as perc_canceled
from tmdb_movies
group by year
order by year desc

-- ***************************************************************************************
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
