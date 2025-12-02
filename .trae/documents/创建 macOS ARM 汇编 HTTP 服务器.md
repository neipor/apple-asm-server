# 创建 macOS ARM 汇编 HTTP 服务器

## 1. 项目初始化
- 初始化 git 仓库
- 创建 .gitignore 文件
- 创建 README.md 文件

## 2. 编写汇编代码
创建 `server.s` 文件，实现以下功能：
- 使用系统调用创建 TCP socket
- 绑定到 8080 端口
- 监听连接
- 接受客户端连接
- 读取 HTTP 请求
- 发送 HTTP 响应
- 关闭连接

## 3. 编写构建脚本
创建 `Makefile` 文件，用于编译和链接汇编代码

## 4. 测试服务器
- 编译并运行服务器
- 使用浏览器或 curl 测试 HTTP 响应

## 5. 版本控制
- 提交初始代码
- 测试并完善功能
- 提交最终代码

## 系统调用号（来自 macOS SDK）
- SYS_socket = 97
- SYS_bind = 104
- SYS_listen = 106
- SYS_accept = 30
- SYS_read = 3
- SYS_write = 4
- SYS_close = 6

## ARM64 系统调用约定
- x0-x7：传递参数
- x16：存储系统调用号
- svc #0：触发系统调用
- x0：返回结果