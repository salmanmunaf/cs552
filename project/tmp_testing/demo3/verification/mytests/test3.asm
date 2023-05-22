LBI	r1, 1		
ADDI	r1, r1, 10
BGEZ	r1, .shouldGoHere
	
LBI	r2, 0
ADDI	r2, r2, 1
ADDI	r2, r2, 1
.shouldGoHere:
ADDI	r1, r1, 10
	HALT