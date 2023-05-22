`default_nettype none
// TODO: Change writeEn 
module ex_mem (id_ex_read2Data, AluRes,
                id_ex_PC_incr,
                id_ex_DatatoReg,
                id_ex_writeRegSel,
                id_ex_memWR, id_ex_MemRead, id_ex_MemWrite, id_ex_RegWrite, id_ex_Halt,
                clk, rst,
                ex_mem_read2Data, ex_mem_AluRes,
                ex_mem_PC_incr,
                ex_mem_DatatoReg,
                ex_mem_writeRegSel,
                ex_mem_memWR, ex_mem_MemRead, ex_mem_MemWrite, ex_mem_RegWrite, ex_mem_Halt);

    parameter OPERAND_WIDTH = 16;
    input wire clk, rst;
    input wire [OPERAND_WIDTH-1:0] id_ex_read2Data, AluRes;
    input wire [OPERAND_WIDTH-1:0] id_ex_PC_incr;
    input wire [1:0] id_ex_DatatoReg;
    input wire [2:0] id_ex_writeRegSel;
    input wire id_ex_memWR, id_ex_MemRead, id_ex_MemWrite, id_ex_RegWrite, id_ex_Halt;

    output wire [OPERAND_WIDTH-1:0] ex_mem_read2Data, ex_mem_AluRes;
    output wire [OPERAND_WIDTH-1:0] ex_mem_PC_incr;
    output wire [1:0] ex_mem_DatatoReg;
    output wire [2:0] ex_mem_writeRegSel;
    output wire ex_mem_memWR, ex_mem_MemRead, ex_mem_MemWrite, ex_mem_RegWrite, ex_mem_Halt;

    reg_16b read2Data_reg (.readData(ex_mem_read2Data), .writeData(id_ex_read2Data), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b AluRes_reg (.readData(ex_mem_AluRes), .writeData(AluRes), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b PC_incr_reg (.readData(ex_mem_PC_incr), .writeData(id_ex_PC_incr), .clk(clk), .rst(rst), .writeEn(1'b1));
    // reg_16b nextPC_reg (.readData(ex_mem_nextPC), .writeData(nextPC), .clk(clk), .rst(rst), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(2)) DatatoReg_reg (.readData(ex_mem_DatatoReg), .writeData(id_ex_DatatoReg), .clk(clk), .rst(rst), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(3)) writeRegSel_reg (.readData(ex_mem_writeRegSel), .writeData(id_ex_writeRegSel), .clk(clk), .rst(rst), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(1)) memWR_reg (.readData(ex_mem_memWR), .writeData(id_ex_memWR), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) MemRead_reg (.readData(ex_mem_MemRead), .writeData(id_ex_MemRead), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) MemWrite_reg (.readData(ex_mem_MemWrite), .writeData(id_ex_MemWrite), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) RegWrite_reg (.readData(ex_mem_RegWrite), .writeData(id_ex_RegWrite), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) Halt_reg (.readData(ex_mem_Halt), .writeData(id_ex_Halt), .clk(clk), .rst(rst), .writeEn(1'b1));

endmodule
`default_nettype wire