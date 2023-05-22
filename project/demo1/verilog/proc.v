/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   // input clk;
   // input rst;

   // output err;

   input wire clk;
   input wire rst;

   output wire err;

   parameter OPERAND_WIDTH = 16;
   wire [OPERAND_WIDTH-1:0] writeData, memDataOut, PC_incr, instruction, nextPC, read1Data, read2Data, signExtendedImm, zeroExtendedImm, signExtendedIns10, AluRes;
   wire Zero, Neg, Beq, Bne, Blt, Bgt, J, JR, JAL, JALR, Halt, memWR, MemRead, MemWrite, RegWrite, AluCin, AluInvA, AluInvB, decode_err, fetch_err, execute_err;
   wire [1:0] DatatoReg, AluSrc1, AluSrc2;
   wire [3:0] AluOp;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   fetch proc_fetch(.nextPC(nextPC), .clk(clk), .rst(rst), .Halt(Halt), .instruction(instruction), .PC_incr(PC_incr), .err(fetch_err));

   decode proc_decode (.instruction(instruction), .PC_incr(PC_incr), .writeData(writeData), 
               .clk(clk), .rst(rst), 
               .read1Data(read1Data), .read2Data(read2Data), 
               .signExtendedImm(signExtendedImm), .zeroExtendedImm(zeroExtendedImm), .signExtendedIns10(signExtendedIns10), 
               .DatatoReg(DatatoReg), .AluSrc1(AluSrc1), .AluSrc2(AluSrc2), 
               .AluOp(AluOp), 
               .Beq(Beq), .Bne(Bne), .Blt(Blt), .Bgt(Bgt), .J(J), .JR(JR), .JAL(JAL), .JALR(JALR), .Halt(Halt), .memWR(memWR), .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), .AluCin(AluCin), .AluInvA(AluInvA), .AluInvB(AluInvB), 
               .err(decode_err));

   execute proc_execute (.read1Data(read1Data), .read2Data(read2Data), .PC_incr(PC_incr), .signExtendedIns10(signExtendedIns10), .signExtendedImm(signExtendedImm), .zeroExtendedImm(zeroExtendedImm),
                  .AluSrc1(AluSrc1), .AluSrc2(AluSrc2),
                  .AluOp(AluOp),
                  .AluCin(AluCin), .AluInvA(AluInvA), .AluInvB(AluInvB), .Beq(Beq), .Bne(Bne), .Blt(Blt), .Bgt(Bgt), .J(J), .JAL(JAL), .JR(JR), .JALR(JALR), .Zero(Zero), .Neg(Neg),
                  .nextPC(nextPC), .AluRes(AluRes), .err(execute_err));

   memory proc_memory (.memDataOut(memDataOut),
               .memDataIn(read2Data), .AluRes(AluRes),
               .memWR(memWR), .MemRead(MemRead), .MemWrite(MemWrite), .Halt(Halt), .clk(clk), .rst(rst));

   wb proc_wb (.WB(writeData),
            .PC_incr(PC_incr), .memDataOut(memDataOut), .AluRes(AluRes), .DatatoReg(DatatoReg));

   assign err = decode_err | fetch_err | execute_err;
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
