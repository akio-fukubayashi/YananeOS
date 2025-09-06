#pragma once

typedef void (*GlobalConstructor)(void);

extern "C" void kernelEntry() __attribute__((section(".text.entry")));

void initGlobalConstructor();

void initBSS();

void kernelMain();
