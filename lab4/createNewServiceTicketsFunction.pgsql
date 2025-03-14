CREATE OR REPLACE FUNCTION
createNewServiceTicketsFunction(theAgencyID VARCHAR(5), maxTotalServiceCost NUMERIC(10,2))
RETURNS NUMERIC(10,2) AS $$
    DECLARE
        tmpVehicleID INTEGER;
        tmpCost NUMERIC(8,2);
        tmpYearBuilt INTEGER;
        initialCost NUMERIC(10,2); 

    -- Make cursor that equals tuple of vehicles with same agency not already in vehicle services
    DECLARE c CURSOR FOR
        SELECT V.vehicleID, V.yearBuilt
        FROM Vehicles V
        WHERE V.agencyID = theAgencyID AND
            V.yearBuilt <= 2020 AND
            NOT EXISTS (SELECT * 
                    FROM VehicleServices VS
                    WHERE V.vehicleID = VS.vehicleID 
                    AND V.agencyID = VS.agencyID
                    AND VS.serviceComplete = "F")
        ORDER BY V.yearBuilt DESC; 
    
    BEGIN 

    IF maxTotalServiceCost <= 0 THEN
        RETURN -1;
    ELSIF (SELECT COUNT(*) FROM Agencies WHERE AgencyID = theAgencyID) == 0 THEN
        RETURN -2;
    END IF;

    
    -- First find current cost of services for Agency
    SELECT SUM(cost) INTO initialCost
    FROM VehicleServices
    WHERE agencyID = theAgencyID
    AND serviceComplete = "F";

    --Loop takes care of this check
    --IF initialCost >= maxTotalServiceCost THEN
    --    RETURN initialCost;
    --END IF;

    -- See which changes you can implement
    OPEN c;
        LOOP
            FETCH c INTO tmpVehicleID, tmpYearBuilt;
            EXIT WHEN NOT FOUND;

            IF tmpYearBuilt <= 1980 THEN
              tmpCost := 10000.00;
            ELSIF tmpYearBuilt <= 2000 THEN
              tmpCost := 5000.00;
            ELSIF tmpYearBuilt <= 2020 THEN
              tmpCost := 1500.00;
            END IF;

            EXIT WHEN tmpCost + initialCost >= maxTotalServiceCost;

            -- ADD QUERY
            INSERT INTO VehicleServices 
            VALUES(tmpVehicleID, theAgencyID, "2025-03-14 11:59:00", "F", tmpCost);

            initialCost := initialCost + tmpCost;

        END LOOP;
    CLOSE c;
    RETURN initialCost;
    END

$$ LANGUAGE plpgsql;
