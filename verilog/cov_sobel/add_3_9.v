`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/19 20:45:34
// Design Name: 
// Module Name: add_3_9
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module add_3_8(
    input [7:0] num1, num2, num3,
    output [7:0] s,
    output [7:0] c
);

    full_adder o0 (
        .A(num1[0]), 
        .B(num2[0]), 
        .Cin(num3[0]),
        .Sum(s[0]), 
        .Cout(c[0])
    );

    full_adder o1 (
        .A(num1[1]), 
        .B(num2[1]), 
        .Cin(num3[1]),
        .Sum(s[1]), 
        .Cout(c[1])
    );

    full_adder o2 (
        .A(num1[2]), 
        .B(num2[2]), 
        .Cin(num3[2]),
        .Sum(s[2]), 
        .Cout(c[2])
    );

    full_adder o3 (
        .A(num1[3]), 
        .B(num2[3]), 
        .Cin(num3[3]),
        .Sum(s[3]), 
        .Cout(c[3])
    );

    full_adder o4 (
        .A(num1[4]), 
        .B(num2[4]), 
        .Cin(num3[4]),
        .Sum(s[4]), 
        .Cout(c[4])
    );

    full_adder o5 (
        .A(num1[5]), 
        .B(num2[5]), 
        .Cin(num3[5]),
        .Sum(s[5]), 
        .Cout(c[5])
    );

    full_adder o6 (
        .A(num1[6]), 
        .B(num2[6]), 
        .Cin(num3[6]),
        .Sum(s[6]), 
        .Cout(c[6])
    );

    full_adder o7 (
        .A(num1[7]), 
        .B(num2[7]), 
        .Cin(num3[7]),
        .Sum(s[7]), 
        .Cout(c[7])
    );

endmodule
