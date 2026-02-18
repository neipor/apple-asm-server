.data
.align 4

file_path_buffer:
    .space 512

stat_buffer:
    .space 144

file_stat_result:
    .word 0
    .word 0
    .word 0
    .word 0
    .quad 0
    .quad 0
    .quad 0
    .word 0
    .word 0
    .quad 0

.text
.global _file_open_ro
.global _file_close
.global _file_read_all
.global _file_stat
.global _file_get_size
.global _file_exists
.global _build_file_path

_file_open_ro:
    mov x19, x0
    
    mov x0, x19
    movz x1, #0
    movz x2, #0
    mov x16, #5
    svc #0
    
    ret

_file_close:
    mov x19, x0
    mov x16, #6
    mov x0, x19
    svc #0
    ret

_file_read_all:
    mov x19, x0
    mov x20, x1
    
    mov x22, x1
    mov x23, #0
    
L_read_loop:
    mov x0, x19
    add x1, x22, x23
    mov x2, #8192
    mov x16, #3
    svc #0
    
    cmp x0, #0
    ble L_read_done
    
    add x23, x23, x0
    
    cmp x0, #8192
    blt L_read_done
    
    b L_read_loop
    
L_read_done:
    mov x0, x23
    ret

_file_stat:
    mov x19, x0
    mov x20, x1
    
    mov x0, x19
    mov x1, x20
    mov x16, #4
    svc #0
    
    ret

_file_get_size:
    mov x19, x0
    
    adrp x20, stat_buffer@PAGE
    add x20, x20, stat_buffer@PAGEOFF
    
    mov x0, x19
    mov x1, x20
    mov x16, #4
    svc #0
    
    cmp x0, #0
    bne L_size_err
    
    ldr x0, [x20, #24]
    ret
    
L_size_err:
    mov x0, #-1
    ret

_file_exists:
    mov x19, x0
    
    adrp x20, stat_buffer@PAGE
    add x20, x20, stat_buffer@PAGEOFF
    
    mov x0, x19
    mov x1, x20
    mov x16, #4
    svc #0
    
    cmp x0, #0
    beq L_exists
    mov x0, #0
    ret
    
L_exists:
    mov x0, #1
    ret

_build_file_path:
    mov x19, x0
    mov x20, x1
    
    adrp x21, file_path_buffer@PAGE
    add x21, x21, file_path_buffer@PAGEOFF
    
    mov x22, x21
    
L_path_copy:
    ldrb w0, [x19], #1
    cmp w0, #0
    beq L_path_end
    strb w0, [x22], #1
    b L_path_copy
    
L_path_end:
    ldrb w0, [x20, #0]
    cmp w0, #'/'
    beq L_has_slash
    
    movz w0, #'/'
    strb w0, [x22], #1
    
L_has_slash:
    mov x23, x22
    
L_file_copy:
    ldrb w0, [x20], #1
    cmp w0, #0
    beq L_file_end
    strb w0, [x23], #1
    b L_file_copy
    
L_file_end:
    movz w0, #0
    strb w0, [x23], #1
    
    mov x0, x21
    ret
