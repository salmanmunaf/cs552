/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 1

    4-1 mux template
*/
module mux4_1(out, inA, inB, inC, inD, s);
    output       out;
    input        inA, inB, inC, inD;
    input [1:0]  s;
    wire         w1, w2;

    // YOUR CODE HERE
    mux2_1 mux_ab (.out(w1), .inA(inA), .inB(inB), .s(s[0]));
    mux2_1 mux_cd (.out(w2), .inA(inC), .inB(inD), .s(s[0]));
    mux2_1 mux_final (.out(out), .inA(w1), .inB(w2), .s(s[1]));

endmodule
