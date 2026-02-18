# macOS ARM64 汇编 HTTP 服务器 Makefile

AS = as
LD = ld
CC = clang

ASFLAGS = -arch arm64 -g
LDFLAGS = -arch arm64 -macos_version_min 11.0 -syslibroot $(shell xcrun -sdk macosx --show-sdk-path) -lSystem

TARGET = server

CONFIG_SRCS = src/config/constants.s src/config/settings.s

CORE_SRCS = src/core/socket.s \
            src/core/bind.s \
            src/core/listen.s \
            src/core/accept.s \
            src/core/io.s \
            src/core/event/kqueue.s \
            src/core/event/poller.s \
            src/core/event/timer.s \
            src/core/connection/pool.s \
            src/core/connection/state.s \
            src/core/connection/buffer.s

UTILS_SRCS = src/utils/string/string.s \
             src/utils/memory/set.s \
             src/utils/memory/copy.s \
             src/utils/memory/compare.s \
             src/utils/conversion/integer.s \
             src/utils/conversion/hex.s \
             src/utils/logging/log.s

ERROR_SRCS = src/error/codes.s \
             src/error/pages.s

HTTP_SRCS = src/http/parser/request.s \
            src/http/builder/response.s \
            src/http/frame/decoder.s \
            src/http/frame/encoder.s \
            src/http/frame/hpack.s \
            src/http/negotiate.s

FILESYSTEM_SRCS = src/filesystem/file.s \
                  src/filesystem/mmap.s \
                  src/filesystem/dir.s \
                  src/filesystem/mime.s \
                  src/filesystem/resolver.s

TLS_SRCS = src/tls/context.s \
           src/tls/handshake.s \
           src/tls/cipher.s \
           src/tls/record.s

PROXY_SRCS = src/proxy/upstream.s \
             src/proxy/balance.s \
             src/proxy/health.s \
             src/proxy/config.s

CACHE_SRCS = src/cache/lru.s \
             src/cache/store.s \
             src/cache/policy.s

BOOT_SRCS = src/boot/startup.s \
            src/boot/main.s

SRCS = $(CONFIG_SRCS) \
       $(CORE_SRCS) \
       $(UTILS_SRCS) \
       $(ERROR_SRCS) \
       $(HTTP_SRCS) \
       $(FILESYSTEM_SRCS) \
       $(TLS_SRCS) \
       $(PROXY_SRCS) \
       $(CACHE_SRCS) \
       $(BOOT_SRCS)

OBJS = $(SRCS:.s=.o)

all: $(TARGET)

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

clean:
	rm -f $(OBJS) $(TARGET)

run: $(TARGET)
	./$(TARGET)

test: $(TARGET)
	./$(TARGET) &
	sleep 1
	curl -v http://localhost:8080
	kill %1 2>/dev/null

.PHONY: all clean run test
