# 贡献指南

感谢您对 Apple ASM Server 项目的兴趣！

## 如何贡献

### 报告问题

如果您发现 bug 或有新功能建议，请提交 Issue。包含以下信息：
- 详细的问题描述
- 复现步骤
- 期望行为和实际行为
- 环境信息 (macOS 版本等)

### 提交代码

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送分支 (`git push origin feature/amazing-feature`)
5. 提交 Pull Request

## 开发环境设置

```bash
# 克隆仓库
git clone https://github.com/your-username/apple-asm-server.git
cd apple-asm-server

# 编译
make

# 测试
make test
```

## 代码规范

### 汇编代码规范

- 使用 Apple clang 汇编语法
- 使用 `.global` 导出公开函数
- 注释关键逻辑
- 保持函数简洁 (< 100 行)

### 函数命名约定

```asm
// 公开函数
.global _function_name

// 私有函数 (不导出)
_function_name:
```

### 寄存器使用

```asm
// 参数
// x0-x7: 函数参数
// x0: 返回值

// 被调用者保存
// x19-x28: 需要在函数调用前后保持
```

### 代码组织

```asm
// 1. 数据段
.data
.align 4

// 2. 只读数据
read_only_data:
    .ascii "message"

// 3. 未初始化数据
buffer:
    .space 4096

// 4. 代码段
.text

// 5. 函数定义
.global _function_name
_function_name:
    // 函数体
    ret
```

## 测试

### 手动测试

```bash
# 启动服务器
make run

# 发送测试请求
curl http://localhost:8080
```

### 自动化测试

```bash
make test
```

## Pull Request 指南

1. 确保代码编译通过
2. 描述您的更改
3. 包含测试结果
4. 更新相关文档

## 许可证

贡献的代码将采用 MIT 许可证。
