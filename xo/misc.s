.INCLUDE "cgb_hardware.i"
.INCLUDE "header.i"


;==============================================================================
; MISC 
;==============================================================================

.SECTION "Misc Subroutines" FREE

; Init Subroutines
BlankData:
    ; a	    value
    ; hl    destination
    ; bc    length/size
    ld d, a			; will need to retrieve later
-   ldi (hl), a
    dec bc
    ld a, b
    or c
    ld a, d
    jp nz, -
    ret

MoveData:
    ; hl  source
    ; de  destination
    ; bc  length/size
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

LoadScreen:
    ; hl    map source
    ld de, $9800
    ld c, $12
--  ld b, $14
-   ldi a, (hl)
    ld (de), a
    inc de
    dec b
    jp nz, -
    ld a, 12
    add e
    ld e, a
    ld a, 0
    adc d
    ld d, a
    dec c
    jp nz, --
    ret

SoundOn:
    xor a
    ldh (R_NR52), a
    ret

SoundOff:
    ld a, $80
    ldh (R_NR52), a
    ret

DetectSystem:
    ldh ($8D), a	; save startup value in accumulator
    ld a, $30
    ldh (R_P1), a	; reset joypad selector pins for test

    ; MLT_REQ test
    ld hl, MLT_REQ2P
    call SGBSend
    ld a, $30
    ldh (R_P1), a
    ldh a, (R_P1)
    ldh a, (R_P1)
    ldh a, (R_P1)
    ld b, a
    ld a, $20
    ldh (R_P1), a
    ld a, $10
    ldh (R_P1), a
    ld a, $30
    ldh (R_P1), a
    ldh a, (R_P1)
    ldh a, (R_P1)
    ldh a, (R_P1)
    cp b
    jr nz, @IsSGB

@NotSGB:
    ldh a, ($8D)
    cp $01
    jr z, @DMG
    cp $FF
    jr z, @MGB
    jr @CGB
@IsSGB:
    ld hl, MLT_REQ1P
    call SGBSend
    ldh a, ($8D)
    cp $01
    jr z, @SGB
    jr @SGB2

@DMG:
@MGB:
    xor a
    ldh (h_CGB), a
    ldh (h_SGB), a
    ret
@CGB:
    ld a, 1
    ldh (h_CGB), a
    xor a
    ldh (h_SGB), a
    ret
@SGB:
@SGB2:
    ld a, 1
    ldh (h_SGB), a
    xor a
    ldh (h_CGB), a
    ret


ReadInput:
    ld a, (joypadStateNew)	; move old keypad state
    ld (joypadStateOld), a

    ld a, $20	    ; select P14
    ld ($FF00), a
    ld a, ($FF00)   ; read pad
    ld a, ($FF00)   ; a bunch of times
    cpl		    ; active low so flip 'er 
    and $0f	    ; only need last 4 bits
    swap a
    ld b, a
    ld a, $10	    ; select P15
    ld ($FF00), a   ;
    ld a, ($FF00)
    ld a, ($FF00)
    cpl
    and $0F	    ; only need last 4 bits
    or b	    ; put a and b together
    ld (joypadStateNew), a ; store into 0page for later

    ld b, a			; Find difference in two keystates
    ld a, (joypadStateOld)
    xor b
    ld b, a
    ld a, (joypadStateNew)
    and b
    ld (joypadStateDiff), a

    ld a, $30	    ; reset joypad
    ld ($FF00), a
    ret

HandleInput:
    ld a, (joypadStateDiff)
    ld b, a
    and JOY_RIGHT
    jp z, @noright
    ld a, (cursorx)
    cp 2
    jp z, @noright
    inc a
    ld (cursorx), a
    call CursorUpdate
@noright:
    ld a, b
    and JOY_LEFT
    jp z, @noleft
    ld a, (cursorx)
    cp 0
    jp z, @noleft
    dec a
    ld (cursorx), a
    call CursorUpdate
@noleft:
    ld a, b
    and JOY_UP
    jp z, @noup
    ld a, (cursory)
    cp 0
    jp z, @noup
    dec a
    ld (cursory), a
    call CursorUpdate
