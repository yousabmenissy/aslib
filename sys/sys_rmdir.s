.macro RMDIR path=(%rdi)
    leaq  \path, %rdi
    movq  $84, %rax
    syscall
.endm
