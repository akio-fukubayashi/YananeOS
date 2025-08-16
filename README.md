# YananeOS

## How to build

### Build
```sh
make all
```

### Prepare Corss Compiler
#### Version
- binutils: 2.45
- GCC: 15.2.0
- GDB: 15.2

#### Build procedure
1. Install build tools
    ```sh
    $ sudo apt update
    $ sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
    ```

1. Prepare directory
    ```sh
    $ mkdir -p ~/source/build-cross
    ```

1. Set enviroment
    ```sh
    $ export PREFIX="$HOME/opt/cross"
    $ export TARGET=i686-elf
    $ export PATH="$PATH:$PREFIX/bin"
    ```

1. Build binutils
    ```sh
    $ mkdir -p ~/source/build-cross/binutils
    $ cd ~/source/build-cross/binutils
    $ wget https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.xz
    $ tar xf binutils-2.45.tar.xz
    $ mkdir build
    $ cd build
    $ ../binutils-2.45/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
    $ make
    $ make install
    ```

1. Build GCC
    ```sh
    $ mkdir ~/source/build-cross/gcc
    $ cd ~/source/build-cross/gcc
    $ wget https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz
    $ tar xf gcc-15.2.0.tar.xz
    $ mkdir build
    $ cd build
    $ ../gcc-15.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx
    $ make -j 8 all-gcc
    $ make -j 8 all-target-libgcc
    $ make -j 8 all-target-libstdc++-v3
    $ make install-gcc
    $ make install-target-libgcc
    $ make install-target-libstdc++-v3
    ```

1. Build GDB
    ```sh
    $ mkdir ~/source/build-cross/gdb
    $ cd ~/source/build-cross/gdb
    $ wget https://ftp.gnu.org/gnu/gdb/gdb-15.2.tar.xz
    $ tar xf gdb-15.2.tar.xz
    $ mkdir build
    $ cd build
    $ ../gdb-15.2/configure --target=$TARGET --prefix="$PREFIX" --disable-werror
    $ make -j 8 all-gdb
    $ make install-gdb
    ```

## Debug

### QEMU
- Interrupt Debug
    ```sh
    $ qemu-system-i386 -drive format=raw,file=build/YananeOS.img -monitor stdio -d int -no-reboot
    ```

- Operation Debug
    ```sh
    qemu-system-i386 -drive format=raw,file=build/YananeOS.img -monitor stdio -d in_asm,cpu -no-reboot
    ```

- Output Log
    ```sh
    $ qemu-system-i386 -drive format=raw,file=build/YananeOS.img -D log.txt -d in_asm,cpu -no-reboot
    ```

### GDB
```sh
$ qemu-system-i386 -drive file=./build/YananeOS.img,format=raw -s -S
$ gdb
(gdb) target remote :1234
(gdb) set architecture i8086
(gdb) set disassemble-flavor intel
```

