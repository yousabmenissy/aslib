.set PAGE_SIZE,     4096

.equ PROT_NONE,	    0
.equ PROT_READ,	    1
.equ PROT_WRITE,    2
.equ PROT_EXEC,	    4

.equ MAP_SHARED,    1
.equ MAP_PRIVATE,   2
.equ MAP_ANONYMOUS, 32

.macro MMAP addr=%rdi, size=%rsi, prot=%rdx, mode=%r10, fd=%r8, offset=%r9
    movq  \addr, %rdi
    movq  \size, %rsi
    movq  \prot, %rdx
    movq  \mode, %r10
    movq  \fd, %r8
    movq  \offset, %r9
    movq  $9, %rax
    syscall
.endm

# Anonymous mapping
.macro ANONMMAP addr=$0, size=$4096, prot=$3, mode=$34, fd=$-1, offset=$0
    movq  \addr, %rdi
    movq  \size, %rsi
    movq  \prot, %rdx
    movq  \mode, %r10
    movq  \fd, %r8
    movq  \offset, %r9
    movq  $9, %rax
    syscall
.endm
