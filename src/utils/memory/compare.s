.text
.global _mem_compare

_mem_compare:
    mov x19, x0
    mov x20, x1
    mov x21, x2
    
    cmp x21, #0
    beq .L_equal
    
.L_compare_loop:
    ldrb w0, [x19], #1
    ldrb w1, [x20], #1
    cmp w0, w1
    bne .L_diff
    subs x21, x21, #1
    bne .L_compare_loop
    
.L_equal:
    mov x0, #0
    ret
    
.L_diff:
    sub x0, x0, x1
    ret
