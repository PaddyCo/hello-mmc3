.include "global.inc"
.export TestProc

.segment "ZEROPAGE"
    test_var: .res 1
    test_var2: .res 1

.segment "CODE"
.byte $DE, $AD, $BE, $EF
.proc TestProc
    ;test
    inc test_var
    rts
.endproc
