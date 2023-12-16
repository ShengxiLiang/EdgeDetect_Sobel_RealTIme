`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/26 20:29:50
// Design Name: 
// Module Name: num_not
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


module num_not(
    input [7:0] num1, num2, num3, num4,
    output [7:0] data1, data2,
    output [8:0] data3, data4
);

    // Perform one's complement and increment operations
    assign data1 = ~num1 + 1;
    assign data2 = ~num2 + 1;

    // Perform left shift operations
    assign data3 = (~num3 + 1) << 1;
    assign data4 = num4 << 1;

endmodule

