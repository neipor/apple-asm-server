.data
.align 4

status_line_200: .ascii "HTTP/1.1 200 OK\r\n"
status_line_400: .ascii "HTTP/1.1 400 Bad Request\r\n"
status_line_404: .ascii "HTTP/1.1 404 Not Found\r\n"
status_line_405: .ascii "HTTP/1.1 405 Method Not Allowed\r\n"
status_line_500: .ascii "HTTP/1.1 500 Internal Server Error\r\n"

content_type_text: .ascii "Content-Type: text/html\r\n"
content_type_css: .ascii "Content-Type: text/css\r\n"
content_type_js: .ascii "Content-Type: application/javascript\r\n"
content_type_json: .ascii "Content-Type: application/json\r\n"
content_type_png: .ascii "Content-Type: image/png\r\n"
content_type_jpg: .ascii "Content-Type: image/jpeg\r\n"
content_type_gif: .ascii "Content-Type: image/gif\r\n"
content_type_svg: .ascii "Content-Type: image/svg+xml\r\n"
content_type_ico: .ascii "Content-Type: image/x-icon\r\n"
content_type_octet: .ascii "Content-Type: application/octet-stream\r\n"

content_length: .ascii "Content-Length: "
content_length_end: .ascii "\r\n"
connection_close: .ascii "Connection: close\r\n"
connection_keepalive: .ascii "Connection: keep-alive\r\n"
server_header: .ascii "Server: AppleASM/1.0\r\n"
double_crlf: .ascii "\r\n"

response_buffer:
    .space 16384

response_pos:
    .word 0

temp_buffer:
    .space 32

.text
.global _http_response_init
.global _http_response_set_status
.global _http_response_add_header
.global _http_response_set_content_type
.global _http_response_set_content_length
.global _http_response_set_body
.global _http_response_finalize
.global _http_response_get_buffer
.global _http_response_get_length

