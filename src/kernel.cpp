#include "kernel.h"

extern "C" void kernel_entry() 
{
    kernel_main();
}

void kernel_main() {
    const char* str = "Start YananeOS!!";
    volatile unsigned char* video = (volatile unsigned char*)0xB8000;

    // Clear Display
    const int columnNum = 80 * 2;
    for(int i = 0; i < 25; i++)
    {
        for(int j = 0; j < columnNum; j++)
        {
            video[i * columnNum + j * 2] = 0;
        }
    }

    // Set Text
    for (int i = 0; str[i]; i++) {
        video[i * 2] = (unsigned char)str[i];
        video[i * 2 + 1] = 0x07;
    }
    
    // Loop
    asm volatile(
        "halt_loop:\n"
            "hlt\n"
            "jmp halt_loop\n"
    );
}