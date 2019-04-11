
;==============================================================================
; HEADER
;==============================================================================

.GBHEADER
    NAME "DBG"
    CARTRIDGETYPE $00 ; RAM only
    RAMSIZE $00 ; 32KByte, no ROM banking
    COUNTRYCODE $01 ; outside Japan
    NINTENDOLOGO
    LICENSEECODENEW "SV"
    ROMDMG  ; DMG rom
.ENDGB


.MEMORYMAP
    DEFAULTSLOT 0
    SLOTSIZE $4000
    SLOT 0 $0000
    SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2

.ASCIITABLE
    MAP "0" TO "9" = $01
    MAP "A" TO "Z" = $01+11
    MAP " " = $19
    MAP "@" = $00
.ENDA

; vim: filetype=wla
