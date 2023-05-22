/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 1

    2-1 mux template
*/
module mux2_1(out, inA, inB, s);
    output  out;
    input   inA, inB;
    input   s;
    wire    wA, wnotS, wB;

    // YOUR CODE HERE
    not1 notA (.out(wnotS), .in1(s));
    nand2 nandA (.out(wA), .in1(inA), .in2(wnotS));
    nand2 nandB (.out(wB), .in1(inB), .in2(s));
    nand2 res (.out(out), .in1(wA), .in2(wB));

endmodule
