    ld a, (bc)
    or (hl)
    ld (de), a                      ; put it on screen

    inc bc                          ; advance to next byte of character data (assumes char data
    inc hl                          ; base address is aligned to multiple of 8 bytes - it most probably is)

