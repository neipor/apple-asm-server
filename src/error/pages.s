.data
.align 4

error_page_400:
    .ascii "HTTP/1.1 400 Bad Request\r\n"
    .ascii "Content-Type: text/html\r\n"
    .ascii "Connection: close\r\n"
    .ascii "\r\n"
    .ascii "<html><body><h1>400 Bad Request</h1></body></html>"

error_page_404:
    .ascii "HTTP/1.1 404 Not Found\r\n"
    .ascii "Content-Type: text/html\r\n"
    .ascii "Connection: close\r\n"
    .ascii "\r\n"
    .ascii "<html><body><h1>404 Not Found</h1></body></html>"

error_page_500:
    .ascii "HTTP/1.1 500 Internal Server Error\r\n"
    .ascii "Content-Type: text/html\r\n"
    .ascii "Connection: close\r\n"
    .ascii "\r\n"
    .ascii "<html><body><h1>500 Internal Server Error</h1></body></html>"

.text
.global _error_get_page

_error_get_page:
    cmp w0, #400
    beq .L_400
    cmp w0, #404
    beq .L_404
    cmp w0, #500
    beq .L_500
    
.L_404:
    adrp x0, error_page_404@PAGE
    add x0, x0, error_page_404@PAGEOFF
    ret
    
.L_400:
    adrp x0, error_page_400@PAGE
    add x0, x0, error_page_400@PAGEOFF
    ret
    
.L_500:
    adrp x0, error_page_500@PAGE
    add x0, x0, error_page_500@PAGEOFF
    ret
