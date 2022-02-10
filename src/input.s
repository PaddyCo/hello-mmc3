.include "nes.inc"
.include "input.inc"
.include "memory.inc"


.scope

.export UpdateJoypads
.exportzp joypad_1, joypad_2

.segment "ZEROPAGE"
  joypad_1: .tag Joypad
  joypad_2: .tag Joypad

.segment "CODE"

.proc UpdateJoypads
  jsr UpdatePressedButtons
  jsr UpdateJustPressedReleased
.endproc

;; Updates the joypad status for both joypads
.proc UpdatePressedButtons
  lda joypad_1+Joypad::pressed
  sta joypad_1+Joypad::prev_pressed
  lda joypad_2+Joypad::pressed
  sta joypad_2+Joypad::prev_pressed

  lda #$01
  sta JOYPAD_1
  sta joypad_2+Joypad::pressed
  lsr a
  sta JOYPAD_1
  .scope
    Loop:
      lda JOYPAD_1
      and #%00000011
      cmp #$01
      rol joypad_1+Joypad::pressed
      lda JOYPAD_2
      and #%00000011
      cmp #$01
      rol joypad_2+Joypad::pressed
      bcc Loop
  .endscope

  rts
.endproc

.macro _UpdateJustPressedReleased joypad
  ;; Check which buttons just got released!
  ;; (pressed XOR prev_pressed AND prev_pressed)

  lda joypad+Joypad::prev_pressed
  sta joypad+Joypad::just_released
  lda joypad+Joypad::pressed
  eor joypad+Joypad::just_released
  and joypad+Joypad::just_released
  sta joypad+Joypad::just_released

  ;; Check which bnuttons just got presssed!
  ;; (pressed XOR prev_pressed AND pressed)

  lda joypad+Joypad::prev_pressed
  sta joypad+Joypad::just_pressed
  lda joypad+Joypad::pressed
  eor joypad+Joypad::just_pressed
  sta joypad+Joypad::just_pressed
  lda joypad+Joypad::pressed
  and joypad+Joypad::just_pressed
  sta joypad+Joypad::just_pressed
.endmacro

.proc UpdateJustPressedReleased
  _UpdateJustPressedReleased joypad_1
  _UpdateJustPressedReleased joypad_2
  rts
.endproc

.endscope
