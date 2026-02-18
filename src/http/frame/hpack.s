.data
.align 4

hpack_dynamic_table:
    .space 4096

hpack_state:
    .word 0

.text
.global _hpack_decode
.global _hpack_encode
.global _hpack_init

_hpack_decode:
    ret

_hpack_encode:
    ret

_hpack_init:
    ret
