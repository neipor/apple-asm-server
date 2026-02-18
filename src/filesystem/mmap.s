.equ PROT_READ, 1
.equ PROT_WRITE, 2
.equ MAP_SHARED, 1
.equ MAP_PRIVATE, 2
.equ MAP_FAILED, -1

.text
.global _file_mmap
.global _file_munmap

_file_mmap:
    mov x16, #197
    svc #0
    ret

_file_munmap:
    mov x16, #73
    svc #0
    ret
