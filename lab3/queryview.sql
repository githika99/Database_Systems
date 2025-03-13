-- query
SELECT inService, COUNT(*)
FROM Vehicles V
JOIN MisreportedServiceCountView M ON V.vehicleID = M.vehicleID AND V.agencyID = M.agencyID
GROUP BY inService;

-- result 1:

-- inservice | count
-- -----------+-------
-- t         |     1
-- (1 row)

-- insertion statement
INSERT INTO VehicleServices
VALUES (2001,'SFMTA','2019-11-03 12:30:00',TRUE,3500.0);

-- query again
SELECT inService, COUNT(*)
FROM Vehicles V
JOIN MisreportedServiceCountView M ON V.vehicleID = M.vehicleID AND V.agencyID = M.agencyID
GROUP BY inService;

-- result 2:

-- inservice | count
-- -----------+-------
-- (0 rows)


--notes:
-- inService is a boolean and can be True, False, or NULL
-- So the question is basically for vehicles that are in service, out of service, and whose status is unknown how many have a service count mismatch?
