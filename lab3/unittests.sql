-- violates foreign key constraint MaintenanceRecordVehicles
INSERT INTO MaintenanceRecords
VALUES (8000,'AMTK','CC',5000,'Good');

-- violates foreign key constraint MaintenanceRecordVehicles
INSERT INTO MaintenanceRecords
VALUES (1515,'SFMTA','77',5000,'Good');

-- violates foreign key constraint MaintenanceDeltasVehicles
INSERT INTO MaintenanceDeltas
VALUES (8000,'AMTK','CC',5000,'Good');

-- meets general constraint chk_yearBuilt
UPDATE Vehicles
SET yearBuilt = 2000
WHERE yearBuilt = 2002;

-- violates general constraint chk_yearBuilt
UPDATE Vehicles
SET yearBuilt = 1899
WHERE yearBuilt = 2001;

-- meets general constraint chk_routeLength
UPDATE Routes
SET length = 6.5
WHERE length = 6.9;

-- violates general constraint chk_routeLength
UPDATE Routes
SET length = -4.7
WHERE length = 4.7;

-- meets general constraint chk_ridership
UPDATE Routes
SET length = 5.0
WHERE ridership = 15000;

-- violates general constraint chk_ridership
UPDATE Routes
SET length = 4.0
WHERE ridership = 15000;

