/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (memDataOut,
               memDataIn, AluRes,
               memWR, MemRead, MemWrite, Halt, clk, rst);
   parameter OPERAND_WIDTH = 16;
   output wire [OPERAND_WIDTH-1:0] memDataOut;
   input wire [OPERAND_WIDTH-1:0] memDataIn, AluRes;
   input wire memWR, MemRead, MemWrite, Halt, clk, rst;

   // TODO: Your code here
   memory2c data_mem_mod (.data_out(memDataOut), .data_in(memDataIn), .addr(AluRes), .enable(MemRead | MemWrite), .wr(memWR), .createdump(Halt), .clk(clk), .rst(rst));
   
endmodule
`default_nettype wire