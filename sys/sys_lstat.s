.macro LSTAT fd=%rdi, stat=(%rsi)
    movq  \fd, %rdi
    leaq  \stat, %rsi
    movq  $6, %rax
    syscall
.endm
