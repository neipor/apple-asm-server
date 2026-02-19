.data
.align 4

optval_1:
    .word 1

sockaddr_in:
    .space 16

response_buffer:
    .space 16384

http_header:
    .ascii "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 186\r\n\r\n"

file_content:
    .ascii "<!DOCTYPE html>\n<html>\n<head>\n    <title>Apple ASM Server</title>\n</head>\n<body>\n    <h1>Welcome to Apple ASM HTTP Server</h1>\n    <p>Running on pure ARM64 Assembly!</p>\n</body>\n</html>"

.text
.global _main

_main:
    mov x0, #2
    mov x1, #1
    mov x2, #0
    mov x16, #97
    svc #0
    
    mov x25, x0
    
    mov x0, x25
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
    
    mov x0, x25
    movz x16, #104
    mov x1, x20
    movz x2, #16
    svc #0
    
    mov x0, x25
    movz x1, #10
    movz x16, #106
    svc #0

L_accept_loop:
    mov x0, x25
    add x1, sp, #0
    add x2, sp, #8
    movz x16, #30
    svc #0
    
    cmp x0, #0
    b.lt L_accept_loop
    
    mov w20, w0
    
    adrp x22, http_header@PAGE
    add x22, x22, http_header@PAGEOFF
    
    mov x0, x20
    mov x1, x22
    movz x2, #72
    movz x16, #4
    svc #0
    
    adrp x23, file_content@PAGE
    add x23, x23, file_content@PAGEOFF
    
    mov x0, x20
    mov x1, x23
    movz x2, #186
    movz x16, #4
    svc #0
    
    mov x0, x20
    movz x16, #6
    svc #0
    
    b L_accept_loop
