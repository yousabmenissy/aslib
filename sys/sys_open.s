/*
    From https://sites.uclouvain.be/SystInfo/usr/include/asm-generic/fcntl.h.html 
*/
.equ O_RDONLY,      00000000
.equ O_WRONLY,      00000001
.equ O_RDWR,        00000002
.equ O_CREAT,       00000100
.equ O_EXCL,        00000200
.equ O_NOCTTY,      00000400
.equ O_TRUNC,       00001000
.equ O_APPEND,      00002000
.equ O_NONBLOCK,    00004000
.equ O_SYNC,        00010000
.equ FASYNC,        00020000
.equ O_DIRECT,      00040000
.equ O_LARGEFILE,   00100000
.equ O_DIRECTORY,   00200000
.equ O_NOFOLLOW,    00400000
.equ O_NOATIME,     01000000
.equ O_CLOEXEC,     02000000

.equ S_IXUSR,       00100
.equ S_IWUSR,       00200
.equ S_IRUSR,       00400
.equ S_IRWXU,       00700

.equ S_IXGRP,       00010
.equ S_IWGRG,       00020
.equ S_IRGRG,       00040
.equ S_IRWXG,       00070

.equ S_IXOTH,       00001
.equ S_IWOTH,       00002
.equ S_IROTH,       00004
.equ S_IRWXO,       00007

.macro OPEN path=(%rdi), flags=%rsi, mode=%rdx
    leaq  \path, %rdi
    movq  \flags, %rsi
    movq  \mode, %rdx
    movq  $2, %rax
    syscall
.endm

# Open a directory
.macro OPENDIR path=(%rdi), flags=$O_DIRECTORY
    leaq  \path, %rdi
    movq  \flags, %rsi
    xor   %rdx, %rdx
    movq  $2, %rax
    syscall
.endm
