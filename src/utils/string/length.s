.text
.global _str_length

_str_length:
    mov x19, x0
    mov x20, x0
    
.L_length_loop:
    ldrb w1, [x19], #1
    cbnz w1, .L_length_loop
    
    sub x0, x19, x20
    ret
