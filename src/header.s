.import NES_MAPPER, NES_PRG_BANKS, NES_CHR_BANKS, NES_MIRRORING, NES_LO_BANKS

INES20 = %00001000

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
