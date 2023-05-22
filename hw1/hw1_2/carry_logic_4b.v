/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 2
    
    a 4-bit carry logic block
*/
module carry_logic_4b(c_out, c, g, p, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output         c_out;
    output [N-2:0] c;
    input [N-1: 0] g, p;
    input          c_in;
    wire           p0_c0, p1_g0, p1_p0_c0, c2_im, p2_g1, p2_p1_g0, p2_p1_p0_c0, c3_im1, c3_im2;
    wire           p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_c0, c4_im1, c4_im2, c4_im3;
    // YOUR CODE HERE
    and2 and_op1 (.out(p0_c0), .in1(p[0]), .in2(c_in));
    or2 or_op1 (.out(c[0]), .in1(g[0]), .in2(p0_c0));

    and2 and_op2 (.out(p1_g0), .in1(p[1]), .in2(g[0]));
    and2 and_op3 (.out(p1_p0_c0), .in1(p[1]), .in2(p0_c0));
    or2 or_op2 (.out(c2_im), .in1(p1_p0_c0), .in2(p1_g0));
    or2 or_op3 (.out(c[1]), .in1(g[1]), .in2(c2_im));

    and2 and_op4 (.out(p2_g1), .in1(p[2]), .in2(g[1]));
    and2 and_op5 (.out(p2_p1_g0), .in1(p[2]), .in2(p1_g0));
    and2 and_op6 (.out(p2_p1_p0_c0), .in1(p[2]), .in2(p1_p0_c0));
    or2 or_op4 (.out(c3_im1), .in1(p2_g1), .in2(p2_p1_g0));
    or2 or_op5 (.out(c3_im2), .in1(c3_im1), .in2(p2_p1_p0_c0));
    or2 or_op6 (.out(c[2]), .in1(g[2]), .in2(c3_im2));

    and2 and_op7 (.out(p3_g2), .in1(p[3]), .in2(g[2]));
    and2 and_op8 (.out(p3_p2_g1), .in1(p[3]), .in2(p2_g1));
    and2 and_op9 (.out(p3_p2_p1_g0), .in1(p[3]), .in2(p2_p1_g0));
    and2 and_op10 (.out(p3_p2_p1_p0_c0), .in1(p[3]), .in2(p2_p1_p0_c0));
    or2 or_op7 (.out(c4_im1), .in1(p3_g2), .in2(p3_p2_g1));
    or2 or_op8 (.out(c4_im2), .in1(p3_p2_p1_g0), .in2(c4_im1));
    or2 or_op9 (.out(c4_im3), .in1(p3_p2_p1_p0_c0), .in2(c4_im2));
    or2 or_op10 (.out(c_out), .in1(g[3]), .in2(c4_im3));

endmodule
