/*
    CS/ECE 552 Spring '22
    Homework #1, Problem 2
    
    a 4-bit CLA module
*/
module cla_4b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    // output         p_out, g_out
    input [N-1: 0] a, b;
    input          c_in;
    // wire [N-1: 0]  g, p, c;
    wire [N-1: 0]  g, p;
    wire [N-2: 0]  c;
    // wire           p0_c0, p1_g0, p1_p0_c0, c2_im, p2_g1, p2_p1_g0, p2_p1_p0_c0, c3_im1, c3_im2;
    // wire           p3_g2, p3_p2_g1, p3_p2_p1_g0, p3_p2_p1_p0_c0, c4_im1, c4_im2, c4_im3;
    // YOUR CODE HERE
    and2 g_0 (.out(g[0]), .in1(a[0]), .in2(b[0]));
    and2 g_1 (.out(g[1]), .in1(a[1]), .in2(b[1]));
    and2 g_2 (.out(g[2]), .in1(a[2]), .in2(b[2]));
    and2 g_3 (.out(g[3]), .in1(a[3]), .in2(b[3]));

    xor2 p_0 (.out(p[0]), .in1(a[0]), .in2(b[0]));
    xor2 p_1 (.out(p[1]), .in1(a[1]), .in2(b[1]));
    xor2 p_2 (.out(p[2]), .in1(a[2]), .in2(b[2]));
    xor2 p_3 (.out(p[3]), .in1(a[3]), .in2(b[3]));

    // and2 p0_c0 (.out(p0_c0), .in1(p[0]), .in2(c_in));
    // or2 c1 (.out(c[0]), .in1(g[0]), .in2(p0_c0));

    // and2 p1_g0 (.out(p1_g0), .in1(p[1]), .in2(g[0]));
    // and2 p1_p0_c0 (.out(p1_p0_c0), .in1(p[1]), .in2(p0_c0));
    // or2 c2_im (.out(c2_im), .in1(p1_p0_c0), .in2(p1_g0));
    // or2 c2 (.out(c[1]), .in1(g[1]), .in2(c2_im));

    // and2 p2_g1 (.out(p2_g1), .in1(p[2]), .in2(g[1]));
    // and2 p2_p1_g0 (.out(p2_p1_g0), .in1(p[2]), .in2(p1_g0));
    // and2 p2_p1_p0_c0 (.out(p2_p1_p0_c0), .in1(p[2]), .in2(p1_p0_c0));
    // or2 c3_im1 (.out(c3_im1), .in1(p2_g1), .in2(p2_p1_g0));
    // or2 c3_im2 (.out(c3_im2), .in1(c3_im1), .in2(p2_p1_p0_c0));
    // or2 c3 (.out(c[2]), .in1(g[2]), .in2(c3_im2));

    // and2 p3_g2 (.out(p3_g2), .in1(p_out), .in2(g[2]));
    // and2 p3_p2_g1 (.out(p3_p2_g1), .in1(p_out), .in2(p2_g1));
    // and2 p3_p2_p1_g0 (.out(p3_p2_p1_g0), .in1(p_out), .in2(p2_p1_g0));
    // and2 p3_p2_p1_p0_c0 (.out(p3_p2_p1_p0_c0), .in1(p_out), .in2(p2_p1_p0_c0));
    // or2 c4_im1 (.out(c4_im1), .in1(p3_g2), .in2(p3_p2_g1));
    // or2 c4_im2 (.out(c4_im2), .in1(p3_p2_p1_g0), .in2(c4_im1));
    // or2 c4_im3 (.out(c4_im3), .in1(p3_p2_p1_p0_c0), .in2(c4_im2));
    // or2 c4 (.out(c_out), .in1(g_out), .in2(c4_im3));
    carry_logic_4b carry_unit (.c_out(c_out), .c(c), .g(g), .p(p), .c_in(c_in));

    xor2 s_0 (.out(sum[0]), .in1(p[0]), .in2(c_in));
    xor2 s_1 (.out(sum[1]), .in1(p[1]), .in2(c[0]));
    xor2 s_2 (.out(sum[2]), .in1(p[2]), .in2(c[1]));
    xor2 s_3 (.out(sum[3]), .in1(p[3]), .in2(c[2]));

    // c_out = c[3];
    // g_out = g[3];
    // p_out = p[3];

endmodule
