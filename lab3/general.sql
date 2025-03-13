ALTER TABLE Vehicles
ADD CONSTRAINT chk_yearBuilt
CHECK (yearBuilt >= 1900 AND yearBuilt <= 2025);

ALTER TABLE Routes
ADD CONSTRAINT chk_routeLength
CHECK (length > 0 AND length < 10000);

ALTER TABLE Routes
ADD CONSTRAINT chk_ridership
CHECK (ridership IS NULL OR ridership <= 5000 OR length >= 5.0)
