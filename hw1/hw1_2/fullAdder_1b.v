/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
    input   a, b;
    input  c_in;
    wire    w1, w2, w3;

    // YOUR CODE HERE
    xor3 sum (.out(s), .in1(a), .in2(b), .in3(c_in));
    nand2 nand_ab (.out(w1), .in1(a), .in2(b));
    nand2 nand_ac (.out(w2), .in1(a), .in2(c_in));
    nand2 nand_bc (.out(w3), .in1(b), .in2(c_in));
    nand3 carry (.out(c_out), .in1(w1) , .in2(w2), .in3(w3));

endmodule
