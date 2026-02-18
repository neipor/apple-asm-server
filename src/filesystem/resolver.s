.data
.align 4

resolved_path:
    .space 512

.text
.global _resolve_path
.global _path_is_safe
.global _normalize_path

_path_is_safe:
    mov x19, x0
    
L_check_start:
    ldrb w1, [x19], #1
    
    cmp w1, #0
    beq L_safe
    
    cmp w1, #'.'
    bne L_check_start
    
    ldrb w1, [x19], #1
    
    cmp w1, #'.'
    bne L_single_dot
    
    ldrb w1, [x19], #1
    
    cmp w1, #'/'
    beq L_unsafe
    
    cmp w1, #0
    beq L_unsafe
    
    b L_check_start
    
L_single_dot:
    cmp w1, #'/'
    beq L_unsafe
    
    b L_check_start
    
L_unsafe:
    mov x0, #0
    ret
    
L_safe:
    mov x0, #1
    ret

_normalize_path:
    mov x19, x0
    mov x20, x1
    
    adrp x21, resolved_path@PAGE
    add x21, x21, resolved_path@PAGEOFF
    mov x22, x21
    
    mov x23, x20
    
L_norm_loop:
    ldrb w1, [x23], #1
    
    cmp w1, #'/'
    beq L_norm_slash
    
    cmp w1, #0
    beq L_norm_end
    
    strb w1, [x22], #1
    b L_norm_loop
    
L_norm_slash:
    ldrb w1, [x22, #-1]
    cmp w1, #'/'
    beq L_norm_loop
    
    movz w1, #'/'
    strb w1, [x22], #1
    b L_norm_loop
    
L_norm_end:
    ldrb w1, [x22, #-1]
    cmp w1, #'/'
    beq L_norm_final
    movz w1, #0
    strb w1, [x22], #1
    
L_norm_final:
    movz w1, #0
    strb w1, [x22], #1
    
    mov x0, x21
    ret

_resolve_path:
    mov x19, x0
    mov x20, x1
    
    bl _normalize_path
    
    mov x19, x0
    
    bl _path_is_safe
    
    cmp x0, #0
    beq L_resolve_bad
    
    mov x0, x19
    ret
    
L_resolve_bad:
    adrp x0, resolved_path@PAGE
    add x0, x0, resolved_path@PAGEOFF
    ret
