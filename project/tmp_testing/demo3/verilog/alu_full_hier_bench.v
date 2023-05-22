module alu_full_hier_bench;

    // declare constant for size of inputs, outputs (N) and # bits to shift (C)
    parameter OP_WIDTH = 16;
    parameter NUM_OPS  =  4;

    // alu signals
    reg  [OP_WIDTH - 1:0] A_pre_inv;
    reg  [OP_WIDTH - 1:0] B_pre_inv;
    wire [OP_WIDTH - 1:0] A;
    wire [OP_WIDTH - 1:0] B;
    reg                   Cin;
    reg  [NUM_OPS  - 1:0] Oper;
    reg                   invA;
    reg                   invB;
    reg                   sign;
    wire [OP_WIDTH - 1:0] Out;
    wire                  Ofl;
    wire                  Zero, Cout, Neg;

    reg                   fail;

    reg                   cerror;
    reg  [31:0]           ExOut;
    reg                   ExOfl;
    reg                   ExZero;
    integer               idx;
   
    alu_full_hier #(.OPERAND_WIDTH(OP_WIDTH),
               .NUM_OPERATIONS(NUM_OPS)) 
             DUT (.InA(A_pre_inv), 
                  .InB(B_pre_inv), 
                  .Cin(Cin), 
                  .Oper(Oper), 
                  .invA(invA), 
                  .invB(invB), 
                  .sign(sign), 
                  .Out(Out), 
                  .Ofl(Ofl), 
                  .Zero(Zero),
                  .Cout(Cout),
                  .Neg(Neg));
   
    initial begin
        A_pre_inv = 16'b0000;
        B_pre_inv = 16'b0000;
        Cin = 1'b0;
        Oper = 4'b0000;
        invA = 1'b0;
        invB = 1'b0;
        sign = 1'b0;
        fail = 0;
        
        #20000;
        if (fail)
          $display("TEST FAILED");
        else
          $display("TEST PASSED");

        $finish;
    end

    assign A = invA ? ~A_pre_inv : A_pre_inv;
    assign B = invB ? ~B_pre_inv : B_pre_inv;
   
    always @(posedge DUT.clk) begin
        A_pre_inv = $random;
        B_pre_inv = $random;
        Cin = $random;
        Oper = $random;
        invA = $random;
        invB = $random;
        sign = $random;
    end

    always @(negedge DUT.clk) begin
        cerror = 1'b0;
        ExOut = 32'h0000_0000;
        ExZero = 1'b0;
        ExOfl = 1'b0;

        case (Oper)
            4'b0000 : begin // Rotate Left
                ExOut = (A << B[3:0]) | (A >> 16-B[3:0]);
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            4'b0001 : begin // Shift Left 
                ExOut = A << B[3:0];
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            4'b0010 : begin // Rotate Right
                ExOut = (A >> B[3:0]) | (A << 16-B[3:0]);
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            4'b0011 : begin // Right Shift Logical
                ExOut = A >> B[3:0];
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            4'b0100 : begin // A + B
                ExOut = A + B + Cin;
                if (ExOut[15:0] == 16'h0000)
                    ExZero = 1'b1;

                if (sign == 1'b1)
                    ExOfl = ExOut[15]^A[15]^B[15]^ExOut[16];
                else
                    ExOfl = ExOut[16];
               
                if ((ExOut[15:0] !== Out) || 
                    (ExZero !== Zero)     || 
                    (ExOfl !== Ofl))
                        cerror = 1'b1;
            end
            4'b0101 : begin // A AND B
                ExOut = A & B;
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end          
            4'b0110 : begin // A OR B
                ExOut = A | B;
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            4'b0111 : begin // A XOR B
                ExOut = A ^ B;
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            4'b1000 : begin // A == B
                A_pre_inv[15] = 1'b0;
                B_pre_inv[15] = 1'b0;
                invA = 0;
                invB = 1;
                Cin = 1;
                sign = 1;
                ExOut = A_pre_inv == B_pre_inv;
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            4'b1001 : begin // A < B
                A_pre_inv[15] = 1'b0;
                B_pre_inv[15] = 1'b0;
                invA = 0;
                invB = 1;
                Cin = 1;
                sign = 1;
                ExOut = A_pre_inv < B_pre_inv;
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            4'b1010 : begin // A <= B
                A_pre_inv[15] = 1'b0;
                B_pre_inv[15] = 1'b0;
                invA = 0;
                invB = 1;
                Cin = 1;
                sign = 1;
                ExOut = A_pre_inv <= B_pre_inv;
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
            // 4'b1100 : begin // A + B -> Cout 
            //     ExOut = A + B;
            //     if (ExOut[15:0] !== Out)
            //         cerror = 1'b1;
            // end
            4'b1111 : begin // BTR 
                ExOut = {A_pre_inv[0], A_pre_inv[1], A_pre_inv[2], A_pre_inv[3], A_pre_inv[4], A_pre_inv[5], A_pre_inv[6], A_pre_inv[7], A_pre_inv[8], A_pre_inv[9], A_pre_inv[10], A_pre_inv[11], A_pre_inv[12], A_pre_inv[13], A_pre_inv[14], A_pre_inv[15]};
                if (ExOut[15:0] !== Out)
                    cerror = 1'b1;
            end
        endcase // case (Oper)
        
        if (cerror == 1'b1) begin
           $display("ERRORCHECK :: ALU :: Inputs :: Oper = %d , InA = 0x%x, InB = 0x%x, Cin = 0x%x, invA = 0x%x, invB = 0x%x, sign = 0x%x :: Outputs :: Out = 0x%x, Ofl = 0x%x, Zero = %z :: Expected :: Out = 0x%x, ExOfl = 0x%x, ExZero = 0x%x", 
                   Oper, 
                   A_pre_inv, 
                   B_pre_inv, 
                   Cin, 
                   invA, 
                   invB, 
                   sign, 
                   Out, 
                   Ofl, 
                   Zero, 
                   ExOut[15:0], 
                   ExOfl, 
                   ExZero);
           fail = 1;
        end
     end

endmodule // alu_hier_bench
