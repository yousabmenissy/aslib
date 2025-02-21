/*
    Write a formated string to file using a variadic number of arguments
    Format characters 
    - {s} -> string
    - {c} -> char
    - {d} -> int
    - {f} -> float
    - {b} -> binary
    - {x} -> hex
    - {o} -> octal
    args... are laid out on the stack from last to first with a null to indicate the end
*/

.section .text
.global printf
.type printf, @function

# 
printf: # printf(fd, fmt, args...)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $64, %rsp
    pushq  %rbx

    movq  $-1, -40(%rbp)
    movq  %rdi, -24(%rbp)
    movq  %rsi, -32(%rbp)
    movq  $-1, -16(%rbp)
    movb  $'s', -8(%rbp)
    movb  $'c', -7(%rbp)
    movb  $'d', -6(%rbp)
    movb  $'f', -5(%rbp)
    movb  $'b', -4(%rbp)
    movb  $'x', -3(%rbp)
    movb  $'o', -2(%rbp)

    movq  -32(%rbp), %rdi
    call  strlen
    movq  %rax, -56(%rbp)
    movq  %rax, %rbx

    addq      $PAGE_SIZE, %rbx
    ANONMMAP  size = %rbx
    testq     %rax, %rax
    js        3f
    movq      %rax, %r8
    movq      %rax, -48(%rbp)

    .LPPRINTF0:
    movq   -32(%rbp), %rdi
    movq   -56(%rbp), %rcx
    movb   $'{', %al
    repne  scasb
    jne    2f
    cmpb   $'!', -2(%rdi)
    jne    1f

    leaq  -2(%rdi), %rcx
    subq  -32(%rbp), %rcx
    movq  -32(%rbp), %rsi
    movq  %rdi, -32(%rbp)
    movq  -48(%rbp), %rdi
    rep   movsb
    incq  %rsi            # Ignore '!'
    movsb
    movq  %rdi, -48(%rbp)
    jmp   .LPPRINTF0

    1:
    movq   %rdi, %rdx
    movb   $'}', %al
    repne  scasb
    jne    2f

    movq  %rcx, -56(%rbp)

    leaq  -1(%rdx), %rcx
    subq  -32(%rbp), %rcx
    movq  -32(%rbp), %rsi
    movq  %rdi, -32(%rbp)
    movq  -48(%rbp), %rdi
    rep   movsb

    movq  %rdi, -48(%rbp)

    movb    (%rdx), %al
    leaq    -8(%rbp), %rdi
    movq    $7, %rcx
    repne   scasb
    cmovne  -16(%rbp), %rax
    jne     2f

    cmpb  %al, -8(%rbp) # al == 's'?
    jne   1f

    incq  -40(%rbp)
    movq  -40(%rbp), %rax
    movq  16(%rbp, %rax, 8), %rdi
    call  strlen
    movq  %rax, %rcx
    movq  %rdi, %rsi
    movq  -48(%rbp), %rdi
    rep   movsb

    leaq  -1(%rdi), %rax
    movq  %rax, -48(%rbp)
    jmp   .LPPRINTF0

    1:
    cmpb  %al, -7(%rbp) # al == 'c'?
    jne   1f

    incq  -40(%rbp)
    movq  -40(%rbp), %rax
    movq  16(%rbp, %rax, 8), %rsi
    movq  -48(%rbp), %rdi
    movq  $1, %rcx
    rep   movsb

    movq  %rdi, -48(%rbp)
    jmp   .LPPRINTF0

    1:
    cmpb   %al, -6(%rbp)           # al == 'd'?
    jne    1f
    movq   -48(%rbp), %rsi
    incq   -40(%rbp)
    movq   -40(%rbp), %rax
    movq   16(%rbp, %rax, 8), %rdi
    pushq  %r8
    call   itoa

    popq   %r8
    testq  %rax, %rax
    js     3f              # TODO add error handling
    decq   %rax
    addq   %rax, -48(%rbp)
    jmp    .LPPRINTF0

    1:
    movq  $0, %rsi
    cmpb  %al, -5(%rbp) # al =='f'?
    jne   1f
    cmpb  $'.', 1(%rdx)
    jne   9f

    # TODO add error handling
    xor   %rax, %rax
    movb  2(%rdx), %al
    cmpb  $'0', %al
    jb    3f
    cmpb  $'9', %al
    ja    3f

    subb  $'0', %al
    movq  %rax, %rsi

    9:
    movq   -48(%rbp), %rdi
    incq   -40(%rbp)
    movq   -40(%rbp), %rax
    movsd  16(%rbp, %rax, 8), %xmm0

    pushq  %r8
    call   ftoa
    popq   %r8

    testq  %rax, %rax
    js     3f              # TODO add error handling
    addq   %rax, -48(%rbp)
    jmp    .LPPRINTF0

    1:
    cmpb  %al, -4(%rbp)      # al =='b'?
    jne   1f
    movq  $2, %rdx
    movq  $0x6230, -64(%rbp) # '0b' prefix
    movq  $2, %rcx
    jmp   4f

    1:
    cmpb  %al, -3(%rbp)      # al =='x'?
    jne   1f
    movq  $16, %rdx
    movq  $0x7830, -64(%rbp) # '0x' prefix
    movq  $2, %rcx
    jmp   4f

    1:
    cmpb  %al, -2(%rbp)    # al =='o'?
    jne   1f
    movq  $8, %rdx
    movq  $1, %rcx
    movq  $0x30, -64(%rbp) # '0' prefix

    4:
    leaq  -64(%rbp), %rsi
    movq  -48(%rbp), %rdi
    rep   movsb
    movq  %rdi, -48(%rbp)

    movq   -48(%rbp), %rsi
    incq   -40(%rbp)
    movq   -40(%rbp), %rax
    movq   16(%rbp, %rax, 8), %rdi
    pushq  %r8
    call   itox
    popq   %r8

    testq  %rax, %rax
    js     3f
    decq   %rax
    addq   %rax, -48(%rbp)
    jmp    .LPPRINTF0

    # No more fmt chars
    2:
    movq    -48(%rbp), %rdi
    movq    -32(%rbp), %rsi
    movq    -56(%rbp), %rcx
    rep     movsb
    movq    %r8, %rdi
    call    strlen
    WRITE   -24(%rbp), (%r8), %rax
    pushq   %rax
    MUNMAP  (%r8), %rbx
    popq    %rax

    3:
    popq  %rbx
    leave
    ret

/*
    # Usage Example 
    .include "aslib/aslib.s"
    .section .data
    fmt_str: .string "kill: '{x}', '{o}', '{b}' and '{f.2}' is not a process id\n"
    fnum: .double 012.122
    .section .text
    .global _start	
    _start:
    movq 	%rsp, %rbp
    subq	$128, %rsp
    pushq	$0
    pushq	fnum(%rip)
    pushq	$123
    pushq	$12313213
    pushq	$99999999
    movq	$1, %rdi
    leaq	fmt_str(%rip), %rsi
    call	printf
    EXIT 	%rax
    # kill: '0x5F5E0FF', '056761175', '0b1111011' and '12.12' is not a process id
*/
