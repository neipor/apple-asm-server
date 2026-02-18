.equ CONN_STATE_IDLE, 0
.equ CONN_STATE_READING, 1
.equ CONN_STATE_WRITING, 2
.equ CONN_STATE_PROCESSING, 3
.equ CONN_STATE_CLOSING, 4

.equ CONN_FLAG_TLS, 1
.equ CONN_FLAG_HTTP2, 2
.equ CONN_FLAG_KEEPALIVE, 4

.data
.align 4

connection_state:
    .word CONN_STATE_IDLE
    .word 0
    .word 0
    .word 0
    .word 0
    .quad 0
    .quad 0
    .quad 0
    .quad 0

.text
.global _conn_state_init
.global _conn_state_set
.global _conn_state_get
.global _conn_set_flags
.global _conn_clear_flags

_conn_state_init:
    adrp x0, connection_state@PAGE
    add x0, x0, connection_state@PAGEOFF
    str wzr, [x0, #0]
    ret

_conn_state_set:
    str w1, [x0, #0]
    ret

_conn_state_get:
    ldr w0, [x0, #0]
    ret

_conn_set_flags:
    ldr w1, [x0, #4]
    orr w1, w1, w2
    str w1, [x0, #4]
    ret

_conn_clear_flags:
    ldr w1, [x0, #4]
    bic w1, w1, w2
    str w1, [x0, #4]
    ret
