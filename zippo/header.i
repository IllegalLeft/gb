.GBHEADER
    NAME "ZIPPO"
    CARTRIDGETYPE $00       ; RAM only
    RAMSIZE $00             ; 32KByte, no ROM banking
    COUNTRYCODE $01         ; outside of Japan
    NINTENDOLOGO
    LICENSEECODENEW "SV"
    ;LICENSEECODEOLD $00
    ROMDMG
.ENDGB

.MEMORYMAP
    DEFAULTSLOT 0
    SLOTSIZE $4000
    SLOT 0 $0000
    SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2

; vim: filetype=wla
