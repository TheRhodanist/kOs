clearScreen.
wait 1.
//Set Target Altitude
SET heightTarget TO SHIP:APOAPSIS.
//Add Node
SET myNode TO NODE(TIME:SECONDS+ETA:APOAPSIS,0,0,0).
ADD myNode.

//Set Prograde burn till circle
UNTIL myNode:orbit:periapsis >= heightTarget-100 {
    SET myNode:prograde TO myNode:prograde+1.
}

run execnode.