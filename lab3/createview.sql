CREATE VIEW MisreportedServiceCountView 
AS 

(SELECT V.vehicleID, V.agencyID, V.serviceCount, COUNT (VS.serviceTimestamp) as actualServiceCount
FROM Vehicles V
LEFT JOIN VehicleServices VS ON V.vehicleID = VS.vehicleID AND V.agencyID = VS.agencyID
GROUP BY (V.vehicleID, V.agencyID, V.serviceCount)
HAVING ABS(COUNT(VS.serviceTimestamp) - V.serviceCount) >= 2
);

