.text
.global _mem_copy

_mem_copy:
    mov x19, x0
    mov x20, x1
    mov x21, x2
    
    cmp x21, #0
    beq .L_copy_done
    
.L_copy_loop:
    ldrb w0, [x20], #1
    strb w0, [x19], #1
    subs x21, x21, #1
    bne .L_copy_loop
    
.L_copy_done:
    ret
