



declare global function getStandardPitch {
    parameter speed.
    parameter height is 0.
    declare local pitch is 85.

    //For the initial ascent, we want our steering to be straight
    //up and rolled due east
    IF speed:MAG < 100 {
        //This sets our steering 85 degrees up and yawed to the compass
        //heading of 90 degrees (east)
    //Once we pass 100m/s, we want to pitch down ten degrees
    } ELSE IF speed:MAG >= 100 AND speed:MAG < 200 {
        SET pitch to 80.

    //Each successive IF statement checks to see if our velocity
    //is within a 100m/s block and adjusts our heading down another
    //ten degrees if so
    } ELSE IF speed:MAG >= 200 AND speed:MAG < 300 {
        SET pitch to 70.

    } ELSE IF speed:MAG >= 300 AND speed:MAG < 400 {
        SET pitch to 60.

    } ELSE IF speed:MAG >= 400 AND speed:MAG < 500 {
        SET pitch to 50.

    } ELSE IF speed:MAG >= 500 AND speed:MAG < 600 {
        SET pitch to 40.

    } ELSE IF speed:MAG >= 600 AND speed:MAG < 700 {
        SET pitch to 30.

    } ELSE IF speed:MAG >= 700 AND speed:MAG < 800 {
        SET pitch to 20.

    //Beyond 800m/s, we can keep facing towards 10 degrees above the horizon and wait
    //for the main loop to recognize that our apoapsis is above 100km
    } ELSE IF speed:MAG >= 800 {
        SET pitch to 10.
    }.
    return pitch.


}