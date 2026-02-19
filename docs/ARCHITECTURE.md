# 架构设计

## 系统概述

Apple ASM Server 是一个使用纯 ARM64 汇编语言编写的 HTTP 服务器，采用事件驱动架构和模块化设计。

## 架构分层

```
┌─────────────────────────────────────────┐
│           Application Layer             │
│         (HTTP/Proxy/Cache)               │
├─────────────────────────────────────────┤
│           Protocol Layer                 │
│      (HTTP Parser/Builder/TLS)          │
├─────────────────────────────────────────┤
│            Core Layer                    │
│    (Socket/Event/Connection)            │
├─────────────────────────────────────────┤
│          System Call Layer               │
│    (macOS Kernel via svc)               │
└─────────────────────────────────────────┘
```

## 核心组件

### 1. 启动模块 (boot/)

负责服务器初始化和主事件循环：

```
main.s
  │
  ├── socket() - 创建监听套接字
  ├── bind()   - 绑定地址
  ├── listen() - 开始监听
  │
  └── 主循环
      │
      ├── kqueue_wait() - 等待事件
      ├── accept()      - 接受新连接
      └── 处理事件
```

### 2. 核心网络层 (core/)

处理底层网络操作：

- **socket.s**: 套接字创建和销毁
- **bind.s**: 地址绑定
- **listen.s**: 监听队列管理
- **accept.s**: 接受连接请求
- **io.s**: 读写操作

### 3. 事件驱动层 (core/event/)

使用 macOS kqueue 实现高效事件处理：

```
kqueue 事件模型
    │
    ├── kqueue_create()  - 创建 kqueue 实例
    │
    ├── kqueue_add_event() - 注册事件
    │   │
    │   ├── 读事件 (EVFILT_READ)
    │   └── 写事件 (EVFILT_WRITE)
    │
    └── kqueue_wait()   - 等待事件触发
```

**优势**:
- O(1) 事件复杂度
- 边缘触发模式
- 高并发支持

### 4. HTTP 协议层 (http/)

处理 HTTP 协议解析和响应构建：

```
HTTP 请求处理流程
    │
    ├── 接收请求 (read)
    │
    ├── 解析请求 (parser/)
    │   │
    │   ├── 解析请求行
    │   ├── 解析头部
    │   └── 解析消息体
    │
    ├── 处理请求
    │   │
    │   ├── 静态文件服务 (filesystem/)
    │   ├── 代理转发 (proxy/)
    │   └── 缓存处理 (cache/)
    │
    ├── 构建响应 (builder/)
    │   │
    │   ├── 构建状态行
    │   ├── 构建头部
    │   └── 构建消息体
    │
    └── 发送响应 (write)
```

### 5. 文件系统层 (filesystem/)

提供静态文件服务：

- **file.s**: 文件打开、读取、关闭
- **mmap.s**: 内存映射文件，提高大文件传输效率
- **dir.s**: 目录遍历
- **mime.s**: MIME 类型识别
- **resolver.s**: URI 到文件路径的解析

### 6. TLS 层 (tls/) [框架]

处理 HTTPS 加密通信：

- **context.s**: TLS 上下文管理
- **handshake.s**: TLS 握手
- **cipher.s**: 加密/解密
- **record.s**: TLS 记录层

### 7. 反向代理层 (proxy/) [框架]

实现负载均衡和反向代理：

- **upstream.s**: 上游服务器管理
- **balance.s**: 负载均衡算法
  - 轮询 (Round Robin)
  - 最少连接 (Least Connections)
- **health.s**: 健康检查
- **config.s**: 代理配置

### 8. 缓存层 (cache/) [框架]

实现响应缓存：

- **lru.s**: LRU (最近最少使用) 缓存
- **store.s**: 缓存存储管理
- **policy.s**: 缓存策略

## 连接管理

### 连接状态机

```
CLOSED ──accept──> READY ──read──> READING
  ▲                   │               │
  │                   │               │
  └───close───────────┴──write────> WRITING
```

### 连接池

- 预分配连接对象
- 复用空闲连接
- 减少内存分配开销

## 内存管理

### 缓冲区设计

- 读缓冲区: 8KB (READ_BUF_SIZE)
- 写缓冲区: 8KB (WRITE_BUF_SIZE)
- 最大请求: 64KB (MAX_REQUEST_SIZE)

### 内存映射

大文件使用 mmap 提高性能：
- 减少内核态/用户态拷贝
- 按需加载文件内容
- 支持大文件处理

## 事件处理流程

```
1. 监听套接字可读
   │
   └── accept() 新连接
       │
       └── 添加到连接池
           │
           └── 注册读事件到 kqueue
               │
               └── 等待客户端请求
                   │
                   └── 解析 HTTP 请求
                       │
                       └── 处理请求
                           │
                           ├── 静态文件 → filesystem/
                           ├── 代理请求 → proxy/
                           └── 缓存响应 → cache/
                               │
                               └── 构建响应并发送
```

## 错误处理

- **codes.s**: 错误码定义
- **pages.s**: 错误页面生成

支持的错误码:
- 400 Bad Request
- 404 Not Found
- 405 Method Not Allowed
- 500 Internal Server Error

## 性能特性

1. **事件驱动**: kqueue 实现单线程高并发
2. **零拷贝**: mmap 文件传输
3. **连接池**: 减少内存分配
4. **非阻塞**: 异步 IO 处理

## 扩展性

模块化设计便于扩展：

1. 新协议支持 → 在 http/ 添加解析器
2. 新缓存策略 → 在 cache/ 实现
3. 新代理算法 → 在 proxy/balance 添加
