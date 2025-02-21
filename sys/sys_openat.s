.equ AT_FDCWD,  -100

.macro openat dirfd=%rdi, path=(%rsi), flags=%rdx
    movq  \dirfd, %rdi
    leaq  \path, %rsi
    movq  \flags, %rdx
    movq  $257, %rax
    syscall
.endm
