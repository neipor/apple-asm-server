# 开发指南

## 环境要求

- macOS 11.0+
- Apple Silicon (ARM64)
- Xcode Command Line Tools

## 编译构建

### 编译项目

```bash
make
```

### 运行服务器

```bash
make run
```

### 测试服务器

```bash
make test
```

### 清理构建

```bash
make clean
```

## 代码规范

### 汇编语法

- 使用 Apple 汇编器语法 (clang as)
- 使用 `.global` 导出函数
- 使用 `.text` 和 `.data` 区分代码段和数据段

### 函数命名

- 函数名以 `_` 开头 (如 `_main`)
- 使用下划线分隔单词
- 公开函数使用 `.global` 声明

### 寄存器使用

- x0-x7: 函数参数
- x0: 返回值
- x19-x28: 被调用者保存寄存器
- sp: 栈指针
- fp (x29): 帧指针
- lr (x30): 链接寄存器

### 常用指令

```asm
// 加载地址
adrp x0, label@PAGE
add x0, x0, label@PAGEOFF

// 保存/恢复
stp x29, x30, [sp, #-16]!
ldp x29, x30, [sp], #16

// 系统调用
mov x16, #97      // syscall number
svc #0            // trigger syscall
```

## 模块开发

### 添加新模块

1. 在 `src/` 下创建对应的目录
2. 编写 `.s` 汇编源文件
3. 在 `Makefile` 中添加源文件到对应变量
4. 重新编译验证

### 模块模板

```asm
// 模块名: example
// 文件: src/example/module.s

.data
.align 4

// 数据定义
module_data:
    .space 64

.text
.global _module_init
.global _module_process

// 初始化函数
_module_init:
    // 初始化代码
    ret

// 处理函数
_module_process:
    // 处理逻辑
    ret
```

### Makefile 添加方式

```makefile
# 在对应模块变量中添加源文件
EXAMPLE_SRCS = src/example/module.s

# 在总源文件列表中添加
SRCS = ... $(EXAMPLE_SRCS) ...
```

## 调试技巧

### 使用 printf 调试

在代码中添加调试输出：

```asm
debug_msg:
    .ascii "Debug: reached here\n"

_debug_function:
    movz x0, #1
    adrp x1, debug_msg@PAGE
    add x1, x1, debug_msg@PAGEOFF
    movz x2, #24
    movz x16, #4
    svc #0
    // 继续执行
```

### 使用 lldb 调试

```bash
# 编译带调试信息
make clean && make

# 启动调试器
lldb ./server

# 设置断点
b _main

# 运行
r

# 查看寄存器
register read

# 单步执行
si
```

## 性能优化

### 减少系统调用

- 使用缓冲区批量读写
- 使用 kqueue 减少 select/poll 开销

### 内存优化

- 复用缓冲区
- 使用内存映射大文件
- 避免不必要的数据复制

### 连接优化

- 设置 SO_REUSEADDR
- 使用非阻塞 IO
- 实现连接池

## 常见问题

### 编译错误

**问题**: `unknown directive`
**解决**: 检查是否使用正确的汇编语法

**问题**: `symbol undefined`
**解决**: 确保使用 `.global` 导出函数

### 运行时错误

**问题**: `Bad file descriptor`
**解决**: 检查套接字创建和关闭逻辑

**问题**: `Connection refused`
**解决**: 检查端口是否被占用，地址是否正确绑定

## 扩展开发

### 添加新 HTTP 方法

1. 在 `constants.s` 添加新方法常量
2. 在 `parser/request.s` 添加解析逻辑
3. 在 `builder/response.s` 添加响应处理

### 添加新模块

1. 创建新的源文件
2. 实现初始化和处理函数
3. 在 main.s 中调用
4. 更新 Makefile
