-- Query to find most frequent lat/lng for inconsistent stations
WITH inconsistent_stations AS (
    -- Subgroup of stations with inconsistent lat/lng values
    SELECT start_station_name
    FROM rides
    GROUP BY start_station_name
    HAVING COUNT(DISTINCT start_lat) > 1 OR COUNT(DISTINCT start_lng) > 1
),
most_frequent_lat_lng AS (
    -- Find most frequent lat/lng values for stations with inconsistencies
    SELECT r.start_station_name, 
           r.start_lat, 
           r.start_lng, 
           COUNT(*) AS freq
    FROM rides r
    JOIN inconsistent_stations i 
    ON r.start_station_name = i.start_station_name
    GROUP BY r.start_station_name, r.start_lat, r.start_lng
)
-- Result: most frequent lat/lng for inconsistent stations
SELECT start_station_name, start_lat, start_lng, freq
FROM most_frequent_lat_lng;
------------------------------------------------------------------------------------------
-- Query for most frequent lat/lng for inconsistent stations
WITH inconsistent_stations AS (
    -- Subgroup of stations with inconsistent lat/lng values
    SELECT start_station_name
    FROM rides
    GROUP BY start_station_name
    HAVING COUNT(DISTINCT start_lat) > 1 OR COUNT(DISTINCT start_lng) > 1
),
most_frequent_lat_lng AS (
    -- Find most frequent lat/lng values for stations with inconsistencies
    SELECT r.start_station_name, 
           r.start_lat, 
           r.start_lng, 
           COUNT(*) AS freq
    FROM rides r
    JOIN inconsistent_stations i 
    ON r.start_station_name = i.start_station_name
    GROUP BY r.start_station_name, r.start_lat, r.start_lng
),
most_frequent AS (
    -- Select the most frequent lat/lng for each inconsistent station
    SELECT start_station_name, start_lat AS correct_lat, start_lng AS correct_lng
    FROM most_frequent_lat_lng
    WHERE (start_station_name, freq) IN (
        SELECT start_station_name, MAX(freq)
        FROM most_frequent_lat_lng
        GROUP BY start_station_name
    )
)
-- Final result: most frequent lat/lng for inconsistent stations
SELECT start_station_name, correct_lat, correct_lng
FROM most_frequent;
------------------------------------------------------------------------------------------
-- Query maximum lat/lng deviance across all inconsistent stations
WITH inconsistent_stations AS (
    -- Subgroup of stations with inconsistent lat/lng values
    SELECT start_station_name
    FROM rides
    GROUP BY start_station_name
    HAVING COUNT(DISTINCT start_lat) > 1 OR COUNT(DISTINCT start_lng) > 1
),
lat_lng_deviance AS (
    -- Calculate the maximum and minimum lat/lng for each inconsistent station
    SELECT start_station_name, 
           MAX(start_lat) - MIN(start_lat) AS lat_deviance,
           MAX(start_lng) - MIN(start_lng) AS lng_deviance
    FROM rides
    WHERE start_station_name IN (SELECT start_station_name FROM inconsistent_stations)
    GROUP BY start_station_name
)
-- Fetch the station with the greatest latitude and longitude deviance
SELECT lat_deviance
FROM lat_lng_deviance
ORDER BY lat_deviance DESC
LIMIT 1;

SELECT lng_deviance
FROM lat_lng_deviance
ORDER BY lng_deviance DESC
LIMIT 1;
------------------------------------------------------------------------------------------
WITH most_frequent_lat_lng AS (
    SELECT start_station_name, 
           start_lat, 
           start_lng, 
           COUNT(*) AS freq
    FROM rides
    GROUP BY start_station_name, start_lat, start_lng
),
most_frequent AS (
    SELECT start_station_name, start_lat AS correct_lat, start_lng AS correct_lng
    FROM most_frequent_lat_lng
    WHERE (start_station_name, freq) IN (
        SELECT start_station_name, MAX(freq)
        FROM most_frequent_lat_lng
        GROUP BY start_station_name
    )
)
UPDATE rides
SET start_lat = most_frequent.correct_lat,
    start_lng = most_frequent.correct_lng
FROM most_frequent
WHERE rides.start_station_name = most_frequent.start_station_name
  AND (rides.start_lat <> most_frequent.correct_lat OR rides.start_lng <> most_frequent.correct_lng);
