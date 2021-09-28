    ld a, (bc)
    or (hl)
    ld (de), a                      ; put it on screen

    dec bc                          ; advance (backwards) to next byte of character data (assumes char data
    dec hl                          ; base address is aligned to multiple of 8 bytes - it most probably is)

