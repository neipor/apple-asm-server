.text
.global _str_find_char

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

.global _str_find
_str_find:
    ret

.global _str_starts_with
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
