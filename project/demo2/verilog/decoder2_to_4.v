/*
   CS/ECE 552, Spring '22
   homework #3, Problem #1
  
   This module creates a 2-to-4 decoder.
*/
module decoder2_to_4 (out, in, en);
    output [3:0]   out;
    input [1:0]    in;
    input          en;

    assign out[0] = ~in[0] & ~in[1] & en;
    assign out[1] = in[0] & ~in[1] & en;
    assign out[2] = ~in[0] & in[1] & en;
    assign out[3] = in[0] & in[1] & en;

endmodule