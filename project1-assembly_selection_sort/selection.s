.text
.global _start
.extern printf
.equ ELEM, 10 //array size

_start:
	.global main
main:
	ldr x0, =stack
	mov sp, x0
	ldr x1, =arr //loads address of array into reg 1
	ldr x0, [x1] //loads value of element 0 in array into reg 0
	ldr x3, size //loads size into reg 3
	mov x5, #0 //initialize reg 5
	mov x6, #0 //init reg 6
	mov x7, #0 //init reg 7
	mov x8, #1 //init reg 8
	mov x9, #0 //counter for j
	mov x10, #0 //counter for min
	mov x11, #0 // var for elem of arr[j]
	mov x12, #0 // var for elem of arr[min]
	mov x13, #0 //temp var for swap
	mov x14, #0 //temp var for swap
	
	
	
	mov x2, #0 //for loop. i = 0
	
	
outer_loop:
	mov x5, x2 //minimum index = i
	mov x10, x1 //addr of x1 in x10
	
	mov x6, x2 //for loop. j=i
	add x6, x6, #1 //add 1 to j
	mov x9, x1 //addr of x1 in x9
inner_loop:

	ldr x12, [x10] // arr[min]
	ldr x11, [x9] // arr[j]
	cmp x11, x12 //if arr[j] < arr[min]: min = j
	b.ge jump
	mov x5, x6
	mov x10, x9
jump:
	add x6, x6, #1 //j++
	add x9, x9, #8 //offset 8
	cmp x6, x3 //is j less than size
	b.le inner_loop
	
	//swap elem at arr[min] and arr[i] 
	ldr x13, [x10] //arr[min]
	ldr x14, [x1] //arr[i]
	str x13, [x1]
	str x14, [x10]
	

	cmp x2, x3 //is i less than size
	add x1, x1, #8 //increment offset
	add x2, x2, #1 //i++
	b.le outer_loop //loop exit
	

end:
	sub sp, sp, #16
	str x30, [sp]
	bl printarr
	ldr x30, [sp]
	add sp, sp, #16
	
	b exit


.func printarr
printarr:
	
	mov x2, #0 //for loop. i = 0
	ldr x5, =arr //loads address of array into reg 5
	ldr x4, [x5] //loads value of element at x5 in array into reg 4
ploop:
	
	stp x4, x5, [sp, #-16]!
	stp x2, x30, [sp, #-16]!
	
	mov x1, x4 //put int to print in reg 1
	ldr x0, =out_string //print. loads print template in reg 0
	bl printf
	
	ldp x2, x30, [sp], #16
	ldp x4, x5, [sp], #16
	ldr x3, size
	
	add x5, x5, #8 //add address offset
	ldr x4, [x5] //load next elem
	
	add x2, x2, #1 //i++
	cmp x2, x3 //is i less than size
	b.lt ploop //loop exit
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
	.ascii "%d\n\0"
arr:
	.dword 5, 4, 3, 2, 1, 0, -1, -2, -3, -4
.bss
	.align 8
out:
	.space 8
	.align 16
	.space 4096
stack:
	.space 16
.end
