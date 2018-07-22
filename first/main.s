.ROMBANKSIZE $4000
.ROMBANKS 2
.CARTRIDGETYPE 0

.COMPUTEGBCHECKSUM
.COMPUTEGBCOMPLEMENTCHECK

.MEMORYMAP
DEFAULTSLOT 0
SLOTSIZE $4000
SLOT 0 $0000
SLOT 1 $4000
.ENDME

.INCLUDE "nintendo_logo.i"

;==============================================================================
.BANK 0
; GB HEADER
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
;.ORG $104   ; Nintendo Logo
;	.DB	$CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
;	.DB	$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
;	.DB	$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E
.ORG $134   ; Game Title
    .DB "SAM FIRST"
.ORG $13F   ; Product code
    .DB "    "
.ORG $143   ; Color Gameboy compatibility code
    .DB $01

.ORG $144   ; Licence code
	.DB	$00,$00

.ORG $146   ; Gameboy indicator
	.DB	$00	; $00 - GameBoy

; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
.ORG $147   ; Cartridge type
	.DB	$00 ; $00 - ROM Only

; $0148 (ROM size)
.ORG $148   ; ROM Size
	.DB	$00
.ORG $149   ; RAM Size
	.DB	$00	; $00 - None

.ORG $14A   ; Destination code
	.DB	$01	; $01 - non-japanese

; $014B (Licensee code - this _must_ be $33)
.ORG $14B
	.DB	$33	; $33 - Check $0144/$0145 for Licensee code.

; $014C (Mask ROM version - handled by RGBFIX)
.ORG $14C
	.DB	$00

; $014D (Complement check - handled by RGBFIX)
;.ORG $14D
;	.DB	$00

; $014E-$014F (Cartridge checksum - handled by RGBFIX)
;	.DW	$00


;==============================================================================

.ORG $150
Start:
    di

    call SCREEN_OFF

Loop:
    jp Loop

;==============================================================================
