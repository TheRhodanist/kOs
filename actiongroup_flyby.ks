declare local a1 to false.
declare local a2 to false.

print "Waiting for ship to unpack.".
wait until ship:unpacked.
print "Ship is now unpacked.".
wait 2.

UNTIL 0>1 {
    declare local alti to SHIP:ALTITUDE.
    clearScreen.
    PRINT "Current parent body is "+SHIP:BODY+" at an altitude of "+alti+"m".
    IF SHIP:BODY = BODY("Sun") {
        PRINT "Can do".
    }
    IF SHIP:BODY = BODY("Moho") {
        IF alti <40000 {
            IF a2 = false {
                SET a2 to true.
                ag2.
            }
        } ELSE {
            IF a1 = false {
                SET a1 to true.
                ag1.
            }
        }
    }
    wait 1.
}