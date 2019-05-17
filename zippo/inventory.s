.INCLUDE "header.i"

.DEFINE Inv_MaxItems    14
.EXPORT Inv_MaxItems

.SECTION "Inventory" FREE

Inv_PrintItem:
    push de
-   ldi a, (hl)
    cp 0
    ret z
    cp $FF
    jr z, @newline
    ld (de), a
    inc de
    jr -
@newline:
    pop de
    ld c, $20
    ld a, e
    add c
    ld e, a
    ld a, 0
    adc d
    ld d, a
    jr -

Inv_DrawText:
    ; Prints item name in inventory screen
    ; a     inventory entry #
    push af
    sla a   ; *2
    ld hl, w_inv
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, (hl)
    sla a
    ld e, a
    ld d, 0
    ; load addr to string data
    ld hl, Inv_ItemNameLUT
    add hl, de
    ldi a, (hl)
    ld b, a
    ld a, (hl)
    ld h, a
    ld l, b
    ; get proper starting addr for str
    pop af
    sla a
    ld bc, Inv_ItemNameAddrLUT
    add c
    ld e, a
    ld a, 0
    adc b
    ld d, a
    ld a, (de)
    ld c, a
    inc de
    ld a, (de)
    ld d, a
    ld e, c

    ; print str to proper spot
    call Inv_PrintItem
    ret

Inv_DrawIcon:
    ; a	    inventory id
    ; get inventory item id
    push af
    sla a
    ld hl, w_inv
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, (hl)
    sla a   ;
    sla a   ; *4
    ; get tile start
    ld b, $70 ; start of tiles
    add b
    ld b, a
    ; get map addr
    ld hl, $9861    ; start of icon map address
    pop af	    ; get item id back
    cp 6
    jr c, @firstcol
    ld de, 9
    add hl, de
    sub 7
@firstcol:
    ld c, a	    ; row # in c
-   xor a
    or c
    jr z, @edittiles
    ld a, $40	    ; every row tile addr is $40 away from eachother
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    dec c
    jr -
    
@edittiles:
    ; place/edit the 4 tiles
    ld a, b
    ldi (hl), a
    inc a
    ld (hl), a
    inc a
    ld bc, $20-1
    add hl, bc
    ldi (hl), a
    inc a
    ld (hl), a
    ret

Inv_DrawInv:
    ld c, Inv_MaxItems
    xor a
-   push af
    push bc
    call Inv_DrawText
    pop bc
    pop af
    push af
    push bc
    call Inv_DrawIcon
    pop bc
    pop af
    inc a
    cp c
    jr nz, -
    ret

.ENDS

.SECTION "InventoryData" FREE

Inv_ItemNameLUT:
.DW Text_ItemNone
.DW Text_ItemWaterBucket
.DW Text_ItemEyeGlass
.DW Text_ItemNewsPaper

Inv_ItemNameAddrLUT:
.DW $9863, $98A3, $98E3, $9923, $9963, $99A3, $99E3
.DW $986C, $98AC, $98EC, $992C, $996C, $99AC, $99EC

.ENDS

; vim: filetype=wla
