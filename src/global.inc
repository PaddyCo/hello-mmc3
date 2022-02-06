.ifndef GLOBAL_INC
.define GLOBAL_INC

.include "nes.inc"

; vectors
.global Reset, NMI, IRQ

; main.s
.global Main
.globalzp arg0, arg1, argw0, argw1

; test.s
.global TestProc
.globalzp test_var2

; mmc3.s
.global SetLoBank, SetHiBank

; init.s
.global ClearMemory

; ppu.s
.global WaitForVBlank, LoadPalettes

.endif
