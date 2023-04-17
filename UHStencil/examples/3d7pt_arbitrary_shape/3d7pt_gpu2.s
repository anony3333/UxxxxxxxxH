	.text
	.file	"LLVMDialectModule"
	.globl	stencil_3d7pt                   # -- Begin function stencil_3d7pt
	.p2align	4, 0x90
	.type	stencil_3d7pt,@function
stencil_3d7pt:                          # @stencil_3d7pt
.Lfunc_begin0:
	.file	1 "/home/jzh/mlir_stencil/SWStenDSL/examples/3d7pt_arbitrary_shape" "3d7pt_gpu_llvm.mlir"
	.loc	1 5 0                           # 3d7pt_gpu_llvm.mlir:5:0
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$312, %rsp                      # imm = 0x138
	.cfi_def_cfa_offset 368
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r9, (%rsp)                     # 8-byte Spill
	movq	%r8, %r13
	movq	%rcx, %rbp
	movq	%rdx, %r15
	movq	%rsi, %r14
	movq	%rdi, %r12
.Ltmp0:
	.loc	1 35 11 prologue_end            # 3d7pt_gpu_llvm.mlir:35:11
	movl	$137388096, %edi                # imm = 0x8306040
	callq	malloc@PLT
	.loc	1 61 11                         # 3d7pt_gpu_llvm.mlir:61:11
	movl	$stencil_3d7pt_kernel_gpubin_cst, %edi
	callq	mgpuModuleLoad@PLT
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	.loc	1 65 11                         # 3d7pt_gpu_llvm.mlir:65:11
	movl	$stencil_3d7pt_kernel_stencil_3d7pt_kernel_kernel_name, %esi
	movq	%rax, %rdi
	callq	mgpuModuleGetFunction@PLT
	movq	%rax, 8(%rsp)                   # 8-byte Spill
	.loc	1 67 11                         # 3d7pt_gpu_llvm.mlir:67:11
	callq	mgpuStreamCreate@PLT
	movq	%rax, %rbx
	.loc	1 93 5                          # 3d7pt_gpu_llvm.mlir:93:5
	movq	%r12, 24(%rsp)
	leaq	24(%rsp), %rax
	.loc	1 96 5                          # 3d7pt_gpu_llvm.mlir:96:5
	movq	%rax, 168(%rsp)
	.loc	1 99 5                          # 3d7pt_gpu_llvm.mlir:99:5
	movq	%r14, 32(%rsp)
	.loc	1 98 11                         # 3d7pt_gpu_llvm.mlir:98:11
	leaq	32(%rsp), %rax
	.loc	1 102 5                         # 3d7pt_gpu_llvm.mlir:102:5
	movq	%rax, 176(%rsp)
	.loc	1 105 5                         # 3d7pt_gpu_llvm.mlir:105:5
	movq	%r15, 40(%rsp)
	.loc	1 104 11                        # 3d7pt_gpu_llvm.mlir:104:11
	leaq	40(%rsp), %rax
	.loc	1 108 5                         # 3d7pt_gpu_llvm.mlir:108:5
	movq	%rax, 184(%rsp)
	.loc	1 111 5                         # 3d7pt_gpu_llvm.mlir:111:5
	movq	%rbp, 48(%rsp)
	.loc	1 110 11                        # 3d7pt_gpu_llvm.mlir:110:11
	leaq	48(%rsp), %rax
	.loc	1 114 5                         # 3d7pt_gpu_llvm.mlir:114:5
	movq	%rax, 192(%rsp)
	.loc	1 117 5                         # 3d7pt_gpu_llvm.mlir:117:5
	movq	%r13, 56(%rsp)
	.loc	1 116 12                        # 3d7pt_gpu_llvm.mlir:116:12
	leaq	56(%rsp), %rax
	.loc	1 120 5                         # 3d7pt_gpu_llvm.mlir:120:5
	movq	%rax, 200(%rsp)
	movq	(%rsp), %rax                    # 8-byte Reload
	.loc	1 123 5                         # 3d7pt_gpu_llvm.mlir:123:5
	movq	%rax, 64(%rsp)
	.loc	1 122 12                        # 3d7pt_gpu_llvm.mlir:122:12
	leaq	64(%rsp), %rax
	.loc	1 126 5                         # 3d7pt_gpu_llvm.mlir:126:5
	movq	%rax, 208(%rsp)
	.loc	1 129 5                         # 3d7pt_gpu_llvm.mlir:129:5
	movq	368(%rsp), %rax
	movq	%rax, 72(%rsp)
	.loc	1 128 12                        # 3d7pt_gpu_llvm.mlir:128:12
	leaq	72(%rsp), %rax
	.loc	1 132 5                         # 3d7pt_gpu_llvm.mlir:132:5
	movq	%rax, 216(%rsp)
	.loc	1 135 5                         # 3d7pt_gpu_llvm.mlir:135:5
	movq	376(%rsp), %rax
	movq	%rax, 80(%rsp)
	.loc	1 134 12                        # 3d7pt_gpu_llvm.mlir:134:12
	leaq	80(%rsp), %rax
	.loc	1 138 5                         # 3d7pt_gpu_llvm.mlir:138:5
	movq	%rax, 224(%rsp)
	.loc	1 141 5                         # 3d7pt_gpu_llvm.mlir:141:5
	movq	384(%rsp), %rax
	movq	%rax, 88(%rsp)
	.loc	1 140 12                        # 3d7pt_gpu_llvm.mlir:140:12
	leaq	88(%rsp), %rax
	.loc	1 144 5                         # 3d7pt_gpu_llvm.mlir:144:5
	movq	%rax, 232(%rsp)
	.loc	1 147 5                         # 3d7pt_gpu_llvm.mlir:147:5
	movq	392(%rsp), %rax
	movq	%rax, 96(%rsp)
	.loc	1 146 12                        # 3d7pt_gpu_llvm.mlir:146:12
	leaq	96(%rsp), %rax
	.loc	1 150 5                         # 3d7pt_gpu_llvm.mlir:150:5
	movq	%rax, 240(%rsp)
	.loc	1 153 5                         # 3d7pt_gpu_llvm.mlir:153:5
	movq	400(%rsp), %rax
	movq	%rax, 104(%rsp)
	.loc	1 152 12                        # 3d7pt_gpu_llvm.mlir:152:12
	leaq	104(%rsp), %rax
	.loc	1 156 5                         # 3d7pt_gpu_llvm.mlir:156:5
	movq	%rax, 248(%rsp)
	.loc	1 159 5                         # 3d7pt_gpu_llvm.mlir:159:5
	movq	408(%rsp), %rax
	movq	%rax, 112(%rsp)
	.loc	1 158 12                        # 3d7pt_gpu_llvm.mlir:158:12
	leaq	112(%rsp), %rax
	.loc	1 162 5                         # 3d7pt_gpu_llvm.mlir:162:5
	movq	%rax, 256(%rsp)
	.loc	1 165 5                         # 3d7pt_gpu_llvm.mlir:165:5
	movq	416(%rsp), %rax
	movq	%rax, 120(%rsp)
	.loc	1 164 12                        # 3d7pt_gpu_llvm.mlir:164:12
	leaq	120(%rsp), %rax
	.loc	1 168 5                         # 3d7pt_gpu_llvm.mlir:168:5
	movq	%rax, 264(%rsp)
	.loc	1 171 5                         # 3d7pt_gpu_llvm.mlir:171:5
	movq	424(%rsp), %rax
	movq	%rax, 128(%rsp)
	.loc	1 170 12                        # 3d7pt_gpu_llvm.mlir:170:12
	leaq	128(%rsp), %rax
	.loc	1 174 5                         # 3d7pt_gpu_llvm.mlir:174:5
	movq	%rax, 272(%rsp)
	.loc	1 177 5                         # 3d7pt_gpu_llvm.mlir:177:5
	movq	432(%rsp), %rax
	movq	%rax, 136(%rsp)
	.loc	1 176 12                        # 3d7pt_gpu_llvm.mlir:176:12
	leaq	136(%rsp), %rax
	.loc	1 180 5                         # 3d7pt_gpu_llvm.mlir:180:5
	movq	%rax, 280(%rsp)
	.loc	1 183 5                         # 3d7pt_gpu_llvm.mlir:183:5
	movq	440(%rsp), %rax
	movq	%rax, 144(%rsp)
	.loc	1 182 12                        # 3d7pt_gpu_llvm.mlir:182:12
	leaq	144(%rsp), %rax
	.loc	1 186 5                         # 3d7pt_gpu_llvm.mlir:186:5
	movq	%rax, 288(%rsp)
	.loc	1 189 5                         # 3d7pt_gpu_llvm.mlir:189:5
	movq	448(%rsp), %rax
	movq	%rax, 152(%rsp)
	.loc	1 188 12                        # 3d7pt_gpu_llvm.mlir:188:12
	leaq	152(%rsp), %rax
	.loc	1 192 5                         # 3d7pt_gpu_llvm.mlir:192:5
	movq	%rax, 296(%rsp)
	.loc	1 195 5                         # 3d7pt_gpu_llvm.mlir:195:5
	movq	456(%rsp), %rax
	movq	%rax, 160(%rsp)
	.loc	1 194 12                        # 3d7pt_gpu_llvm.mlir:194:12
	leaq	160(%rsp), %rax
	.loc	1 198 5                         # 3d7pt_gpu_llvm.mlir:198:5
	movq	%rax, 304(%rsp)
	.loc	1 200 12                        # 3d7pt_gpu_llvm.mlir:200:12
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	176(%rsp), %rax
	movl	$256, %esi                      # imm = 0x100
	movl	$1, %edx
	movl	$1, %ecx
	movl	$256, %r8d                      # imm = 0x100
	movl	$256, %r9d                      # imm = 0x100
	movq	16(%rsp), %rdi                  # 8-byte Reload
	pushq	$0
	.cfi_adjust_cfa_offset 8
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	pushq	%rbx
	.cfi_adjust_cfa_offset 8
	pushq	$0
	.cfi_adjust_cfa_offset 8
	pushq	$1
	.cfi_adjust_cfa_offset 8
	callq	mgpuLaunchKernel@PLT
	addq	$48, %rsp
	.cfi_adjust_cfa_offset -48
	.loc	1 201 12                        # 3d7pt_gpu_llvm.mlir:201:12
	movq	%rbx, %rdi
	callq	mgpuStreamSynchronize@PLT
	.loc	1 202 12                        # 3d7pt_gpu_llvm.mlir:202:12
	movq	%rbx, %rdi
	callq	mgpuStreamDestroy@PLT
	movq	16(%rsp), %rdi                  # 8-byte Reload
	.loc	1 203 12                        # 3d7pt_gpu_llvm.mlir:203:12
	callq	mgpuModuleUnload@PLT
	.loc	1 204 5                         # 3d7pt_gpu_llvm.mlir:204:5
	addq	$312, %rsp                      # imm = 0x138
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Ltmp1:
.Lfunc_end0:
	.size	stencil_3d7pt, .Lfunc_end0-stencil_3d7pt
	.cfi_endproc
                                        # -- End function
	.globl	stencil_3d7pt_iteration         # -- Begin function stencil_3d7pt_iteration
	.p2align	4, 0x90
	.type	stencil_3d7pt_iteration,@function
