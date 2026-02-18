.text
.global _mem_set

_mem_set:
    mov x19, x0
    mov x20, x1
    mov x21, x2
    
    cmp x21, #0
    beq .L_set_done
    
    and w20, w20, #0xFF
    
.L_set_loop:
    strb w20, [x19], #1
    subs x21, x21, #1
    bne .L_set_loop
    
.L_set_done:
    ret
