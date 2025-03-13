BEGIN TRANSACTION;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    -- we supposed to insert values from MaintenanceDeltas into MaintanenceRecords
    -- and if that record already exists, we update the milegae Delta and newMaintenanceStats
    
    -- 1. update exisiting records

    -- MaintenanceRecords(vehicleID, agencyID, routeID, lastMaintenanceMileage, maintenanceStatus)
    -- MaintenanceDeltas(vehicleID, agencyID, routeID, mileageDelta, newMaintenanceStatus)

    UPDATE
        MaintenanceRecords
    SET
        lastMaintenanceMileage = MD.mileageDelta, 
        maintenanceStatus = MD.newMaintenanceStatus
    FROM
        MaintenanceDeltas MD
    WHERE 
        MaintenanceRecords.vehicleID = MD.vehicleID AND MaintenanceRecords.agencyID = MD.agencyID AND MaintenanceRecords.routeID = MD.routeID;

    -- 2. insert new values 
    INSERT INTO MaintenanceRecords(vehicleID, agencyID, routeID, lastMaintenanceMileage, maintenanceStatus)
    SELECT vehicleID, agencyID, routeID, mileageDelta, newMaintenanceStatus
    FROM MaintenanceDeltas MD
    WHERE NOT EXISTS(
        SELECT 1
        FROM MaintenanceRecords MR
        WHERE MD.vehicleID = MR.vehicleID AND MD.agencyID = MR.agencyID AND MD.routeID = MR.routeID
    );

COMMIT;

