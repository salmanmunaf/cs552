/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (WB,
            PC_incr, memDataOut, AluRes, DatatoReg);

   parameter OPERAND_WIDTH = 16;
   output wire [OPERAND_WIDTH-1:0] WB;
   input wire [OPERAND_WIDTH-1:0] PC_incr, memDataOut, AluRes;
   input wire [1:0] DatatoReg;

   // TODO: Your code here

   assign WB = DatatoReg[1] ? PC_incr : (DatatoReg[0] ? memDataOut : AluRes);
   
endmodule
`default_nettype wire