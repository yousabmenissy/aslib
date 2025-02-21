.macro MPROTECT addr=%rdi, size=%rsi, prot=%rdx
    movq  \addr, %rdi
    movq  \size, %rsi
    movq  \prot, %rdx
    movq  $10, %rax
    syscall
.endm
