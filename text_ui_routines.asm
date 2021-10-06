EXTERN _text_x
EXTERN _text_y
EXTERN asm_zx_cxy2saddr
EXTERN _font_4x8_80columns
PUBLIC _text_ui_write

ALIGN 8

font_even:
    binary "font_4x8_even.bin"

font_odd:
    binary "font_4x8_odd.bin"

ALIGN 256

font_odd_top_lut:
    defs 256 ; font_odd+0, font_odd+8, etc
font_even_top_lut:
    defs 256 ; font_even+0, font_even+8, etc
font_odd_bottom_lut:
    defs 256 ; font_odd+7, font_odd+15, etc
font_even_bottom_lut:
    defs 256 ; font_even+7, font_even+15, etc


; stack: string to write
; stack: amount to write
; registers used:
;     iyl - number of characters left to write
;     de - current screen address
;     bc - current characted A data address
;     hl - current character B data address
;     ix - current string address
_text_ui_write:
    pop hl                          ; ret
    pop iy                          ; pop the amount into iyl
    pop ix                          ; pop string address into ix
    push hl                         ; ret

    ld a, (_text_x)                 ; get initial screen address
    ld l, a
    ld a, (_text_y)
    ld h, a
    call asm_zx_cxy2saddr

    ex de, hl                       ; de now holds a screen address

_text_ui_write_loop:
;    ld h, 0
;    ld l, (ix)
;    sla l
;    add hl, hl
;    add hl, hl                      ; multiply by 8
;    add hl, font_odd - 32 * 8
;    ld bc, hl                       ; bc now holds character data A

    ld a, (ix)
    add a, a
    ld (get1_a+2), a
get1_a: ld bc, (font_odd_top_lut+0)

    inc ix

;    ld h, 0
;    ld l, (ix)
;    sla l
;    add hl, hl
;    add hl, hl                      ; multiply by 8
;    add hl, font_even - 32 * 8      ; hl now holds characted data B

    ld a, (ix)
    add a, a
    ld (get2_a+2), a
get2_a: ld hl, (font_even_top_lut+0)

    inc ix

    ; now we hold the following
    ; de - current screen address
    ; bc - current characted A data address
    ; hl - current character B data address

    ; do ([d++]e) << (bc++) | (hl++) 8 times

    include "text_ui_routine.inc"
    inc d
    include "text_ui_routine.inc"
    inc d
    include "text_ui_routine.inc"
    inc d
    include "text_ui_routine.inc"
    inc d
    include "text_ui_routine.inc"
    inc d
    include "text_ui_routine.inc"
    inc d
    include "text_ui_routine.inc"
    inc d
    include "text_ui_routine.inc"

    dec iyl                         ; do we have more to print?
    ret z

    inc e                           ; onto next screen address position (horizontally)

                                    ; next two characters, printed bottom-to-top, to avoid d<-iyh instructions

;    ld h, 0
;    ld l, (ix)
;    sla l
;    add hl, hl
;    add hl, hl                      ; multiply by 8
;    add hl, font_odd - 32 * 8 + 7   ; add 7 to point to bottom

;    ld bc, hl                       ; bc now holds characted data A (bottom)

    ld a, (ix)
    add a, a
    ld (get1_b+2), a
get1_b: ld bc, (font_odd_bottom_lut+0)

    inc ix

;    ld h, 0
;    ld l, (ix)
;    sla l
;    add hl, hl
;    add hl, hl                      ; multiply by 8
;    add hl, font_even - 32 * 8 + 7  ; hl now holds characted data B (bottom)

    ld a, (ix)
    add a, a
    ld (get2_b+1), a
get2_b: ld hl, (font_even_bottom_lut+0)

    inc ix

    ; now we hold the following
    ; de - current screen address
    ; bc - current characted A data address
    ; hl - current character B data address

    ; do ([d--]e) << (bc--) | (hl--) 8 times

    include "text_ui_routine_rev.inc"
    dec d
    include "text_ui_routine_rev.inc"
    dec d
    include "text_ui_routine_rev.inc"
    dec d
    include "text_ui_routine_rev.inc"
    dec d
    include "text_ui_routine_rev.inc"
    dec d
    include "text_ui_routine_rev.inc"
    dec d
    include "text_ui_routine_rev.inc"
    dec d
    include "text_ui_routine_rev.inc"

    inc e                           ; onto next screen address position (horisontally)

    dec iyl                         ; do we have more to print?
    jp nz, _text_ui_write_loop

    ret                             ; we're done