------------------------------------------------------------------------------------------
-- Query for most frequent lat/lng for inconsistent stations
WITH inconsistent_stations AS (
    -- Subgroup of stations with inconsistent lat/lng values
    SELECT end_station_name
    FROM rides
    GROUP BY end_station_name
    HAVING COUNT(DISTINCT end_lat) > 1 OR COUNT(DISTINCT end_lng) > 1
),
most_frequent_lat_lng AS (
    -- Find most frequent lat/lng values for stations with inconsistencies
    SELECT r.end_station_name, 
           r.end_lat, 
           r.end_lng, 
           COUNT(*) AS freq
    FROM rides r
    JOIN inconsistent_stations i 
    ON r.end_station_name = i.end_station_name
    GROUP BY r.end_station_name, r.end_lat, r.end_lng
),
most_frequent AS (
    -- Select the most frequent lat/lng for each inconsistent station
    SELECT end_station_name, end_lat AS correct_lat, end_lng AS correct_lng
    FROM most_frequent_lat_lng
    WHERE (end_station_name, freq) IN (
        SELECT end_station_name, MAX(freq)
        FROM most_frequent_lat_lng
        GROUP BY end_station_name
    )
)
-- Final result: most frequent lat/lng for inconsistent stations
SELECT end_station_name, correct_lat, correct_lng
FROM most_frequent;
------------------------------------------------------------------------------------------
WITH inconsistent_stations AS (
	SELECT start_station_name
    FROM rides
    GROUP BY start_station_name
    HAVING COUNT(DISTINCT start_station_id) > 1
),
most_frequent_id AS (
    -- Find most frequent id values for stations with inconsistencies
    SELECT r.start_station_name, 
           r.start_station_id, 
           COUNT(*) AS freq
    FROM rides r
    JOIN inconsistent_stations i 
    ON r.start_station_name = i.start_station_name
    GROUP BY r.start_station_name, r.start_station_id
)
-- Final result:
SELECT start_station_name, start_station_id, freq
FROM most_frequent_id
	ORDER BY start_station_name;
------------------------------------------------------------------------------------------
WITH most_frequent_id AS (
    -- Find most frequent id values for stations with inconsistencies
    SELECT start_station_name, 
           start_station_id, 
           COUNT(*) AS freq
    FROM rides
    GROUP BY start_station_name, start_station_id
),
most_frequent AS (
    SELECT start_station_name, start_station_id AS correct_id
    FROM most_frequent_id
    WHERE (start_station_name, freq) IN (
        SELECT start_station_name, MAX(freq)
        FROM most_frequent_id
        GROUP BY start_station_name
    )
)
UPDATE rides
SET start_station_id = most_frequent.correct_id
FROM most_frequent
WHERE rides.start_station_name = most_frequent.start_station_name
  AND (rides.start_station_id <> most_frequent.correct_id);
------------------------------------------------------------------------------------------
WITH long_ids AS (
	SELECT end_station_name, end_station_id, end_lat, end_lng, COUNT(*) AS freq
	FROM rides 
	GROUP BY end_station_name, end_station_id, end_lat, end_lng
)
SELECT * FROM long_ids WHERE LENGTH(end_station_id) > 7;
------------------------------------------------------------------------------------------
WITH cleaned AS (
	SELECT * FROM rides2408
	WHERE start_station_name IS NOT NULL
	AND start_lat IS NOT NULL
	AND end_lat IS NOT NULL
	AND (start_lat <> end_lat OR start_lng <> end_lng)
	-- ORDER BY RANDOM()
	-- LIMIT 100000
),
binned AS (
	SELECT start_station_name, start_lat,start_lng, 
	CASE WHEN EXTRACT(DOW FROM started_at) IN (0, 6) THEN 'Weekend' ELSE 'Weekday' END AS day, 
	EXTRACT(HOUR FROM started_at) as hour,
	AVG((end_lat-start_lat)/SQRT(POWER(end_lat-start_lat,2)+POWER(end_lng-start_lng,2))) as i,
	AVG((end_lng-start_lng)/SQRT(POWER(end_lat-start_lat,2)+POWER(end_lng-start_lng,2))) as j,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY earth_distance(ll_to_earth(start_lat, start_lng), ll_to_earth(end_lat, end_lng))) AS median_distance,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ended_at-started_at) AS median_duration,
	COUNT(*) FROM cleaned
	GROUP BY start_station_name, start_lat,start_lng, day, hour
	ORDER BY start_station_name, start_lat,start_lng, day, hour
)
SELECT * FROM binned
------------------------------------------------------------------------------------------
WITH most_frequent_lat_lng AS (
    SELECT name, 
           lat, 
           lng, 
           COUNT(*) AS freq
    FROM rides
    GROUP BY name, lat, lng
),
most_frequent AS (
    SELECT name, lat AS correct_lat, lng AS correct_lng
    FROM most_frequent_lat_lng
    WHERE (name, freq) IN (
        SELECT name, MAX(freq)
        FROM most_frequent_lat_lng
        GROUP BY name
    )
)
UPDATE rides
SET lat = most_frequent.correct_lat,
    lng = most_frequent.correct_lng
FROM most_frequent
WHERE rides.name = most_frequent.name
  AND (rides.lat <> most_frequent.correct_lat OR rides.lng <> most_frequent.correct_lng);
------------------------------------------------------------------------------------------
SELECT * FROM rides WHERE 
	end_lat is NULL and 
	end_lng is NULL and 
	end_station_name is NULL and
	end_station_id is NULL
	ORDER BY start_station_name;

SELECT DISTINCT start_station_name,start_station_id,COUNT(*) FROM rides
	GROUP BY start_station_name, start_station_id;