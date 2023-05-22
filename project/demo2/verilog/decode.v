/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
// check PC_incr not being used
module decode (instruction, PC_incr, writeData, 
               mem_wb_RegWrite, mem_wb_writeRegSel,
               clk, rst, 
               read1Data, read2Data, writeRegSel,
               signExtendedImm, zeroExtendedImm, signExtendedIns10, 
               DatatoReg, AluSrc1, AluSrc2, 
               AluOp, 
               IsR, IsI1, IsI2, Beq, Bne, Blt, Bgt, J, JR, JAL, JALR, Halt, memWR, MemRead, MemWrite, RegWrite, AluCin, AluInvA, AluInvB, 
               err);

   // TODO: Your code here

   parameter OPERAND_WIDTH = 16;
   input wire clk, rst;
   input wire [OPERAND_WIDTH-1:0] instruction, PC_incr, writeData;
   input wire mem_wb_RegWrite;
   output wire [OPERAND_WIDTH-1:0] read1Data, read2Data; // add control signals
   output wire [OPERAND_WIDTH-1:0] signExtendedImm, zeroExtendedImm, signExtendedIns10;
   output wire [1:0] DatatoReg, AluSrc1, AluSrc2;
   output wire [3:0] AluOp;
   output wire IsR, IsI1, IsI2, Beq, Bne, Blt, Bgt, J, JR, JAL, JALR, Halt, memWR, MemRead, MemWrite, RegWrite, AluCin, AluInvA, AluInvB;
   output wire err;
   
   wire control_err, reg_err;
   wire [1:0] RegDst;
  
   output wire [2:0] writeRegSel;
   input wire [2:0] mem_wb_writeRegSel;
   wire [OPERAND_WIDTH-1:0] signExtendedIns4, signExtendedIns7, zeroExtendedIns4, zeroExtendedIns7;

   control controlMod (.Opcode(instruction[15:11]), .func(instruction[1:0]), .err(control_err), .Beq(Beq), .Bne(Bne), .Blt(Blt), .Bgt(Bgt), .J(J), .JR(JR), .JAL(JAL), .JALR(JALR), .Halt(Halt), .IsR(IsR), .IsI1(IsI1), .IsI2(IsI2), .memWR(memWR), .MemRead(MemRead), .MemWrite(MemWrite), .RegWrite(RegWrite), .AluCin(AluCin), .AluInvA(AluInvA), .AluInvB(AluInvB), .RegDst(RegDst), .DatatoReg(DatatoReg), .AluSrc1(AluSrc1), .AluSrc2(AluSrc2), .AluOp(AluOp));

   // mux4_1 writeSelMux (.out(writeRegSel), .inA(instruction[7:5]), .inB(instruction[4:2]), .inC(instruction[10:8]), .inD(3'b111), .s(RegDst));
   assign writeRegSel = RegDst[1] ? (RegDst[0] ? 3'b111 : instruction[10:8]) : (RegDst[0] ? instruction[4:2] : instruction[7:5]);
   // assign read1RegSel = instruction[10:8];
   // assign read2RegSel = instruction[7:5];

   regFile_bypass registerFile (.read1Data(read1Data), .read2Data(read2Data), .err(reg_err), .clk(clk), .rst(rst), .read1RegSel(instruction[10:8]), .read2RegSel(instruction[7:5]), .writeRegSel(mem_wb_writeRegSel), .writeData(writeData), .writeEn(mem_wb_RegWrite));
   
   assign signExtendedIns4 = { {11{instruction[4]}}, instruction[4:0] };
   assign signExtendedIns7 = { {8{instruction[7]}}, instruction[7:0] };
   assign zeroExtendedIns4 = { 11'b0000_0000_000, instruction[4:0] };
   assign zeroExtendedIns7 = { 8'b0000_0000, instruction[7:0] };
   assign signExtendedIns10 = { {5{instruction[10]}}, instruction[10:0] };
   
   assign signExtendedImm = IsI2 ? signExtendedIns7 : signExtendedIns4;
   assign zeroExtendedImm = IsI2 ? zeroExtendedIns7 : zeroExtendedIns4;

   assign err = reg_err | control_err;
   
endmodule
`default_nettype wire