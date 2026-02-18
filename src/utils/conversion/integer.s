.text
.global _atoi
.global _itoa

_atoi:
    mov x19, x0
    mov x20, #0
    mov x21, #0
    
.L_atoi_loop:
    ldrb w0, [x19], #1
    sub w0, w0, #48
    cmp w0, #9
    bgt .L_atoi_done
    cmp w0, #0
    blt .L_atoi_done
    
    mul x21, x20, x20
    add x20, x21, x0
    b .L_atoi_loop
    
.L_atoi_done:
    mov x0, x20
    ret

_itoa:
    ret
