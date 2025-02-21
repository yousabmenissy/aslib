/*
    Convert string into float 
*/

.section .text
.global atof
.type atof, @function

atof: # atof(str)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp
    pushq  %rbx

    movq   $1, -8(%rbp) # NFLAG. Negative flag
    movq   $-1, %rdx
    pushq  %rdi
    call   isfloat
    popq   %rdi
    testq  %rax, %rax
    jns    1f
    leave
    ret

    1:
    xor    %rdx, %rdx
    xorpd  %xmm0, %xmm0
    xorpd  %xmm1, %xmm1
    xor    %rax, %rax

    movq  %rdi, %rsi
    xor   %rdi, %rdi
    lodsb

    movq  $1, %rbx      # How many decimal point are there
    movq  $0, -16(%rbp) # r11 hold the whole part, 0 if none was found

    # Parse characters before '.'
    cmpb  $'+', %al
    jne   1f
    lodsb
    jmp   .LPATOF0

    1:
    cmpb  $'-', %al     # Is negative?
    jne   .LPATOF0
    movq  $-1, -8(%rbp) # Set the negative flag
    lodsb

    .LPATOF0:
    cmpb  $0, %al   # If null we're done
    je    2f
    cmpb  $'.', %al # If start with '.' skip this part
    je    1f

    subq  $'0', %rax      # Convert the char
    addq  %rax, %rdi      # rdi will hold the result
    movq  %rdi, -16(%rbp)

    lodsb  # Load the next char

    cmpb  $0, %al # If null we're done
    je    2f

    imul  $10, %rdi # Adjust the base
    jmp   .LPATOF0  # Repeat

    # Parse characters after '.'
    1:
    lodsb

    movq  %rdi, -16(%rbp)
    cmpq  $0, -16(%rbp)
    jne   .LPATOF1        # Start the loop

    addq  $1, %rdi  # these two lines solve the problem of ignored decimal zeros
    imul  $10, %rdi # for example .001 becomes 1. Which is a problem!

    .LPATOF1:
    cmpb  $0, %al
    je    2f

    subq  $'0', %rax # Convert the char
    addq  %rax, %rdi # rdi will hold the result

    lodsb
    imul  $10, %rbx # Count the decimal points

    cmpb  $0, %al
    je    2f

    imul  $10, %rdi # Adjust the base
    jmp   .LPATOF1

    2:
    cvtsi2sd  %rdi, %xmm0  # xmm0 = 125
    cvtsi2sd  %rbx, %xmm1  # xmm1 = 100
    divsd     %xmm1, %xmm0 # xmm0 = 125 / 100 = 1.25

    cmpq  $0, -16(%rbp)
    jne   1f

    movq      $1, -16(%rbp)
    cvtsi2sd  -16(%rbp), %xmm1
    subsd     %xmm1, %xmm0     # subsract 1.0

    1:
    cvtsi2sd  -8(%rbp), %xmm1
    mulsd     %xmm1, %xmm0    # res = res * NFLAG

    cvttsd2si  %xmm0, %rax # Truncated integer result
    popq       %rbx
    leave
    ret

