/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 2

    2 input AND
*/
module and2 (out,in1,in2);
    output out;
    input in1,in2;
    wire w1;

    nand2 nand_ab (.out(w1), .in1(in1), .in2(in2));
    nand2 nand_out (.out(out), .in1(w1), .in2(w1));
endmodule
