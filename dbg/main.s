
;==============================================================================
;
; DBG
;
; Samuel Volk, July 2018
;
; A GameBoy monitor program.
;
;==============================================================================

.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"


;==============================================================================
; GAMEBOY HEADER
;==============================================================================
.BANK 0
.ORG $00    ; Reset $00
    jp $100
.ORG $08    ; Reset $08
    jp $100
.ORG $10    ; Reset $10
    jp $100
.ORG $18    ; Reset $18
    jp $100
.ORG $20    ; Reset $20
    jp $100
.ORG $28    ; Reset $28
    jp $100
.ORG $30    ; Reset $30
    jp $100
.ORG $38    ; Reset $38
    jp $100
.ORG $40    ; Vblank IRQ Vector
    reti
.ORG $48    ; LCD IRQ Vector
    reti
.ORG $50    ; Timer IRQ Vector
    reti
.ORG $58    ; Serial IRQ Vector
    reti
.ORG $60    ; Joypad IRQ Vector
    reti

.ORG $100   ; Code Execution Start
    nop
    jp Start

;==============================================================================
; HRAM
;==============================================================================

.DEFINE DMARoutine  $FF80

.ENUM $FF8D
    Joypad	    DB
    JoypadOld	    DB
    JoypadDiff	    DB
.ENDE

;==============================================================================
; WRAM
;==============================================================================

.ENUM $C000
    WorkingBase	    DW
    CursorOffset    DB
.ENDE

.DEFINE OAMBuffer   $C100

;==============================================================================
; SUBROUTINES
;==============================================================================
.BANK 0
.SECTION "Subroutines" FREE
; Init Subroutines
BlankData:
    ; a	    value
    ; hl    destination
    ; bc    length/size
    ld d, a	    ; will need later
-   ldi (hl), a
    dec bc
    ld a, b
    or c
    ld a, d
    jr nz, -
    ret

MoveData:
    ; hl    source
    ; de    destination
    ; bc    length/size
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, -
    ret

BlankSprites:
    ld hl, $8000
    ld bc, 4080
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jr nz, -
    ret

BlankOAM:
    ld hl, $C100
    ld bc, 160	; entries
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jr nz, -
    ret

BlankWRAM:
    ld hl, $C000    ; WRAM
    ld bc, $2000    ; counter
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jr nz, -
    ret

LoadTiles:
    ld hl, Tiles
    ld de, $8000
    ld bc, TileCount
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, -
    ret

BlankMap:
    ld hl, $9800
    ld bc, 1024
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

LoadMap:
    ld hl, Map
    ld de, $9800
    ld bc, TileCount
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, -
    ret

ScreenOn:
    ldh a, (R_LCDC)
    or %01000000
    ldh (R_LCDC), a
    ret

ScreenOff:
    ld a, 0
    ldh (R_LCDC), a
    ret

DMARoutineOriginal:
    ld a, >OAMBuffer
    ldh (R_DMA), a
    ld a, $28		; 5x40 cycles, approx. 200ms
-   dec a
    jr nz, -
    ret

ScanJoypad:
    ; move old keypad state
    ld a, (Joypad)
    ld (JoypadOld), a

    ; read new keypad state
    ld a, $20		; P14 (d-pad)
    ldh (R_P1), a
    ldh a, (R_P1)
    ldh a, (R_P1)
    ldh a, (R_P1)
    ldh a, (R_P1)
    cpl
    and $0F
    swap a
    ld b, a
    ld a, $10		; P15 (misc)
    ldh (R_P1), a
    ldh a, (R_P1)
    ldh a, (R_P1)
    ldh a, (R_P1)
    ldh a, (R_P1)
    cpl
    and $0F
    or b

    ; store for later
    ld (Joypad), a

    ; find difference in keystrokes
    ld b, a
    ld a, (JoypadOld)
    xor b
    ld b, a
    ld a, (Joypad)
    and b
    ld (JoypadDiff), a

    ; reset joypad
    ld a, $30
    ld (R_P1), a
    ret

