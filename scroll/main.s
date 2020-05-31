;==============================================================================
;
; SCROLL
;
; Samuel Volk, July 2018
;
; Description
;
;==============================================================================

.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"
.INCLUDE "hram.i"
.INCLUDE "wram.i"


;==============================================================================
; SUBROUTINES
;==============================================================================
.BANK 0 SLOT 0
.SECTION "Subroutines" FREE
; Init Subroutines
BlankData:
    ; a     value
    ; hl    destination
    ; bc    length/size
    ld d, a			; will need later
-   ldi (hl), a
    dec bc
    ld a, b
    or c
    ld a, d
    jr nz, -
    ret

MoveData:
    ;hl  source
    ;de  destination
    ;bc  length/size
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

ReadInput:
    ldh a, (H_joyStateNew)
    ldh (H_joyStateOld), a

    ld a, $20		    ; select P14
    ldh ($00), a
    ldh a, ($00)	    ; read pad
    ldh a, ($00)	    ; a bunch of times
    ldh a, ($00)	    ; for good measure
    cpl			    ; active low so flip 'er
    and $0F		    ; only need the last 4 bits
    swap a
    ld b, a
    ld a, $10		    ; select P15
    ldh ($00), a	    ;
    ldh a, ($00)
    ldh a, ($00)
    ldh a, ($00)
    cpl			    ; active low
    and $0F		    ; only need last 4 bits
    or b		    ; put the joypad results together
    ldh (H_joyStateNew), a  ; store in zeropage for later

    ld b, a		    ; find difference in two keystates
    ldh a, (H_joyStateOld)
    xor b
    ld b, a
    ldh a, (H_joyStateNew)
    and b
    ldh (H_joyStateDiff), a

    ld a, $30		    ; reset joypad
    ld ($FF00), a
    ret

HandleInput:
    ldh a, (H_joyStateNew)
    cp joy_up
    jr nz, @checkjoydown    ; up keypress
    ldh a, (R_SCY)
    dec a
    ldh (R_SCY), a

    ld a, (mapypix)         ; dec mapypix counter
    dec a
    ld (mapypix), a
    cp $FF                  ; check if 0
    jr nz, @checkjoydown
    ld a, 7                 ; need to set it back up to 8
    ld (mapypix), a
    ld a, (mapy)            ; dec mapy
    dec a                   ;
    ld (mapy), a            ;

    ; draw upper line
    ld a, 1
    ld (drawline), a
    jr @newline



@checkjoydown:
    cp joy_down
    jr nz, @handleinputend  ; down keypress
    ldh a, (R_SCY)
    inc a
    ldh (R_SCY), a

    ld a, (mapypix)         ; inc mapypix
    inc a
    ld (mapypix), a
    cp $08
    jr nz, @handleinputend
    ld a, 0                 ; need to set it back down to 0
    ld (mapypix), a
    ld a, (mapy)            ; inc mapy
    inc a                   ;
    ld (mapy), a            ;
    
    ; draw lower line
    ld a, 2
    ld (drawline), a
    ldh a, (R_SCY)
    add ($12+3)*8           ; add lines to get to the lower line
    jr +

@newline:                   ; note: this is only touched by upper lines...
    ldh a, (R_SCY)          ;
    sub (3)*8               ; ...up to here

+   srl a                   ; shift left to divide by 8
    srl a                   ;
    srl a                   ;
    ld c, a
    ld de, $9800
-   xor a
    cp c
    jr z, @drawline
    ld a, $20
    add e
    ld e, a
    ld a, 0
    adc d
    ld d, a
    dec c
    jr -

@drawline:
+   ; de    vram addr
    ld a, e                 ; store for address to draw later
    ld (linevramaddr), a
    ld a, d
    ld (linevramaddr+1), a
    ; find map addr
    ld a, (drawline)        ; need to determine if upper or lower
    cp 1
    jr nz, @lower

@upper:
    ld a, (mapy)
    sub $3
    jr +
@lower:
    ld a, (mapy)
    add $12+3               ; add lines to get lower line

+   ld c, a
    ld hl, tapestryMap      ; starting map addr
-   xor a
    cp c
    jr z, +
    ld a, $14
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    dec c
    jr -

+   ld a, l                 ; store mapaddr for drawing later
    ld (linemapaddr), a
    ld a, h
    ld (linemapaddr+1), a

@handleinputend:
    ret

.ENDS

;==============================================================================
; START
;==============================================================================
.ORG $150
Start:
    di
    ld sp, $FFFE            ; setup stack

-   ld a, (LY)              ; wait vblank
    cp $91
    jr nz, -
    xor a
    ldh (R_LCDC), a         ; turn off screen
    ldh (R_NR52), a         ; turn off sound

    ;xor a
    ld hl, $C000
    ld bc, $2000
    call BlankData          ; blank WRAM
    ld hl, $8000
    ld bc, $2000
    call BlankData          ; blank VRAM
    ld hl, $FF80
    ld bc, $0060
    call BlankData	    ; blank HRAM

    ; load palette
    ld a, %11100100	    ; bg
    ldh (R_BGP), a
    ld a, %00011011	    ; obj
    ldh (R_OBP0), a

    ; load tiles
    ld hl, CP437Tiles
    ld de, $8000
    ld bc, 192*16
    call MoveData
    
    ; draw first full screen, and 4 lines below
    ld hl, tapestryMap
    call LoadScreen

    call DMACopy            ; set up DMA subroutine
    call DMARoutine         ; clear OAM

    ld a, %10010011         ; setup screen
    ldh (R_LCDC), a

    ld a, $01 
    ldh (R_IE), a           ; enable vblank interrupt
    ei

MainLoop:
    halt
    nop
    ;call DMARoutine

    ; do we need to draw a line?
    ld a, (linevramaddr+1)  ; should be like $98-$9B
    cp 0
    jr z, @nodraw
    ld hl, linevramaddr
    ldi a, (hl)             ; load vram addr
    ld e, a                 ;
    ldi a, (hl)
    ld d, a                 ;
    ldi a, (hl)
    ld c, a
    ldi a, (hl)
    ld b, a
    ld h, b
    ld l, c
    ld bc, $14              ; counter
    call MoveData
    ld hl, linevramaddr
    xor a
    ldi (hl), a             ; clear addresses for drawing
    ldi (hl), a             ; so it doesn't draw again
    ldi (hl), a             ;
    ldi (hl), a             ;

@nodraw:
    call ReadInput
    call HandleInput

    jp MainLoop


; vim: filetype=wla