stencil_3d7pt_iteration:                # @stencil_3d7pt_iteration
.Lfunc_begin1:
	.loc	1 206 0                         # 3d7pt_gpu_llvm.mlir:206:0
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r9, 40(%rsp)                   # 8-byte Spill
	movq	%r8, 32(%rsp)                   # 8-byte Spill
	movq	%rcx, 24(%rsp)                  # 8-byte Spill
	movq	%rdx, 16(%rsp)                  # 8-byte Spill
	movq	%rsi, 8(%rsp)                   # 8-byte Spill
	movq	%rdi, (%rsp)                    # 8-byte Spill
	xorl	%eax, %eax
	movq	8(%rsp), %rbp                   # 8-byte Reload
	movq	16(%rsp), %rbx                  # 8-byte Reload
	movq	24(%rsp), %r13                  # 8-byte Reload
	movq	32(%rsp), %r12                  # 8-byte Reload
	movq	40(%rsp), %r15                  # 8-byte Reload
.Ltmp2:
	.loc	1 232 11 prologue_end           # 3d7pt_gpu_llvm.mlir:232:11
	cmpq	$9, %rax
	.loc	1 233 5                         # 3d7pt_gpu_llvm.mlir:233:5
	jg	.LBB1_3
	.p2align	4, 0x90
