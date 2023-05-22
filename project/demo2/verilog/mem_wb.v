`default_nettype none
// TODO: Change writeEn 
module mem_wb (ex_mem_PC_incr, memDataOut, ex_mem_AluRes,
                ex_mem_DatatoReg, ex_mem_writeRegSel, ex_mem_RegWrite,
                ex_mem_Halt,
                clk, rst,
                mem_wb_PC_incr, mem_wb_memDataOut, mem_wb_AluRes,
                mem_wb_DatatoReg, mem_wb_writeRegSel, mem_wb_RegWrite, mem_wb_Halt);

    parameter OPERAND_WIDTH = 16;
    input wire clk, rst;
    input wire [OPERAND_WIDTH-1:0] ex_mem_PC_incr, memDataOut, ex_mem_AluRes;
    input wire [1:0] ex_mem_DatatoReg;
    input wire [2:0] ex_mem_writeRegSel;
    input wire ex_mem_RegWrite;
    input wire ex_mem_Halt;

    output wire [OPERAND_WIDTH-1:0] mem_wb_PC_incr, mem_wb_memDataOut, mem_wb_AluRes;
    output wire [1:0] mem_wb_DatatoReg;
    output wire [2:0] mem_wb_writeRegSel;
    output wire mem_wb_RegWrite;
    output wire mem_wb_Halt;

    reg_16b PC_incr_reg (.readData(mem_wb_PC_incr), .writeData(ex_mem_PC_incr), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b memDataOut_reg (.readData(mem_wb_memDataOut), .writeData(memDataOut), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b AluRes_reg (.readData(mem_wb_AluRes), .writeData(ex_mem_AluRes), .clk(clk), .rst(rst), .writeEn(1'b1));
    // reg_16b nextPC_reg (.readData(mem_wb_nextPC), .writeData(ex_mem_nextPC), .clk(clk), .rst(rst), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(2)) DatatoReg_reg (.readData(mem_wb_DatatoReg), .writeData(ex_mem_DatatoReg), .clk(clk), .rst(rst), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(3)) writeRegSel_reg (.readData(mem_wb_writeRegSel), .writeData(ex_mem_writeRegSel), .clk(clk), .rst(rst), .writeEn(1'b1));

    reg_16b #(.REG_SIZE(1)) RegWrite_reg (.readData(mem_wb_RegWrite), .writeData(ex_mem_RegWrite), .clk(clk), .rst(rst), .writeEn(1'b1));
    reg_16b #(.REG_SIZE(1)) Halt_reg (.readData(mem_wb_Halt), .writeData(ex_mem_Halt), .clk(clk), .rst(rst), .writeEn(1'b1));

endmodule
`default_nettype wire