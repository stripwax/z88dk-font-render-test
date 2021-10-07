    include "text_ui_routine_onerow.inc"

    inc c                           ; advance to next byte of character data (assumes char data
    inc l                           ; base address is aligned to multiple of 8 bytes - which it is)
    inc d                           ; advance one pixel row down
