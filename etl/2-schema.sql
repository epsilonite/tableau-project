-- Create a new table
CREATE TABLE rides (
	rideable_type_copy VARCHAR(13) NOT NULL,
	ride_id VARCHAR(16) PRIMARY KEY,
	rideable_type VARCHAR(13) NOT NULL,
	started_at TIMESTAMP NOT NULL,
	ended_at TIMESTAMP NOT NULL,
	start_station_name VARCHAR(45),
	start_station_id VARCHAR(12),
	end_station_name VARCHAR(45),
	end_station_id VARCHAR(12),
	start_lat DECIMAL NOT NULL,
	start_lng DECIMAL NOT NULL,
	end_lat DECIMAL,
	end_lng DECIMAL,
	member_casual VARCHAR(6) NOT NULL
);

-- Create a new table
CREATE TABLE rides (
	ride_id VARCHAR(16) PRIMARY KEY,
	rideable_type VARCHAR(13) NOT NULL,
	started_at TIMESTAMP NOT NULL,
	ended_at TIMESTAMP NOT NULL,
	start_station_name VARCHAR(45),
	start_station_id VARCHAR(20),
	end_station_name VARCHAR(45),
	end_station_id VARCHAR(20),
	start_lat DECIMAL NOT NULL,
	start_lng DECIMAL NOT NULL,
	end_lat DECIMAL,
	end_lng DECIMAL,
	member_casual VARCHAR(6) NOT NULL
);