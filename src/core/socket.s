.text
.global _socket_create
.global _socket_set_nonblocking
.global _socket_set_reuseaddr

_socket_create:
    mov x16, #97
    mov x0, #2
    mov x1, #1
    mov x2, #0
    svc #0
    ret

_socket_set_nonblocking:
    mov x19, x0
    
    mov x0, #-1
    mov x16, #62
    mov x1, x19
    mov x2, #3
    svc #0
    mov x20, x0
    
    movz x21, #0x80
    orr x21, x20, x21
    
    mov x0, x19
    mov x16, #62
    mov x1, x19
    mov x2, #4
    mov x3, x21
    svc #0
    
    ret

_socket_set_reuseaddr:
    mov x19, x0
    
    mov x0, x19
    mov x16, #33
    mov x1, #65535
    mov x2, #2
    adrp x3, optval@PAGE
    add x3, x3, optval@PAGEOFF
    mov x4, #4
    svc #0
    
    ret

.data
.align 4
optval:
    .word 1
