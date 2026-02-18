.data
.align 4

mime_html: .ascii "text/html"
mime_css:  .ascii "text/css"
mime_js:   .ascii "application/javascript"
mime_json: .ascii "application/json"
mime_png:  .ascii "image/png"
mime_jpg:  .ascii "image/jpeg"
mime_gif:  .ascii "image/gif"
mime_svg:  .ascii "image/svg+xml"
mime_ico:  .ascii "image/x-icon"
mime_txt:  .ascii "text/plain"
mime_pdf:  .ascii "application/pdf"
mime_woff: .ascii "font/woff"
mime_woff2: .ascii "font/woff2"
mime_octet: .ascii "application/octet-stream"

.text
.global _mime_get_type

_mime_get_type:
    mov x19, x0
    
    adrp x0, default_mime@PAGE
    add x0, x0, default_mime@PAGEOFF
    
    ldrb w1, [x19], #1
    cmp w1, #'.'
    bne .L_not_found
    
    ldrb w1, [x19], #1
    cmp w1, #'h'
    beq .L_html
    cmp w1, #'c'
    beq .L_css
    cmp w1, #'j'
    beq .L_js
    cmp w1, #'p'
    beq .L_png
    cmp w1, #'g'
    beq .L_gif
    
    b .L_not_found
    
.L_html:
    adrp x0, mime_html@PAGE
    add x0, x0, mime_html@PAGEOFF
    ret
    
.L_css:
    adrp x0, mime_css@PAGE
    add x0, x0, mime_css@PAGEOFF
    ret
    
.L_js:
    adrp x0, mime_js@PAGE
    add x0, x0, mime_js@PAGEOFF
    ret
    
.L_png:
    adrp x0, mime_png@PAGE
    add x0, x0, mime_png@PAGEOFF
    ret
    
.L_gif:
    adrp x0, mime_gif@PAGE
    add x0, x0, mime_gif@PAGEOFF
    ret
    
.L_not_found:
    adrp x0, default_mime@PAGE
    add x0, x0, default_mime@PAGEOFF
    ret

.data
.align 4
default_mime:
    .ascii "application/octet-stream"
