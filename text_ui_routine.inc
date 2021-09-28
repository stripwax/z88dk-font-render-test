    ld a, (bc)
    or (hl)
    ld (de), a                      ; put it on screen

    inc c                           ; advance to next byte of character data (assumes char data
    inc l                           ; base address is aligned to multiple of 8 bytes - it most probably is)

