/*
   CS/ECE 552, Spring '22
   homework #3, Problem #1
  
   This module creates a 16-bit 8-to-1 mux.
*/
module mux8_1_16b(out, inA, inB, inC, inD, inE, inF, inG, inH, s);
    parameter OPERAND_WIDTH = 16;

    output [OPERAND_WIDTH-1:0] out;
    input [OPERAND_WIDTH-1:0]  inA, inB, inC, inD, inE, inF, inG, inH;
    input [2:0]                s;

    mux8_1 mux[OPERAND_WIDTH-1:0] (.out(out), .inA(inA), .inB(inB), .inC(inC), .inD(inD), .inE(inE), .inF(inF), .inG(inG), .inH(inH), .s(s));

endmodule