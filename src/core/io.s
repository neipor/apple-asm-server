.text
.global _read_fd
.global _write_fd
.global _close_fd

_read_fd:
    mov x19, x0
    mov x20, x1
    mov x21, x2
    
    mov x0, x19
    mov x16, #3
    mov x1, x20
    mov x2, x21
    svc #0
    
    ret

_write_fd:
    mov x19, x0
    mov x20, x1
    mov x21, x2
    
    mov x0, x19
    mov x16, #4
    mov x1, x20
    mov x2, x21
    svc #0
    
    ret

_close_fd:
    mov x19, x0
    mov x16, #6
    mov x0, x19
    svc #0
    ret
