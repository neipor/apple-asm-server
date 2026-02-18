.text
.global _str_compare

_str_compare:
    mov x19, x0
    mov x20, x1
    
.L_compare_loop:
    ldrb w2, [x19], #1
    ldrb w3, [x20], #1
    cmp w2, w3
    bne .L_compare_diff
    cbnz w2, .L_compare_loop
    
    mov x0, #0
    ret
    
.L_compare_diff:
    sub x0, x2, x3
    ret

.global _str_equal
_str_equal:
    bl _str_compare
    cmp x0, #0
    cset x0, eq
    ret
