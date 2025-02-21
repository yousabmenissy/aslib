.macro MUNMAP addr=(%rdi), size=%rsi
    leaq  \addr, %rdi
    movq  \size, %rsi
    movq  $11, %rax
    syscall
.endm
