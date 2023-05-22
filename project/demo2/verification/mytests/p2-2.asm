// Author: salman
// Test source code follows

//This mainly tests the code in which branch is not taken
//where the processor predicts branch not taken that leads to no stalls.

lbi r1, 1	    //load 1 into r1
lbi r2, 1	    //load 1 into r2
lbi r3, 1	    //load 1 into r3
lbi r4, 1       //load 1 into r4
lbi r5, 1       //load 1 into r5
andn r5, r1, r2  //expected r5 = 0
andn r5, r1, r2  //expected r5 = 0
beqz r3, .label1 //branch not taken (and processor predicts not taken)
andn r5, r1, r2  //expected r5 = 0
andn r5, r1, r2  //expected r5 = 0
halt

.label1:
lbi r4, 0
halt