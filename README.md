# macOS ARM 汇编 HTTP 服务器

这是一个使用 ARM64 汇编语言编写的简单 HTTP 服务器，运行在 macOS 系统上。

## 功能特性

- 使用纯 ARM64 汇编语言编写
- 基于 macOS 系统调用
- 支持基本的 HTTP GET 请求
- 监听 8080 端口

## 系统要求

- macOS 11.0 或更高版本（ARM64 架构，如 Apple Silicon M1/M2/M3）
- Xcode 命令行工具
- GNU Make

## 编译和运行

### 编译

```bash
make
```

### 运行

```bash
./server
```

### 测试

使用浏览器访问：
```
http://localhost:8080
```

或使用 curl：
```bash
curl http://localhost:8080
```

## 项目结构

```
.
├── README.md      # 项目说明文档
├── Makefile       # 编译脚本
├── .gitignore     # Git 忽略文件
└── server.s       # 汇编源代码
```

## 实现原理

服务器使用以下系统调用实现基本的 HTTP 功能：

1. `socket()` - 创建 TCP socket
2. `bind()` - 绑定到 8080 端口
3. `listen()` - 开始监听连接
4. `accept()` - 接受客户端连接
5. `read()` - 读取 HTTP 请求
6. `write()` - 发送 HTTP 响应
7. `close()` - 关闭连接

## ARM64 系统调用约定

- `x0-x7` - 传递参数
- `x16` - 存储系统调用号
- `svc #0` - 触发系统调用
- `x0` - 返回结果

## 许可证

MIT
