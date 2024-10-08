-- Create a new table
CREATE TABLE rides (
	date INTEGER NOT NULL,
	name VARCHAR(45) PRIMARY KEY,
	lat DECIMAL NOT NULL,
	lng DECIMAL NOT NULL,
	day VARCHAR(7) NOT NULL,
	hour INTEGER NOT NULL,
	s_i DECIMAL NOT NULL,
	s_j DECIMAL NOT NULL,
	s_median_dist DECIMAL NOT NULL,
    s_count INTEGER NOT NULL,
	e_i DECIMAL NOT NULL,
	e_j DECIMAL NOT NULL,
	e_median_dist DECIMAL NOT NULL,
	e_count INTEGER NOT NULL
);