
;==============================================================================
; HRAM
;==============================================================================

; HRAM constants
.DEFINE DMARoutine	$FF80
.DEFINE h_CGB	        $8D
.DEFINE h_SGB	        $8E
.EXPORT DMARoutine, h_CGB, h_SGB
.ENUM $FF8D EXPORT              ; before this is after the DMA routine
    CGB			DB	; is gameboy colour?
    SGB			DB	; is super gameboy?
    joypadStateNew	DB
    joypadStateOld	DB
    joypadStateDiff	DB
.ENDE

.DEFINE JOY_A	    1 << 0
.DEFINE JOY_B	    1 << 1
.DEFINE JOY_SELECT  1 << 2
.DEFINE JOY_START   1 << 3
.DEFINE JOY_RIGHT   1 << 4
.DEFINE JOY_LEFT    1 << 5
.DEFINE JOY_UP	    1 << 6
.DEFINE JOY_DOWN    1 << 7
.EXPORT JOY_A, JOY_B, JOY_SELECT, JOY_START
.EXPORT JOY_LEFT, JOY_RIGHT, JOY_UP, JOY_DOWN


; vim: filetype=wla
