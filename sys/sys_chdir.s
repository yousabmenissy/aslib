.macro CHDIR path=(%rdi)
    leaq  \path, %rdi
    movq  $80, %rax
    syscall
.endm
