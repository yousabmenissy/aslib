.macro SYMLINK old=(%rdi), new=(%rsi)
    leaq  \old, %rdi
    leaq  \new, %rsi
    movq  $88, %rax
    syscall
.endm
