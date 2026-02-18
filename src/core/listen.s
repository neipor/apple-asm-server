.text
.global _socket_listen

_socket_listen:
    mov x19, x0
    mov x20, x1
    
    mov x0, x19
    mov x16, #106
    mov x1, x20
    svc #0
    
    ret
