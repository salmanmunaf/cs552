/*
    CS/ECE 552 Spring '22
    Project Phase 1

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, rotate right, shift right logical, add,
    or, xor, and, btr, seq, slt, sle and sco.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/

`default_nettype none 
module alu_full (InA, InB, Cin, Oper, invA, invB, sign, 
                Out, Zero, Ofl, Cout, Neg);
    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 4;
       
    input wire [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input wire [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input wire                      Cin ; // Carry in
    input wire [NUM_OPERATIONS-1:0] Oper; // Operation type
    input wire                      invA; // Signal to invert A
    input wire                      invB; // Signal to invert B
    input wire                      sign; // Signal for signed operation
    output wire [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output wire                     Ofl ; // Signal if overflow occured
    output wire                     Zero; // Signal if Out is 0
    output wire                     Cout;
    output wire                     Neg;

    wire [NUM_OPERATIONS-2:0]   AluOper;
    wire [OPERAND_WIDTH-1:0]    bitReverse, AluOut;
    wire                        IsBTROp, IsSetComp, setCompOut, Rs_Pos_Rt_Neg, Rs_Neg_Rt_Pos, isLess;

    assign AluOper = Oper[3] ? 3'b100 : Oper[NUM_OPERATIONS-2:0];

    assign bitReverse = {InA[0], InA[1], InA[2], InA[3], InA[4], InA[5], InA[6], InA[7], InA[8], InA[9], InA[10], InA[11], InA[12], InA[13], InA[14], InA[15]};

    alu aluMod (.InA(InA), .InB(InB), .Cin(Cin), .Oper(AluOper), .invA(invA), .invB(invB), .sign(sign), .Out(AluOut), .Zero(Zero), .Ofl(Ofl), .Cout(Cout), .Neg(Neg));

    assign Rs_Pos_Rt_Neg = ~InA[15] & InB[15];
    assign Rs_Neg_Rt_Pos = InA[15] & ~InB[15];
    assign isLess = Rs_Neg_Rt_Pos ? 1'b1 : (Rs_Pos_Rt_Neg ? 1'b0 : Neg);
    
    mux4_1 muxSetComp (.out(setCompOut), .inA(Zero), .inB(isLess), .inC(Zero|isLess), .inD(Cout), .s(Oper[1:0]));

    assign IsBTROp = &Oper;
    assign IsSetComp = Oper[3] & ~Oper[2];
    
    assign Out = IsBTROp ? bitReverse : (IsSetComp ? { 15'b0000_0000_0000_000, setCompOut } : AluOut);

endmodule
`default_nettype wire