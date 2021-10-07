EXTERN _text_x
EXTERN _text_y
EXTERN asm_zx_cxy2saddr
PUBLIC _text_ui_write

EXTERN font_even_index
EXTERN font_odd_index
EXTERN font_even_index_rev
EXTERN font_odd_index_rev


; stack: string to write
; stack: amount to write (number of characters)
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
    ld a, (ix)
    add a, a
    ld (_text_ui_write_odd_get + 1), a
_text_ui_write_odd_get:
    ld hl, (font_odd_index+0)

    dec iyl
    jp z, _text_ui_write_odd_only

    inc ix

    ld a, (ix)
    add a, a
    ld (_text_ui_write_even_get + 2), a
_text_ui_write_even_get:
    ld bc, (font_even_index)

    inc ix

    ; now we hold the following
    ; de - current screen address: top of char
    ; bc - current character A data address of first pixel row
    ; hl - current character B data address of first pixel row

    ; do ([d++]e) << (bc++) | (hl++) 8 times

    include "text_ui_routine.inc"
    include "text_ui_routine.inc"
    include "text_ui_routine.inc"
    include "text_ui_routine.inc"
    include "text_ui_routine.inc"
    include "text_ui_routine.inc"
    include "text_ui_routine.inc"
    include "text_ui_routine_onerow.inc"

    dec iyl                         ; do we have more to print?
    ret z

    inc e                           ; onto next screen address position (horizontally)

                                    ; next two characters, printed bottom-to-top, to avoid d<-iyh instructions

    ld a, (ix)
    add a, a
    ld (_text_ui_write_odd_get_rev + 1), a
_text_ui_write_odd_get_rev:
    ld hl, (font_odd_index_rev+0)

    dec iyl
    jp z, _text_ui_write_odd_rev_only

    inc ix

    ld a, (ix)
    add a, a
    ld (_text_ui_write_even_get_rev + 2), a
_text_ui_write_even_get_rev:
    ld bc, (font_even_index_rev+0)

    inc ix

    ; now we hold the following
    ; de - current screen address: BOTTOM of char
    ; bc - current character A data address of LAST pixel row
    ; hl - current character B data address of LAST pixel row

    ; do ([d--]e) << (bc--) | (hl--) 8 times

    include "text_ui_routine_rev.inc"
    include "text_ui_routine_rev.inc"
    include "text_ui_routine_rev.inc"
    include "text_ui_routine_rev.inc"
    include "text_ui_routine_rev.inc"
    include "text_ui_routine_rev.inc"
    include "text_ui_routine_rev.inc"
    include "text_ui_routine_onerow.inc"

    inc e                           ; onto next screen address position (horizontally)

    dec iyl                         ; do we have more to print?
    jp nz, _text_ui_write_loop

    ret                             ; we're done

_text_ui_write_odd_only:
    ; now we hold the following
    ; de - current screen address: top of char
    ; hl - current character A data address of first pixel row

    ; do ([d++]e) << (hl++) 8 times

    include "text_ui_routine_odd.inc"
    include "text_ui_routine_odd.inc"
    include "text_ui_routine_odd.inc"
    include "text_ui_routine_odd.inc"
    include "text_ui_routine_odd.inc"
    include "text_ui_routine_odd.inc"
    include "text_ui_routine_odd.inc"
    include "text_ui_routine_odd_onerow.inc"

    ret

_text_ui_write_odd_rev_only:
    ; now we hold the following
    ; de - current screen address: BOTTOM of char
    ; hl - current character A data address of LAST pixel row

    ; do ([d--]e) << (hl--) 8 times

    include "text_ui_routine_odd_rev.inc"
    include "text_ui_routine_odd_rev.inc"
    include "text_ui_routine_odd_rev.inc"
    include "text_ui_routine_odd_rev.inc"
    include "text_ui_routine_odd_rev.inc"
    include "text_ui_routine_odd_rev.inc"
    include "text_ui_routine_odd_rev.inc"
    include "text_ui_routine_odd_onerow.inc"

    ret
