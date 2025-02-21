/*
    convert the uppercase letters in str into lowercase
*/

.section .text
.global tolower
.type tolower, @function
tolower: # tolower(str)
    movq  %rdi, %rsi

    .LPLOWER0:
    lodsb
    testb  %al, %al
    jz     1f

    cmpb  $'A', %al
    jb    .LPLOWER0
    cmpb  $'Z', %al
    ja    .LPLOWER0

    addb  $32, %al
    movb  %al, -1(%rsi)

    jmp  .LPLOWER0

    1:
    ret
/*
    ## Altered Registers ##
    - rsi
*/
