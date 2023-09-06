.text
.global _start
.extern printf
.equ ELEM, 10 //array size

_start:
	.global main
main:
	ldr x0, =stack
	mov sp, x0
	
	adr x0, real_three 
	ldur d0, [x0]
	fmov d2, d0 //d2 = 0.0
	
	fmov d0, d2
	fmov d1, d2
	fmov d2, d2
	fmov d3, d2
	fmov d4, d2
	fmov d5, d2
	fmov d6, d2
	fmov d11, d2
	fmov d12, d2
	fmov d13, d2
	fmov d14, d2
	fmov d15, d2
	fmov d16, d2

	mov x0, #0
	mov x1, #0

	
	adr x0, real_one //initialze d5 as 2.5
	ldur d0, [x0]
	fmov d10, d0
	
	//calculate length of recatangles
	adr x0, a 
	ldur d0, [x0]
	fmov d1, d0 // d1 = a
	
	adr x0, b
	ldur d0, [x0]
	fmov d2, d0 // d2 = b
	
	adr x0, n
	ldur d0, [x0]
	fmov d3, d0 // d2 = n
	
	fmov d13, d1 //left bound in d6
	fmov d14, d2 //rightbound in d14
	
	fabs d1, d1
	fadd d4, d1, d2
	fdiv d5, d4, d3 //rectangles = a
	
	fmov d12, d5 //rectangle width in d12
	fmov d1, d13 // rectangle width (input) in d1
		
	sub sp, sp, #16
	str x30, [sp]
	bl arithmetic
	ldr x30, [sp]
	add sp, sp, #16
	
	fmul d0, d0, d12 // width times height
	fadd d11, d11, d0 //add area to counter d11
	fadd d13, d13, d12 //increment leftbound 
	
loop:
	//stp x4, x5, [sp, #-16]!
		
	fmov d1, d13 // leftbound (input) in d1
		
	sub sp, sp, #16
	str x30, [sp]
	bl arithmetic
	ldr x30, [sp]
	add sp, sp, #16
	
	fmul d0, d0, d12 // width times height
	fadd d11, d11, d0 //add area to counter d11
	fadd d13, d13, d12 //increment leftbound 
	

	//ldp x4, x5, [sp], #16
	fcmp d13, d14 //if leftbound > right bound
	b.lt loop
	
	adr x0, out_string
	fmov d0, d11
	bl printf
	
	adr x0, answer
	ldur d0, [x0]
	fmov d15, d0
	adr x0, out_string_two
	bl printf
	
	adr x0, out_string_three
	fsub d0, d11, d15
	bl printf
	
	b exit

.func arithmetic
arithmetic:
	adr x0, real_two
	ldur d0, [x0]
	fmov d6, d0 //d1 = input
	
	//d1 = input
	adr x0, real_three 
	ldur d0, [x0]
	fmov d2, d0 //d2 = 0.0
	fmov d0, d2 //init d0
	
	fmov d3, d2
	fmov d4, d2
	fmov d5, d10 //reset d5
	//d6 is 15.5
	fmov d7, #20
	fmov d8, #15
	fmov d9, d2
	fmov d16, d2

	//y = 2.5x^3 - 15x^2 + 20x + 15
	fmul d3, d1, d1 //x^2
	fmul d4, d3, d1 //x^3
	
	fmul d5, d5, d4 //2.5x^3
	fmul d6, d6, d3 //15.5 x^2
	fmul d7, d7, d1 //20x
	// d8 = 15
	
	fadd d9, d5, d7
	fadd d16, d9, d8
	
	fsub d0, d16, d6
	
	
	br x30 //go back
.endfunc

exit:
	mov x0, #0
	mov w8, #93
	svc #0



.data
size:
	.dword 10
out_string:
	.ascii "Approx: %lf\n\0"
out_string_two:
	.ascii "Exact: %lf\n\0"
out_string_three:
	.ascii "Difference: %lf\n\0"
a:
	.double -0.5 // left limit = -0.5
b:
	.double 5.0 // right limit = 5
n:
	.double 150000 // 150,000 rectangles
real_one:
	.double 2.5
real_two: 
	.double 15.5
real_three:
	.double 0.0
answer:
	.double 74.1067708

.bss
	.align 8
result: .skip 8 // the result of the integral

out:
	.space 8
	.align 16
	.space 4096
stack:
	.space 16
.end
