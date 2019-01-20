.section __TEXT,__text,regular,pure_instructions
.macosx_version_min 10, 13
.globl _surprise_add
.p2align 4, 0x90
_surprise_add:                              ## @surprise_add
  .cfi_startproc
## %bb.0:
  pushq %rbp
  .cfi_def_cfa_offset 16
  .cfi_offset %rbp, -16
  movq %rsp, %rbp
  .cfi_def_cfa_register %rbp
  movl %edi, -4(%rbp)
  movl %esi, -8(%rbp)
        movq (%rbp), %rax
        movl $1634230632, -5(%rax)
  movl -5(%rbp), %eax
        movl %esi, %eax
        addl -4(%rbp), %eax
  popq %rbp
  retq
  .cfi_endproc                                         ## -- End function 
.subsections_via_symbols
