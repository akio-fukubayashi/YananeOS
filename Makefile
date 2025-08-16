TARGET=i686
CC=$(TARGET)-elf-g++
NASM=nasm
LD=$(TARGET)-elf-ld
OBJCOPY=$(TARGET)-elf-objcopy
CFLAGS=-ffreestanding -O0 -Wall -Wextra -g
LDFLAGS=-nostdlib -Ttext 0x10000 -e kernel_entry

BUILD_DIR=build
BIN_DIR=$(BUILD_DIR)/bin

# Sources
CXXSRC=$(wildcard src/*.cpp)

OBJ=$(CXXSRC:%.cpp=$(BUILD_DIR)/%.o)

# Create Directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)/src $(BUILD_DIR)/bin

all: $(BUILD_DIR) YananeOS.img

# Bootloader
boot.bin:
	$(NASM) -f bin boot/boot.asm -o $(BIN_DIR)/boot.bin

# Build C++
$(BUILD_DIR)/%.o: %.cpp | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Link
kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) -o $(BIN_DIR)/kernel.elf $(OBJ)
	$(OBJCOPY) -O binary $(BIN_DIR)/kernel.elf $(BIN_DIR)/kernel.bin
	
# Image
YananeOS.img: kernel.bin boot.bin
	cat $(BIN_DIR)/boot.bin $(BIN_DIR)/kernel.bin > $(BUILD_DIR)/YananeOS.img

clean:
	rm -rf $(BUILD_DIR)