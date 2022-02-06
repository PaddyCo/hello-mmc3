.include "global.inc"
.exportzp arg0, arg1, argw0, argw1
.export Main

.segment "ZEROPAGE"
  arg0: .res 1
  arg1: .res 1
  argw0: .res 2
  argw1: .res 2

.segment "STARTUP"
Main:
  inc $203
  jsr TestProc

  .scope SpriteDMA
    lda #$02
    sta OAM_DMA
  .endscope

  jsr WaitForVBlank
  jmp Main

NMI:
  rti

IRQ:
  rti

.segment "VECTORS"
  .word NMI
  .word Reset
  .word IRQ

.segment "CHARS"
  .incbin "../data/tiles.chr"
