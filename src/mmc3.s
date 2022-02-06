.include "common.inc"
.include "global.inc"
.import NES_MAPPER, NES_PRG_BANKS, NES_CHR_BANKS, NES_MIRRORING, NES_LO_BANKS
.importzp arg0
.export SetLoBank, SetHiBank

.segment "HEADER"
  .byte "NES", $1a ; This is a NES rom!
  .byte <NES_PRG_BANKS ; X * 16KB PRG ROM
  .byte <NES_CHR_BANKS ; X * 8KB CHR ROM
  .byte <NES_MAPPER << 4 ; Mapper and mirroring
  .byte INES20
  .byte $00
  .byte $00
  .byte $00
  .byte $00, $00, $00, $00, $00 ; Filler

.segment "CODE"
  .proc SetLoBank
    ; Set slot you want to switch to
    lda #%00000110
    sta $8000
    ; Set bank
    lda arg0
    sta $8001
    rts
  .endproc

  .proc SetHiBank
    ; Set slot you want to switch to
    lda #%00000111
    sta $8000
    ; Set bank
    lda arg0
    adc #<NES_LO_BANKS ; Offset with amount of Lo Banks (so Bank #0 will map to first Hi Bank)
    sta $8001
    rts
  .endproc
