.equ AT_FDCWD,  -100
.equ AT_REMOVEDIR, 0x200

.macro UNLINKAT dirfd=%rdi, path=(%rsi), flags=%rdx
    movq  \dirfd, %rdi
    leaq  \path, %rsi
    movq  \flags, %rdx
    movq  $263, %rax
    syscall
.endm
