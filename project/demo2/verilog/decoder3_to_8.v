/*
   CS/ECE 552, Spring '22
   homework #3, Problem #1
  
   This module creates a 3-to-8 decoder.
*/
module decoder3_to_8 (out, in);
    output [7:0]   out;
    input [2:0]    in;

    decoder2_to_4 decoder1 (out[3:0], in[1:0], ~in[2]);
    decoder2_to_4 decoder2 (out[7:4], in[1:0], in[2]);

endmodule