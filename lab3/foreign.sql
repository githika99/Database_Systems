ALTER TABLE MaintenanceRecords 
ADD CONSTRAINT MaintenanceRecordVehicles
FOREIGN KEY (vehicleID, agencyID) REFERENCES Vehicles(vehicleID, agencyID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE MaintenanceRecords 
ADD CONSTRAINT MaintenanceRecordRoutes
FOREIGN KEY (routeID, agencyID) REFERENCES Routes(routeID, agencyID)
ON DELETE SET NULL
ON UPDATE CASCADE;

ALTER TABLE MaintenanceDeltas 
ADD CONSTRAINT MaintenanceDeltasVehicles
FOREIGN KEY (vehicleID, agencyID) REFERENCES Vehicles(vehicleID, agencyID)
ON DELETE CASCADE;
