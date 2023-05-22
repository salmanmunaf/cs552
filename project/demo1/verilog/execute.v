/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (read1Data, read2Data, PC_incr, signExtendedIns10, signExtendedImm, zeroExtendedImm,
                  AluSrc1, AluSrc2,
                  AluOp,
                  AluCin, AluInvA, AluInvB, Beq, Bne, Blt, Bgt, J, JAL, JR, JALR, Zero, Neg,
                  nextPC, AluRes, err);

   // TODO: Your code here
   parameter OPERAND_WIDTH = 16;
   input wire [OPERAND_WIDTH-1:0] read1Data, read2Data, PC_incr, signExtendedIns10, signExtendedImm, zeroExtendedImm;
   input wire [1:0] AluSrc1, AluSrc2;
   input wire [3:0] AluOp;
   input wire AluCin, AluInvA, AluInvB, Beq, Bne, Blt, Bgt, J, JAL, JR, JALR, Zero, Neg;
   output wire [OPERAND_WIDTH-1:0] nextPC, AluRes;
   output wire err;
   
   wire [OPERAND_WIDTH-1:0] InA, InB, shiftedRs, adderIn2, displacedPC;
   wire Branch, PC_add_Cout, Ofl, Cout;

   shifter rsShift (.In(read1Data), .ShAmt(4'b1000), .Oper(2'b01), .Out(shiftedRs));

   assign InA = AluSrc1[1] ? 16'b0000_0000_0000_0000 : (AluSrc1[0] ? shiftedRs : read1Data);
   assign InB = AluSrc2[1] ? (AluSrc2[0] ? 16'b0000_0000_0000_0000 : zeroExtendedImm) : (AluSrc2[0] ? signExtendedImm : read2Data);

   alu_full aluMod (.InA(InA), .InB(InB), .Cin(AluCin), .Oper(AluOp), .invA(AluInvA), .invB(AluInvB), .sign(1'b1), .Out(AluRes), .Zero(Zero), .Ofl(Ofl), .Cout(Cout), .Neg(Neg));
   
   branch_unit branchMod (.Out(Branch), .Beq(Beq), .Bne(Bne), .Blt(Blt), .Bgt(Bgt), .Zero(Zero), .Neg(Neg));

   assign adderIn2 = (J | JAL) ? signExtendedIns10 : signExtendedImm;

   cla_16b pc_add (.A(PC_incr), .B(adderIn2), .C_in(1'b0), .S(displacedPC), .C_out(PC_add_Cout), .err(err));

   assign nextPC = (Branch|J|JAL) ? displacedPC : ((JR|JALR) ? AluRes : PC_incr);

endmodule
`default_nettype wire