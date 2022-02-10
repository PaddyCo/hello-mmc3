.include "ppu.inc"
.include "memory.inc"
.include "main.inc"
.include "mmc3.inc"
.include "nes.inc"

.export Reset

.segment "STARTUP"
Reset:
  sei ; Ignore IRQs
  cld ; Disable decimal mode as it is not supported by the NES

  ;; Disable Sound IRQ
  ldx #$40
  stx $4017

  ;; Mirroring
  ldx #$01
  stx $A000

  ;; Init stack register
  ldx #$FF
  txs

  inx ; X = #$00
  stx PPUCTRL ; disable NMI
  stx PPUMASK ; disable rendering
  stx $4010 ; disable DMC IRQs

  bit PPUSTATUS ; Clear vblank flag (unknown state after reset)

  jsr WaitForVBlank

  .scope ClearMemory
    loop:
      lda #$00
      sta $0000, X
      sta $0100, X
      sta $0300, X
      sta $0400, X
      sta $0500, X
      sta $0600, X
      sta $0700, X
      lda #$FF
      sta $0200, X
      inx
      bne loop
  .endscope

  ; Initialize banks
  .scope InitBanks
    lda #$00
    sta r0
    jsr SetLoBank

    lda #$00
    sta r0
    jsr SetHiBank
  .endscope

  jsr WaitForVBlank

  lda dummyPalette
  sta r0

  .scope LoadPalettes
    lda #$3f
    sta PPUADDR
    lda #$00
    sta PPUADDR

    ldx #$0
    loop:
      lda dummyPalette, x
      sta PPUDATA
      inx
      cpx #$10
      bne loop
  .endscope

  lda #$00
  sta PPUADDR
  lda #$00
  sta PPUADDR

  .scope LoadNametable
    NametablePtr := r0
    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR

    lda #<dummyNametable
    sta NametablePtr
    lda #>dummyNametable
    sta NametablePtr+1

    ldy #$00
    ldx #$00
      loop:
        lda (NametablePtr), y
        sta PPUDATA
        iny
        cpy #$00
        bne loop
      inx
      inc NametablePtr+1
      cpx #$04
      bne loop
  .endscope

  jsr WaitForVBlank

  .scope InitDummySprite
    lda #$20
    sta SHADOW_OAM
    sta SHADOW_OAM+3
    lda #$11
    sta SHADOW_OAM+1
    lda #%00100011
    sta SHADOW_OAM+2
  .endscope

  ; Enable interrupts
  cli
  lda #%10000000
  sta PPUCTRL
  lda #%00011110
  sta PPUMASK

  jsr WaitForVBlank

  jmp Main

.segment "LOBANK00"
dummyPalette:
  .byte $0f,$33,$23,$03,$0f,$26,$17,$07,$0f,$14,$2a,$19,$0f,$30,$25,$03
dummyNametable:
  .incbin "../data/nametable.nam"