_http_response_init:
    adrp x0, response_buffer@PAGE
    add x0, x0, response_buffer@PAGEOFF
    adrp x1, response_pos@PAGE
    add x1, x1, response_pos@PAGEOFF
    str wzr, [x1, #0]
    ret

_http_response_set_status:
    mov w19, w0
    
    adrp x20, response_buffer@PAGE
    add x20, x20, response_buffer@PAGEOFF
    
    cmp w19, #200
    beq .L_status_200
    cmp w19, #400
    beq .L_status_400
    cmp w19, #404
    beq .L_status_404
    cmp w19, #405
    beq .L_status_405
    cmp w19, #500
    beq .L_status_500
    
.L_status_200:
    adrp x21, status_line_200@PAGE
    add x21, x21, status_line_200@PAGEOFF
    movz x22, #19
    b .L_copy_status
    
.L_status_400:
    adrp x21, status_line_400@PAGE
    add x21, x21, status_line_400@PAGEOFF
    movz x22, #22
    b .L_copy_status
    
.L_status_404:
    adrp x21, status_line_404@PAGE
    add x21, x21, status_line_404@PAGEOFF
    movz x22, #21
    b .L_copy_status
    
.L_status_405:
    adrp x21, status_line_405@PAGE
    add x21, x21, status_line_405@PAGEOFF
    movz x22, #29
    b .L_copy_status
    
.L_status_500:
    adrp x21, status_line_500@PAGE
    add x21, x21, status_line_500@PAGEOFF
    movz x22, #29
    b .L_copy_status
    
.L_copy_status:
    sub sp, sp, #16
    str x20, [sp, #0]
    str x21, [sp, #8]
    
    mov x23, x22
    
.L_status_copy_loop:
    ldrb w0, [x21], #1
    strb w0, [x20], #1
    subs x23, x23, #1
    bne .L_status_copy_loop
    
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w1, [x0, #0]
    add w1, w1, w22
    str w1, [x0, #0]
    
    add sp, sp, #16
    ret

_http_response_add_header:
    mov x19, x0
    mov x20, x1
    mov w21, w2
    
    sub sp, sp, #32
    str x19, [sp, #0]
    str x20, [sp, #8]
    str w21, [sp, #16]
    
    adrp x22, response_buffer@PAGE
    add x22, x22, response_buffer@PAGEOFF
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w1, [x0, #0]
    add x22, x22, x1
    
    mov x23, x22
    
.L_header_copy:
    ldrb w0, [x20], #1
    cmp w0, #0
    beq .L_header_copy_end
    strb w0, [x23], #1
    b .L_header_copy
    
.L_header_copy_end:
    movz w0, #0
    strb w0, [x23], #1
    
    ldr w1, [sp, #16]
    add w1, w1, #1
    ldr x20, [sp, #8]
    add x20, x20, x1
    
.L_header_copy2:
    ldrb w0, [x20], #1
    cmp w0, #0
    beq .L_header_copy_end2
    strb w0, [x23], #1
    b .L_header_copy2
    
.L_header_copy_end2:
    movz w0, #0
    strb w0, [x23], #1
    
    movz w0, #0x0D
    strb w0, [x23], #1
    movz w0, #0x0A
    strb w0, [x23], #1
    
    ldr w1, [sp, #16]
    ldr x0, [sp, #8]
    add w1, w1, #2
    add x0, x0, x1
    bl _str_length
    add x23, x23, x0
    
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w1, [x0, #0]
    ldr x20, [sp, #8]
    bl _str_length
    add w1, w1, w0
    add w1, w1, #4
    str w1, [x0, #0]
    
    add sp, sp, #32
    ret

_http_response_set_content_type:
    mov x19, x0
    
    adrp x20, content_type_text@PAGE
    add x20, x20, content_type_text@PAGEOFF
    movz w21, #25
    
    cmp x19, #0
    beq .L_ct_text
    
    ldrb w1, [x19], #1
    cmp w1, #'.'
    bne .L_ct_text
    
    ldrb w1, [x19], #1
    cmp w1, #'h'
    beq .L_ct_html
    cmp w1, #'c'
    beq .L_ct_css
    cmp w1, #'j'
    beq .L_ct_js
    cmp w1, #'p'
    ldrb w2, [x19], #0
    cmp w2, #'n'
    beq .L_ct_json
    cmp w1, #'g'
    beq .L_ct_gif
    cmp w1, #'i'
    beq .L_ct_ico
    cmp w1, #'s'
    beq .L_ct_svg
    
    b .L_ct_default
    
.L_ct_text:
    adrp x20, content_type_text@PAGE
    add x20, x20, content_type_text@PAGEOFF
    movz w21, #25
    b .L_ct_done
    
.L_ct_html:
    adrp x20, content_type_text@PAGE
    add x20, x20, content_type_text@PAGEOFF
    movz w21, #25
    b .L_ct_done
    
.L_ct_css:
    adrp x20, content_type_css@PAGE
    add x20, x20, content_type_css@PAGEOFF
    movz w21, #23
    b .L_ct_done
    
.L_ct_js:
    adrp x20, content_type_js@PAGE
    add x20, x20, content_type_js@PAGEOFF
    movz w21, #33
    b .L_ct_done
    
.L_ct_json:
    adrp x20, content_type_json@PAGE
    add x20, x20, content_type_json@PAGEOFF
    movz w24, #24
    mov w21, w24
    b .L_ct_done
    
.L_ct_gif:
    adrp x20, content_type_gif@PAGE
    add x20, x20, content_type_gif@PAGEOFF
    movz w21, #21
    b .L_ct_done
    
.L_ct_ico:
    adrp x20, content_type_ico@PAGE
    add x20, x20, content_type_ico@PAGEOFF
    movz w21, #25
    b .L_ct_done
    
.L_ct_svg:
    adrp x20, content_type_svg@PAGE
    add x20, x20, content_type_svg@PAGEOFF
    movz w21, #25
    b .L_ct_done
    
.L_ct_default:
    adrp x20, content_type_octet@PAGE
    add x20, x20, content_type_octet@PAGEOFF
    movz w21, #31
    
.L_ct_done:
    sub sp, sp, #16
    str x20, [sp, #0]
    str w21, [sp, #8]
    
    adrp x22, response_buffer@PAGE
    add x22, x22, response_buffer@PAGEOFF
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w1, [x0, #0]
    add x22, x22, x1
    
    ldr x20, [sp, #0]
    ldr w21, [sp, #8]
    
.L_ct_copy:
    ldrb w0, [x20], #1
    strb w0, [x22], #1
    subs w21, w21, #1
    bne .L_ct_copy
    
    add sp, sp, #16
    ret

_http_response_set_content_length:
    mov x19, x0
    
    adrp x20, response_buffer@PAGE
    add x20, x20, response_buffer@PAGEOFF
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w1, [x0, #0]
    add x20, x20, x1
    
    adrp x21, content_length@PAGE
    add x21, x21, content_length@PAGEOFF
    movz x22, #16
    
.L_cl_copy:
    ldrb w0, [x21], #1
    strb w0, [x20], #1
    subs x22, x22, #1
    bne .L_cl_copy
    
    mov x21, x20
    mov x22, x19
    
    cmp x22, #0
    beq .L_cl_done
    
.L_cl_digit:
    sub x22, x22, #1
    mov x23, x22
    mov x24, #10
    
    cmp x23, #0
    blt .L_cl_write
    
    udiv x25, x23, x24
    msub x26, x25, x24, x23
    add w26, w26, #48
    strb w26, [x21], #1
    mov x22, x25
    b .L_cl_digit
    
.L_cl_write:
    mov x21, x20
    mov x22, x19
    
.L_cl_rev:
    cmp x22, #0
    beq .L_cl_done
    udiv x23, x22, x24
    msub x25, x23, x24, x22
    add w25, w25, #48
    strb w25, [x21], #1
    mov x22, x23
    b .L_cl_rev
    
.L_cl_done:
    movz w0, #0x0D
    strb w0, [x21], #1
    movz w0, #0x0A
    strb w0, [x21], #1
    
    bl _str_length
    add w0, w0, #16
    adrp x1, response_pos@PAGE
    add x1, x1, response_pos@PAGEOFF
    ldr w2, [x1, #0]
    add w2, w2, w0
    str w2, [x1, #0]
    
    ret

_http_response_set_body:
    mov x19, x0
    mov x20, x1
    
    adrp x21, response_buffer@PAGE
    add x21, x21, response_buffer@PAGEOFF
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w1, [x0, #0]
    add x21, x21, x1
    
.L_body_copy:
    ldrb w0, [x20], #1
    cmp w0, #0
    beq .L_body_end
    strb w0, [x21], #1
    b .L_body_copy
    
.L_body_end:
    bl _str_length
    adrp x1, response_pos@PAGE
    add x1, x1, response_pos@PAGEOFF
    ldr w2, [x1, #0]
    add w2, w2, w0
    str w2, [x1, #0]
    
    ret

_http_response_finalize:
    adrp x20, response_buffer@PAGE
    add x20, x20, response_buffer@PAGEOFF
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w1, [x0, #0]
    add x20, x20, x1
    
    movz w0, #0x0D
    strb w0, [x20], #1
    movz w0, #0x0A
    strb w0, [x20], #1
    strb w0, [x20], #1
    
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w1, [x0, #0]
    add w1, w1, #2
    str w1, [x0, #0]
    
    ret

_http_response_get_buffer:
    adrp x0, response_buffer@PAGE
    add x0, x0, response_buffer@PAGEOFF
    ret

_http_response_get_length:
    adrp x0, response_pos@PAGE
    add x0, x0, response_pos@PAGEOFF
    ldr w0, [x0, #0]
    ret
