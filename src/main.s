.include "ppu.inc"
.include "init.inc"
.include "input.inc"
.include "memory.inc"
.include "nes.inc"

.export Main

.segment "STARTUP"
Main:
  jsr UpdateJoypads
  ;; Insert more logic here

  ;; Wait for VBlank to finish
  jsr WaitForVBlank

  ;; Everything PPU related here:
  .scope SpriteDMA
    lda #$02
    sta OAM_DMA
  .endscope

  ;; It's a loop, baby!
  jmp Main

NMI:
  ;; Stuff that has to run every frame, everything else be damned
  ;; Good for: Music, probably some other stuff!
  rti

IRQ:
  rti

.segment "VECTORS"
  .word NMI
  .word Reset
  .word IRQ

.segment "CHARS"
  .incbin "../data/tiles.chr"
