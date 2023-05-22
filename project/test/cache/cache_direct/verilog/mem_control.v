`define IDLE 0
`define COMPARE_READ 1
`define COMPARE_WRITE 2
`define WB_0 3
`define WB_1 4
`define WB_2 5
`define WB_3 6
`define ALLOC_0 7
`define ALLOC_1 8
`define ALLOC_2 9
`define ALLOC_3 10
`define ALLOC_4 11
`define ALLOC_5 12

`default_nettype none
module mem_control(Rd, Wr, address, hit, dirty, valid, 
                cache_data_out, tag_out, data_in_mem, proc_data_in,
                clk, rst,
                //Outputs
                enable, comp, write, tag_in, cache_data_in, valid_in, offset_in,
                Done, mem_addr, mem_data, mem_wr, mem_rd, proc_data_out, proc_stall, CacheHit, Error);
    
    input wire clk, rst, Rd, Wr, hit, dirty, valid;
    input wire [15:0] address, cache_data_out, data_in_mem, proc_data_in;
    input wire [4:0] tag_out;

    output reg enable, comp, write, valid_in, Done, mem_wr, mem_rd, Error;
    output reg [15:0] mem_addr, mem_data, cache_data_in;
    output reg [4:0] tag_in;
    output reg [2:0] offset_in;
    output reg [15:0] proc_data_out;
    output reg proc_stall;
    output reg CacheHit;

    wire [3:0] state;
    reg [3:0] next_state;
    reg [15:0] address_reg, proc_data_in_reg, data_out_reg;
    reg rd_reg, wr_reg, hit_reg, dirty_reg;
    reg [4:0] tag_in_reg;

    wire [4:0] tag;
    wire [7:0] index;
    wire [2:0] offset;

    assign tag = address_reg[15:11];
    assign index = address_reg[10:3];
    assign offset = address_reg[2:0];

    always @(*) begin
        valid_in = 1'b0;
        mem_wr = 1'b0; 
        mem_rd = 1'b0;
        Error = 1'b0;
        enable = 1'b0;
        comp = 1'b0;
        write = 1'b0;
        Done = 1'b0;
        proc_stall = 1'b0;
        CacheHit = 1'b0;

        casex(state)
            `IDLE: begin
                rd_reg = Rd;
                wr_reg = Wr;
                next_state = Rd ? `COMPARE_READ : (Wr ? `COMPARE_WRITE : `IDLE);
            end
            `COMPARE_READ: begin
                comp = 1'b1;
                write = 1'b0;
                enable = 1'b1;
                tag_in = tag;
                offset_in = offset;
                valid_in = 1'b1;
                cache_data_in = 1'b0;

                proc_data_in_reg = proc_data_in;
                address_reg = address;
                dirty_reg = dirty;
                data_out_reg = cache_data_out;
                tag_in_reg = tag_out;

                proc_stall = 1'b1;
                CacheHit = (hit & valid);
                proc_data_out = (CacheHit) ? cache_data_out : 16'bxxxx_xxxx_xxxx_xxxx;
                Done = (CacheHit) ? 1'b1 : 1'b0;
                next_state = (CacheHit) ? `IDLE : ((~hit & valid & dirty) ? `WB_0 : 
                                    ((~dirty & ~CacheHit) ? `ALLOC_0 : `COMPARE_READ));
            end
            `COMPARE_WRITE: begin
                comp = 1'b1;
                write = 1'b1;
                enable = 1'b1;
                tag_in = tag;
                offset_in = offset;
                valid_in = 1'b1;
                cache_data_in = proc_data_in;

                proc_data_in_reg = proc_data_in;
                address_reg = address;
                dirty_reg = dirty;
                data_out_reg = cache_data_out;
                tag_in_reg = tag_out;

                proc_stall = 1'b1;
                CacheHit = (hit & valid);
                proc_data_out = (CacheHit) ? cache_data_out : 16'bxxxx_xxxx_xxxx_xxxx;
                Done = (CacheHit) ? 1'b1 : 1'b0;
                next_state = (CacheHit) ? `IDLE : ((~hit & valid & dirty) ? `WB_0 : 
                                    ((~dirty & ~CacheHit) ? `ALLOC_0 : `COMPARE_WRITE));
            end
            `WB_0: begin
                mem_wr = 1'b1;
                mem_rd = 1'b0;
                mem_addr = {tag_in_reg, index, 3'b000};
                mem_data = cache_data_out;
                proc_stall = 1'b1;

                enable = 1'b1;
                write = 1'b0;
                comp = 1'b1;
                tag_in = tag_in_reg;
                offset_in = 3'b000;
                valid_in = 1'b1;
                next_state = `WB_1;
            end
            `WB_1: begin
                mem_wr = 1'b1;
                mem_rd = 1'b0;
                mem_addr = {tag_in_reg, index, 3'b010};
                mem_data = cache_data_out;
                proc_stall = 1'b1;

                enable = 1'b1;
                write = 1'b0;
                comp = 1'b1;
                tag_in = tag_in_reg;
                offset_in = 3'b010;
                valid_in = 1'b1;
                next_state = `WB_2;
            end
            `WB_2: begin
                mem_wr = 1'b1;
                mem_rd = 1'b0;
                mem_addr = {tag_in_reg, index, 3'b100};
                mem_data = cache_data_out;
                proc_stall = 1'b1;

                enable = 1'b1;
                write = 1'b0;
                comp = 1'b1;
                tag_in = tag_in_reg;
                offset_in = 3'b100;
                valid_in = 1'b1;
                next_state = `WB_3;
            end
            `WB_3: begin
                mem_wr = 1'b1;
                mem_rd = 1'b0;
                mem_addr = {tag_in_reg, index, 3'b110};
                mem_data = cache_data_out;
                proc_stall = 1'b1;

                enable = 1'b1;
                write = 1'b0;
                comp = 1'b1;
                tag_in = tag_in_reg;
                offset_in = 3'b110;
                valid_in = 1'b1;
                next_state = `ALLOC_0;
            end
            `ALLOC_0: begin
                mem_wr = wr_reg & (offset == 3'b000);
                mem_rd = rd_reg | (wr_reg & (offset != 3'b000));
                mem_addr = {address_reg[15:3], 3'b000}; 
                mem_data = proc_data_in_reg;
                proc_stall = 1'b1;

                enable = 1'b0;
                write = 1'b0;
                comp = 1'b0;
                next_state = `ALLOC_1;
            end
            `ALLOC_1: begin
                mem_wr = wr_reg & (offset == 3'b010);
                mem_rd = rd_reg | (wr_reg & (offset != 3'b010));
                mem_addr = {address_reg[15:3], 3'b010};
                mem_data = proc_data_in_reg;
                proc_stall = 1'b1;

                enable = 1'b0;
                write = 1'b0;
                comp = 1'b0;
                next_state = `ALLOC_2;
            end
            `ALLOC_2: begin
                mem_wr = wr_reg & (offset == 3'b100);
                mem_rd = rd_reg | (wr_reg & (offset != 3'b100));
                mem_addr = {address_reg[15:3], 3'b100};
                mem_data = proc_data_in_reg;

                comp = 1'b0;
                write = 1'b1;
                tag_in = tag;
                cache_data_in = rd_reg | (wr_reg & offset != 3'b000) ? data_in_mem : proc_data_in;
                valid_in = 1'b1;
                enable = 1'b1;
                offset_in = 3'b000;

                proc_stall = 1'b1;
                proc_data_out = (offset == 3'b000) ? data_in_mem : 16'bxxxx_xxxx_xxxx_xxxx;
                Done = (offset == 3'b000) ? 1'b1 : 1'b0;
                next_state = `ALLOC_3;
            end
            `ALLOC_3: begin
                mem_wr = wr_reg & (offset == 3'b110);
                mem_rd = rd_reg | (wr_reg & (offset != 3'b110));
                mem_addr = {address_reg[15:3], 3'b110};
                mem_data = proc_data_in_reg;

                comp = 1'b0;
                write = 1'b1;
                tag_in = tag;
                cache_data_in = rd_reg | (wr_reg & offset != 3'b010) ? data_in_mem : proc_data_in;
                valid_in = 1'b1;
                enable = 1'b1;
                offset_in = 3'b010;

                proc_stall = 1'b1;
                proc_data_out = (offset == 3'b010) ? data_in_mem : 16'bxxxx_xxxx_xxxx_xxxx;
                Done = (offset == 3'b010) ? 1'b1 : 1'b0;
                next_state = `ALLOC_4;
            end
            `ALLOC_4: begin
                mem_wr = 1'b0;
                mem_rd = 1'b0;

                comp = 1'b0;
                write = 1'b1;
                tag_in = tag;
                cache_data_in = rd_reg | (wr_reg & offset != 3'b100) ? data_in_mem : proc_data_in;
                valid_in = 1'b1;
                enable = 1'b1;
                offset_in = 3'b100;

                proc_stall = 1'b1;
                proc_data_out = (offset == 3'b100) ? data_in_mem : 16'bxxxx_xxxx_xxxx_xxxx;
                Done = (offset == 3'b100) ? 1'b1 : 1'b0;
                next_state = `ALLOC_5;
            end
            `ALLOC_5: begin
                mem_wr = 1'b0;
                mem_rd = 1'b0;

                comp = 1'b0;
                write = 1'b1;
                tag_in = tag;
                cache_data_in = rd_reg | (wr_reg & offset != 3'b110) ? data_in_mem : proc_data_in;
                valid_in = 1'b1;
                enable = 1'b1;
                offset_in = 3'b110;

                proc_stall = 1'b1;
                proc_data_out = (offset == 3'b110) ? data_in_mem : 16'bxxxx_xxxx_xxxx_xxxx;
                Done = (offset == 3'b110) ? 1'b1 : 1'b0;
                next_state = `IDLE;
            end
            default: begin
                next_state = `IDLE;
            end
        endcase
    end

// Next state flip-flop
reg_16b #(.REG_SIZE(4)) state_reg (.readData(state), .writeData(next_state), .clk(clk), .rst(rst), .writeEn(1'b1));

endmodule
`default_nettype wire