.include "ppu.inc"
.include "init.inc"
.include "input.inc"
.include "memory.inc"
.include "nes.inc"

.export Main

.segment "ZEROPAGE"
  frame_count: .res 1

.segment "STARTUP"
Main:

  ;; Add some logic here!

  ;; Work's done! Wait for the next frame to start:
  lda frame_count
  waitForNextFrame:
    cmp frame_count
    beq waitForNextFrame

  ;; It's a loop, baby!
  jmp Main

NMI:
  ;; Backing up registers
  pha
  txa
  pha
  tya
  pha

  ;; Shadow OAM
  lda #>shadow_oam ; Start DMA transfer of
  sta OAM_DMA      ; Shadow OAM!

  ;; Update inputs
  jsr UpdateJoypads

  ;; Increase frame count, which signals Main it it is time to get to work!
  inc frame_count

  ;; Restoring registers
  pla
  tay
  pla
  tax
  pla

  rti

IRQ:
  rti

.segment "VECTORS"
  .word NMI
  .word Reset
  .word IRQ

.segment "CHARS"
  .incbin "../data/tiles.chr"
