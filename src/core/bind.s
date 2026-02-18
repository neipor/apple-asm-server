.text
.global _socket_bind

_socket_bind:
    mov x19, x0
    mov w20, w1
    
    sub sp, sp, #32
    mov x21, sp
    
    movz w22, #2
    strh w22, [x21, #0]
    
    and w22, w20, #0xFF
    lsr w23, w20, #8
    and w23, w23, #0xFF
    
    strb w22, [x21, #3]
    strb w23, [x21, #2]
    
    str wzr, [x21, #4]
    str wzr, [x21, #8]
    
    mov x0, x19
    mov x16, #104
    mov x1, x21
    movz x2, #16
    svc #0
    
    add sp, sp, #32
    ret
