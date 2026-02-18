.text
.global _kqueue_create
.global _kqueue_add_event
.global _kqueue_del_event
.global _kqueue_wait

_kqueue_create:
    mov x16, #362
    svc #0
    ret

_kqueue_add_event:
    mov x19, x0
    mov x20, x1
    mov x21, x2
    
    sub sp, sp, #32
    mov x22, sp
    
    str x20, [x22, #0]
    str x21, [x22, #8]
    mov x23, #33
    str x23, [x22, #16]
    str xzr, [x22, #24]
    
    mov x0, x19
    mov x16, #363
    mov x1, x22
    mov x2, #1
    add x3, x22, #32
    mov x4, #0
    svc #0
    
    add sp, sp, #32
    ret

_kqueue_del_event:
    mov x19, x0
    mov x20, x1
    mov x21, x2
    
    sub sp, sp, #32
    mov x22, sp
    
    str x20, [x22, #0]
    str x21, [x22, #8]
    mov x23, #2
    str x23, [x22, #16]
    str xzr, [x22, #24]
    
    mov x0, x19
    mov x16, #363
    mov x1, x22
    mov x2, #1
    add x3, x22, #32
    mov x4, #0
    svc #0
    
    add sp, sp, #32
    ret

_kqueue_wait:
    mov x19, x0
    mov x20, x1
    mov x21, x2
    
    mov x0, x19
    mov x16, #363
    mov x1, x20
    mov x2, x21
    add x3, x20, x21, lsl #5
    mov x4, #0
    svc #0
    
    ret
