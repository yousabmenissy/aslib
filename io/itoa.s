/*
    Convert an integer to a string.
*/

.section .text
.global itoa
.type itoa, @function
itoa: # itoa(int, buff)
    movq  %rdi, %rax

    testq  %rax, %rax
    jns    1f
    imul   $-1, %rax

    1:
    xor   %rcx, %rcx
    xor   %rdx, %rdx
    movq  $10, %r8

    .LPITOA0:
    incq  %rcx
    xor   %rdx, %rdx
    div   %r8
    addq  $'0', %rdx
    movb  %dl, -1(%rsi, %rcx)
    cmpq  $0, %rax
    jne   .LPITOA0

    testq  %rdi, %rdi
    jns    1f
    incq   %rcx
    movb   $'-', -1(%rsi, %rcx)

    1:
    movb  $0, (%rsi, %rcx) # Null terminate the string

    # Reverse the string
    movq  %rsi, %rax
    addq  %rcx, %rax
    decq  %rax
    movq  %rax, %rdi

    .LPITOA1:
    cmpq  %rsi, %rdi
    jb    1f
    movb  (%rsi), %al
    movb  (%rdi), %dl
    movb  %al, (%rdi)
    movb  %dl, (%rsi)
    incq  %rsi
    decq  %rdi
    jmp   .LPITOA1

    1:
    movq  %rcx, %rax
    ret
