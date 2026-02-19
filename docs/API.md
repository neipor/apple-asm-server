# API 参考手册

## 核心函数

### 套接字操作

#### socket_create

创建新的套接字。

```asm
.global _socket_create
_socket_create:
    // x0: 协议族 (AF_INET = 2)
    // x1: 套接字类型 (SOCK_STREAM = 1)
    // x2: 协议 (IPPROTO_TCP = 6)
    // 返回: 套接字描述符
```

#### bind

绑定套接字到地址。

```asm
.global _bind
_bind:
    // x0: 套接字描述符
    // x1: 地址结构体指针
    // x2: 地址长度
    // 返回: 0 成功，-1 失败
```

#### listen

监听套接字。

```asm
.global _listen
_listen:
    // x0: 套接字描述符
    // x1: backlog 大小
    // 返回: 0 成功，-1 失败
```

### 事件驱动

#### kqueue_create

创建 kqueue 实例。

```asm
.global _kqueue_create
kqueue_create:
    // 无参数
    // 返回: kqueue 描述符
```

#### kqueue_add_event

添加事件到 kqueue。

```asm
.global _kqueue_add_event
kqueue_add_event:
    // x0: kqueue 描述符
    // x1: 事件标识符 (文件描述符)
    // x2: 事件过滤器 (EVFILT_READ/EVFILT_WRITE)
```

#### kqueue_wait

等待事件发生。

```asm
.global _kqueue_wait
kqueue_wait:
    // x0: kqueue 描述符
    // x1: 事件数组指针
    // x2: 最大事件数
    // 返回: 实际事件数
```

### HTTP 处理

#### http_parse_request

解析 HTTP 请求。

```asm
.global _http_parse_request
http_parse_request:
    // x0: 请求缓冲区
    // x1: 缓冲区长度
    // 返回: 解析结果
```

#### http_build_response

构建 HTTP 响应。

```asm
.global _http_build_response
http_build_response:
    // x0: 响应结构体指针
    // x1: 输出缓冲区
    // x2: 缓冲区大小
    // 返回: 响应长度
```

### 文件操作

#### file_open

打开文件。

```asm
.global _file_open
file_open:
    // x0: 文件路径指针
    // x1: 打开标志
    // 返回: 文件描述符
```

#### file_mmap

内存映射文件。

```asm
.global _file_mmap
file_mmap:
    // x0: 文件描述符
    // x1: 映射长度
    // 返回: 映射地址
```

## 数据结构

### 连接结构

```asm
// 连接状态定义
.equ CONN_STATE_IDLE, 0
.equ CONN_STATE_READING, 1
.equ CONN_STATE_WRITING, 2
.equ CONN_STATE_CLOSED, 3
```

### HTTP 方法

```asm
.equ METHOD_GET, 1
.equ METHOD_POST, 2
.equ METHOD_PUT, 3
.equ METHOD_DELETE, 4
.equ METHOD_HEAD, 5
```

### HTTP 状态码

```asm
.equ STATUS_200, 200
.equ STATUS_400, 400
.equ STATUS_404, 404
.equ STATUS_405, 405
.equ STATUS_500, 500
```

## 常量

### 网络常量

```asm
.equ AF_INET, 2
.equ SOCK_STREAM, 1
.equ IPPROTO_TCP, 6
.equ SOL_SOCKET, 65535
.equ SO_REUSEADDR, 2
```

### 事件常量

```asm
.equ EVFILT_READ, -1
.equ EVFILT_WRITE, -2
.equ EV_ADD, 1
.equ EV_ENABLE, 4
.equ EV_CLEAR, 32
```

### 文件常量

```asm
.equ O_RDONLY, 0
.equ O_NONBLOCK, 4
.equ S_IFMT, 0170000
.equ S_IFREG, 0100000
.equ S_IFDIR, 0040000
```

## 系统调用

### 常用系统调用表

| 功能 | 系统调用 | 编号 |
|------|---------|------|
| 读取 | read | 3 |
| 写入 | write | 4 |
| 打开 | open | 5 |
| 关闭 | close | 6 |
| 创建进程 | fork | 2 |
| 等待 | wait4 | 7 |
| 套接字 | socket | 97 |
| 连接 | connect | 98 |
| 接受 | accept | 30 |
| 发送 | sendto | 28 |
| 接收 | recvfrom | 27 |
| 绑定 | bind | 104 |
| 监听 | listen | 106 |
| kqueue | kqueue | 362 |
| kevent | kevent | 363 |
