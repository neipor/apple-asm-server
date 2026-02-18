.text
.global _poller_init
.global _poller_add_fd
.global _poller_remove_fd
.global _poller_poll

.data
.align 4

poller_kqueue:
    .quad 0
poller_max_events:
    .word 64
poller_events:
    .space 64 * 32

.text
_poller_init:
    adrp x0, poller_kqueue@PAGE
    add x0, x0, poller_kqueue@PAGEOFF
    bl _kqueue_create
    str x0, [x0, #0]
    ret

_poller_add_fd:
    adrp x0, poller_kqueue@PAGE
    add x0, x0, poller_kqueue@PAGEOFF
    ldr x0, [x0, #0]
    mov x1, x0
    mov x2, #-1
    b _kqueue_add_event

_poller_remove_fd:
    adrp x0, poller_kqueue@PAGE
    add x0, x0, poller_kqueue@PAGEOFF
    ldr x0, [x0, #0]
    mov x1, x0
    mov x2, #-1
    b _kqueue_del_event

_poller_poll:
    adrp x0, poller_kqueue@PAGE
    add x0, x0, poller_kqueue@PAGEOFF
    ldr x0, [x0, #0]
    adrp x1, poller_events@PAGE
    add x1, x1, poller_events@PAGEOFF
    adrp x2, poller_max_events@PAGE
    add x2, x2, poller_max_events@PAGEOFF
    ldr w2, [x2, #0]
    b _kqueue_wait
