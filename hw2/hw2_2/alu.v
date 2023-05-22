/*
    CS/ECE 552 Spring '22
    Homework #2, Problem 2

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0
    wire   [OPERAND_WIDTH -1:0] A, B, add_out, shift_out, or_out, and_out, xor_out, out_unit1;
    wire                        Cout, err;

    /* YOUR CODE HERE */
    assign A = invA ? ~InA : InA;
    assign B = invB ? ~InB : InB;

    cla_16b adder (.A(A), .B(B), .C_in(Cin), .S(add_out), .C_out(Cout), .err(err));

    shifter shift (.In(A), .ShAmt(B[3:0]), .Oper(Oper[1:0]), .Out(shift_out));

    or2 orGate[OPERAND_WIDTH -1:0] (.in1(A), .in2(B), .out(or_out));
    and2 andGate[OPERAND_WIDTH -1:0] (.in1(A), .in2(B), .out(and_out));
    xor2 xorGate[OPERAND_WIDTH -1:0] (.in1(A), .in2(B), .out(xor_out));

    assign Ofl = (~sign & Cout) | (sign & (add_out[OPERAND_WIDTH-1] & ~A[OPERAND_WIDTH-1] & ~B[OPERAND_WIDTH-1]) | (~add_out[OPERAND_WIDTH-1] & A[OPERAND_WIDTH-1] & B[OPERAND_WIDTH-1]));
    assign out_unit1 = Oper[1] ? (Oper[0] ? xor_out : or_out) : (Oper[0] ? and_out : add_out);
    assign Out = Oper[2] ? out_unit1 : shift_out;
    assign Zero = ~(|Out);
    
endmodule
