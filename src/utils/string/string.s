.text
.global _str_copy
.global _str_length
.global _str_compare
.global _str_equal
.global _str_find_char
.global _str_starts_with

_str_copy:
    mov x19, x0
    mov x20, x1
    
.L_copy_loop:
    ldrb w1, [x20], #1
    strb w1, [x19], #1
    cbnz w1, .L_copy_loop
    
    ret

_str_length:
    mov x19, x0
    mov x20, x0
    
.L_length_loop:
    ldrb w1, [x19], #1
    cbnz w1, .L_length_loop
    
    sub x0, x19, x20
    ret

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

_str_equal:
    mov x19, x0
    mov x20, x1
    
.L_equal_loop:
    ldrb w2, [x19], #1
    ldrb w3, [x20], #1
    cmp w2, w3
    bne .L_equal_no
    cbz w2, .L_equal_yes
    b .L_equal_loop
    
.L_equal_yes:
    mov x0, #1
    ret
    
.L_equal_no:
    mov x0, #0
    ret

_str_find_char:
    mov x19, x0
    mov w20, w1
    
.L_find_loop:
    ldrb w1, [x19], #1
    cmp w1, w20
    beq .L_found
    cbnz w1, .L_find_loop
    
    mov x0, #-1
    ret
    
.L_found:
    sub x0, x19, x0
    ret

_str_starts_with:
    mov x19, x0
    mov x20, x1
    
.L_starts_loop:
    ldrb w2, [x20], #1
    cbz w2, .L_starts_match
    ldrb w3, [x19], #1
    cmp w2, w3
    bne .L_starts_no
    b .L_starts_loop
    
.L_starts_match:
    mov x0, #1
    ret
    
.L_starts_no:
    mov x0, #0
    ret
