/*
   CS/ECE 552, Spring '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   parameter NUM_REGISTERS = 8;
   parameter REG_SIZE = 16;

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   wire [REG_SIZE-1:0]  regOut0, regOut1, regOut2, regOut3, regOut4, regOut5, regOut6, regOut7;
   wire [NUM_REGISTERS-1:0]  decoderOut;

   /* YOUR CODE HERE */
   decoder3_to_8 decoder (.out(decoderOut), .in(writeRegSel));

   reg_16b reg0 (.readData(regOut0), .writeData(writeData), .clk(clk), .rst(rst), .writeEn(decoderOut[0] & writeEn));
   reg_16b reg1 (.readData(regOut1), .writeData(writeData), .clk(clk), .rst(rst), .writeEn(decoderOut[1] & writeEn));
   reg_16b reg2 (.readData(regOut2), .writeData(writeData), .clk(clk), .rst(rst), .writeEn(decoderOut[2] & writeEn));
   reg_16b reg3 (.readData(regOut3), .writeData(writeData), .clk(clk), .rst(rst), .writeEn(decoderOut[3] & writeEn));
   reg_16b reg4 (.readData(regOut4), .writeData(writeData), .clk(clk), .rst(rst), .writeEn(decoderOut[4] & writeEn));
   reg_16b reg5 (.readData(regOut5), .writeData(writeData), .clk(clk), .rst(rst), .writeEn(decoderOut[5] & writeEn));
   reg_16b reg6 (.readData(regOut6), .writeData(writeData), .clk(clk), .rst(rst), .writeEn(decoderOut[6] & writeEn));
   reg_16b reg7 (.readData(regOut7), .writeData(writeData), .clk(clk), .rst(rst), .writeEn(decoderOut[7] & writeEn));

   mux8_1_16b mux1(.out(read1Data), .inA(regOut0), .inB(regOut1), .inC(regOut2), .inD(regOut3), .inE(regOut4), .inF(regOut5), .inG(regOut6), .inH(regOut7), .s(read1RegSel));
   mux8_1_16b mux2(.out(read2Data), .inA(regOut0), .inB(regOut1), .inC(regOut2), .inD(regOut3), .inE(regOut4), .inF(regOut5), .inG(regOut6), .inH(regOut7), .s(read2RegSel));

   assign err = ((^read1RegSel == 1'bx) | (^read2RegSel == 1'bx) | (^writeRegSel == 1'bx) | (^writeData == 1'bx) | (writeEn == 1'bx));

endmodule
