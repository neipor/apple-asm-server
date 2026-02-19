# Apple ASM Server

一个使用纯 ARM64 汇编语言编写的模块化 HTTP 服务器，运行在 macOS Apple Silicon 设备上。

## 概述

本项目是一个从零编写的 HTTP 服务器，完全使用 ARM64 汇编语言实现。服务器采用模块化架构，支持高并发连接、静态文件服务，并提供了 HTTP/2、TLS/SSL、反向代理和缓存系统的基础框架。

## 技术特性

- **纯 ARM64 汇编**：所有代码使用 ARM64 汇编语言编写，无 C 代码依赖
- **kqueue 事件驱动**：使用 macOS 原生 kqueue 机制实现高效事件处理
- **模块化架构**：清晰的模块划分，便于维护和扩展
- **高性能**：最小化内存占用和指令开销

## 功能支持

### 已实现
- HTTP/1.1 协议
- 静态文件服务
- kqueue 多路复用
- 连接池管理
- 基本错误处理

### 框架功能（开发中）
- HTTP/2 协议 (HPACK 编解码)
- TLS/SSL 加密
- 反向代理
- 缓存系统 (LRU)

## 快速开始

### 编译

```bash
make
```

### 运行

```bash
make run
```

### 测试

```bash
make test
```

服务器默认监听 8080 端口。

## 项目结构

```
src/
├── boot/              # 启动入口
│   ├── main.s         # 主程序入口
│   └── startup.s     # 启动初始化
├── config/           # 配置模块
│   ├── constants.s    # 常量定义
│   └── settings.s     # 配置管理
├── core/             # 核心模块
│   ├── accept.s       # 连接接受
│   ├── bind.s         # 套接字绑定
│   ├── listen.s       # 监听套接字
│   ├── socket.s       # 套接字操作
│   ├── io.s           # IO 操作
│   ├── event/         # 事件驱动
│   │   ├── kqueue.s   # kqueue 实现
│   │   ├── poller.s   # 轮询器
│   │   └── timer.s    # 定时器
│   └── connection/    # 连接管理
│       ├── pool.s     # 连接池
│       ├── state.s    # 连接状态
│       └── buffer.s   # 缓冲区
├── http/             # HTTP 协议
│   ├── parser/       # 请求解析
│   │   ├── request.s # HTTP 请求解析
│   │   └── header.s  # 头部解析
│   ├── builder/      # 响应构建
│   │   ├── response.s # 响应构建
│   │   └── header.s  # 头部构建
│   ├── frame/        # HTTP/2 帧
│   │   ├── hpack.s   # HPACK 编解码
│   │   ├── encoder.s # 帧编码
│   │   └── decoder.s # 帧解码
│   └── negotiate.s   # 协议协商
├── tls/              # TLS/SSL
│   ├── context.s     # TLS 上下文
│   ├── handshake.s   # 握手过程
│   ├── cipher.s      # 加密算法
│   └── record.s      # 记录层
├── filesystem/       # 文件系统
│   ├── file.s        # 文件操作
│   ├── mmap.s        # 内存映射
│   ├── dir.s         # 目录操作
│   ├── mime.s        # MIME 类型
│   └── resolver.s    # 路径解析
├── proxy/            # 反向代理
│   ├── upstream.s    # 上游服务器
│   ├── balance.s     # 负载均衡
│   ├── health.s      # 健康检查
│   └── config.s      # 代理配置
├── cache/           # 缓存系统
│   ├── lru.s         # LRU 缓存
│   ├── store.s       # 缓存存储
│   └── policy.s      # 缓存策略
├── utils/           # 工具函数
│   ├── string/       # 字符串操作
│   ├── memory/       # 内存操作
│   ├── conversion/   # 类型转换
│   └── logging/      # 日志输出
└── error/           # 错误处理
    ├── codes.s       # 错误码
    └── pages.s       # 错误页面
```

## 核心模块详解

### 启动模块 (boot/)

负责服务器初始化和主事件循环。

### 配置模块 (config/)

定义服务器运行所需的常量和配置参数：
- 最大连接数: 256
- 缓冲区大小: 16384 字节
- HTTP 端口: 80

### 核心模块 (core/)

实现底层的网络和事件处理功能：
- **socket**: 套接字创建和管理
- **event/kqueue**: 使用 macOS kqueue 实现高效事件通知
- **connection**: 连接池和状态管理

### HTTP 模块 (http/)

处理 HTTP 协议相关功能：
- **parser**: 解析 HTTP 请求和头部
- **builder**: 构建 HTTP 响应
- **frame**: HTTP/2 帧处理

### 文件系统模块 (filesystem/)

提供静态文件服务：
- 内存映射文件 (mmap)
- MIME 类型识别
- 路径解析

### TLS 模块 (tls/)

处理 HTTPS 加密通信（框架阶段）

### 反向代理模块 (proxy/)

实现负载均衡和反向代理功能（框架阶段）

### 缓存模块 (cache/)

实现 LRU 缓存机制（框架阶段）

## 系统调用

服务器直接使用 macOS 系统调用，包括：

| 系统调用 | 编号 | 功能 |
|---------|------|------|
| socket | 97 | 创建套接字 |
| bind | 104 | 绑定地址 |
| listen | 106 | 监听连接 |
| accept | 30 | 接受连接 |
| read | 3 | 读取数据 |
| write | 4 | 写入数据 |
| kqueue | 362 | 创建 kqueue |
| kevent | 363 | 事件通知 |

## 常量定义

关键常量定义在 `src/config/constants.s`:

```asm
.equ MAX_CONNECTIONS, 256
.equ BUFFER_SIZE, 16384
.equ HTTP_PORT, 80
.equ DEFAULT_BACKLOG, 128
```

## 开发指南

### 添加新模块

1. 在对应目录创建 `.s` 文件
2. 使用 `.global` 导出函数
3. 在 Makefile 中添加源文件
4. 重新编译测试

### 调试

编译时使用 `-g` 标志生成调试信息：
```bash
make clean && make
```

## 性能优化

- 使用 kqueue 实现 O(1) 事件处理
- 连接池复用减少内存分配
- 内存映射文件提高大文件传输效率

## 许可证

MIT License
