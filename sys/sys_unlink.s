.macro UNLINK path=(%rdi)
    leaq  \path, %rdi
    movq  $87, %rax
    syscall
.endm
