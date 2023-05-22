/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 1

    a 16 bit 2-1 mux template
*/
module mux2_1_16b(out, inA, inB, s);
    // parameter N for length of inputs and outputs (to use with larger inputs/outputs)
    parameter N = 16;

    output [N-1:0]  out;
    input [N-1:0]   inA, inB;
    input           s;

    // YOUR CODE HERE
    mux2_1 mux0 (.out(out[0]), .inA(inA[0]), .inB(inB[0]), .s(s));
    mux2_1 mux1 (.out(out[1]), .inA(inA[1]), .inB(inB[1]), .s(s));
    mux2_1 mux2 (.out(out[2]), .inA(inA[2]), .inB(inB[2]), .s(s));
    mux2_1 mux3 (.out(out[3]), .inA(inA[3]), .inB(inB[3]), .s(s));
    mux2_1 mux4 (.out(out[4]), .inA(inA[4]), .inB(inB[4]), .s(s));
    mux2_1 mux5 (.out(out[5]), .inA(inA[5]), .inB(inB[5]), .s(s));
    mux2_1 mux6 (.out(out[6]), .inA(inA[6]), .inB(inB[6]), .s(s));
    mux2_1 mux7 (.out(out[7]), .inA(inA[7]), .inB(inB[7]), .s(s));
    mux2_1 mux8 (.out(out[8]), .inA(inA[8]), .inB(inB[8]), .s(s));
    mux2_1 mux9 (.out(out[9]), .inA(inA[9]), .inB(inB[9]), .s(s));
    mux2_1 mux10 (.out(out[10]), .inA(inA[10]), .inB(inB[10]), .s(s));
    mux2_1 mux11 (.out(out[11]), .inA(inA[11]), .inB(inB[11]), .s(s));
    mux2_1 mux12 (.out(out[12]), .inA(inA[12]), .inB(inB[12]), .s(s));
    mux2_1 mux13 (.out(out[13]), .inA(inA[13]), .inB(inB[13]), .s(s));
    mux2_1 mux14 (.out(out[14]), .inA(inA[14]), .inB(inB[14]), .s(s));
    mux2_1 mux15 (.out(out[15]), .inA(inA[15]), .inB(inB[15]), .s(s));

endmodule
