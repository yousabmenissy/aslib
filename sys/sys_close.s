.macro CLOSE fd=%rdi
    movq  \fd, %rdi
    movq  $3, %rax
    syscall
.endm