@noup:
    ld a, b
    and JOY_DOWN
    jp z, @nodown
    ld a, (cursory)
    cp 2
    jp z, @nodown
    inc a
    ld (cursory), a
    call CursorUpdate
@nodown:
    ld a, b
    and JOY_A
    jp z, @noa
    ld hl, state    ; is it player's turn?
    ld a, (hl)
    cp 1
    jp nz, @noa	    ; jump if it isn't
    ld a, (cursory)
    cp 0
    jp z, +	; you don't need to multiply it if it's 0
    ld c, a
    xor a
-   add 3
    dec c
    jp nz, -
+   ld c, a
    ld a, (cursorx)
    add c	; offset for cursor square in a
    ld hl, field
    ld d, 0
    ld e, a
    add hl, de	; add offset to find selected field spot
    ld a, (hl)
    cp 0
    jp z, @place
@noa:
    ret
@place:
    ld b, 1
    push hl	    ; need to save hl (offset for field spot)
    call DrawFieldTile2
    pop hl
    ld (hl), 1	    ; Xs are 1
    ld hl, state
    ld (hl), 2	    ; Os turn
    ret

RandomInt:
    ld a, (seed)
    sla a
    jp nc, +
    xor %00011101
+   ld (seed), a
    ret

CPUTurn:
-   call RandomInt  ; get a random spot
    and $0F
    cp 9
    jp nc, -
    ld hl, field    ; is it occupied?
    ld d, 0
    ld e, a
    add hl, de
    ld a, (hl)
    cp 0
    jp nz, -	    ; ...then pick another!
    ld (hl), 2	    ; place
    ld b, 2
    ;ld de, ..	; already loaded up to go!
    call DrawFieldTile2
    ld a, 1
    ld (state), a   ; players turn now
    ret

CheckforWin:
    ; This function will return 1 on x win and 2 on o win and 3 for tie
    ; return value in accumulator

    ; horizontal wins
    ld hl, field
    ld b, 3	    ; three rows
--  ld c, 3	    ; three spots per row
    ldi a, (hl)	    ; load the first one
    jp +
-   and (hl)	    ; but and it with the next two for result
    inc hl
+   dec c
    jp nz, -
    and 3	    ; row is finished check, compare result
    jp nz, @hwin    ; handle win
    dec b	    ; next row
    jp nz, --
    jp @nohwin
@hwin:
    ret		    ; acc. has the winning side already
@nohwin:

    ; vertical wins
    ld hl, field
    ld de, 3	    ; column items are 3 bytes apart
    ld b, 3	    ; three columns
--  ld c, 3	    ; three spots
    ld a, (hl)	    ; load first one
    jp +
-   and (hl)	    ; but and it with the next two for result
+   add hl, de
    dec c
    jp nz, -
    and 3	    ; column is finished check, compare result
    jp nz, @vwin    ; handle win
    dec b	    ; next column
    jp z, @novwin   ; b = 0 so we are done
    bit 0, b
    jp nz, @col2    ; b must be odd
@col1:
    ld hl, (field+1)
    jp @coladdrpicked
@col2:
    ld hl, (field+2)
@coladdrpicked:
    xor a
    cp b
    jp nz, --	    ; start new column
    jp @novwin
@vwin:
    ret		    ; acc. has the winning side already
@novwin:

    ; diagonal wins
    ld hl, field	; top left to bottom right
    ld a, (hl)
    inc l
    inc l
    inc l
    inc l
    and (hl)
    inc l
    inc l
    inc l
    inc l
    and (hl)
    jp nz, @diagonalwin
    ; top right to bottom left
    ld hl, (field+2)	; top left to bottom right
    ld a, (hl)
    inc l
    inc l
    and (hl)
    inc l
    inc l
    and (hl)
    jp nz, @diagonalwin
    jp @diagonalnowin
@diagonalwin:
    ret		    ; acc. has winning side
@diagonalnowin:

    ; check for filled field (tie)
    ld hl, field
    ld c, 9
-   ldi a, (hl)
    and $0F	    ; just to get the Z flag really
    jp z, @notie
    dec c
    jp nz, -
@tie:
    ld a, 3	    ; tie
    ret
@notie:
    xor a
    ret

.ENDS

; vim: filetype=wla