.LBB1_2:                                # =>This Inner Loop Header: Depth=1
	.loc	1 0 5 is_stmt 0                 # 3d7pt_gpu_llvm.mlir:0:5
	movq	(%rsp), %rdi                    # 8-byte Reload
	.loc	1 253 5 is_stmt 1               # 3d7pt_gpu_llvm.mlir:253:5
	movq	%rbp, %rsi
	movq	%rbx, %rdx
	movq	%r13, %rcx
	movq	%r12, %r8
	movq	%r15, %r9
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %r14
	pushq	%r14
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %r14
	pushq	%r14
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	movq	200(%rsp), %rax
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	callq	stencil_3d7pt@PLT
	addq	$96, %rsp
	.cfi_adjust_cfa_offset -96
	.loc	1 272 5                         # 3d7pt_gpu_llvm.mlir:272:5
	movq	%r14, %rdi
	movq	144(%rsp), %rsi
	movq	152(%rsp), %rdx
	movq	160(%rsp), %rcx
	movq	168(%rsp), %r8
	movq	176(%rsp), %r9
	pushq	128(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	128(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	128(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	%r15
	.cfi_adjust_cfa_offset 8
	pushq	%r12
	.cfi_adjust_cfa_offset 8
	pushq	%r13
	.cfi_adjust_cfa_offset 8
	pushq	%rbx
	.cfi_adjust_cfa_offset 8
	pushq	%rbp
	.cfi_adjust_cfa_offset 8
	pushq	64(%rsp)                        # 8-byte Folded Reload
	.cfi_adjust_cfa_offset 8
	pushq	272(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	272(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	272(%rsp)
	.cfi_adjust_cfa_offset 8
	callq	stencil_3d7pt@PLT
	movq	144(%rsp), %rax                 # 8-byte Reload
	addq	$96, %rsp
	.cfi_adjust_cfa_offset -96
	.loc	1 273 11                        # 3d7pt_gpu_llvm.mlir:273:11
	incq	%rax
	.loc	1 232 11                        # 3d7pt_gpu_llvm.mlir:232:11
	cmpq	$9, %rax
	.loc	1 233 5                         # 3d7pt_gpu_llvm.mlir:233:5
	jle	.LBB1_2
.LBB1_3:
	.loc	1 276 5                         # 3d7pt_gpu_llvm.mlir:276:5
	addq	$56, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Ltmp3:
.Lfunc_end1:
	.size	stencil_3d7pt_iteration, .Lfunc_end1-stencil_3d7pt_iteration
	.cfi_endproc
                                        # -- End function
	.type	stencil_3d7pt_kernel_stencil_3d7pt_kernel_kernel_name,@object # @stencil_3d7pt_kernel_stencil_3d7pt_kernel_kernel_name
	.section	.rodata,"a",@progbits
	.p2align	4
stencil_3d7pt_kernel_stencil_3d7pt_kernel_kernel_name:
	.asciz	"stencil_3d7pt_kernel"
	.size	stencil_3d7pt_kernel_stencil_3d7pt_kernel_kernel_name, 21

	.type	stencil_3d7pt_kernel_gpubin_cst,@object # @stencil_3d7pt_kernel_gpubin_cst
	.p2align	4
stencil_3d7pt_kernel_gpubin_cst:
	.asciz	"\177ELF\002\001\0013\007\000\000\000\000\000\000\000\002\000\276\000o\000\000\000\000\000\000\000\000\000\000\000\200\017\000\000\000\000\000\000\200\f\000\000\000\000\000\000F\005#\000@\0008\000\003\000@\000\f\000\001\000\000.shstrtab\000.strtab\000.symtab\000.symtab_shndx\000.nv.info\000.text.stencil_3d7pt_kernel\000.nv.info.stencil_3d7pt_kernel\000.nv.shared.stencil_3d7pt_kernel\000.nv.constant2.stencil_3d7pt_kernel\000.nv.constant0.stencil_3d7pt_kernel\000.rel.nv.constant0.stencil_3d7pt_kernel\000.debug_frame\000.rel.text.stencil_3d7pt_kernel\000.rel.debug_frame\000.nv.rel.action\000\000.shstrtab\000.strtab\000.symtab\000.symtab_shndx\000.nv.info\000stencil_3d7pt_kernel\000.text.stencil_3d7pt_kernel\000.nv.info.stencil_3d7pt_kernel\000.nv.shared.stencil_3d7pt_kernel\000.nv.constant2.stencil_3d7pt_kernel\000stencil_3d7pt_kernel.const2.0.8\000stencil_3d7pt_kernel.const2.8.16\000stencil_3d7pt_kernel.const2.16.24\000stencil_3d7pt_kernel.const2.24.32\000stencil_3d7pt_kernel.const2.32.40\000stencil_3d7pt_kernel.const2.40.48\000.rel.nv.constant0.stencil_3d7pt_kernel\000.nv.constant0.stencil_3d7pt_kernel\000_param\000.debug_frame\000.rel.text.stencil_3d7pt_kernel\000.rel.debug_frame\000.nv.rel.action\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000G\000\000\000\003\000\013\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\240\000\000\000\003\000\t\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\263\001\000\000\003\000\n\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\335\001\000\000\003\000\004\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\032\002\000\000\003\000\007\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0002\000\000\000\022\020\013\000\000\000\000\000\000\000\000\000\000\003\000\000\000\000\000\000\377\377\377\377(\000\000\000\000\000\000\000\377\377\377\377\377\377\377\377\003\000\004|\377\377\377\377\017\f\201\200\200(\000\b\377\201\200(\b\201\200\200(\000\000\000\000\000\000\000\377\377\377\3770\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\360\002\000\000\000\000\000\000\004\004\000\000\000\004\000\000\000\000\f\201\200\200(\000\004\244\000\000\000\000\000\000\004\021\b\000\006\000\000\000\000\000\000\000\004/\b\000\006\000\000\000\026\000\000\000\004\022\b\000\006\000\000\000\000\000\000\000\004\034\004\000\240\002\000\000\0041\004\000\020\000\000\000\003\033\377\000\004\027\f\000\000\000\000\000\000\000\000\000\000\360!\000\004\027\f\000\000\000\000\000\001\000\b\000\000\360!\000\004\027\f\000\000\000\000\000\002\000\020\000\000\360!\000\004\027\f\000\000\000\000\000\003\000\030\000\000\360!\000\004\027\f\000\000\000\000\000\004\000 \000\000\360!\000\004\027\f\000\000\000\000\000\005\000(\000\000\360!\000\004\027\f\000\000\000\000\000\006\0000\000\000\360!\000\004\027\f\000\000\000\000\000\007\0008\000\000\360!\000\004\027\f\000\000\000\000\000\b\000@\000\000\360!\000\004\027\f\000\000\000\000\000\t\000H\000\000\360!\000\004\027\f\000\000\000\000\000\n\000P\000\000\360!\000\004\027\f\000\000\000\000\000\013\000X\000\000\360!\000\004\027\f\000\000\000\000\000\f\000`\000\000\360!\000\004\027\f\000\000\000\000\000\r\000h\000\000\360!\000\004\027\f\000\000\000\000\000\016\000p\000\000\360!\000\004\027\f\000\000\000\000\000\017\000x\000\000\360!\000\004\027\f\000\000\000\000\000\020\000\200\000\000\360!\000\004\027\f\000\000\000\000\000\021\000\210\000\000\360!\000\003\031\220\000\004\n\b\000\003\000\000\000`\001\220\000\0047\004\000o\000\000\000\0046\004\000\001\000\000\000K\000\000\000\000\000\000\000\000\002\002\b\020\n/\"\000\000\000\b\000\000\000\000\000\000\b\b\000\000\000\000\000\000\020\b\000\000\000\000\000\000\030\b\000\000\000\000\000\000 \b\000\000\000\000\000\000(\b\000\000\000\000\000\0000\b\000\000\000\000\000\0008\b\000\000\000\000\001\000\000\b\000\000\000\000\001\000\b\b\000\000\000\000\001\000\020\b\000\000\000\000\001\000\030\b\000\000\000\000\001\000 \b\000\000\000\000\001\000(\b\000\000\000\000\001\0000\b\000\000\000\000\001\0008\b\000\000\000\000\002\000\000\b\000\000\000\000\002\000\b\b\000\000\000\000\002\000\020\b\000\000\000\000\002\000\030\b\000\000\000\000\002\000 \b\000\000\000\000\002\000(\b\000\000\000\000\002\0000\b\000\000\000\000\002\0008\b\000\000\000\000H\000\000\000\000\000\000\000\002\000\000\000\006\000\000\000\232\231\231\231\231\231\271?\232\231\231\231\231\231\311?333333\323?\232\231\231\231\231\231\331?333333\343?ffffff\346?\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000$v\001\377\000\n\000\000\377\000\216\007\000\320\017\000\211\363\377\377\377\000\000\000\377\000\016\000\000\342\017\000\031y\002\000\000\000\000\000\000!\000\000\000(\016\000\031y\005\000\000\000\000\000\000%\000\000\000h\016\000\031y\007\000\000\000\000\000\000\"\000\000\000\242\016\000\031x\000\377\037\000\000\000\002\024\001\000\000\342\037\000%x\002\002\002\001\000\000\377\000\216\007\000\310\017\000$x\t\000\002\001\000\000\377\002\216\007\000\310\017\000$x\003\003\001\000\000\000\t\002\216\007\000\342\017\000\031x\t\377\037\000\000\000\007\024\001\000\000\306O\000%x\002\005\004\004\001\000\002\000\216\007\000\342/\000\031x\005\377\037\000\000\000\005\024\001\000\000\312\017\000$x\005\005\004\004\001\000\377\002\216\007\000\342\017\000\020r\000\007\002\000\000\000\377\340\361\007\000\310\017\000\020r\t\t\003\000\000\000\005\344\177\000\000\342\017\000$x\b\000\b\000\000\000\377\000\216\007\000\306\017\000\031x\000\000\003\000\000\000\t\002\001\000\000\344\017\000\020z\f\b\000Z\000\000\377\340\361\007\000\310\017\000\020z\r\000\000[\000\000\377\344\177\000\000\320\017\000\200y\016\f@@\020\000\000\353\020\000\000\250\016\000\200y\020\f  \b\000\000\353\020\000\000\350\016\000\200y\022\f\000\000\000\000\000\353\020\000\000(\017\000\200y\006\f\b\000\000\000\000\353\020\000\000h\017\000\200y\004\f\020\000\000\000\000\353\020\000\000h\017\000\200y\002\f\020\b\000\000\000\353\020\000\000h\017\000\200y\n\f \020\000\000\000\353\020\000\000b\017\000\020z\b\b\000l\000\000\377\340\361\007\000\310\017\000\020z\t\000\000m\000\000\377\344\177\000\000\342\017\000(z\016\016\000\000\200\000\000\000\000\000\000\310O\000(z\020\020\000\002\200\000\000\000\000\000\000\b\216\000(z\022\022\000\004\200\000\000\000\000\000\000\310\017\001)r\016\016\000\000\000\000\020\000\000\000\000\b\036\000(z\006\006\000\006\200\000\000\000\000\000\000\310\017\002)r\016\016\000\000\000\000\022\000\000\000\000\b\036\000(x\004\004\000\000\340?\000\000\000\000\000\310\017\000)r\006\016\000\000\000\000\006\000\000\000\000\b\036\000(z\002\002\000\b\200\000\000\000\000\000\000\310\017\000)r\004\006\000\000\000\000\004\000\000\000\000\b\036\000(z\n\n\000\n\200\000\000\000\000\000\000\310\017\000)r\002\004\000\000\000\000\002\000\000\000\000\020\036\000)r\002\002\000\000\000\000\n\000\000\000\000\022\036\000\205s\000\b\000\000\000\000\002\353\020\000\000\342\037\000My\000\000\000\000\000\000\000\000\200\003\000\352\017\000Gy\000\000\360\377\377\377\377\377\203\003\000\300\017\000\030y\000\000\000\000\000\000\000\000\000\000\000\300\017\000\030y\000\000\000\000\000\000\000\000\000\000\000\300\017\000\030y\000\000\000\000\000\000\000\000\000\000\000\300\017\000\030y\000\000\000\000\000\000\000\000\000\000\000\300\017\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000@\000\000\000\000\000\000\000D\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\013\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\204\001\000\000\000\000\000\000)\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\023\000\000\000\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\260\003\000\000\000\000\000\000\250\000\000\000\000\000\000\000\002\000\000\000\005\000\000\000\b\000\000\000\000\000\000\000\030\000\000\000\000\000\000\000\370\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000X\004\000\000\000\000\000\000p\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000)\000\000\000\000\000\000p\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\310\004\000\000\000\000\000\000$\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\004\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000M\000\000\000\000\000\000p\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\354\004\000\000\000\000\000\000T\001\000\000\000\000\000\000\003\000\000\000\013\000\000\000\004\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0005\001\000\000\013\000\000p\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000@\006\000\000\000\000\000\000\320\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000$\001\000\000\t\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\020\007\000\000\000\000\000\000\020\000\000\000\000\000\000\000\003\000\000\000\004\000\000\000\b\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\213\000\000\000\001\000\000\000\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000 \007\000\000\000\000\000\0000\000\000\000\000\000\000\000\000\000\000\000\013\000\000\000\b\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\256\000\000\000\001\000\000\000\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000P\007\000\000\000\000\000\000\360\001\000\000\000\000\000\000\000\000\000\000\013\000\000\000\004\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0002\000\000\000\001\000\000\000\006\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\200\t\000\000\000\000\000\000\000\003\000\000\000\000\000\000\003\000\000\000\006\000\000\026\200\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\006\000\000\000\005\000\000\000\200\017\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\250\000\000\000\000\000\000\000\250\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\001\000\000\000\005\000\000\000 \007\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000`\005\000\000\000\000\000\000`\005\000\000\000\000\000\000\b\000\000\000\000\000\000\000\001\000\000\000\006\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.size	stencil_3d7pt_kernel_gpubin_cst, 4136

	.section	.debug_abbrev,"",@progbits
	.byte	1                               # Abbreviation Code
	.byte	17                              # DW_TAG_compile_unit
	.byte	1                               # DW_CHILDREN_yes
	.byte	37                              # DW_AT_producer
	.byte	14                              # DW_FORM_strp
	.byte	19                              # DW_AT_language
	.byte	5                               # DW_FORM_data2
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	16                              # DW_AT_stmt_list
	.byte	23                              # DW_FORM_sec_offset
	.byte	27                              # DW_AT_comp_dir
	.byte	14                              # DW_FORM_strp
	.ascii	"\264B"                         # DW_AT_GNU_pubnames
	.byte	25                              # DW_FORM_flag_present
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	2                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	0                               # DW_CHILDREN_no
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	110                             # DW_AT_linkage_name
	.byte	14                              # DW_FORM_strp
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	4                               # DWARF version number
	.long	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	8                               # Address Size (in bytes)
	.byte	1                               # Abbrev [1] 0xb:0x52 DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	2                               # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
                                        # DW_AT_GNU_pubnames
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x19 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string3                  # DW_AT_linkage_name
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	5                               # DW_AT_decl_line
                                        # DW_AT_external
	.byte	2                               # Abbrev [2] 0x43:0x19 DW_TAG_subprogram
	.quad	.Lfunc_begin1                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
	.long	.Linfo_string4                  # DW_AT_linkage_name
	.long	.Linfo_string4                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	206                             # DW_AT_decl_line
                                        # DW_AT_external
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"mlir"                          # string offset=0
.Linfo_string1:
	.asciz	"LLVMDialectModule"             # string offset=5
.Linfo_string2:
	.asciz	"/"                             # string offset=23
.Linfo_string3:
	.asciz	"stencil_3d7pt"                 # string offset=25
.Linfo_string4:
	.asciz	"stencil_3d7pt_iteration"       # string offset=39
	.section	.debug_pubnames,"",@progbits
	.long	.LpubNames_end0-.LpubNames_start0 # Length of Public Names Info
.LpubNames_start0:
	.short	2                               # DWARF Version
	.long	.Lcu_begin0                     # Offset of Compilation Unit Info
	.long	93                              # Compilation Unit Length
	.long	67                              # DIE offset
	.asciz	"stencil_3d7pt_iteration"       # External Name
	.long	42                              # DIE offset
	.asciz	"stencil_3d7pt"                 # External Name
	.long	0                               # End Mark
.LpubNames_end0:
	.section	.debug_pubtypes,"",@progbits
	.long	.LpubTypes_end0-.LpubTypes_start0 # Length of Public Types Info
.LpubTypes_start0:
	.short	2                               # DWARF Version
	.long	.Lcu_begin0                     # Offset of Compilation Unit Info
	.long	93                              # Compilation Unit Length
	.long	0                               # End Mark
.LpubTypes_end0:
	.section	".note.GNU-stack","",@progbits
	.section	.debug_line,"",@progbits
.Lline_table_start0:
