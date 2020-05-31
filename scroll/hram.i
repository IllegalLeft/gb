.DEFINE H_DMARoutine      $80 ; to $FF8C
.DEFINE H_joyStateNew     $8D
.DEFINE H_joyStateOld     $8E
.DEFINE H_joyStateDiff    $8F

; Joypad bitmasks
.DEFINE joy_a	    1 << 0
.DEFINE joy_b	    1 << 1
.DEFINE joy_select  1 << 2
.DEFINE joy_start   1 << 3
.DEFINE joy_right   1 << 4
.DEFINE joy_left    1 << 5
.DEFINE joy_up	    1 << 6
.DEFINE joy_down    1 << 7

.ENUM $FF80
DMARoutine      ds  13
joyStateNew     db
joyStateOld     db
joyStateDiff    db
.ENDE

; vim: filetype=wla
