#include <sys/types.h>
#include <sys/stat.h>

#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

#undef errno
extern __thread int errno;

#ifndef O_CLOEXEC
#define O_CLOEXEC 0
#endif

#define DF_GRND_NONBLOCK 0x0001U
#define DF_GRND_RANDOM 0x0002U
#define DF_GRND_INSECURE 0x0004U
#define DF_GRND_KNOWN_MASK (DF_GRND_NONBLOCK | DF_GRND_RANDOM | DF_GRND_INSECURE)

int *__errno_location(void)
{
    return &errno;
}

ssize_t getrandom(void *buf, size_t buflen, unsigned int flags)
{
    unsigned char *cursor;
    const char *path;
    int fd;
    int open_flags;
    size_t filled;

    if (flags & ~DF_GRND_KNOWN_MASK) {
        errno = EINVAL;
        return -1;
    }

    if (buflen == 0) {
        return 0;
    }

    path = (flags & DF_GRND_RANDOM) ? "/dev/random" : "/dev/urandom";
    open_flags = O_RDONLY | O_CLOEXEC;
    if (flags & DF_GRND_NONBLOCK) {
        open_flags |= O_NONBLOCK;
    }

    fd = open(path, open_flags);
    if (fd < 0) {
        return -1;
    }

    cursor = (unsigned char *)buf;
    filled = 0;
    while (filled < buflen) {
        ssize_t chunk;

        chunk = read(fd, cursor + filled, buflen - filled);
        if (chunk > 0) {
            filled += (size_t)chunk;
            continue;
        }

        if (chunk == 0) {
            close(fd);
            errno = EIO;
            return -1;
        }

        if (errno == EINTR) {
            continue;
        }

        close(fd);
        return -1;
    }

    close(fd);
    return (ssize_t)filled;
}

int posix_fallocate(int fd, off_t offset, off_t len)
{
    struct stat st;
    off_t end;

    if (offset < 0 || len < 0) {
        return EINVAL;
    }

    end = offset + len;
    if (end < offset) {
        return EINVAL;
    }

    if (fstat(fd, &st) != 0) {
        return errno;
    }

    if (st.st_size >= end) {
        return 0;
    }

    if (ftruncate(fd, end) != 0) {
        return errno;
    }

    return 0;
}
