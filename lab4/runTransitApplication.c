/**
 * runTransitApplication skeleton, to be modified by students
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "libpq-fe.h"

/* These constants would normally be in a header file */
/* Maximum length of string used to submit a connection */
#define MAXCONNECTIONSTRINGSIZE 501
/* Maximum length of string used to submit a SQL statement */
#define MAXSQLSTATEMENTSTRINGSIZE 2001
/* Maximum length of string version of integer; you don't have to use a value this big */
#define  MAXNUMBERSTRINGSIZE        20


/* Exit with success after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void good_exit(PGconn* conn)
{
    PQfinish(conn);
    exit(EXIT_SUCCESS);
}

/* Exit with failure after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void bad_exit(PGconn* conn, char *str)
{
    fprintf(stderr, "%s: %s\n", 
                str,PQerrorMessage(conn));
    PQfinish(conn);
    exit(EXIT_FAILURE);
}

/* The three C functions that for Lab4 should appear below.
 * Write those functions, as described in Lab4 Section 4 (and Section 5,
 * which describes the Stored Function used by the third C function).
 *
 * Write the tests of those function in main, as described in Section 6
 * of Lab4.
 *
 * You may use "helper" functions to avoid having to duplicate calls and
 * printing, if you'd like, but if Lab4 says do things in a function, do them
 * in that function, and if Lab4 says do things in main, do them in main,
 * possibly using a helper function, if you'd like.
 */

/* Function: countStationTransfers:
 * ---------------------------------------
 * Parameters: connection, and theStationID, which should be the ID of a station.
 * Returns the number transfers at that station,
 * if there is a station corresponding to theStationID.
 * Returns -1 if no such station.
 * bad_exit if SQL statement execution fails.
 */

int countStationTransfers(PGconn* conn, int theStationID)
{
    //printf("We are in countStationTransfers for %d\n", theStationID);

    //VARIABLES
    PGresult *res;
    int stationIDfound = -1;

    //begin transaction
    if (PQresultStatus(PQexec(conn, "BEGIN ISOLATION LEVEL SERIALIZABLE")) != PGRES_COMMAND_OK) {
        bad_exit(conn, "Begin Transaction Failed");
    }

    char tmp[12];
    const char *paramValues[1];
    sprintf(tmp, "%d", theStationID); //type cast int to str
    paramValues[0] = tmp;

    // go thorugh Stations and see if a station matches theStationID
    res = PQexecParams(conn, "SELECT stationID FROM Stations WHERE stationID =$1", 1, NULL, paramValues, NULL, NULL, 1);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        PQclear(res);
        bad_exit(conn, "Stations Query Failed");
    } 
  
    if (PQntuples(res) < 1) {
        //printf("We are retuning -1\n");
        PQclear(res);
        return -1;
    }
    PQclear(res);
    
    //go through Transfers and count the number of transfers with that StationID
    //use a cursor to the route1 of all transfers that match stationID
    if (PQresultStatus(PQexecParams(conn, "DECLARE c CURSOR FOR SELECT route1 FROM Transfers WHERE stationID =$1", 1, NULL, paramValues, NULL, NULL, 1)) != PGRES_COMMAND_OK) {
        bad_exit(conn, "Transfers Cursor Query Failed");
    }

    //loop through the cursor to count how many there are in cursor!!!!!
    // may need to change comparison to PGRES_TUPLES_OK

    int count = 0;
    while(1){
        res = PQexec(conn, "FETCH NEXT FROM c");
        if (PQntuples(res) == 0)
            break;
        count = count + 1;
    }

    PQclear(res);

    res = PQexec(conn, "CLOSE CURSOR c");
    PQclear(res);

    //End Transaction
    res = PQexec(conn, "END");
    PQclear(res);
    //printf("We are retuning count\n");
    return (count);
}


/* Function: changeRoute:
 * ------------------------
 * Parameters: connection, and character strings theAgencyID, oldRouteID, and newRouteID.
 * Updates the routeID values for all vehicles in Vehicles whose agencyID is theAgencyID
 * and whose routeID was oldRouteID to newRouteID, and returns the number of addresses updates.
 *
 * If no vehicle routes are updated (because no vehicles have oldRouteID as their
 * routeID, return 0; that's not an error.
 *
 * If multiple vehicles (with theAgencyID as their agencyID) had oldRouteID as their routeID, 
 * then update the routeID for all of them, and return the number updated; that's also not an error.
 *
 * However, if there isn't a route whose routeID is theRouteID and whose agencyID is theAgencyID, 
 * then return -1, even if there aren't any vehicles whose routeID is oldRouteID and whose agencyID is theAgencyID.
 */

