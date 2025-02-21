.macro READ fd=%rdi, loc=(%rsi), len=%rdx
    movq  \fd, %rdi
    leaq  \loc, %rsi
    movq  \len, %rdx
    movq  $0, %rax
    syscall
.endm
