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
   wire [2:0] Rs, Rt;
   wire [OPERAND_WIDTH-1:0] if_id_ins, if_id_PC_incr;

   wire [OPERAND_WIDTH-1:0] id_ex_read1Data, id_ex_read2Data;
   wire [OPERAND_WIDTH-1:0] id_ex_signExtendedImm, id_ex_zeroExtendedImm, id_ex_signExtendedIns10;
   wire [OPERAND_WIDTH-1:0] id_ex_PC_incr;
   wire [1:0] id_ex_DatatoReg, id_ex_AluSrc1, id_ex_AluSrc2;
   wire [3:0] id_ex_AluOp;
   wire id_ex_Beq, id_ex_Bne, id_ex_Blt, id_ex_Bgt, id_ex_J, id_ex_JR, id_ex_JAL, id_ex_JALR;
   wire id_ex_Halt, id_ex_memWR, id_ex_MemRead, id_ex_MemWrite, id_ex_RegWrite, id_ex_AluCin;
   wire id_ex_AluInvA, id_ex_AluInvB;
   wire [2:0] id_ex_Rs, id_ex_Rt; 
   wire [OPERAND_WIDTH-1:0] ex_mem_read2Data, ex_mem_AluRes;
   wire [OPERAND_WIDTH-1:0] ex_mem_PC_incr;
   wire [1:0] ex_mem_DatatoReg;

   wire ex_mem_memWR, ex_mem_MemRead, ex_mem_MemWrite, ex_mem_RegWrite, ex_mem_Halt, mem_wb_Halt, combined_Halt;

   wire [OPERAND_WIDTH-1:0] mem_wb_PC_incr, mem_wb_memDataOut, mem_wb_AluRes;
   wire mem_wb_RegWrite;
   wire [1:0] mem_wb_DatatoReg;
   wire [2:0] writeRegSel, id_ex_writeRegSel, ex_mem_writeRegSel, mem_wb_writeRegSel;

   wire Stall, contend_Stall, Flush, IsR, IsI1, IsI2, IsUnalignedFetch, IsUnalignedMem, HaltOrUnaligned, id_ex_HaltOrUnaligned, ex_mem_HaltOrUnaligned, DMemStall;
   wire fin_MemRead, fin_MemWrite, fin_RegWrite, fin_memWR, fin_Beq, fin_Bne, fin_Blt, fin_Bgt, fin_J, fin_JR, fin_JAL, fin_JALR;
   wire forward_ex_ex_Rs, forward_ex_ex_Rt, forward_mem_ex_Rs, forward_mem_ex_Rt;

   wire [OPERAND_WIDTH -1:0] forward_mem_ex_read1Data, forward_ex_ex_read1Data, forward_mem_ex_read2Data, forward_ex_ex_read2Data;
   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   // TODO: mux of nextPC and PC_incr
   assign combined_Halt = (~Flush) & (Halt | id_ex_Halt | ex_mem_Halt | mem_wb_Halt | IsUnalignedFetch | IsUnalignedMem);
   // TODO: fin_next_PC
   // assign fin_next_PC = Flush ? nextPC : PC_incr;
   assign contend_Stall = Flush ? 1'b0 : (Stall | DMemStall);
   fetch proc_fetch(.nextPC(nextPC), .clk(clk), .rst(rst), .Stall(contend_Stall), .Halt(combined_Halt), .Flush(Flush), .instruction(instruction), .PC_incr(PC_incr), .IsUnaligned(IsUnalignedFetch), .err(fetch_err));

   if_id proc_if_id(.instruction(instruction), .PC_incr(PC_incr),
            .clk(clk), .rst(rst), .Stall(contend_Stall), .Flush(Flush), .DMemStall(DMemStall),
            .if_id_ins(if_id_ins), .if_id_PC_incr(if_id_PC_incr));
   
   decode proc_decode (.instruction(if_id_ins), .PC_incr(if_id_PC_incr), .writeData(writeData), 
               .mem_wb_RegWrite(mem_wb_RegWrite), .mem_wb_writeRegSel(mem_wb_writeRegSel),
               .clk(clk), .rst(rst), .read1Data(read1Data), .read2Data(read2Data), .writeRegSel(writeRegSel),
               .signExtendedImm(signExtendedImm), .zeroExtendedImm(zeroExtendedImm), .signExtendedIns10(signExtendedIns10), 
               .DatatoReg(DatatoReg), .AluSrc1(AluSrc1), .AluSrc2(AluSrc2), .AluOp(AluOp), 
               .IsR(IsR), .IsI1(IsI1), .IsI2(IsI2), .Beq(Beq), .Bne(Bne), .Blt(Blt), .Bgt(Bgt), .J(J), .JR(JR), .JAL(JAL), .JALR(JALR), .Halt(Halt), 
               .memWR(memWR), .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), .AluCin(AluCin), .AluInvA(AluInvA), .AluInvB(AluInvB), 
               .err(decode_err), .Rs(Rs), .Rt(Rt));

   detect_hazard proc_detect_hazard (.instruction(if_id_ins), 
                     .id_ex_writeRegSel(id_ex_writeRegSel), .id_ex_RegWrite(id_ex_RegWrite), 
                     .ex_mem_writeRegSel(ex_mem_writeRegSel), .ex_mem_RegWrite(ex_mem_RegWrite), 
                     .id_ex_Rs(id_ex_Rs), .id_ex_Rt(id_ex_Rt), .id_ex_MemRead(id_ex_MemRead), .ex_mem_MemRead(ex_mem_MemRead), 
                     .mem_wb_writeRegSel(mem_wb_writeRegSel), .mem_wb_RegWrite(mem_wb_RegWrite), .forward_ex_ex_Rs(forward_ex_ex_Rs), 
                     .forward_ex_ex_Rt(forward_ex_ex_Rt), .forward_mem_ex_Rs(forward_mem_ex_Rs), .forward_mem_ex_Rt(forward_mem_ex_Rt), .Stall(Stall));
   
      // Forwarding Logic
      assign forward_mem_ex_read1Data = forward_mem_ex_Rs ? writeData : id_ex_read1Data;
      assign forward_ex_ex_read1Data = forward_ex_ex_Rs ? ex_mem_AluRes : forward_mem_ex_read1Data;
      assign forward_mem_ex_read2Data = forward_mem_ex_Rt ? writeData : id_ex_read2Data;
      assign forward_ex_ex_read2Data = forward_ex_ex_Rt ? ex_mem_AluRes : forward_mem_ex_read2Data;
        
   //TODO: place this appropriately
   assign fin_MemRead = contend_Stall ? 1'b0 : MemRead;
   assign fin_MemWrite = contend_Stall ? 1'b0 : MemWrite;
   assign fin_RegWrite = contend_Stall ? 1'b0 : RegWrite;
   assign fin_memWR = contend_Stall ? 1'b0 : memWR;
   assign fin_Beq = contend_Stall ? 1'b0 : Beq;
   assign fin_Bne = contend_Stall ? 1'b0 : Bne;
   assign fin_Blt = contend_Stall ? 1'b0 : Blt;
   assign fin_Bgt = contend_Stall ? 1'b0 : Bgt;
   assign fin_J = contend_Stall ? 1'b0 : J;
   assign fin_JR = contend_Stall ? 1'b0 : JR;
   assign fin_JAL = contend_Stall ? 1'b0 : JAL;
   assign fin_JALR = contend_Stall ? 1'b0 : JALR;
   assign HaltOrUnaligned = Halt | IsUnalignedFetch | IsUnalignedMem;

   id_ex proc_id_ex(.read1Data(read1Data), .read2Data(read2Data), .writeRegSel(writeRegSel),
            .signExtendedImm(signExtendedImm), .zeroExtendedImm(zeroExtendedImm), .signExtendedIns10(signExtendedIns10),
            .if_id_PC_incr(if_id_PC_incr),
            .DatatoReg(DatatoReg), .AluSrc1(AluSrc1), .AluSrc2(AluSrc2),
            .AluOp(AluOp), .Flush(Flush), .DMemStall(DMemStall),
            .Beq(fin_Beq), .Bne(fin_Bne), .Blt(fin_Blt), .Bgt(fin_Bgt), .J(fin_J), .JR(fin_JR), .JAL(fin_JAL), .JALR(fin_JALR), .Halt(HaltOrUnaligned), .memWR(fin_memWR), .MemRead(fin_MemRead), .MemWrite(fin_MemWrite), .RegWrite(fin_RegWrite), .AluCin(AluCin), .AluInvA(AluInvA), .AluInvB(AluInvB),
            .clk(clk), .rst(rst),
            .id_ex_read1Data(id_ex_read1Data), .id_ex_read2Data(id_ex_read2Data), .id_ex_writeRegSel(id_ex_writeRegSel),
            .id_ex_signExtendedImm(id_ex_signExtendedImm), .id_ex_zeroExtendedImm(id_ex_zeroExtendedImm), .id_ex_signExtendedIns10(id_ex_signExtendedIns10),
            .id_ex_PC_incr(id_ex_PC_incr),
            .id_ex_DatatoReg(id_ex_DatatoReg), .id_ex_AluSrc1(id_ex_AluSrc1), .id_ex_AluSrc2(id_ex_AluSrc2),
            .id_ex_AluOp(id_ex_AluOp),
            .id_ex_Beq(id_ex_Beq), .id_ex_Bne(id_ex_Bne), .id_ex_Blt(id_ex_Blt), .id_ex_Bgt(id_ex_Bgt), .id_ex_J(id_ex_J), .id_ex_JR(id_ex_JR), .id_ex_JAL(id_ex_JAL), .id_ex_JALR(id_ex_JALR),
            .id_ex_Halt(id_ex_Halt), .id_ex_memWR(id_ex_memWR), .id_ex_MemRead(id_ex_MemRead), .id_ex_MemWrite(id_ex_MemWrite), .id_ex_RegWrite(id_ex_RegWrite), .id_ex_AluCin(id_ex_AluCin),
            .id_ex_AluInvA(id_ex_AluInvA), .id_ex_AluInvB(id_ex_AluInvB), .Rs(Rs), .Rt(Rt), .id_ex_Rs(id_ex_Rs), .id_ex_Rt(id_ex_Rt));

   execute proc_execute (.read1Data(forward_ex_ex_read1Data), .read2Data(forward_ex_ex_read2Data), .PC_incr(id_ex_PC_incr), .signExtendedIns10(id_ex_signExtendedIns10), .signExtendedImm(id_ex_signExtendedImm), .zeroExtendedImm(id_ex_zeroExtendedImm),
                  .AluSrc1(id_ex_AluSrc1), .AluSrc2(id_ex_AluSrc2),
                  .AluOp(id_ex_AluOp),
                  .AluCin(id_ex_AluCin), .AluInvA(id_ex_AluInvA), .AluInvB(id_ex_AluInvB), .Beq(id_ex_Beq), .Bne(id_ex_Bne), .Blt(id_ex_Blt), .Bgt(id_ex_Bgt), .J(id_ex_J), .JAL(id_ex_JAL), .JR(id_ex_JR), .JALR(id_ex_JALR),
                  .nextPC(nextPC), .AluRes(AluRes), .Flush(Flush), .err(execute_err));

   assign id_ex_HaltOrUnaligned = id_ex_Halt | IsUnalignedMem;
   
   ex_mem proc_ex_mem (.id_ex_read2Data(forward_ex_ex_read2Data), .AluRes(AluRes), .DMemStall(DMemStall),
               .id_ex_PC_incr(id_ex_PC_incr),
               .id_ex_DatatoReg(id_ex_DatatoReg),
               .id_ex_writeRegSel(id_ex_writeRegSel),
               .id_ex_memWR(id_ex_memWR), .id_ex_MemRead(id_ex_MemRead), .id_ex_MemWrite(id_ex_MemWrite), .id_ex_RegWrite(id_ex_RegWrite), .id_ex_Halt(id_ex_HaltOrUnaligned),
               .clk(clk), .rst(rst),
               .ex_mem_read2Data(ex_mem_read2Data), .ex_mem_AluRes(ex_mem_AluRes),
               .ex_mem_PC_incr(ex_mem_PC_incr),
               .ex_mem_DatatoReg(ex_mem_DatatoReg),
               .ex_mem_writeRegSel(ex_mem_writeRegSel),
               .ex_mem_memWR(ex_mem_memWR), .ex_mem_MemRead(ex_mem_MemRead), .ex_mem_MemWrite(ex_mem_MemWrite), .ex_mem_RegWrite(ex_mem_RegWrite), .ex_mem_Halt(ex_mem_Halt));

   memory proc_memory (.memDataOut(memDataOut), .IsUnaligned(IsUnalignedMem), .DMemStall(DMemStall),
               .memDataIn(ex_mem_read2Data), .AluRes(ex_mem_AluRes),
               .memWR(ex_mem_memWR), .MemRead(ex_mem_MemRead), .MemWrite(ex_mem_MemWrite), .Halt(ex_mem_Halt), .clk(clk), .rst(rst));

   assign ex_mem_HaltOrUnaligned = ex_mem_Halt | IsUnalignedMem;

   mem_wb proc_mem_wb (.ex_mem_PC_incr(ex_mem_PC_incr), .memDataOut(memDataOut), .ex_mem_AluRes(ex_mem_AluRes), .DMemStall(DMemStall),
               .ex_mem_DatatoReg(ex_mem_DatatoReg), .ex_mem_writeRegSel(ex_mem_writeRegSel), .ex_mem_RegWrite(ex_mem_RegWrite), .ex_mem_Halt(ex_mem_HaltOrUnaligned),
               .clk(clk), .rst(rst),
               .mem_wb_PC_incr(mem_wb_PC_incr), .mem_wb_memDataOut(mem_wb_memDataOut), .mem_wb_AluRes(mem_wb_AluRes),
               .mem_wb_DatatoReg(mem_wb_DatatoReg), .mem_wb_writeRegSel(mem_wb_writeRegSel), .mem_wb_RegWrite(mem_wb_RegWrite), .mem_wb_Halt(mem_wb_Halt));

   wb proc_wb (.WB(writeData),
            .PC_incr(mem_wb_PC_incr), .memDataOut(mem_wb_memDataOut), .AluRes(mem_wb_AluRes), .DatatoReg(mem_wb_DatatoReg));

   assign err = decode_err | fetch_err | execute_err;
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
