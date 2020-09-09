.STRUCT item
id      DB
amount  DB
.ENDST

.ENUM $C000 EXPORT
w_inv       INSTANCEOF  item 14
.ENDE

.DEFINE OAM_Buffer  $C100   EXPORT

; vim: filetype=wla
