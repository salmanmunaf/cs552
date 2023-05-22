`default_nettype none
// check PC_incr
module detect_hazard (instruction,
                    id_ex_writeRegSel, id_ex_RegWrite,
                    ex_mem_writeRegSel, ex_mem_RegWrite,
                    IsR, IsI1, IsI2,
                    Stall);

    parameter OPERAND_WIDTH = 16;
    input wire [OPERAND_WIDTH-1:0] instruction;
    input wire [2:0] id_ex_writeRegSel, ex_mem_writeRegSel;
    input wire id_ex_RegWrite, ex_mem_RegWrite, IsR, IsI1, IsI2;
    output wire Stall;

    assign Stall = (((instruction[10:8] == id_ex_writeRegSel) & id_ex_RegWrite & (IsR | IsI1 | IsI2)) | ((instruction[7:5] == id_ex_writeRegSel) & id_ex_RegWrite & IsR) |
    ((instruction[10:8] == ex_mem_writeRegSel) & ex_mem_RegWrite & (IsR | IsI1 | IsI2)) | ((instruction[7:5] == ex_mem_writeRegSel) & ex_mem_RegWrite & IsR));

endmodule
`default_nettype wire