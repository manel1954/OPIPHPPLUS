#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdarg.h>

#define FAKE_PATH "/tmp/sxfeeder_fake_cpuinfo"

// Constructor para verificar que la librería se carga
__attribute__((constructor))
void init() {
    fprintf(stderr, "[FAKE_CPUINFO] Librería cargada correctamente\n");
}

// Interceptar open()
int open(const char *pathname, int flags, ...) {
    if (pathname && strcmp(pathname, "/proc/cpuinfo") == 0) {
        fprintf(stderr, "[FAKE_CPUINFO] Interceptado open(/proc/cpuinfo)\n");
        
        // Obtener la función original
        int (*orig_open)(const char*, int, ...) = dlsym(RTLD_NEXT, "open");
        return orig_open(FAKE_PATH, flags);
    }
    
    // Llamar a la función original para otros casos
    int (*orig_open)(const char*, int, ...) = dlsym(RTLD_NEXT, "open");
    if (flags & O_CREAT) {
        va_list args;
        va_start(args, flags);
        mode_t mode = va_arg(args, mode_t);
        va_end(args);
        return orig_open(pathname, flags, mode);
    }
    return orig_open(pathname, flags);
}

// Interceptar openat()
int openat(int dirfd, const char *pathname, int flags, ...) {
    if (pathname && strcmp(pathname, "/proc/cpuinfo") == 0) {
        fprintf(stderr, "[FAKE_CPUINFO] Interceptado openat(/proc/cpuinfo)\n");
        
        // Obtener la función original
        int (*orig_openat)(int, const char*, int, ...) = dlsym(RTLD_NEXT, "openat");
        return orig_openat(AT_FDCWD, FAKE_PATH, flags);
    }
    
    // Llamar a la función original para otros casos
    int (*orig_openat)(int, const char*, int, ...) = dlsym(RTLD_NEXT, "openat");
    if (flags & O_CREAT) {
        va_list args;
        va_start(args, flags);
        mode_t mode = va_arg(args, mode_t);
        va_end(args);
        return orig_openat(dirfd, pathname, flags, mode);
    }
    return orig_openat(dirfd, pathname, flags);
}
