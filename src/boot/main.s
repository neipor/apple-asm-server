.data
.align 4

msg_start:
    .ascii "Starting server...\n"
msg_socket_ok:
    .ascii "Socket OK\n"
msg_bind_ok:
    .ascii "Bind OK\n"
msg_listen_ok:
    .ascii "Listen OK\n"
msg_accept:
    .ascii "Accepted\n"
msg_error:
    .ascii "Error\n"

optval_1:
    .word 1

www_root:
    .asciz "./www/index.html"

sockaddr_in:
    .space 16

read_buffer:
    .space 4096

response_buffer:
    .space 8192

http_response:
    .ascii "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 76\r\n\r\n<!DOCTYPE html>\n<html>\n<head>\n    <title>Apple ASM Server</title>\n</head>\n<body>\n    <h1>Welcome to Apple ASM HTTP Server</h1>\n    <p>Running on pure ARM64 Assembly!</p>\n</body>\n</html>"

http_header_404:
    .ascii "HTTP/1.1 404 Not Found\r\nContent-Type: text/html\r\nContent-Length: 9\r\n\r\nNot Found"

.text
.global _main

_main:
    movz x0, #1
    adrp x1, msg_start@PAGE
    add x1, x1, msg_start@PAGEOFF
    movz x2, #16
    movz x16, #4
    svc #0
    
    mov x0, #2
    mov x1, #1
    mov x2, #0
    mov x16, #97
    svc #0
    
    mov x25, x0
    
    cmp x25, #0
    b.lt .L_err
    
    movz x0, #1
    adrp x1, msg_socket_ok@PAGE
    add x1, x1, msg_socket_ok@PAGEOFF
    movz x2, #11
    movz x16, #4
    svc #0
    
    mov w19, w25
    
    mov x0, x19
    mov x16, #33
    movz x1, #65535
    movz x2, #2
    adrp x3, optval_1@PAGE
    add x3, x3, optval_1@PAGEOFF
    movz x4, #4
    svc #0
    
    adrp x20, sockaddr_in@PAGE
    add x20, x20, sockaddr_in@PAGEOFF
    
    movz w21, #2
    strh w21, [x20, #0]
    
    movz w21, #0x1F
    movz w22, #0x90
    strb w21, [x20, #2]
    strb w22, [x20, #3]
    
    str wzr, [x20, #4]
    str wzr, [x20, #8]
    
    mov x0, x19
    movz x16, #104
    mov x1, x20
    movz x2, #16
    svc #0
    
    cmp x0, #0
    b.lt .L_err
    
    movz x0, #1
    adrp x1, msg_bind_ok@PAGE
    add x1, x1, msg_bind_ok@PAGEOFF
    movz x2, #9
    movz x16, #4
    svc #0
    
    mov x0, x19
    movz x1, #10
    movz x16, #106
    svc #0
    
    cmp x0, #0
    b.lt .L_err
    
    movz x0, #1
    adrp x1, msg_listen_ok@PAGE
    add x1, x1, msg_listen_ok@PAGEOFF
    movz x2, #11
    movz x16, #4
    svc #0

.accept_loop:
    sub sp, sp, #16
    
    mov x0, x19
    add x1, sp, #0
    add x2, sp, #8
    movz x16, #30
    svc #0
    
    cmp x0, #0
    b.lt .accept_loop_done
    
    mov w20, w0
    
    movz x0, #1
    adrp x1, msg_accept@PAGE
    add x1, x1, msg_accept@PAGEOFF
    movz x2, #9
    movz x16, #4
    svc #0
    
    adrp x21, read_buffer@PAGE
    add x21, x21, read_buffer@PAGEOFF
    
    mov x0, x21
    movz x2, #4096
    mov x1, x21
    movz x16, #3
    svc #0
    
    mov x25, x0
    
    cmp x25, #0
    beq .close_connection
    
    adrp x26, www_root@PAGE
    add x26, x26, www_root@PAGEOFF
    
    mov x0, x26
    movz x1, #0
    movz x2, #0
    movz x16, #5
    svc #0
    
    cmp x0, #0
    blt .send_404
    
    mov w27, w0
    
    adrp x28, response_buffer@PAGE
    add x28, x28, response_buffer@PAGEOFF
    
    mov x0, x27
    mov x1, x28
    add x1, x1, #64
    movz x2, #8128
    movz x16, #3
    svc #0
    
    mov w29, w0
    
    mov x0, x27
    movz x16, #6
    svc #0
    
    cmp w29, #0
    beq .send_404
    
    adrp x22, response_buffer@PAGE
    add x22, x22, response_buffer@PAGEOFF
    
    adrp x23, http_response@PAGE
    add x23, x23, http_response@PAGEOFF
    mov x24, #182
    
L_copy_response:
    ldrb w0, [x23]
    strb w0, [x22]
    add x23, x23, #1
    add x22, x22, #1
    sub x24, x24, #1
    cmp x24, #0
    bne L_copy_response
    
    mov x0, x20
    adrp x1, response_buffer@PAGE
    add x1, x1, response_buffer@PAGEOFF
    mov x2, x22
    adrp x3, response_buffer@PAGE
    add x3, x3, response_buffer@PAGEOFF
    sub x2, x2, x3
    
    movz x16, #4
    svc #0
    
    b .close_connection

.send_404:
    adrp x22, response_buffer@PAGE
    add x22, x22, response_buffer@PAGEOFF
    
    adrp x23, http_header_404@PAGE
    add x23, x23, http_header_404@PAGEOFF
    mov x24, #79
    
L_copy_404:
    ldrb w0, [x23]
    strb w0, [x22]
    add x23, x23, #1
    add x22, x22, #1
    sub x24, x24, #1
    cmp x24, #0
    bne L_copy_404
    
    mov x0, x20
    adrp x1, response_buffer@PAGE
    add x1, x1, response_buffer@PAGEOFF
    movz x2, #79
    movz x16, #4
    svc #0

.close_connection:
    mov x0, x20
    movz x16, #6
    svc #0
    
    add sp, sp, #16
    
    b .accept_loop

.accept_loop_done:
    add sp, sp, #16

.L_exit:
    movz x0, #0
    movz x16, #1
    svc #0

.L_err:
    movz x0, #1
    adrp x1, msg_error@PAGE
    add x1, x1, msg_error@PAGEOFF
    movz x2, #7
    movz x16, #4
    svc #0
    
    movz x0, #1
    movz x16, #1
    svc #0
