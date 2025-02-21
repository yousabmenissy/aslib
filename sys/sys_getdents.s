/*
    struct linux_dirent64 {
    unsigned long  d_ino;    //   (buff) 64-bit inode number 
    off_t          d_off;    //  8(buff) 64-bit offset from buffer start 
    unsigned short d_reclen; // 16(buff) 16-bit Size of this dirent 
    unsigned char  d_type;   // 18(buff) 8-bit File type 
    char           d_name[]; // 19(buff) Filename (null-terminated) 
    };
*/
.equ DT_UNKNOWN, 0      # File type is unknown.
.equ DT_FIFO,    1      # File is a named pipe (FIFO).
.equ DT_CHR,     2      # File is a character device.
.equ DT_DIR,     4      # File is a directory.
.equ DT_BLK,     6      # File is a block device.
.equ DT_REG,     8      # File is a regular file.
.equ DT_LNK,     10     # File is a symbolic link.
.equ DT_SOCK,    12     # File is a UNIX domain socket.

.macro GETDENTS fd=%rdi, buff=(%rsi), size=%rdx
    movq  \fd, %rdi
    leaq  \buff, %rsi
    movq  \size, %rdx
    movq  $217, %rax
    syscall
.endm

.macro GETENT buff=%rsi, index=$1
    movq  \buff, %rsi
    movq  \index, %rcx

    1:
    testq   %rcx, %rcx
    jz      1f
    movq    %rsi, %rax
    movzwq  16(%rsi), %rdx
    addq    %rdx, %rsi
    decq    %rcx
    jmp     1b
    1:
.endm

/*
    ## Usage Example ##
    # Use GETENT to get the linux_dirent64 struct from the buffer
    # Get the entry name from 19(%rax) and print it
    .include "aslib/aslib.s"
    .section .data
    dir: .string "."
    .section .bss
    .lcomm buff, 4096
    .section .text
    .global _start
    _start:
    OPENDIR  	dir(%rip)
    GETDENTS    %rax, buff(%rip), $4096
    leaq		   buff(%rip), %rsi
    GETENT		%rsi, $1
    leaq		   19(%rax), %rdi
    PRINTLN		
    leaq		   buff(%rip), %rsi
    GETENT		%rsi, $2
    leaq		   19(%rax), %rdi
    PRINTLN		
    leaq		   buff(%rip), %rsi
    GETENT		%rsi, $3
    leaq		   19(%rax), %rdi
    PRINTLN		
    leaq		   buff(%rip), %rsi
    GETENT		%rsi, $4
    leaq		   19(%rax), %rdi
    PRINTLN		
    EXIT %rax
*/
