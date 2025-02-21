.macro PREAD fd=%rdi, buff=%rsi, size=%rdx, pos=%r10
    movq  \fd, %rdi
    movq  \buff, %rsi
    movq  \size, %rdx
    movq  \pos, %r10
    movq  $17, %rax
    syscall
.endm
