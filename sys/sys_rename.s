.macro RENAME old=(%rdi), new=(%rsi)
    leaq  \old, %rdi
    leaq  \new, %rsi
    movq  $82, %rax
    syscall
.endm
