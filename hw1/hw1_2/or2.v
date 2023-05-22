/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 2

    2 input OR
*/
module or2 (out,in1,in2);
    output out;
    input in1,in2;
    wire w1, w2;

    not1 not_a (.out(w1), .in1(in1));
    not1 not_b (.out(w2), .in1(in2));
    nand2 nand_out (.out(out), .in1(w1), .in2(w2));
endmodule
