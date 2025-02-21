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

.macro CREAT path=(%rdi), mode=%rsi
    leaq  \path, %rdi
    movq  \mode, %rsi
    movq  $85, %rax
    syscall
.endm
