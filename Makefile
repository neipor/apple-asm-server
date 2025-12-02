# macOS ARM64 汇编 HTTP 服务器 Makefile

# 编译器和链接器
AS = as
LD = ld
CC = clang

# 编译选项
ASFLAGS = -arch arm64
LDFLAGS = -arch arm64 -macosx_version_min 11.0 -lSystem

# 目标文件和可执行文件
TARGET = server
OBJS = server.o

# 默认目标
all: clang

# 编译汇编文件
$(OBJS): server.s
	$(AS) $(ASFLAGS) -o $@ $<

# 链接目标文件
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

# 使用 clang 直接编译（默认方案）
clang: server.s
	$(CC) -arch arm64 -o $(TARGET) $<

# 清理生成的文件
clean:
	rm -f $(OBJS) $(TARGET)

# 伪目标
.PHONY: all clean clang
