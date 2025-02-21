/*
    Read the first line in a file
*/

.section .text
.global getline
.type getline, @function

getline: # getline(fd, buff)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $16, %rsp

    movq  %rdi, -8(%rbp)
    movq  $128, -16(%rbp)
    movq  %rsi, %r8
    movq  -16(%rbp), %r9

    .LPGETL0:
    subq  -16(%rbp), %rsp # buff

    PREAD  -8(%rbp), %rsp, %r9, $0
    movq   %rax, %r10
    movq   %rsp, %rdi
    movq   $'\n', %rsi
    call   strchr
    testq  %rax, %rax
    jns    1f                      # Newline was found

    movq  %rsp, %rax
    addq  %r10, %rax
    cmpq  %r9, %r10
    jl    1f         # Newline was not found

    movq  -16(%rbp), %r9
    movq  -16(%rbp), %rcx
    imul  $2, %rcx
    movq  %rcx, -16(%rbp)
    addq  -16(%rbp), %r9
    jmp   .LPGETL0

    1:
    movq  %rsp, %rcx
    subq  %rcx, %rax            # line length
    READ  -8(%rbp), (%r8), %rax

    leave
    ret
