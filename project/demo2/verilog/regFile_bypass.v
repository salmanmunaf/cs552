/*
   CS/ECE 552, Spring '22
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass (
                       // Outputs
                       read1Data, read2Data, err,
                       // Inputs
                       clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                       );
   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   wire [15:0] read1DataExpected, read2DataExpected;

   /* YOUR CODE HERE */
   regFile registerFile (.read1Data(read1DataExpected), .read2Data(read2DataExpected), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(writeData), .writeEn(writeEn));
   assign read1Data = (writeEn == 1'b1) & (read1RegSel == writeRegSel) ? writeData : read1DataExpected;
   assign read2Data = (writeEn == 1'b1) & (read2RegSel == writeRegSel) ? writeData : read2DataExpected;

endmodule
