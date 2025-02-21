.macro FCHDIR fd=%rdi
    movq  \fd, %rdi
    movq  $81, %rax
    syscall
.endm
