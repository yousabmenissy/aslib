.equ SEEK_SET, 0
.equ SEEK_CUR, 1
.equ SEEK_END, 2

.macro LSEEK fd=%rdi, offset=%rsi, seek=%rdx
    movq  \fd, %rdi
    movq  \offset, %rsi
    movq  \seek, %rdx
    movq  $8, %rax
    syscall
.endm
