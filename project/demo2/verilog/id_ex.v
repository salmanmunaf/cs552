`default_nettype none
// TODO: Change writeEn 
module id_ex (read1Data, read2Data, writeRegSel,
            signExtendedImm, zeroExtendedImm, signExtendedIns10,
            if_id_PC_incr,
            DatatoReg, AluSrc1, AluSrc2,
            AluOp, Flush,
            Beq, Bne, Blt, Bgt, J, JR, JAL, JALR, Halt, memWR, MemRead, MemWrite, RegWrite, AluCin, AluInvA, AluInvB,
            clk, rst,
            id_ex_read1Data, id_ex_read2Data, id_ex_writeRegSel,
            id_ex_signExtendedImm, id_ex_zeroExtendedImm, id_ex_signExtendedIns10,
            id_ex_PC_incr,
            id_ex_DatatoReg, id_ex_AluSrc1, id_ex_AluSrc2,
            id_ex_AluOp,
            id_ex_Beq, id_ex_Bne, id_ex_Blt, id_ex_Bgt, id_ex_J, id_ex_JR, id_ex_JAL, id_ex_JALR,
            id_ex_Halt, id_ex_memWR, id_ex_MemRead, id_ex_MemWrite, id_ex_RegWrite, id_ex_AluCin,
            id_ex_AluInvA, id_ex_AluInvB);

    parameter OPERAND_WIDTH = 16;
    input wire clk, rst;
    input wire [OPERAND_WIDTH-1:0] read1Data, read2Data;
    input wire [OPERAND_WIDTH-1:0] signExtendedImm, zeroExtendedImm, signExtendedIns10;
    input wire [OPERAND_WIDTH-1:0] if_id_PC_incr;
    input wire [1:0] DatatoReg, AluSrc1, AluSrc2;
    input wire [3:0] AluOp;
    input wire [2:0] writeRegSel;
    input wire Flush, Beq, Bne, Blt, Bgt, J, JR, JAL, JALR, Halt, memWR, MemRead, MemWrite, RegWrite, AluCin, AluInvA, AluInvB;

    output wire [OPERAND_WIDTH-1:0] id_ex_read1Data, id_ex_read2Data;
    output wire [OPERAND_WIDTH-1:0] id_ex_signExtendedImm, id_ex_zeroExtendedImm, id_ex_signExtendedIns10;
    output wire [OPERAND_WIDTH-1:0] id_ex_PC_incr;
    output wire [1:0] id_ex_DatatoReg, id_ex_AluSrc1, id_ex_AluSrc2;
    output wire [3:0] id_ex_AluOp;
    output wire [2:0] id_ex_writeRegSel;
    output wire id_ex_Beq, id_ex_Bne, id_ex_Blt, id_ex_Bgt, id_ex_J, id_ex_JR, id_ex_JAL, id_ex_JALR;
    output wire id_ex_Halt, id_ex_memWR, id_ex_MemRead, id_ex_MemWrite, id_ex_RegWrite, id_ex_AluCin;
    output wire id_ex_AluInvA, id_ex_AluInvB;

    reg_16b read1Data_reg (.readData(id_ex_read1Data), .writeData(read1Data), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b read2Data_reg (.readData(id_ex_read2Data), .writeData(read2Data), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));

    reg_16b signExtendedImm_reg (.readData(id_ex_signExtendedImm), .writeData(signExtendedImm), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b zeroExtendedImm_reg (.readData(id_ex_zeroExtendedImm), .writeData(zeroExtendedImm), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b signExtendedIns10_reg (.readData(id_ex_signExtendedIns10), .writeData(signExtendedIns10), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));

    reg_16b PC_incr_reg (.readData(id_ex_PC_incr), .writeData(if_id_PC_incr), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(4)) AluOp_reg (.readData(id_ex_AluOp), .writeData(AluOp), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(3)) writeRegSel_reg (.readData(id_ex_writeRegSel), .writeData(writeRegSel), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(2)) DatatoReg_reg (.readData(id_ex_DatatoReg), .writeData(DatatoReg), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(2)) AluSrc1_reg (.readData(id_ex_AluSrc1), .writeData(AluSrc1), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(2)) AluSrc2_reg (.readData(id_ex_AluSrc2), .writeData(AluSrc2), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(1)) Beq_reg (.readData(id_ex_Beq), .writeData(Beq), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) Bne_reg (.readData(id_ex_Bne), .writeData(Bne), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) Blt_reg (.readData(id_ex_Blt), .writeData(Blt), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) Bgt_reg (.readData(id_ex_Bgt), .writeData(Bgt), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) J_reg (.readData(id_ex_J), .writeData(J), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) JR_reg (.readData(id_ex_JR), .writeData(JR), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) JAL_reg (.readData(id_ex_JAL), .writeData(JAL), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) JALR_reg (.readData(id_ex_JALR), .writeData(JALR), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) Halt_reg (.readData(id_ex_Halt), .writeData(Halt), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) memWR_reg (.readData(id_ex_memWR), .writeData(memWR), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) MemRead_reg (.readData(id_ex_MemRead), .writeData(MemRead), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) MemWrite_reg (.readData(id_ex_MemWrite), .writeData(MemWrite), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) RegWrite_reg (.readData(id_ex_RegWrite), .writeData(RegWrite), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) AluCin_reg (.readData(id_ex_AluCin), .writeData(AluCin), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) AluInvA_reg (.readData(id_ex_AluInvA), .writeData(AluInvA), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) AluInvB_reg (.readData(id_ex_AluInvB), .writeData(AluInvB), .clk(clk), .rst(rst|Flush), .writeEn(1'b1));

endmodule
`default_nettype wire