.macro WRITE fd=%rdi, str=(%rsi), len=%rdx
    movq  \fd, %rdi
    leaq  \str, %rsi
    movq  \len, %rdx
    movq  $1, %rax
    syscall
.endm

.macro NEWLN fd=%rdi
    pushq  $'\n'
    WRITE  \fd, (%rsp), $1
    addq   $8, %rsp
.endm

.macro WRITELN fd=%rdi, str=(%rsi), len=%rdx
    leaq   \str, %rsi
    movq   \len, %rdx
    movb   $'\n', -1(%rsi, %rdx)
    WRITE  \fd
    movb   $0, -1(%rsi, %rdx)
.endm
