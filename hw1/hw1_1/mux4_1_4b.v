/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 1

    a 4-bit (quad) 4-1 Mux template
*/
module mux4_1_4b(out, inA, inB, inC, inD, s);

    // parameter N for length of inputs and outputs (to use with larger inputs/outputs)
    parameter N = 4;

    output [N-1:0]  out;
    input [N-1:0]   inA, inB, inC, inD;
    input [1:0]     s;

    // YOUR CODE HERE
    mux4_1 mux0 (.out(out[0]), .inA(inA[0]), .inB(inB[0]), .inC(inC[0]), .inD(inD[0]), .s(s));
    mux4_1 mux1 (.out(out[1]), .inA(inA[1]), .inB(inB[1]), .inC(inC[1]), .inD(inD[1]), .s(s));
    mux4_1 mux2 (.out(out[2]), .inA(inA[2]), .inB(inB[2]), .inC(inC[2]), .inD(inD[2]), .s(s));
    mux4_1 mux3 (.out(out[3]), .inA(inA[3]), .inB(inB[3]), .inC(inC[3]), .inD(inD[3]), .s(s));

endmodule
