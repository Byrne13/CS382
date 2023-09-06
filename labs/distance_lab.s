.text
.global _start
_start:

	ADR x0, zero
	LDUR d4, [x0] //set d4 to 0
	ADR x0, max_val
	LDUR d3, [x0] //set d3 to arbitrary large value
	
	ADR x0, x //address of x arr
	ADR x2, y //addr of y arr
	
	mov x5, #0 // outer count
	mov x6, #0 // inner count
	
	MOV x3, #0
	MOV x4, #1
	MOV x25, #0
	MOV x26, #1
	
in_loop:
	mov x7, #8
	MUL x8, x5, x7 //offset multiplication
	LDR d5, [x0, x8] // x[i]
	LDR d6, [x2, x8] // y[i]
	
	MUL x10, x6, x7 //offset multiplication
	LDR d7, [x0, x10] // x[j]
	LDR d8, [x2, x10] // y[j]
	
	CMP x5, #8 // is i at end?
	B.GE print_out
	CMP x6, #8 // is j at end?
	B.NE calc
	mov x6, #0
	add x5, x5, #1 //sets counter
	bl in_loop
calc:	CMP x5, x6
	B.NE distance
	ADD x6, x6, #1 //increment index if not at end
	bl in_loop

distance:
	FSUB d5, d5, d7
	FMUL d5, d5, d5
	FSUB d6, d6, d8
	FMUL d6, d6, d6
	FADD d6, d5, d6 // find distance sum
	
	fcmp d6, d4 //if new max
	b.gt set_max
	
	fcmp d6, d3 //if new min
	b.lt set_min
	ADD x6, x6, #1
	bl in_loop
	
	


distance_min:
	fcmp d6, d3
	b.lt set_min
	ADD x6, x6, #1
	bl in_loop
	
set_max:
	fmov d4, d6 
	mov x3, x5
	mov x4, x6
	bl distance_min
	ADD x6, x6, #1
	bl in_loop
	
set_min:
	fmov d3, d6
	mov x25, x5
	mov x26, x6
	ADD x6, x6, #1
	bl in_loop
	
print_out:
	LDR x0, =max_out
	mov x1, x3
	mov x2, x4
	bl printf
	
	ldr x0, =min_out
	mov x1, x25
	mov x2, x26
	bl printf
exit:
	mov x0, #0
	mov w8, #93
	svc #0
	
.data
max_out:
	.ascii "Largest distance between points: %d and %d \n\0"
min_out:
	.ascii "Smallest distance between points: %d and %d \n\0"
zero:
	.double 0.0
max_val:
	.double 99999.99
N:
	.dword 8
x:
	.double 0.0, 0.4140, 1.4949, 5.0014, 6.5163, 3.9303, 8.4813, 2.6505
y: 	
	.double 0.0, 3.9862, 6.1488, 1.047, 4.6102, 1.4057, 5.0371, 4.1196

.end
	
