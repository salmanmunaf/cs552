/*
    CS/ECE 552 Spring '22
    Homework #2, Problem 1

    8 bit shifter 
*/
module shifter8 (In, Shift, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    // parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input                       Shift; // shift/rotate by 2 bit
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate
    wire   [OPERAND_WIDTH -1:0] Tmp;

   /* YOUR CODE HERE */
   mux4_1 mux0 (.out(Tmp[0]), .inA(In[8]), .inB(1'b0), .inC(In[8]), .inD(In[8]), .s(Oper));
   mux4_1 mux1 (.out(Tmp[1]), .inA(In[9]), .inB(1'b0), .inC(In[9]), .inD(In[9]), .s(Oper));
   mux4_1 mux2 (.out(Tmp[2]), .inA(In[10]), .inB(1'b0), .inC(In[10]), .inD(In[10]), .s(Oper));
   mux4_1 mux3 (.out(Tmp[3]), .inA(In[11]), .inB(1'b0), .inC(In[11]), .inD(In[11]), .s(Oper));
   mux4_1 mux4 (.out(Tmp[4]), .inA(In[12]), .inB(1'b0), .inC(In[12]), .inD(In[12]), .s(Oper));
   mux4_1 mux5 (.out(Tmp[5]), .inA(In[13]), .inB(1'b0), .inC(In[13]), .inD(In[13]), .s(Oper));
   mux4_1 mux6 (.out(Tmp[6]), .inA(In[14]), .inB(1'b0), .inC(In[14]), .inD(In[14]), .s(Oper));
   mux4_1 mux7 (.out(Tmp[7]), .inA(In[15]), .inB(1'b0), .inC(In[15]), .inD(In[15]), .s(Oper));
   mux4_1 mux8 (.out(Tmp[8]), .inA(In[0]), .inB(In[0]), .inC(In[0]), .inD(1'b0), .s(Oper));
   mux4_1 mux9 (.out(Tmp[9]), .inA(In[1]), .inB(In[1]), .inC(In[1]), .inD(1'b0), .s(Oper));
   mux4_1 mux10 (.out(Tmp[10]), .inA(In[2]), .inB(In[2]), .inC(In[2]), .inD(1'b0), .s(Oper));
   mux4_1 mux11 (.out(Tmp[11]), .inA(In[3]), .inB(In[3]), .inC(In[3]), .inD(1'b0), .s(Oper));
   mux4_1 mux12 (.out(Tmp[12]), .inA(In[4]), .inB(In[4]), .inC(In[4]), .inD(1'b0), .s(Oper));
   mux4_1 mux13 (.out(Tmp[13]), .inA(In[5]), .inB(In[5]), .inC(In[5]), .inD(1'b0), .s(Oper));
   mux4_1 mux14 (.out(Tmp[14]), .inA(In[6]), .inB(In[6]), .inC(In[6]), .inD(1'b0), .s(Oper));
   mux4_1 mux15 (.out(Tmp[15]), .inA(In[7]), .inB(In[7]), .inC(In[7]), .inD(1'b0), .s(Oper));

   mux2_1_16b mux16 (.out(Out), .inA(In), .inB(Tmp), .s(Shift));
   
endmodule