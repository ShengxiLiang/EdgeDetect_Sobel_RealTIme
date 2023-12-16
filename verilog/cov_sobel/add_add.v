`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:26:41
// Design Name: 
// Module Name: add_add
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


module add_add(
    input [7:0] num1, num2, num3, num4, num5, num6,
    output [10:0] num
);
    // Internal wire declarations
    wire [7:0] s00, s01, s10, s20;
    wire [7:0] c00, c01, c10, c20;
    wire c4, c8;
    wire [8:0] op3, op4;
    wire [7:0] op1, op2;
    wire [1:0] data;

    // Assign statements
    assign data[1] = s00[0] & s01[0];
    assign data[0] = s00[0] ^ s01[0];

    // Module instantiations
    num_not a0(
        .num1(num1),
        .num2(num2),
        .num3(num3),
        .num4(num4),
        .data1(op1),
        .data2(op2),
        .data3(op3),
        .data4(op4)
    );

    add_3_8 a1(
        .num1(op1),
        .num2(op2),
        .num3(op3[7:0]),
        .s(s00),
        .c(c00)
    );

    add_3_8 a2(
        .num1(num5),
        .num2(num6),
        .num3(op4[7:0]),
        .s(s01),
        .c(c01)
    );

    add_3_8 a3(
        .num1(c00),
        .num2(c01),
        .num3({op3[8], s00[7:1]}),
        .s(s10),
        .c(c10)
    );

    add_3_8 a4(
        .num1({op4[8], s01[7:1]}),
        .num2(s10),
        .num3({c10[6:0], data[1]}),
        .s(s20),
        .c(c20)
    ); 

    CLA_4 a5(
        .a(c20[3:0]),
        .b(s20[4:1]),
        .cin(1'b0),
        .sum(num[5:2]),
        .cout(c4)
    );

    CLA_4 a6(
        .a(c20[7:4]),
        .b({c10[7], s20[7:5]}),
        .cin(c4),
        .sum(num[9:6]),
        .cout(c8)
    );

    // Assign output bits
    assign num[10] = !c8;
    assign num[1] = s20[0];
    assign num[0] = data[0];

endmodule
