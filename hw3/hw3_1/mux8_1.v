/*
   CS/ECE 552, Spring '22
   homework #3, Problem #1
  
   This module creates a 8-to-1 mux.
*/
module mux8_1(out, inA, inB, inC, inD, inE, inF, inG, inH, s);
    output         out;
    input          inA, inB, inC, inD, inE, inF, inG, inH;
    input [2:0]    s;

    wire           outA, outB;

    mux4_1 muxA (.out(outA), .inA(inA), .inB(inB), .inC(inC), .inD(inD), .s(s[1:0]));
    mux4_1 muxB (.out(outB), .inA(inE), .inB(inF), .inC(inG), .inD(inH), .s(s[1:0]));
    mux2_1 muxC (.out(out), .inA(outA), .inB(outB), .s(s[2]));

endmodule