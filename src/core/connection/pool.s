.data
.align 4

connection_pool:
    .space 256 * 64

pool_lock:
    .word 0
pool_count:
    .word 0

.text
.global _pool_init
.global _pool_alloc
.global _pool_free
.global _pool_get

_pool_init:
    adrp x0, pool_count@PAGE
    add x0, x0, pool_count@PAGEOFF
    str wzr, [x0, #0]
    ret

_pool_alloc:
    adrp x0, pool_count@PAGE
    add x0, x0, pool_count@PAGEOFF
    ldr w1, [x0, #0]
    cmp w1, #256
    bge .L_pool_full
    
    add w1, w1, #1
    str w1, [x0, #0]
    
    adrp x0, connection_pool@PAGE
    add x0, x0, connection_pool@PAGEOFF
    sub x1, x1, #1
    lsl x1, x1, #6
    add x0, x0, x1
    
    ret
    
.L_pool_full:
    mov x0, #-1
    ret

_pool_free:
    ret

_pool_get:
    ret
