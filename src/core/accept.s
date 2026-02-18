.text
.global _socket_accept
.global _socket_accept_nonblocking

_socket_accept:
    mov x19, x0
    mov x20, x1
    
    sub sp, sp, #28
    mov x21, sp
    
    mov x0, x19
    mov x16, #30
    add x1, x21, #4
    add x2, x21, #8
    svc #0
    
    add sp, sp, #28
    ret

_socket_accept_nonblocking:
    mov x19, x0
    mov x20, x1
    
    sub sp, sp, #28
    mov x21, sp
    
    mov x0, x19
    mov x16, #28
    add x1, x21, #4
    add x2, x21, #8
    mov x3, #4
    svc #0
    
    add sp, sp, #28
    ret

.data
.align 4
