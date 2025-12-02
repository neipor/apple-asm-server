// macOS ARM64 汇编 HTTP 服务器
// 监听 8080 端口
// 只处理一个连接，然后退出

.data
    // HTTP 响应
    response: .ascii "HTTP/1.1 200 OK\r\n"
              .ascii "Content-Length: 13\r\n"
              .ascii "\r\n"
              .ascii "Hello, World!"
    response_len = 45

.text
.global _main

_main:
    // 1. 创建 TCP socket
    // socket(AF_INET, SOCK_STREAM, 0)
    mov x0, #2              // AF_INET
    mov x1, #1              // SOCK_STREAM
    mov x2, #0              // protocol = 0
    mov x16, #97            // SYS_socket
    svc #0                  // 触发系统调用
    
    // 保存 socket 文件描述符
    mov x19, x0
    
    // 2. 设置 sockaddr_in 结构体
    // 为了简化，直接在栈上构造 sockaddr_in 结构体
    sub sp, sp, #16         // 分配 16 字节的空间
    
    // 初始化整个结构体为 0
    mov x0, #0
    str x0, [sp]
    str x0, [sp, #8]
    
    // sin_family = AF_INET (2)
    mov w0, #2
    strh w0, [sp]
    
    // sin_port = 8080 (网络字节序)
    mov w0, #0x1f90         // 8080 的网络字节序
    strh w0, [sp, #2]
    
    // sin_addr = INADDR_ANY (0.0.0.0)
    mov w0, #0
    str w0, [sp, #4]
    
    // 3. 绑定到端口
    // bind(sockfd, (struct sockaddr *)&sockaddr_in, sizeof(sockaddr_in))
    mov x0, x19             // sockfd
    mov x1, sp              // &sockaddr_in
    mov x2, #16             // sizeof(sockaddr_in)
    mov x16, #104           // SYS_bind
    svc #0                  // 触发系统调用
    
    // 4. 监听连接
    // listen(sockfd, 5)
    mov x0, x19             // sockfd
    mov x1, #5              // backlog = 5
    mov x16, #106           // SYS_listen
    svc #0                  // 触发系统调用
    
    // 5. 接受客户端连接
    // accept(sockfd, NULL, NULL)
    mov x0, x19             // sockfd
    mov x1, #0              // addr = NULL
    mov x2, #0              // addrlen = NULL
    mov x16, #30            // SYS_accept
    svc #0                  // 触发系统调用
    
    // 保存客户端 socket 文件描述符
    mov x20, x0
    
    // 6. 发送 HTTP 响应
    // write(clientfd, response, response_len)
    mov x0, x20             // clientfd
    adrp x1, response@PAGE  // 获取 response 所在页的地址
    add x1, x1, response@PAGEOFF // 添加页内偏移量
    mov x2, #response_len   // response_len
    mov x16, #4             // SYS_write
    svc #0                  // 触发系统调用
    
    // 7. 关闭客户端连接
    // close(clientfd)
    mov x0, x20             // clientfd
    mov x16, #6             // SYS_close
    svc #0                  // 触发系统调用
    
    // 8. 关闭服务器 socket
    mov x0, x19             // sockfd
    mov x16, #6             // SYS_close
    svc #0                  // 触发系统调用
    
    // 恢复栈指针
    add sp, sp, #16
    
    // 退出程序
    mov x0, #0              // exit code = 0
    mov x16, #1             // SYS_exit
    svc #0                  // 触发系统调用
