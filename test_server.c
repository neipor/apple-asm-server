// 简单的 C 语言 HTTP 服务器
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main() {
    int sockfd, newsockfd;
    struct sockaddr_in serv_addr, cli_addr;
    socklen_t clilen;
    
    // HTTP 响应
    char *response = "HTTP/1.1 200 OK\r\n"
                     "Content-Length: 13\r\n"
                     "\r\n"
                     "Hello, World!";
    
    // 创建 socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("Error: Failed to create socket");
        exit(1);
    }
    
    // 设置 sockaddr_in 结构体
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(8080);
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    
    // 绑定到端口
    if (bind(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("Error: Failed to bind socket");
        exit(1);
    }
    
    // 监听连接
    listen(sockfd, 5);
    
    printf("Server listening on port 8080...\n");
    
    // 接受客户端连接
    clilen = sizeof(cli_addr);
    newsockfd = accept(sockfd, (struct sockaddr *)&cli_addr, &clilen);
    if (newsockfd < 0) {
        perror("Error: Failed to accept connection");
        exit(1);
    }
    
    // 发送 HTTP 响应
    write(newsockfd, response, strlen(response));
    
    // 关闭连接
    close(newsockfd);
    close(sockfd);
    
    return 0;
}