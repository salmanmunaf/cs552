/*
   CS/ECE 552 Spring '20
  
   Filename        : branch_unit.v
   Description     : This is the overall module for the branch unit of the processor.
*/
`default_nettype none
module branch_unit (Out, Beq, Bne, Blt, Bgt, Zero, Neg);
    output wire Out;
    input wire Beq, Bne, Blt, Bgt, Zero, Neg;

    assign Out = (Beq & Zero) | (Bne & ~Zero) | (Blt & Neg) | (Bgt & (~Neg | Zero));
endmodule
`default_nettype wire