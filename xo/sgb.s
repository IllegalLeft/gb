.INCLUDE "cgb_hardware.i"
.INCLUDE "header.i"


.SECTION "SGBFunctions" FREE

PAL_SET:
    .DB ($0A << 3) + 1
    .DB 0, 1, 2, 3, 4, 5, 6, 7
    .DS 7, $00
PAL_TRN:
    .DB ($0B << 3) + 1
    .DS 15, $00
MLT_REQ1P:
    .DB ($11 << 3) + 1
    .DS 15, $00
MLT_REQ2P:
    .DB ($11 << 3) + 1
    .DB $01
    .DS 14, $00
MLT_REQ4P:
    .DB ($11 << 3) + 1
    .DB $03
    .DS 14, $00
PAL01:
    .DB ($00 << 3) + 1
    .DW $24A6, $4609, $2B72, $77DC
    .DW $4609, $2B72, $77DC
    .DB $00

SGBSend:
    ; hl    SGB data to send (16 bytes long)
    ld a, (hl)
    and $07		; only packet count
    ret z		; no need to send if no packets to send
    ld d, a

    ; RESET pulse
--- xor a
    ldh (R_P1), a
    ld a, $30
    ldh (R_P1), a
    ; send the rest of the data
    ld c, 16		; # of bytes to send 
--  ld e, 8		; counter for shifting
    ldi a, (hl)		; load byte to send
    ld b, a		; keep data to send safe in b
-   bit 0, b
    jr nz, @send1
@send0:
    ld a, $20
    jr +
@send1:
    ld a, $10
+   ldh (R_P1), a	; send data
    ld a, $30
    ldh (R_P1), a	; reset pins
    rr b
    dec e
    jr nz, -
    dec c
    jr nz, --
    ; stop bit
    ld a, $20
    ldh (R_P1), a
    ld a, $30
    ldh (R_P1), a

    dec d
    ; pause 60ms
    ld bc, 7000
-   nop
    nop
    nop
    dec bc
    ld a, b
    or c
    jr nz, -
    ; next packet?
    xor a
    cp d
    jr nz, ---
    ret

.ENDS

; vim: filetype=wla
