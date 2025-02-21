.macro LINK old=(%rdi), new=(%rsi)
    leaq  \old, %rdi
    leaq  \new, %rsi
    movq  $86, %rax
    syscall
.endm
