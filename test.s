// 简单的 ARM64 汇编测试程序

.data
    message: .ascii "Hello from ARM64 Assembly!\n"
    message_len = 27

.text
.global _main

_main:
    // 打印消息
    mov x0, #1              // stdout
    adrp x1, message@PAGE   // 获取 message 所在页的地址
    add x1, x1, message@PAGEOFF // 添加页内偏移量
    mov x2, #message_len    // message length
    mov x16, #4             // SYS_write
    svc #0                  // 触发系统调用
    
    // 退出程序
    mov x0, #0              // exit code = 0
    mov x16, #1             // SYS_exit
    svc #0                  // 触发系统调用
