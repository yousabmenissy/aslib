.macro PWRITE fd=%rdi, buff=(%rsi), count=%rdx, pos=%r10
    movq  \fd, %rdi
    leaq  \buff, %rsi
    movq  \count, %rdx
    movq  \pos, %r10
    movq  $18, %rax
    syscall
.endm
