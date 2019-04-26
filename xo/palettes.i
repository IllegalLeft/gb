.SECTION "Palettes" FREE

SGBPal_Base:
.DB ($00 << 3) + 1
Pal_Base:
.DW $24A6
.DW $4609
.DW $2B72
.DW $77DC
.DB $00

SGBPal_SeaGreen:
.DB ($00 << 3) + 1
Pal_SeaGreen:
.DW $7FFA, $4790, $2209, $0920
.DW $4790, $2209, $0920
.DB $00

SGBPal_GreyScale:
.DB ($01 << 3) + 1
Pal_GreyScale:
.DW $7FFA, $6B5A, $318C, $0000
.DW $6B5A, $318C, $0000
.DB $00
.ENDS

; vim: filetype=wla
