.INCLUDE "header.i"

.ASCIITABLE
    MAP "A" TO "Z" = $50
    MAP "a" to "z" = $50
    MAP " " = $6A
    MAP "^" = $FF
    MAP "@" = $00
.ENDA

.SECTION "Strings" FREE
Text_Items:
Text_ItemNone:
.ASC "^@"
Text_ItemWaterBucket:
.ASC "water^bucket@"
Text_ItemEyeGlass:
.ASC "eye^glass@"
Text_ItemNewsPaper:
.ASC "news^paper@"
.ENDS

; vim: filetype=wla
