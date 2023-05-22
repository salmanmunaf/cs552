/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (memDataOut, IsUnaligned, DMemStall,
               memDataIn, AluRes,
               memWR, MemRead, MemWrite, Halt, clk, rst);
   parameter OPERAND_WIDTH = 16;
   output wire [OPERAND_WIDTH-1:0] memDataOut;
   output wire IsUnaligned, DMemStall;
   input wire [OPERAND_WIDTH-1:0] memDataIn, AluRes;
   input wire memWR, MemRead, MemWrite, Halt, clk, rst;
   wire MemReadAligned, MemWriteAligned, Done, CacheHit, err;

   // TODO: Your code here
   assign MemReadAligned = MemRead & ~AluRes[0];
   assign MemWriteAligned = MemWrite & ~AluRes[0];

   mem_system #(1) data_mem_mod (.DataOut(memDataOut), .Done(Done), .Stall(DMemStall), .CacheHit(CacheHit), .err(err), .Addr(AluRes), .DataIn(memDataIn), .Rd(MemReadAligned), .Wr(MemWriteAligned), .createdump(Halt), .clk(clk), .rst(rst));
   // stallmem data_mem_mod (.DataOut(memDataOut), .Done(Done), .Stall(DMemStall), .CacheHit(CacheHit), .err(err), .Addr(AluRes), .DataIn(memDataIn), .Rd(MemReadAligned), .Wr(MemWriteAligned), .createdump(Halt), .clk(clk), .rst(rst));
   // memory2c_align data_mem_mod (.data_out(memDataOut), .data_in(memDataIn), .addr(AluRes), .enable(MemReadAligned | MemWriteAligned), .wr(memWR), .createdump(Halt), .clk(clk), .rst(rst), .err(err));
   assign IsUnaligned = err | ((MemRead | MemWrite) & AluRes[0]);
endmodule
`default_nettype wire