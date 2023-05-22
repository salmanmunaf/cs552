/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (nextPC, clk, rst, Stall, Halt, Flush, instruction, PC_incr, IsUnaligned, err);

   parameter INSTRUCTION_SIZE = 16;

   input wire Stall, Halt, Flush, clk, rst;
   input wire [INSTRUCTION_SIZE-1:0] nextPC;
   output wire [INSTRUCTION_SIZE-1:0] instruction, PC_incr;
   output wire IsUnaligned, err;
   wire [INSTRUCTION_SIZE-1:0] currPC, fin_next_PC, savedNextPC, two, inter_ins;
   wire adder_err, PC_add_Cout, IMemStall, Done, CacheHit, savedFlush;

   // TODO: Your code here
   // writeEn should be set to ~halt?
   // assign writePC = Halt ? currPC : nextPC;
   reg_16b #(.REG_SIZE(1)) flush_reg (.readData(savedFlush), .writeData(Flush), .clk(clk), .rst(rst | Done), .writeEn(IMemStall & Flush));
   reg_16b nextPC_reg (.readData(savedNextPC), .writeData(nextPC), .clk(clk), .rst(rst | Done), .writeEn(IMemStall & Flush));

   assign fin_next_PC = (Done & savedFlush) ? savedNextPC : (Flush ? nextPC : PC_incr);

/**/
   // wire fetchWriteEn;
   // wire [15:0] AddrOut_FSM;
   // assign fetchWriteEn = Halt ? 1'b0 :
   //                              Stall ? 1'b0 : Done;
                                        /*Done ? 1'b1 :
                                               ~IMemStall;&/
/**/
   reg_16b pc_reg (.readData(currPC), .writeData(fin_next_PC), .clk(clk), .rst(rst), .writeEn(~Halt & ~Stall & ~IMemStall/*fetchWriteEn*/));

   //TODO: confirm enable, createdump and wr signals
   // enable in case of stall will be 0
   // stallmem instr_mem (.DataOut(inter_ins), .Done(Done), .Stall(IMemStall), .CacheHit(CacheHit), .err(IsUnaligned), .Addr(currPC), .DataIn(16'b0), .Rd(1'b1), .Wr(1'b0), .createdump(Halt), .clk(clk), .rst(rst));
   mem_system #(0) instr_mem (.DataOut(inter_ins), .Done(Done), .Stall(IMemStall), .CacheHit(CacheHit), .err(IsUnaligned), .Addr(currPC), .DataIn(16'b0), .Rd(1'b1), .Wr(1'b0), .createdump(Halt), .clk(clk), .rst(rst));
   // memory2c_align instr_mem (.data_out(inter_ins), .data_in(16'b0), .addr(currPC), .enable(1'b1), .wr(1'b0), .createdump(Halt), .clk(clk), .rst(rst), .err(IsUnaligned));
   assign instruction = (rst | Halt | ~Done | (Done & savedFlush) /*| (AddrOut_FSM != currPC)*/) ? 16'b0000_1000_0000_0000 : inter_ins;

   assign two = 16'b0000_0000_0000_0010;
   cla_16b pc_add_2 (.A(currPC), .B(two), .C_in(1'b0), .S(PC_incr), .C_out(PC_add_Cout), .err(err));

   // assign err = adder_err | IsUnaligned;
   
endmodule
`default_nettype wire