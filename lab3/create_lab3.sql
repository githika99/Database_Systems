-- Uncomment the next lines if you want to drop and recreate the schema. Ideally you should run these line in psql terminal before running this script.
DROP SCHEMA lab3 CASCADE;
CREATE SCHEMA lab3;
ALTER ROLE cse180 SET search_path TO lab3;

-- Agencies(agencyID, agencyCity, agencyState)
CREATE TABLE Agencies(
    agencyID    VARCHAR(5) PRIMARY KEY,
    agencyCity  VARCHAR(20) NOT NULL,
    agencyState CHAR(2),
    UNIQUE (agencyCity, agencyState)
);

-- Routes(routeID, agencyID, routeName, length, ridership)
CREATE TABLE Routes(
    routeID     VARCHAR(5),
    agencyID    VARCHAR(5) REFERENCES Agencies,
    routeName   VARCHAR(20) NOT NULL,
    length      NUMERIC(5,1),
    ridership   INT,
    PRIMARY KEY (routeID, agencyID),
    UNIQUE (routeName)
);

-- Stations(stationID, operatorID, stationName, address)
CREATE TABLE Stations(
    stationID   INT PRIMARY KEY,
    operatorID  VARCHAR(5) REFERENCES Agencies (agencyID),
    stationName VARCHAR(20) NOT NULL,
    address     VARCHAR(60),
    UNIQUE (stationName)
);

-- Transfers(route1, agency1, route2, agency2, stationID)
CREATE TABLE Transfers(
    route1      VARCHAR(5),
    agency1     VARCHAR(5),
    route2      VARCHAR(5),
    agency2     VARCHAR(5),
    stationID   INT REFERENCES Stations,
    FOREIGN KEY (route1, agency1) REFERENCES Routes (routeID, agencyID),
    FOREIGN KEY (route2, agency2) REFERENCES Routes (routeID, agencyID),
    PRIMARY KEY (route1, agency1, route2, agency2, stationID)
);

-- VehicleKinds(vehicleMake, vehicleModel, vehicleType, stillOffered)
CREATE TABLE VehicleKinds(
    vehicleMake     VARCHAR(20),
    vehicleModel    VARCHAR(20),
    vehicleType     CHAR(2),
    stillOffered    BOOLEAN,
    PRIMARY KEY (vehicleMake, vehicleModel)
);

-- Vehicles(vehicleID, agencyID, routeID, vehicleMake, vehicleModel, yearBuilt, inService, serviceCount)
CREATE TABLE Vehicles(
    vehicleID       INT,
    agencyID        VARCHAR(5),
    routeID         VARCHAR(5),
    vehicleMake     VARCHAR(20),
    vehicleModel    VARCHAR(20),
    yearBuilt       INT,
    inService       BOOLEAN,
    serviceCount    INT,  -- New attribute for Lab3
    FOREIGN KEY (vehicleMake, vehicleModel) REFERENCES VehicleKinds,
    PRIMARY KEY (vehicleID, agencyID),
    FOREIGN KEY (routeID, agencyID) REFERENCES Routes(routeID, agencyID)
);

-- VehicleServices(vehicleID, agencyID, serviceTimestamp, serviceComplete, cost)
CREATE TABLE VehicleServices(
    vehicleID           INT,
    agencyID            VARCHAR(5),
    serviceTimestamp    TIMESTAMP,
    serviceComplete     BOOLEAN,
    cost                NUMERIC(8,2),
    FOREIGN KEY (vehicleID, agencyID) REFERENCES Vehicles,
    PRIMARY KEY (vehicleID, agencyID, serviceTimestamp)
);

-- MaintenanceRecords(vehicleID, agencyID, routeID, lastMaintenanceMileage, maintenanceStatus)
CREATE TABLE MaintenanceRecords(
    vehicleID             INT,
    agencyID              VARCHAR(5),
    routeID               VARCHAR(5),
    lastMaintenanceMileage NUMERIC(8,0),
    maintenanceStatus     VARCHAR(10),
    PRIMARY KEY (vehicleID, agencyID, routeID)
    -- FOREIGN KEY (vehicleID, agencyID) REFERENCES Vehicles,
    -- FOREIGN KEY (routeID, agencyID) REFERENCES Routes(routeID, agencyID)
    -- Foreign key constraints for (vehicleID, agencyID) and (routeID, agencyID) 
    -- will be added later via ALTER TABLE commands.
);

-- MaintenanceDeltas(vehicleID, agencyID, routeID, mileageDelta, newMaintenanceStatus)
CREATE TABLE MaintenanceDeltas(
    vehicleID           INT,
    agencyID            VARCHAR(5),
    routeID             VARCHAR(5),
    mileageDelta        NUMERIC(8,0),
    newMaintenanceStatus VARCHAR(10),
    PRIMARY KEY (vehicleID, agencyID, routeID)
    -- FOREIGN KEY (vehicleID, agencyID) REFERENCES Vehicles,
    -- FOREIGN KEY (routeID, agencyID) REFERENCES Routes(routeID, agencyID)
    -- Foreign key constraints for (vehicleID, agencyID) and (routeID, agencyID) 
    -- will be added later via ALTER TABLE commands.
);