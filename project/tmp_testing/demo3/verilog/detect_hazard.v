`default_nettype none
// check PC_incr
module detect_hazard (instruction,
                    id_ex_writeRegSel, id_ex_RegWrite,
                    ex_mem_writeRegSel, ex_mem_RegWrite,
                    id_ex_Rs, id_ex_Rt, id_ex_MemRead, ex_mem_MemRead, mem_wb_writeRegSel, mem_wb_RegWrite,
                    forward_ex_ex_Rs, forward_ex_ex_Rt, forward_mem_ex_Rs, forward_mem_ex_Rt, Stall);

    parameter OPERAND_WIDTH = 16;
    input wire [OPERAND_WIDTH-1:0] instruction;
    input wire [2:0] id_ex_writeRegSel, ex_mem_writeRegSel, mem_wb_writeRegSel, id_ex_Rs, id_ex_Rt;
    input wire id_ex_RegWrite, ex_mem_RegWrite, mem_wb_RegWrite, id_ex_MemRead, ex_mem_MemRead;
    output wire forward_ex_ex_Rs, forward_ex_ex_Rt, forward_mem_ex_Rs, forward_mem_ex_Rt;
    output wire Stall;

    assign Stall = ((instruction[10:8] == id_ex_writeRegSel) & id_ex_RegWrite & id_ex_MemRead) | ((instruction[7:5] == id_ex_writeRegSel) & 
                    id_ex_RegWrite & id_ex_MemRead);

   // Forwarding Logic:
     // ex_mem_Rs
     assign forward_ex_ex_Rs = (ex_mem_RegWrite & (ex_mem_writeRegSel == id_ex_Rs) & !(ex_mem_MemRead));

     // ex_mem_Rt
     assign forward_ex_ex_Rt = (ex_mem_RegWrite & (ex_mem_writeRegSel == id_ex_Rt) & !(ex_mem_MemRead));

     // mem_wb_Rs
     assign forward_mem_ex_Rs = (mem_wb_RegWrite & (mem_wb_writeRegSel == id_ex_Rs));

     // mem_wb_Rt
     assign forward_mem_ex_Rt = (mem_wb_RegWrite & (mem_wb_writeRegSel == id_ex_Rt));
endmodule
`default_nettype wire