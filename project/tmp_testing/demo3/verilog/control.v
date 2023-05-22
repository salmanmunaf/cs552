/*
   CS/ECE 552 Spring '20
  
   Filename        : control.v
   Description     : This is the module for the overall control unit of the processor.
*/
`default_nettype none
module control (Opcode, func, 
                err, Beq, Bne, Blt, Bgt, J, JR, JAL, JALR, Halt, IsR, IsI1, IsI2, memWR, MemRead, MemWrite, RegWrite, AluCin, AluInvA, AluInvB, 
                RegDst, DatatoReg, AluSrc1, AluSrc2, 
                AluOp);
    input wire [4:0] Opcode;
    input wire [1:0] func;
    output reg     err, Beq, Bne, Blt, Bgt, J, JR, JAL, JALR, Halt, IsR, IsI1, IsI2, memWR, MemRead, MemWrite, RegWrite, AluCin, AluInvA, AluInvB;
    output reg [1:0] RegDst, DatatoReg, AluSrc1, AluSrc2;
    output reg [3:0] AluOp;

   // TODO: Your code here
   // always block to decide on control logic
   always @(*) begin
        // set default values of any signals here that you don't want to set in every single case statement below -- ala my suggestion @255
        // Branch = 1'b0; // 0 for non branch, 1 for branch
        Beq = 1'b0; // 1 for beq instruction
        Bne = 1'b0; // 1 for bne instruction
        Blt = 1'b0; // 1 for blt instruction
        Bgt = 1'b0; // 1 for bgt instruction
        J = 1'b0; // 1 for J instruction
        JR = 1'b0; // 1 for JR instruction
        JAL = 1'b0; // 1 for JAL instruction
        JALR = 1'b0; // 1 for JALR instruction
        // BTR = 1'b0; // 1 for BTR instruction
        Halt = 1'b0; // 1 for halt instruction
        IsI2 = 1'b0; // 0 = ins[4-0], 1 = ins[7-0] to extension modules
        RegDst = 2'b00; // 0 for ins[7-5] - rd, 1 for ins[4-2] - rd, 2 for ins[10-8] - rs, 3 for r7
        MemRead = 1'b0; // 0 for non load, 1 for load
        MemWrite = 1'b0;
        DatatoReg = 2'b00; // 0 for alu result, 1 for MemtoReg, 2 for PC+2 (JAL/JALR)
        memWR = 1'b0; // 0 for non ST, 1 for ST
        // AluDst = 2'b00; // 0 for ALU result, 1 for zero, 2 for neg, 3 for carry
        AluSrc1 = 2'b00; // 0 for rs or 1 for rs << 8 (SLBI) or 2 for 0
        AluSrc2 = 2'b00; // 0 for r2, 1 for sign extended I, 2 for zero extended I, 3 for 0
        RegWrite = 1'b0; // 0 for no reg write, 1 for reg write
        AluOp = 4'b0000; // refer to hw2 table
        AluCin = 1'b0; // 1 incase of subtraction
        AluInvA = 1'b0; 
        AluInvB = 1'b0;
        // Jump = 1'b0; // 0 for non jump, 1 for jump
        IsI1 = 1'b0; // instruction is I1 format
        IsR = 1'b0; // instruction is R format
        casex( {Opcode, func} ) // where Opcode and Funct are the appropriate bits from the 16-bit instruction.
        // 1. halt
            7'b00000_xx: begin
                // set control signal values for a halt in here
                Halt = 1'b1;
            end
            // 2. nop
            7'b00001_xx: begin

            end
            // 3. addi
            7'b01000_xx: begin
                AluSrc2 = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0100;
                IsI1 = 1'b1;
            end
            // 4. subi
            7'b01001_xx: begin
                AluSrc2 = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0100;
                AluCin = 1'b1;
                AluInvA = 1'b1;
                IsI1 = 1'b1;
            end
            // 5. xori
            7'b01010_xx: begin
                AluSrc2 = 2'b10;
                RegWrite = 1'b1;
                AluOp = 4'b0111;
                IsI1 = 1'b1;
            end
            // 6. andni
            7'b01011_xx: begin
                AluSrc2 = 2'b10;
                RegWrite = 1'b1;
                AluOp = 4'b0101;
                AluInvB = 1'b1;
                IsI1 = 1'b1;
            end
            // 7. roli
            7'b10100_xx: begin
                AluSrc2 = 2'b10;
                RegWrite = 1'b1;
                AluOp = 4'b0000;
                IsI1 = 1'b1;
            end
            // 8. slli
            7'b10101_xx: begin
                AluSrc2 = 2'b10;
                RegWrite = 1'b1;
                AluOp = 4'b0001;
                IsI1 = 1'b1;
            end
            // 9. rori - change sra - done
            7'b10110_xx: begin
                AluSrc2 = 2'b10;
                RegWrite = 1'b1;
                AluOp = 4'b0010;
                IsI1 = 1'b1;
            end
            // 10. srli
            7'b10111_xx: begin
                AluSrc2 = 2'b10;
                RegWrite = 1'b1;
                AluOp = 4'b0011;
                IsI1 = 1'b1;
            end
            // 11. st
            7'b10000_xx: begin
                AluSrc2 = 2'b01;
                AluOp = 4'b0100;
                memWR = 1'b1;
                MemWrite = 1'b1;
                IsR = 1'b1;
            end
            // 12. ld
            7'b10001_xx: begin
                AluSrc2 = 2'b01;
                AluOp = 4'b0100;
                memWR = 1'b0;
                RegWrite = 1'b1;
                DatatoReg = 2'b01;
                MemRead = 1'b1;
                IsI1 = 1'b1;
            end
            // 13. stu
            7'b10011_xx: begin
                AluSrc2 = 2'b01;
                AluOp = 4'b0100;
                memWR = 1'b1;
                RegWrite = 1'b1;
                RegDst = 2'b10;
                MemWrite = 1'b1;
                IsR = 1'b1;
            end
            // 14. btr
            7'b11001_xx: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b1111;
                IsR = 1'b1;
            end
            // 15. add
            7'b11011_00: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0100;
                IsR = 1'b1;
            end
            // 16. sub
            7'b11011_01: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0100;
                AluCin = 1'b1;
                AluInvA = 1'b1;
                IsR = 1'b1;
            end
            // 17. xor
            7'b11011_10: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0111;
                IsR = 1'b1;
            end
            // 18. andn
            7'b11011_11: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0101;
                AluInvB = 1'b1;
                IsR = 1'b1;
            end
            // 19. rol
            7'b11010_00: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0000;
                IsR = 1'b1;
            end
            // 20. sll
            7'b11010_01: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0001;
                IsR = 1'b1;
            end
            // 22. ror
            7'b11010_10: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0010;
                IsR = 1'b1;
            end
            // 23. srl
            7'b11010_11: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b0011;
                IsR = 1'b1;
            end
            // 24. seq
            7'b11100_xx: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b1000;
                AluCin = 1'b1;
                AluInvB = 1'b1;
                IsR = 1'b1;
                //ALUDst
            end
            // 25. slt
            7'b11101_xx: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b1001;
                AluCin = 1'b1;
                AluInvB = 1'b1;
                IsR = 1'b1;
                //ALUDst

            end
            // 26. sle
            7'b11110_xx: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b1010;
                AluCin = 1'b1;
                AluInvB = 1'b1;
                IsR = 1'b1;
                //ALUDst
            end
            // 27. sco
            7'b11111_xx: begin
                RegDst = 2'b01;
                RegWrite = 1'b1;
                AluOp = 4'b1011;
                IsR = 1'b1;
                //ALUDst
            end
            // 28. beqz
            7'b01100_xx: begin
                Beq = 1'b1;
                IsI2 = 1'b1;
                AluSrc2 = 2'b11;
                //change to or
                AluOp = 4'b0100;
            end
            // 29. bnez
            7'b01101_xx: begin
                Bne = 1'b1;
                IsI2 = 1'b1;
                AluSrc2 = 2'b11;
                // change to or
                AluOp = 4'b0100;
            end
            // 30. bltz
            7'b01110_xx: begin
                Blt = 1'b1;
                IsI2 = 1'b1;
                AluSrc2 = 2'b11;
                AluOp = 4'b0100;
            end
            // 31. bgez
            7'b01111_xx: begin
                Bgt = 1'b1;
                IsI2 = 1'b1;
                AluSrc2 = 2'b11;
                AluOp = 4'b0100;
            end
            // 32. lbi
            7'b11000_xx: begin
                AluSrc1 = 2'b10;
                AluSrc2 = 2'b01;
                IsI2 = 1'b1;
                RegDst = 2'b10;
                RegWrite = 1'b1;
                AluOp = 4'b0100;
            end
            // 33. slbi
            7'b10010_xx: begin
                AluSrc1 = 2'b01;
                AluSrc2 = 2'b10;
                IsI2 = 1'b1;
                RegDst = 2'b10;
                RegWrite = 1'b1;
                AluOp = 4'b0110;
            end
            // 34. j
            7'b00100_xx: begin
                J = 1'b1;

            end
            // 35. jr
            7'b00101_xx: begin
                JR = 1'b1;
                AluSrc2 = 2'b01;
                AluOp = 4'b0100;
                IsI2 = 1'b1;
            end
            // 35. jal
            7'b00110_xx: begin
                JAL = 1'b1;
                RegDst = 2'b11;
                RegWrite = 1'b1;
                DatatoReg = 2'b10;
            end
            // 36. jalr
            7'b00111_xx: begin
                JALR = 1'b1;
                RegDst = 2'b11;
                DatatoReg = 2'b10;
                RegWrite = 1'b1;
                AluSrc2 = 2'b01;
                AluOp = 4'b0100;
                IsI2 = 1'b1;
            end
            default: begin
                err = 1'b1;
            end

        endcase
    end
endmodule
`default_nettype wire