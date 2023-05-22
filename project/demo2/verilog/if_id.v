`default_nettype none
// TODO: Change writeEn 
module if_id (instruction, PC_incr,
            clk, rst, Stall, Flush,
            if_id_ins, if_id_PC_incr);
    parameter INSTRUCTION_SIZE = 16;
    input wire clk, rst, Stall, Flush;
    input wire [INSTRUCTION_SIZE-1:0] instruction, PC_incr;
    output wire [INSTRUCTION_SIZE-1:0] if_id_ins, if_id_PC_incr;
    wire [INSTRUCTION_SIZE-1:0] inter_ins;

    //TODO: check rst flag for ins_reg
    // assign inter_ins = (rst == 1'b1) ? 16'b0000_1000_0000_0000 : ((Halt == 1'b1) ? 16'b0000_0000_0000_0000 : instruction);
    // (Halt == 1'b1) ? 16'b0000_0000_0000_0000 : (rst == 1'b1 ? 16'b0000_1000_0000_0000 : instruction);
    assign inter_ins = Flush ? 16'b0000_1000_0000_0000 : instruction;

    reg_16b ins_reg (.readData(if_id_ins), .writeData(inter_ins), .clk(clk), .rst(1'b0), .writeEn(~Stall));
    reg_16b pc_incr_reg (.readData(if_id_PC_incr), .writeData(PC_incr), .clk(clk), .rst(rst|Flush), .writeEn(~Stall));

endmodule
`default_nettype wire