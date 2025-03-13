-- CSE 180 Winter 2025 Lab4 create file

-- This file is similar to our Lab1 solution (and the Lab2 create file you were asked
-- to modify).  It has the Foreign Key constraints that were in those files, but does
-- not have the UNIQUE and NOT NULL constraints which were in the Lab2 solution.
-- It also does not have the new tables, attributes, and constraints which were used in Lab3.
-- Please note the new FOREIGN KEY in Vehicles: (agencyID, routeID) REFERENCES Routes,

DROP SCHEMA Lab4 CASCADE;
CREATE SCHEMA Lab4;

-- Agencies(agencyID, agencyCity, agencyState)
CREATE TABLE Agencies(
    agencyID    VARCHAR(5) PRIMARY KEY,
    agencyCity  VARCHAR(20),
    agencyState CHAR(2)
);

-- Routes(routeID, agencyID, routeName, length, ridership)
CREATE TABLE Routes(
    routeID     VARCHAR(5),
    agencyID    VARCHAR(5) REFERENCES Agencies,
    routeName   VARCHAR(20),
    length      NUMERIC(5,1),
    ridership   INT,
    PRIMARY KEY (routeID, agencyID)
);

-- Stations(stationID, operatorID, stationName, address)
CREATE TABLE Stations(
    stationID   INT PRIMARY KEY,
    operatorID  VARCHAR(5) REFERENCES Agencies (agencyID),
    stationName VARCHAR(20),
    address     VARCHAR(60)
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

-- Vehicles(vehicleID, agencyID, routeID, vehicleMake, vehicleModel, yearBuilt, inService)
CREATE TABLE Vehicles(
    vehicleID       INT,
    agencyID        VARCHAR(5),
    routeID         VARCHAR(5),
    vehicleMake     VARCHAR(20),
    vehicleModel    VARCHAR(20),
    yearBuilt       INT,
    inService       BOOLEAN,
    FOREIGN KEY (vehicleMake, vehicleModel) REFERENCES VehicleKinds,
    FOREIGN KEY (routeID, agencyID) REFERENCES Routes,
    PRIMARY KEY (vehicleID, agencyID)
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
