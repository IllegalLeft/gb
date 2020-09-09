.INCLUDE "header.i"

.BANK 0
.ORG $00            ; Reset $00
    jp $100

.ORG $08            ; Reset $08
    jp $100

.ORG $10            ; Reset $10
    jp $100

.ORG $18            ; Reset $18
    jp $100

.ORG $20            ; Reset $20
    jp $100

.ORG $28            ; Reset $28
    jp $100

.ORG $30            ; Reset $30
    jp $100

.ORG $38            ; Reset $38
    jp $100

.ORG $40            ; VBlank IRQ Vector
    reti

.ORG $48            ; LCD IRQ Vector
    reti

.ORG $50            ; Timer IRQ Vector
    reti

.ORG $58            ; Serial IRQ Vector
    reti

.ORG $60            ; Joypad IRQ Vector
    reti


.ORG $100           ; Code Execution Start
    nop
    jp Start

; vim: filetype=wla
