.text
.global _buffer_init
.global _buffer_read
.global _buffer_write
.global _buffer_clear

_buffer_init:
    mov x19, x0
    mov x20, x1
    
    str xzr, [x19, #0]
    str xzr, [x19, #8]
    str x20, [x19, #16]
    
    ret

_buffer_read:
    ret

_buffer_write:
    ret

_buffer_clear:
    str xzr, [x0, #0]
    str xzr, [x0, #8]
    ret
