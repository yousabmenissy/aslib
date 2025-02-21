.macro GETCWD buff=(%rdi), size=%rsi
    leaq  \buff, %rdi
    movq  \size, %rsi
    movq  $79, %rax
    syscall
.endm
