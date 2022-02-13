.export WaitForVBlank, shadow_oam

.include "nes.inc"

.segment "SHADOW_OAM"
  shadow_oam: .res $100

.segment "STARTUP"
.proc WaitForVBlank
  bit PPUSTATUS
  bpl WaitForVBlank
  rts
.endproc
