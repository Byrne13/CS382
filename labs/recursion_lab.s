.text
.global _start
.extern printf

_start:
	ADR x5, vec
	Mov x2, #2
	bl recur
	
	ADR x0, bananas_str
	BL printf
	
	MOV x0, #0
	MOV w8, #93
	svc #0
	
recur:   SUB SP, SP, #16
	STUR X30, [SP, #8]
	STUR x2, [SP,#0]
	CMP x2, #0
	B.GT recur_split
	LDUR x1, [x5, #0]
	ADD SP, SP, #16
	B return
	
recur_split: 
	SUB X2, x2, 1
	BL recur
	LDUR x2, [SP, #0]
	LDUR x30, [SP, #8]
	ADD SP, SP, #16
	
	LSL x3, x2, #4
	LDR x6, [x5, x3]
	
	CMP x6, x1
	B.GT recur_end
	mov X1, X1
	B return
	 
recur_end:
	MOV x1, x6
	B return
	
return:
	BR x30
	
.data

vec: .dword 1, 3, 15, 5, 6

bananas_str:
.ascii "%d\n\0"

.end
	
