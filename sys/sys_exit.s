.macro EXIT status=%rdi
    movq  \status, %rdi
    movq  $60, %rax
    syscall
.endm
