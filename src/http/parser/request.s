.equ METHOD_GET, 1
.equ METHOD_POST, 2
.equ METHOD_PUT, 3
.equ METHOD_DELETE, 4
.equ METHOD_HEAD, 5

.data
.align 4

.global parsed_uri
.global parsed_method

http_method_get: .ascii "GET"
http_method_post: .ascii "POST"
http_method_put: .ascii "PUT"
http_method_delete: .ascii "DELETE"
http_method_head: .ascii "HEAD"

http_version_10: .ascii "HTTP/1.0"
http_version_11: .ascii "HTTP/1.1"

request_buffer:
    .space 65536

parsed_uri:
    .space 4096

parsed_method:
    .word 0

parsed_version:
    .word 0

header_count:
    .word 0

header_names:
    .space 256
header_values:
    .space 1024

.text
.global _http_parse_request
.global _http_parse_method
.global _http_parse_uri
.global _http_parse_headers
.global _http_find_header
.global _http_get_method
.global _http_get_uri
.global _http_get_version

_http_get_method:
    adrp x1, parsed_method@PAGE
    add x1, x1, parsed_method@PAGEOFF
    ldr w0, [x1, #0]
    ret

_http_get_uri:
    adrp x0, parsed_uri@PAGE
    add x0, x0, parsed_uri@PAGEOFF
    ret

_http_get_version:
    adrp x1, parsed_version@PAGE
    add x1, x1, parsed_version@PAGEOFF
    ldr w0, [x1, #0]
    ret

_http_parse_request:
    mov x19, x0
    mov x20, x1
    
    sub sp, sp, #16
    str x19, [sp, #0]
    str x20, [sp, #8]
    
    bl _http_parse_method
    
    adrp x21, parsed_method@PAGE
    add x21, x21, parsed_method@PAGEOFF
    str w0, [x21, #0]
    
    bl _http_parse_uri
    
    bl _http_parse_version
    
    bl _http_parse_headers
    
    add sp, sp, #16
    ret

_http_parse_method:
    ldr x19, [sp, #0]
    
    adrp x0, request_buffer@PAGE
    add x0, x0, request_buffer@PAGEOFF
    
    mov x21, x19
    mov x22, x0
    
L_method_loop:
    ldrb w1, [x21], #1
    cmp w1, #' '
    beq L_method_end
    cmp w1, #0
    beq L_method_invalid
    strb w1, [x22], #1
    b L_method_loop
    
L_method_end:
    sub x21, x21, x19
    cmp x21, #3
    beq L_check_get
    cmp x21, #4
    beq L_check_post
    cmp x21, #6
    beq L_check_delete
    cmp x21, #5
    beq L_check_head
    mov x0, #0
    ret
    
L_check_get:
    adrp x1, http_method_get@PAGE
    add x1, x1, http_method_get@PAGEOFF
    bl _str_compare_3
    cmp w0, #1
    beq L_is_get
    movz x0, #1
    ret
    
L_is_get:
    movz x0, #1
    ret
    
L_check_post:
    adrp x1, http_method_post@PAGE
    add x1, x1, http_method_post@PAGEOFF
    bl _str_compare_4
    cmp w0, #1
    beq L_is_post
    movz x0, #2
    ret
    
L_is_post:
    movz x0, #2
    ret
    
L_check_delete:
    adrp x1, http_method_delete@PAGE
    add x1, x1, http_method_delete@PAGEOFF
    bl _str_compare_3
    cmp w0, #1
    beq L_is_delete
    movz x0, #4
    ret
    
L_is_delete:
    movz x0, #4
    ret
    
L_check_head:
    adrp x1, http_method_head@PAGE
    add x1, x1, http_method_head@PAGEOFF
    bl _str_compare_4
    cmp w0, #1
    beq L_is_head
    movz x0, #5
    ret
    
L_is_head:
    movz x0, #5
    ret
    
L_method_invalid:
    mov x0, #0
    ret

_str_compare_3:
    mov x19, x0
    mov x20, x1
    ldrb w0, [x19, #0]
    ldrb w1, [x20, #0]
    cmp w0, w1
    bne L_cmp_ne
    ldrb w0, [x19, #1]
    ldrb w1, [x20, #1]
    cmp w0, w1
    bne L_cmp_ne
    ldrb w0, [x19, #2]
    ldrb w1, [x20, #2]
    cmp w0, w1
    bne L_cmp_ne
    mov w0, #1
    ret
L_cmp_ne:
    mov w0, #0
    ret

_str_compare_4:
    mov x19, x0
    mov x20, x1
    ldrb w0, [x19, #0]
    ldrb w1, [x20, #0]
    cmp w0, w1
    bne L_cmp_ne
    ldrb w0, [x19, #1]
    ldrb w1, [x20, #1]
    cmp w0, w1
    bne L_cmp_ne
    ldrb w0, [x19, #2]
    ldrb w1, [x20, #2]
    cmp w0, w1
    bne L_cmp_ne
    ldrb w0, [x19, #3]
    ldrb w1, [x20, #3]
    cmp w0, w1
    bne L_cmp_ne
    mov w0, #1
    ret

_http_parse_uri:
    ldr x19, [sp, #0]
    
    adrp x0, parsed_uri@PAGE
    add x0, x0, parsed_uri@PAGEOFF
    mov x21, x0
    
L_uri_find_space:
    ldrb w1, [x19], #1
    cmp w1, #' '
    beq L_uri_end
    cmp w1, #0
    beq L_uri_end
    strb w1, [x21], #1
    b L_uri_find_space
    
L_uri_end:
    movz w1, #0
    strb w1, [x21, #0]
    ret

_http_parse_version:
    ldr x19, [sp, #0]
    
L_version_skip:
    ldrb w1, [x19], #1
    cmp w1, #'H'
    bne L_version_skip
    
    adrp x0, http_version_11@PAGE
    add x0, x0, http_version_11@PAGEOFF
    mov x21, x19
    
    ldrb w1, [x21, #0]
    cmp w1, #'1'
    bne L_version_10
    ldrb w1, [x21, #1]
    cmp w1, #'.'
    bne L_version_10
    ldrb w1, [x21, #2]
    cmp w1, #'1'
    beq L_version_set
    
L_version_10:
    mov w0, #10
    b L_version_done
    
L_version_set:
    mov w0, #11
    
L_version_done:
    adrp x1, parsed_version@PAGE
    add x1, x1, parsed_version@PAGEOFF
    str w0, [x1, #0]
    ret

_http_parse_headers:
    ldr x19, [sp, #0]
    
    mov x20, x19
    adrp x21, header_names@PAGE
    add x21, x21, header_names@PAGEOFF
    adrp x22, header_values@PAGE
    add x22, x22, header_values@PAGEOFF
    
    mov w23, #0
    
L_header_loop:
    ldrb w1, [x20], #1
    
    cmp w1, #0
    beq L_headers_done
    
    cmp w1, #13
    bne L_header_loop
    
    ldrb w1, [x20], #1
    cmp w1, #10
    bne L_header_loop
    
    ldrb w1, [x20], #1
    cmp w1, #13
    bne L_headers_done
    
    ldrb w1, [x20], #1
    cmp w1, #10
    beq L_headers_done
    
L_headers_done:
    adrp x0, header_count@PAGE
    add x0, x0, header_count@PAGEOFF
    str w23, [x0, #0]
    ret

_http_find_header:
    mov x19, x0
    mov x20, x1
    
    adrp x21, header_names@PAGE
    add x21, x21, header_names@PAGEOFF
    
    mov x0, x21
    mov x1, x20
    bl _str_equal
    cmp w0, #1
    
    adrp x0, header_values@PAGE
    add x0, x0, header_values@PAGEOFF
    ret
