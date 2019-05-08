.INCLUDE "header.i"

.ASCIITABLE
    MAP "A" TO "Z" = $50
    MAP "a" to "z" = $50
    MAP " " = $6A
    MAP "@" = $00
.ENDA

.SECTION "Strings" FREE
Text_Items:
.ASC "water bucket@"
.ENDS

; vim: filetype=wla
