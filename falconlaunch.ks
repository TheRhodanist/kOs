//load dependencies
switch to 0.
RUNPATH(ascentcurves.ks).
COPYPATH(circle.ks, "1:").
COPYPATH(execnode.ks, "1:").
switch to 1.

//declare parameters
declare parameter targetAltitude is 82000.
declare parameter head is 90.
declare parameter circle is true.
declare global hasSeperated is false.

declare function stageBooster {
    SET thr to 0.
    UNTIL SHIP:ALTITUDE>46000 {
        SET MYSTEER TO prograde.
        wait 0.1.
    }
    wait 1.
    TOGGLE ag10.
    wait 1.
    STAGE. 
    SET hasSeperated to true.
    wait 2.
    IF SHIP:APOAPSIS < targetAltitude-5000 {
        SET thr to 1.   
    }
}











//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

//Disable SAS
SAS OFF.
SET thr to 1.0.
//Next, we'll lock our throttle to 100%.
LOCK THROTTLE TO thr.   // 1.0 is the max, 0.0 is idle.
SET MYSTEER TO HEADING(SHIP:HEADING,90).
LOCK STEERING TO MYSTEER. // from now on we'll be able to change steering by just assigning a new value to MYSTEER

//This is our countdown loop, which cycles from 10 to 0
PRINT "Counting down:".
FROM {local countdown is 3.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}
STAGE.

LIST ENGINES IN elist.



//This will be our main control loop for the ascent. It will
//cycle through continuously until our apoapsis is greater
//than target altitude. Each cycle, it will check each of the IF
//statements inside and perform them if their conditions
//are met
UNTIL SHIP:APOAPSIS > targetAltitude { //Remember, all altitudes will be in meters, not kilometers
    PRINT "Stage: " + STAGE:NUMBER AT (0,12).
    FOR e IN elist {
        //PRINT ""+e:FLAMEOUT+"/"+e:NAME at (0,11). 
        IF e:FLAMEOUT {
            SET tmpVel to MYSTEER.
            SET MYSTEER TO SHIP:VELOCITY:SURFACE.
            wait 1.
            STAGE.
            PRINT "STAGING!" AT (0,13).

            UNTIL STAGE:READY {
                WAIT 0.1.
            }
            SET MYSTEER to tmpVel.
            LIST ENGINES IN elist.
            BREAK.
        }
    }
    // Control throttle to sustain a predictable acceleration curve
    // SET twr to SHIP:MASS / SHIP:AVAILABLETHRUST.//Ship:Mass * SHIP:SENSORS:GRAV:MAG / Ship:AvailableThrust.
    // IF twr > 2 {
    //     IF thr > 0 {
    //         SET thr to thr - 0.01.
    //     }
    // }
    // IF twr < 2 {
    //     IF thr < 1 {
    //         SET thr to thr + 0.01.
    //     }
    // }
    // PRINT "Current TWR "+twr AT (0,13).
    //lock throttle to 2 * Ship:Mass * g / Ship:AvailableThrust.

    IF SHIP:ALTITUDE<2000 {
        IF SHIP:ALTITUDE>250 {
            SET MYSTEER to HEADING(head,85).
        }
    }
    ELSE {
        SET pitch to getStandardPitch(SHIP:VELOCITY:SURFACE).
        SET MYSTEER TO HEADING(head,pitch).
        PRINT "Pitching to "+pitch+" degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).
    }

    IF not hasSeperated and SHIP:PARTSDUBBED("landingtank")[0]:MASS < SHIP:PARTSDUBBED("landingtank")[0]:WETMASS{
        stageBooster().
    }
}.

PRINT targetAltitude+"m apoapsis reached, cutting throttle".
SET thr TO 0.
SET MYSTEER TO prograde.
if SHIP:ALTITUDE < 46000 {
    SET MYSTEER TO prograde.
    wait 0.1.
}.
IF SHIP:PARTSDUBBED("liftingcore"):LENGTH > 0{
    stageBooster().
}
//If still in the atmosphere, physicwarp out of it
if SHIP:ALTITUDE < 70000 {
    SET kuniverse:timewarp:mode TO "PHYSICS".
    SET kuniverse:timewarp:warp to 3.
    until SHIP:altitude > 70000 {
        SET MYSTEER TO prograde.
        wait 0.1.
    }
    SET kuniverse:timewarp:mode TO "RAILS".
    SET kuniverse:timewarp:warp to 0.
}
wait 2.

//After exiting the Atmosphere

//Possibly discarding the lifting stage depending on parameter ...
//and if the main lifting stage is even there


//trigger actiongroups to prepare upper stage for space
TOGGLE ag9.
wait 1.
TOGGLE ag8.
wait 2.


//At this point, our apoapsis is above the target altitude and our main loop has ended. 
//If the parameter indicated that we would want to circularize, do so.
IF circle {
    run circle.ks.
}





//This sets the user's throttle setting to zero to prevent the throttle
//from returning to the position it was at before the script was run.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.


