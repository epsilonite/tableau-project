select date,day,hour, COUNT(*) from rides
where name = '5 Ave & 67 St'
group by date,day,hour
HAVING COUNT(*) > 1;

-- Step 1: Create a temporary table to store merged data
CREATE TEMP TABLE merged AS
SELECT 
    date,name,lat,lng,day,hour,
	SUM(s_i) as s_i_n,
	SUM(s_j) as s_j_n,
	SUM(s_count*s_median_dist)/SUM(s_count) as s_median_n,
	SUM(s_count) as s_count_n,
	SUM(e_i) as e_i_n,
	SUM(e_j) as e_j_n,
	SUM(e_count*e_median_dist)/SUM(e_count) as e_median_n,
	SUM(e_count) as e_count_n
FROM 
    rides
WHERE name = '5 Ave & 67 St'
GROUP BY 
    date,name,lat,lng,day,hour
HAVING COUNT(*) > 1;

select * from merged

update merged
set s_i_n = s_i_n/SQRT(s_i_n^2+s_j_n^2),
s_j_n = s_j_n/SQRT(s_i_n^2+s_j_n^2),
e_i_n = e_i_n/SQRT(e_i_n^2+e_j_n^2),
e_j_n = e_j_n/SQRT(e_i_n^2+e_j_n^2)

-- Step 2: Delete duplicate rows
DELETE FROM rides
WHERE (date,day,hour) IN (
    select date,day,hour from rides
	where name = '5 Ave & 67 St'
	group by date,day,hour
	HAVING COUNT(*) > 1
);

-- Step 3: Insert merged rows back into the original table
INSERT INTO rides (date,name,lat,lng,day,hour,s_i,s_j,s_median_dist,s_count,e_i,e_j,e_median_dist,e_count)
SELECT date,name,lat,lng,day,hour,s_i_n,s_j_n,s_median_n,s_count_n,e_i_n,e_j_n,e_median_n,e_count_n
FROM merged;

select * from rides where name = '5 Ave & 67 St'