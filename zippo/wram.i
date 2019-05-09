.STRUCT item
id      DB
amount  DB
.ENDST

.ENUM $C000 EXPORT
w_inv       INSTANCEOF  item 14
.ENDE

;vim: filetype=wla
