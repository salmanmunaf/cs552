/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (nextPC, clk, rst, Halt, instruction, PC_incr, err);

   parameter INSTRUCTION_SIZE = 16;
   
   input wire Halt, clk, rst;
   input wire [INSTRUCTION_SIZE-1:0] nextPC;
   output wire [INSTRUCTION_SIZE-1:0] instruction, PC_incr;
   output wire err;
   wire [INSTRUCTION_SIZE-1:0] currPC, two;
   wire PC_add_Cout;

   // TODO: Your code here
   // writeEn should be set to ~halt?
   reg_16b pc_reg (.readData(currPC), .writeData(nextPC), .clk(clk), .rst(rst), .writeEn(~Halt));

   //TODO: confirm enable, createdump and wr signals
   // enable in case of stall will be 0
   memory2c instr_mem (.data_out(instruction), .data_in(16'b0), .addr(currPC), .enable(1'b1), .wr(1'b0), .createdump(Halt), .clk(clk), .rst(rst));

   assign two = 16'b0000_0000_0000_0010;
   cla_16b pc_add_2 (.A(currPC), .B(two), .C_in(1'b0), .S(PC_incr), .C_out(PC_add_Cout), .err(err));
   
endmodule
`default_nettype wire