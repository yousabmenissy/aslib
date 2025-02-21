.macro FSTAT fd=%rdi, stat=(%rsi)
    movq  \fd, %rdi
    leaq  \stat, %rsi
    movq  $5, %rax
    syscall
.endm
