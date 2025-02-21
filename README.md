# aslib
A collection of functions and macros written in the GNU assembler, `as`. 

Designed for Unix/Linux x86_64 systems it provides a variety of useful utilities for various tasks, written entirely in assembly language.

## Table of Contents
- [Tutorial](#tutorial)
- [Examples](#examples)
  - [Hello World](#hello-world)
  - [Echo](#echo)
  - [Decimal Sum](#decimal-sum)
  - [More Examples](#more-examples)
- [Directory Structure](#directory-structure)
- [Features](#features)
- [Formatting](#formatting)
- [100% Assembly](#100-assembly)
- [License](#license)
- [Contributing](#contributing)
- [Contact](#contact)

## Tutorial
To use the library, clone the aslib directory into the current working directory:
```sh
git clone https://github.com/yousabmenissy/aslib.git
```
and include it in your program by adding the line:
```as
.include "aslib/aslib.s"
```
at the top of your main assembly file. Now you can use all macros and functions from aslib in your program.

## Examples

### Hello World
```as
.include "aslib/aslib.s"

.section .data
msg: .string "hello world"
len: .quad .-msg

.section .text
.global _start
_start:
    WRITELN $1, msg(%rip), len(%rip)
    EXIT    $0
```

### Echo
```as
.include "aslib/aslib.s"

.section .text
.global _start
_start:
    movq  %rsp, %rbp
    movq  (%rbp), %r8

    .LP0:
    incq   %rbx
    movq   8(%rbp, %rbx, 8), %rdi
    call   strlen
    movq   8(%rbp, %rbx, 8), %rsi
    WRITE  $1, (%rsi), %rax
    movq   $1, %rdi
    movq   $' ', %rsi
    call   putc

    decq  %r8
    cmpq  $1, %r8
    jne   .LP0

    NEWLN  $1
    EXIT   $0
```

### Decimal Sum
```as
.include "aslib/aslib.s"

.section .data
err: .string "sum: ignored bad input '{s}' \n"

.section .text
.global _start

_start:
    movq  %rsp, %rbp

    pxor  %xmm1, %xmm1
    cmpq  $1, (%rbp)
    jne   .LP0
    EXIT  $0

    .LP0:
    incq  %rbx
    movq  8(%rbp, %rbx, 8), %rdi
    cmpq  $0, %rdi
    je    2f

    ATOD
    testq  %rdx, %rdx
    jns    1f

    pushq  $0
    pushq  8(%rbp, %rbx, 8)
    movq   $1, %rdi
    leaq   err(%rip), %rsi
    call   printf
    jmp    .LP0

    1:
    DADD
    movaps  %xmm0, %xmm1
    pxor    %xmm0, %xmm0
    jmp     .LP0

    2:
    movaps  %xmm1, %xmm0
    PUTD    $1
    NEWLN   $1
    EXIT    $0
```

### More Examples
You can find many more examples at [aslib examples](https://github.com/yousabmenissy/aslib-examples.git).

## Directory Structure
- `aslib.s`: Main include file that includes all other files.
- `sys/`: System call macros.
- `string/`: String manipulation functions.
- `io/`: Input/output functions.
- `decimal/`: Functions for operating on decimal numbers.

## Features
- **Syscall macros** - Readable and easy-to-use macros for many system calls.
- **Conversion utilities** - Convert between string, int, float, and decimal.
- **Read/Write utilities** - Read and write values of various types.
- **String Manipulation** - Operate on strings and command line arguments.
- **Decimal type** - Read, store, and operate on decimal values with exact precision.

## Formatting
The library has a somewhat unconventional formatting where local labels are indented alongside the instructions. Not only did I not find an assembly autoformatter that does that, but I didn't find any formatter for GNU assembly anywhere.

Out of frustration, I made my own GAS autoformatter in C called [cur](https://github.com/yousabmenissy/cur.git). It's portable, small, simple, and very opinionated. It's what is used to format [aslib](https://github.com/yousabmenissy/aslib.git) and [aslib examples](https://github.com/yousabmenissy/aslib-examples.git).

## 100% Assembly
This library is entirely composed of handwritten assembly instructions. It does not use the C standard library, compilers, or libraries from any other language.

## License
Copyright (c) 2025-present Yousab Menissy

Licensed under MIT License. See the [LICENSE](LICENSE) file for details.