.text
.global _str_copy

_str_copy:
    mov x19, x0
    mov x20, x1
    
.L_copy_loop:
    ldrb w2, [x20], #1
    strb w2, [x19], #1
    cbnz w2, .L_copy_loop
    
    ret
