#pragma once

typedef void (*GlobalConstructor)(void);

void initGlobalConstructor();

void initBSS();

void kernelMain();
