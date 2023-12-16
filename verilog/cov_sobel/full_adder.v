`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/19 21:49:54
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input A, B, Cin,
    output Sum, Cout
);

    // Sum calculation using XOR
    assign Sum = A ^ B ^ Cin;

    // Carry out calculation
    assign Cout = (A & B) | (Cin & (A ^ B));

endmodule
