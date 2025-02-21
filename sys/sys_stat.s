/*
    From https://github.com/torvalds/linux/blob/master/arch/x86/include/uapi/asm/stat.h
    struct stat {
    unsigned long   st_dev;         //    (buff)
    unsigned long   st_ino;         //   8(buff)
    unsigned long   st_nlink;       //  16(buff)
    unsigned int    st_mode;        //  24(buff)
    unsigned int    st_uid;         //  32(buff)
    unsigned int    st_gid;         //  40(buff)
    unsigned int    __pad0;         //  48(buff)
    unsigned long 	st_rdev;        //  56(buff)
    long		    st_size;        //  64(buff)
    long		    st_blksize;     //  72(buff)
    long		    st_blocks;	    //  80(buff)
    unsigned long	st_atime;       //  88(buff)
    unsigned long	st_atime_nsec;  //  96(buff)
    unsigned long	st_mtime;       // 104(buff)
    unsigned long	st_mtime_nsec;  // 112(buff)
    unsigned long	st_ctime;       // 120(buff)
    unsigned long	st_ctime_nsec;  // 128(buff)
    long		    __unused[3];    
    }
*/
.equ ST_DEV,    0
.equ ST_INO,    8
.equ ST_NLINK,  16
.equ ST_MODE,   24
.equ st_uid,    32

# From https://github.com/torvalds/linux/blob/master/include/uapi/linux/stat.h
.equ S_IFMT,     0170000    # 1111 0000 0000 0000
.equ S_IFSOCK,   0140000    # 1100 0000 0000 0000
.equ S_IFLNK,    0120000    # 1010 0000 0000 0000
.equ S_IFREG,    0100000    # 1000 0000 0000 0000
.equ S_IFBLK,    0060000    # 0110 0000 0000 0000
.equ S_IFDIR,    0040000    # 0100 0000 0000 0000
.equ S_IFCHR,    0020000    # 0010 0000 0000 0000
.equ S_IFIFO,    0010000    # 0001 0000 0000 0000

.equ S_ISUID,    0004000    # 0000 1000 0000 0000
.equ S_ISGID,    0002000    # 0000 0100 0000 0000
.equ S_ISVTX,    0001000    # 0000 0010 0000 0000

.macro STAT path=(%rdi), buff=(%rsi)
    leaq  \path, %rdi
    leaq  \buff, %rsi
    movq  $4, %rax
    syscall
.endm

.macro S_ISLNK m
    pushq  %rdi
    movq   \m, %rdi
    movq   $-1, %rax
    and    $S_IFMT, %rdi
    cmpq   $S_IFLNK, %rdi
    popq   %rdi
    jne    1f
    movq   $1, %rax
    1:
.endm

.macro S_ISREG m
    pushq  %rdi
    movq   \m, %rdi
    movq   $-1, %rax
    and    $S_IFMT, %rdi
    cmpq   $S_IFREG, %rdi
    popq   %rdi
    jne    1f
    movq   $1, %rax
    1:
.endm

.macro S_ISDIR m
    pushq  %rdi
    movq   \m, %rdi
    movq   $-1, %rax
    and    $S_IFMT, %rdi
    cmpq   $S_IFDIR, %rdi
    popq   %rdi
    jne    1f
    movq   $1, %rax
    1:
.endm

.macro S_ISCHR m
    pushq  %rdi
    movq   \m, %rdi
    movq   $-1, %rax
    and    $S_IFMT, %rdi
    cmpq   $S_IFCHR, %rdi
    popq   %rdi
    jne    1f
    movq   $1, %rax
    1:
.endm

.macro S_ISBLK m
    pushq  %rdi
    movq   \m, %rdi
    movq   $-1, %rax
    and    $S_IFMT, %rdi
    cmpq   $S_IFBLK, %rdi
    popq   %rdi
    jne    1f
    movq   $1, %rax
    1:
.endm

.macro S_ISFIFO m
    pushq  %rdi
    movq   \m, %rdi
    movq   $-1, %rax
    and    $S_IFMT, %rdi
    cmpq   $S_IFIFO, %rdi
    popq   %rdi
    jne    1f
    movq   $1, %rax
    1:
.endm

.macro S_ISSOCK m
    pushq  %rdi
    movq   \m, %rdi
    movq   $-1, %rax
    and    $S_IFMT, %rdi
    cmpq   $S_IFSOCK, %rdi
    popq   %rdi
    jne    1f
    movq   $1, %rax
    1:
.endm

