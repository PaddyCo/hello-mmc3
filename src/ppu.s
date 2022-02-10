.export WaitForVBlank, SHADOW_OAM

.include "nes.inc"

SHADOW_OAM = $200

.segment "STARTUP"
.proc WaitForVBlank
  bit PPUSTATUS
  bpl WaitForVBlank
  rts
.endproc
