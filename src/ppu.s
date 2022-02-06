.include "global.inc"
.export WaitForVBlank

.segment "STARTUP"
.proc WaitForVBlank
  bit PPUSTATUS
  bpl WaitForVBlank
  rts
.endproc
