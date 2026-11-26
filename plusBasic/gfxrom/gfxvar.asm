;=====================================================================================
; Graphics system variable accessors
;
; RECONSTRUCTED: The original gfxvar.asm was never committed upstream. This file
; was rebuilt by disassembling the 78 bytes found at this location ($E681 in the
; auxiliary ROM) in the prebuilt zout/sysrom.bin, so that the assembled ROM matches
; that binary byte-for-byte. Label names are guesses; the originals are unknown.
; None of these routines are referenced by the rest of the ROM.
;
; Each routine takes an inline byte after the CALL: the offset of the variable
; in the BASIC buffer page (BAS_BUFFR), which is mapped into Bank 2 while the
; variable is accessed, after which RAM_BAS_2 is mapped back.
;=====================================================================================

;-----------------------------------------------------------------------------
; Read word variable
; Input: Inline byte: variable offset
; Output: DE = variable contents
; Note: returns to the inline byte rather than past it
;-----------------------------------------------------------------------------
gfxvar_get_de:
    pop     ix                    ; IX = Pointer to inline offset
    push    hl
    ld      l,(ix+0)
    ld      h,BANK2_BASE>>8       ; HL = Variable address
    ex      af,af'
    ld      a,BAS_BUFFR
    out     (IO_BANK2),a          ; Map BASIC buffers into Bank 2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                ; DE = Variable contents
    ld      a,RAM_BAS_2
    out     (IO_BANK2),a          ; Map BASIC RAM back into Bank 2
    ex      af,af'
    pop     hl
    jp      (ix)

;-----------------------------------------------------------------------------
; Read word variable into HL
;-----------------------------------------------------------------------------
gfxvar_get_hl:
    ex      de,hl
    call    gfxvar_get_de
    ex      de,hl
    ret

;-----------------------------------------------------------------------------
; Write byte variable
; Input: Inline byte: variable offset
;        A = value to write
; Clobbered: Alternate registers
;-----------------------------------------------------------------------------
gfxvar_set_a:
    exx
    pop     ix                    ; IX = Pointer to inline offset
    ld      l,(ix+0)
    ld      h,BANK2_BASE>>8       ; HL' = Variable address
    inc     ix                    ; Skip inline offset
    ld      c,a
    ld      a,BAS_BUFFR
    out     (IO_BANK2),a          ; Map BASIC buffers into Bank 2
    ld      (hl),c
    ld      a,RAM_BAS_2
    out     (IO_BANK2),a          ; Map BASIC RAM back into Bank 2
    ld      a,c
    exx
    jp      (ix)

;-----------------------------------------------------------------------------
; Write word variable
; Input: Inline byte: variable offset
;        DE = value to write
; Note: returns to the inline byte rather than past it
;-----------------------------------------------------------------------------
gfxvar_set_de:
    pop     ix                    ; IX = Pointer to inline offset
    push    hl
    ld      l,(ix+0)
    ld      h,BANK2_BASE>>8       ; HL = Variable address
    ex      af,af'
    ld      a,BAS_BUFFR
    out     (IO_BANK2),a          ; Map BASIC buffers into Bank 2
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      a,RAM_BAS_2
    out     (IO_BANK2),a          ; Map BASIC RAM back into Bank 2
    ex      af,af'
    pop     hl
    jp      (ix)
