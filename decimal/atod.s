/*
    Convert a string into the decimal type
*/

.section .text
.global atod
.type atod, @function
atod: # atod(str)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $16, %rsp

    pushq  %rbx
    movq   $0, %rbx

    movq   $1, -8(%rbp)    # NFLAG. Negative flag
    movq   $-1, %rdx
    pushq  %rdi
    call   isfloat
    popq   %rdi
    testq  %rax, %rax
    jns    1f
    jmp    3f

    1:
    movq  %rdi, %rsi

    xor    %rax, %rax
    xor    %rdx, %rdx
    xor    %rdi, %rdi
    xorpd  %xmm0, %xmm0

    # Parse characters before '.'
    lodsb

    cmpb  $'+', %al
    jne   1f
    lodsb
    jmp   .LPATOD0

    1:
    cmpb  $'-', %al       # Is negative?
    jne   .LPATOD0
    movq  $-1, -8(%rbp)   # Set the negative flag
    lodsb

    .LPATOD0:
    cmpb  $0, %al
    je    2f
    cmpb  $'.', %al       # If '.' skip this part
    je    1f

    subq  $'0', %rax
    addq  %rax, %rdi      # rdi will hold the result

    lodsb
    cmpb  $0, %al
    je    2f

    imul  $10, %rdi
    jmp   .LPATOD0

    # Parse characters after '.'
    1:
    lodsb

    .LPATOD1:
    cmpb  $0, %al
    je    2f

    subq  $'0', %rax      # Convert the char
    addq  %rax, %rdi      # rdi will hold the result

    lodsb
    incq  %rbx            # Count the decimal points

    cmpb  $0, %al
    je    2f

    imul  $10, %rdi       # Adjust the base
    jmp   .LPATOD1

    2:
    movq   %rdi, %rax
    imulq  -8(%rbp)
    xor    %rdx, %rdx

    pinsrq  $0, %rax, %xmm0
    pinsrq  $1, %rbx, %xmm0

    3:
    popq  %rbx
    leave
    ret

.macro ATOD dstr=(%rdi)
    leaq  \dstr, %rdi
    call  atod
.endm
