.ifndef _INPUT_INC
_INPUT_INC := 1

.import UpdateJoypads
.importzp joypad_1, joypad_2

.struct Joypad
  pressed       .res 1
  just_pressed  .res 1
  just_released .res 1
  prev_pressed  .res 1
.endstruct

.endif