int changeRoute(PGconn *conn, char* theAgencyID, char* oldRouteID, char* newRouteID)
{

}

/* Function: createNewServiceTickets:
 * -----------------------------------------
 * Parameters:  connection, a character string theAgencyID and float maxTotalServiceCost
 *
 * createNewServiceTickets will try to add new service tickets for some vehicles,
 * starting with those who have the earliest yearBuilt, aa described in Section 5 of the Lab4 pdf.
 *
 * However, the Total Service Cost for this agency, counting the total cost of all vehicles with
 * uncompleted service should not be more than maxTotalServiceCost.
 *
 * Executes by invoking a Stored Function, createNewServiceTicketsFunction, which does
 * all of the work.
 *
 * Returns the new Total Service Cost after the cost of any new tickets have been applied.
 * However, if maxTotalServiceCost is not postiive, this function returns -1.
 *
 * And it is possible that Total Service Cost already equals (or even if greater than) maxTotalServiceCost.
 * That's not an error.  In that case, createNewServiceTickets creates no new tickets, and
 * returns (the unchanged) Total Service Cost.
 */

float createNewServiceTickets(PGconn* conn, char* theAgencyID, float maxTotalServiceCost)
{

}

int main(int argc, char** argv)
{
    printf("We are in main function\n");

    PGconn *conn;

    char conninfo[MAXCONNECTIONSTRINGSIZE] = "port=5432 user=";
    strcat(conninfo, "cse180");
    strcat(conninfo, " password=");
    strcat(conninfo, "database4me");

    /* Make a connection to the database */
    conn = PQconnectdb(conninfo);

    /* Check to see if the database connection was successfully made. */
    if (PQstatus(conn) != CONNECTION_OK)
    {
        // fprintf(stderr, "Connection to database failed: %s\n",
        //         PQerrorMessage(conn));
        bad_exit(conn, "Connection to database failed");
    }
    
    /* Perform the calls to countStationTransfers listed in Section 6 of Lab4,
     * and print messages as described.
     */
    //Required Tests

    int stationIDs[4] = {1920, 9870, 6313, 1279};
    for(int i = 0; i < 4; i++){
        //printf("We are calling countStationTransfers with %d\n", stationIDs[i]);

        int res = countStationTransfers(conn, stationIDs[i]);
        if (res == -1)
            printf("There is no station whose stationID is %d", stationIDs[i]);
        else
            printf("Number of transfers at %d is %d", stationIDs[i], res);
    }
    
    /* Extra newline for readability */
    printf("\n");

    
    /* Perform the calls to changeRoute  listed in Section 6 of Lab4,
     * and print messages as described.
     */
    
    /* Extra newline for readability */
    printf("\n");

    
    /* Perform the calls to createNewServiceTickets  listed in Section 6 of Lab4,
     * and print messages as described.
     * You may use helper functions to do this, if you want.
     */


    good_exit(conn);
    return 0;
}

/*
1) PGresult *PQexec(PGconn *conn, const char *command);
- Submits a command to the server and waits for the result.

so command is any SQL command

res = PQexec(conn, "BEGIN ISOLATION LEVEL SERIALIZABLE");

2) In order to compare to a variable in your code, you can't use PQexec you should use
PQexecParams. 
PGresult *PQexecParams(PGconn *conn,
                       const char *command,
                       int nParams,
                       const Oid *paramTypes,
                       const char * const *paramValues,
                       const int *paramLengths,
                       const int *paramFormats,
                       int resultFormat);

a) All parameters are passed in as char *'s. When compared to the appropriate 
variable in the query, they will be typecasted to int or the appropriate value. 
Unless the parameter is a binary(T/F) in which it must be specified as such. 

3) Don't need to use declare variables like in embedded SQL

4) in pgSQL when you DECLARE a cursor, it is automatically open so you don't need 
to open it again
*/
