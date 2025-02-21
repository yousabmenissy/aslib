/*
    Map a file into virtual memory
*/

.section .text
.global fmap
.type fmap, @function

fmap: # fmap(fd)
    movq   %rdi, -8(%rsp)
    LSEEK  %rdi, $0, $SEEK_END
    testq  %rax, %rax
    js     1f
    MMAP   $0, %rax, $PROT_READ, $MAP_PRIVATE, -8(%rsp), $0

    1:
    LSEEK  -8(%rsp), $0, $SEEK_SET
    ret