HandleJoypad:
    ldh a, (JoypadDiff & $FF)
    cp 0
    jr z, @end		    ; no need to handle it, no new buttons pressed

    cp %01000000
    jr z, @up
    cp %10000000
    jr z, @down
    cp %00100000
    jr z, @left
    cp %00010000
    jr z, @right
    jr @end

    ; cursor movement
@up:
    ld a, (CursorOffset)
    ld b, 8
    cp b
    jr c, @end
    sub b
    ld (CursorOffset), a
    jr @end
@down:
    ld a, (CursorOffset)
    ld b, 8
    cp (8*16) - 9
    jr nc, @end
    add b
    ld (CursorOffset), a
    jr @end
@left:
    ld a, (CursorOffset)
    cp 0
    jr z, @end
    dec a
    ld (CursorOffset), a
    jr @end
@right:
    ld a, (CursorOffset)
    cp (8*16) - 1
    jr z, @end
    inc a
    ld (CursorOffset), a
    jr @end

@end:
    ret

DrawMem:
    ld a, (WorkingBase)
    ld h, a
    ld a, (WorkingBase+1)
    ld l, a
    ld de, $9803
    ld b, 16
--  ld c, 8
-   ldi a, (hl)
    push af
    and $F0
    swap a
    inc a
    ld (de), a
    inc de
    pop af
    and $0F
    inc a
    ld (de), a
    inc de
    dec c
    xor a
    cp c
    jr nz, -
    ld a, $10
    add e
    ld e, a
    jr nc, +
    inc d
+   xor a
    dec b
    cp b
    jr nz, --
    ret

DrawBar:
    ld de, $9A20	    ; start of bottom row
    ld hl, WorkingBase

    ; Base address
.REPEAT 2
    ldi a, (hl)		    ; base address lsb
    ld b, a
    and $F0
    swap a
    inc a
    ld (de), a
    inc de
    ld a, b
    and $0F
    inc a
    ld (de), a
    inc de
.ENDR

    inc de
    inc de

    ; Cursor offset
    ld hl, CursorOffset
    ld a, (hl)
    ld b, a
    and $F0
    swap a
    inc a
    ld (de), a
    inc de
    ld a, b
    and $0F
    inc a
    ld (de), a
    inc de

    ret

.ENDS

;==============================================================================
; START
;==============================================================================
.ORG $150
Start:
    di
    ld sp, $FFFE    ; setup stack

    ; wait for vblank
-   ld a, (LY)
    cp $91
    jr nz, -
    ; turn screen off
    call ScreenOff

    ; no sound needed
    xor a
    ldh (R_NR52), a

    ;xor a
    ld hl, $C000
    ld bc, $2000
    call BlankData	; blank WRAM
    ld hl, $8000
    ld bc, $2000
    call BlankData	; blank VRAM

    call LoadTiles

    call BlankMap
    ;call LoadMap

    ; load palette
    ld a, %11100100	; bg
    ldh (R_BGP), a
    ld a, %00011011	; obj
    ldh (R_OBP0), a

    ld hl, DMARoutineOriginal
    ld de, DMARoutine
    ld bc, _sizeof_DMARoutineOriginal
    call MoveData

    ; set some initial variables up
    ld a, $01
    ld (WorkingBase), a
    ld a, $50
    ld (WorkingBase+1), a

    call DrawMem
    call DrawBar

    ; setup screen
    ld a, %10010011
    ldh (R_LCDC), a

    ; enable vblank interrupt
    ld a, $01 
    ldh (R_IE), a
    ei

MainLoop:
    halt
    nop
    call $FF80 ; DMA routine in HRAM

    call ScanJoypad
    call HandleJoypad
    call DrawBar

    jr MainLoop


;==============================================================================
; DATA
;==============================================================================

.SECTION "Tiles" FREE

Tiles:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.INCBIN "numbers.bin" FSIZE sizeofnums
.INCBIN "alphas.bin" FSIZE sizeofalphas
.DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.DB $C0,$C0,$70,$70,$1C,$1C,$07,$07,$07,$07,$1C,$1C,$70,$70,$C0,$C0

.DEFINE TileCount   (1*16 + sizeofnums + sizeofalphas + 2*16)

.ENDS

.SECTION "Maps" FREE
Map:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.ENDS

; vim: filetype=wla
