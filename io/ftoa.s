/*
    convert float into string with specific decimal points
*/

.section .text
.global ftoa
.type ftoa, @function

ftoa: # ftoa(double, buff, points)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp

    xor        %rcx, %rcx   # Will be used later
    xor        %rdx, %rdx   # Will be used later
    movq       $10, %r8     # r8 = 10
    cvttsd2si  %xmm0, %r9   # r9 = Truncated double
    movaps     %xmm0, %xmm3
    movq       $1, %r11

    movq  %r9, -8(%rbp)
    movq  %rdi, -16(%rbp)

    .LSFTOA0:
    testq  %r9, %r9 # Is it signed?
    jns    1f       # If not move on

    # Convert to unsigned
    movq       $-1, %rax
    cvtsi2sd   %rax, %xmm1
    mulsd      %xmm1, %xmm0
    cvttsd2si  %xmm0, %rax  # rax = Truncated double without the sign
    movq       %rax, %r9    # number in int form without the sign

    1:
    cmpq  $0, %rsi # Was the decimal points specidied?
    je    .LSFTOA2 # If zero skip the next section
    js    .LSFTOA4 # Signed means no decimal points

    .LSFTOA1:
    movq  $1, %rax

    .LPFTOA0:
    mul       %r8          # rax *= 10
    dec       %rsi         # rsi--
    cmpq      $0, %rsi     # rsi == 0?
    jne       .LPFTOA0     # Repeat unitill rsi is zero
    cvtsi2sd  %rax, %xmm1  # xmm1 = rax
    mulsd     %xmm1, %xmm0 # xmm0 = xmm0 * xmm1
    cvtsd2si  %xmm0, %r10  # r10 is now the number without the decimal points
    movq      %rax, %r11   # Save for later use

    jmp  .LSFTOA3 # We're ready to parse

    .LSFTOA2:
    cvttsd2si  %xmm0, %r10
    cvtsi2sd   %r10, %xmm2

    .LPFTOA1:
    comisd  %xmm2, %xmm0
    je      .LSFTOA3

    # multiply by ten
    imul      %r8, %r11    # r11 count the number of decimal points
    cvtsi2sd  %r8, %xmm1
    mulsd     %xmm1, %xmm0

    cvttsd2si  %xmm0, %r10 # Convert into integer truncating the decimal points
    cvtsi2sd   %r10, %xmm2 # Convert it back to a rounded up decimal form

    jmp  .LPFTOA1 # Repeat untill they're equal

    .LSFTOA3:
    movq  %r9, %rax  # rax hold the truncated int. for example the 1 in 1.25
    imul  %r11, %rax # Correct the base. for example 100 instead of 1 in 1.25
    addq  %r11, %r10 # Sove the problem of ignored decimal zeros so now .002 will become 1002 instead of just 2
    subq  %rax, %r10 # r10 now hold the decimal part in int form. with an additional whole 1 to the left

    # Check if there is any decimal points to print
    movq  %r10, %rax
    cmpq  $1, %rax
    je    .LSFTOA4

    .LPFTOA2:
    cqo
    div    %r8        # rax /= 10
    addq   $'0', %rdx # the first decimal on the right is in rdx
    pushq  %rdx       # push it to the stack
    incq   %rcx       # Increase the count

    cmpq  $1, %rax # If rax is 1 that means there's no more decimal points
    jne   .LPFTOA2

    pushq  $'.' # Push the decimal point
    incq   %rcx # Increase the count

    .LSFTOA4:
    movq  %r9, %rax # rax hold the whole integer part

    # Convert and push each digit before the decimal point
    .LPFTOA3:
    cqo
    div    %r8        # rax /= 10
    addq   $'0', %rdx # the first decimal on the right is in rdx
    pushq  %rdx       # push it to the stack
    incq   %rcx       # Increase the count

    cmpq  $0, %rax
    jne   .LPFTOA3

    # If the number was negative push '-' to the stack
    cmpq   $0, -8(%rbp)
    jns    .LSFTOA5
    pushq  $'-'
    incq   %rcx

    .LSFTOA5:
    movq  %rcx, %r8       # r8 is how many characters going to be printed
    movq  %rcx, -24(%rbp)
    movq  $0, %rcx
    movq  -16(%rbp), %rsi

    .LPFTOA4:
    popq  %rax
    movb  %al, (%rsi, %rcx)
    incq  %rcx

    cmpq  %rcx, %r8
    jne   .LPFTOA4

    movb    $0, (%rsi, %rcx) # The null character
    movaps  %xmm3, %xmm0

    movq  %r8, %rax
    leave
    ret
