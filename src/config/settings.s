.data
.align 4

server_config:
    .word 8080
    .word 128
    .word 256
    .word 16384
    .word 60
    .word 1
    .word 1
    .word 1
    .word 1

vhost_default:
    .asciz "localhost"
    .align 4

root_dir:
    .asciz "./www"
    .align 4

index_files:
    .asciz "index.html"
    .asciz "index.htm"
    .byte 0

error_pages_dir:
    .asciz "./error_pages"
    .align 4

log_dir:
    .asciz "./logs"
    .align 4

proxy_config:
    .word 0
    .word 80
    .word 3
    .word 5000

cache_config:
    .word 1
    .word 10485760
    .word 300
