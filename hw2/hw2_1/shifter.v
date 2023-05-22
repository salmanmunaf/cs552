/*
    CS/ECE 552 Spring '22
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate
    wire   [OPERAND_WIDTH -1:0] w1,w2,w3;

   /* YOUR CODE HERE */
   shifter1 shift1 (.In(In), .Shift(ShAmt[0]), .Oper(Oper), .Out(w1));
   shifter2 shift2 (.In(w1), .Shift(ShAmt[1]), .Oper(Oper), .Out(w2));
   shifter4 shift4 (.In(w2), .Shift(ShAmt[2]), .Oper(Oper), .Out(w3));
   shifter8 shift8 (.In(w3), .Shift(ShAmt[3]), .Oper(Oper), .Out(Out));
   
endmodule
