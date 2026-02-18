# Apple ASM Server

一个使用纯 ARM64 汇编语言编写的模块化 HTTP 服务器，运行在 macOS Apple Silicon 上。

## 功能特性

### 已实现
- ✅ 纯 ARM64 汇编语言
- ✅ Socket 编程 (socket, bind, listen, accept)
- ✅ kqueue 事件驱动
- ✅ HTTP/1.1 支持
- ✅ 静态文件服务
- ✅ 404 错误处理

### 框架（准备实现）
- ⏳ HTTP/2 支持
- ⏳ TLS/SSL 支持
- ⏳ 反向代理
- ⏳ 缓存系统

## 编译和运行

```bash
# 编译
make

# 运行
make run

# 或者
./server
```

服务器将在 http://localhost:8080 监听。

## 项目结构

```
src/
├── boot/              # 启动入口
├── config/            # 配置
├── core/              # 核心模块
│   ├── event/         # 事件驱动 (kqueue)
│   └── connection/    # 连接管理
├── http/              # HTTP 协议
│   ├── parser/        # 请求解析
│   ├── builder/       # 响应构建
│   └── frame/         # HTTP/2 帧
├── tls/               # TLS/SSL
├── filesystem/        # 文件系统
├── proxy/             # 反向代理
├── cache/             # 缓存系统
├── utils/             # 工具函数
└── error/             # 错误处理
```

## 技术细节

- 使用 macOS 系统调用 (svc #0)
- ARM64 指令集
- 非阻塞 I/O (kqueue)
- 模块化架构

## 许可证

MIT
