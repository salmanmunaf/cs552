// Author: salman
// Test source code follows

//This mainly tests the X->X forwarding problems for SEQ instruction that can happen
//if people messed up passing values between their pipelines.

lbi r1, 5	    //load 5 into r1
lbi r2, 5	    //load 5 into r2
lbi r3, 10	    //load 10 into r3
lbi r4, 5       //load 5 into r4
lbi r5, 5       //load 5 into r5
andn r4, r1, r2  //expected r4 = 0
andn r4, r1, r2  //expected r4 = 0
add r4, r1, r2  //expected r4 = 10
seq r6, r4, r3  //expected r6 = 1 (X->X forwarding)
andn r5, r1, r2 //expected r5 = 0
halt