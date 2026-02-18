.equ LOG_DEBUG, 0
.equ LOG_INFO, 1
.equ LOG_WARN, 2
.equ LOG_ERROR, 3

.data
.align 4

log_level:
    .word LOG_INFO

log_buffer:
    .space 256

msg_debug: .ascii "[DEBUG] "
msg_info:  .ascii "[INFO] "
msg_warn:  .ascii "[WARN] "
msg_error: .ascii "[ERROR] "

.text
.global _log_set_level
.global _log_debug
.global _log_info
.global _log_warn
.global _log_error

_log_set_level:
    adrp x1, log_level@PAGE
    add x1, x1, log_level@PAGEOFF
    str w0, [x1, #0]
    ret

_log_debug:
    mov x0, #LOG_DEBUG
    b _log_message

_log_info:
    mov x0, #LOG_INFO
    b _log_message

_log_warn:
    mov x0, #LOG_WARN
    b _log_message

_log_error:
    mov x0, #LOG_ERROR
    b _log_message

_log_message:
    ret
