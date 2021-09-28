EXTERN _text_x
EXTERN _text_y
EXTERN asm_zx_cxy2saddr
EXTERN _font_4x8_80columns
PUBLIC _text_ui_write

align 8
font_even:
    binary "font_4x8_even.bin"

font_odd:
    binary "font_4x8_odd.bin"

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
    ld h, 0
    ld l, (ix)
    inc ix

    sla l
    add hl, hl
    add hl, hl                      ; multiply by 8
    add hl, font_odd - 32 * 8

    ld bc, hl                       ; bc now holds characted data A

    ld h, 0
    ld l, (ix)
    inc ix

    sla l
    add hl, hl
    add hl, hl                      ; multiply by 8
    add hl, font_even - 32 * 8      ; hl now holds characted data B

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

    inc e                           ; onto next screen address position (horizontally)

    dec iyl                         ; do we have more to print?
    ret z
                                    ; next two characters, printed bottom-to-top, to avoid d<-iyh instructions
    ld h, 0
    ld l, (ix)
    inc ix

    sla l
    add hl, hl
    add hl, hl                      ; multiply by 8
    add hl, font_odd - 32 * 8 + 7   ; add 7 to point to bottom

    ld bc, hl                       ; bc now holds characted data A (bottom)

    ld h, 0
    ld l, (ix)
    inc ix

    sla l
    add hl, hl
    add hl, hl                      ; multiply by 8
    add hl, font_even - 32 * 8 + 7  ; hl now holds characted data B (bottom)

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

