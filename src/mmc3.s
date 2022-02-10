.import NES_LO_BANKS
.include "memory.inc"

.export SetLoBank, SetHiBank

.segment "CODE"

  ;; Set low bank ($8000-9FFF)
  ;;
  ;; INPUTS -
  ;;   r0 - bank to switch to
  .proc SetLoBank
    ; Set slot you want to switch to
    lda #%00000110
    sta $8000
    ; Set bank
    lda r0
    sta $8001
    rts
  .endproc

  ;; Set high bank ($A000-BFFF)
  ;;
  ;; INPUTS -
  ;;   r0 - bank to switch to
  .proc SetHiBank
    ; Set slot you want to switch to
    lda #%00000111
    sta $8000
    ; Set bank
    lda r0
    adc #<NES_LO_BANKS ; Offset with amount of Lo Banks (so Bank #0 will map to first Hi Bank)
    sta $8001
    rts
  .endproc
