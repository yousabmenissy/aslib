/*
    convert the lowercase letters in str into uppercase
*/

.section .text
.global toupper
.type toupper, @function
toupper: # toupper(str)
    movq  %rdi, %rsi

    .LPUPPER0:
    lodsb
    testb  %al, %al
    jz     1f

    cmpb  $'a', %al
    jb    .LPUPPER0
    cmpb  $'z', %al
    ja    .LPUPPER0

    subb  $32, %al
    movb  %al, -1(%rsi)

    jmp  .LPUPPER0

    1:
    ret
