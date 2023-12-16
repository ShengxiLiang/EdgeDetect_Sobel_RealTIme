`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/26 20:29:50
// Design Name: 
// Module Name: cov_sobel
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




module cov_sobel(
    input clk,
    input rst_n,
    input [10:0] pixel_x,
    input [10:0] pixel_y,
    input wire [23:0] rgb_data,
    output reg [23:0] k_sobel_out
);

    // Output wires of the adders
    wire [10:0] add_out1, add_out2, add_out3, add_out4;

    // Constants for picture dimensions and sobel threshold
    parameter PIC_X_START = 11'd200;    // Horizontal start coordinate of the picture
    parameter PIC_Y_START = 11'd100;    // Vertical start coordinate of the picture
    parameter PIC_WIDTH   = 11'd200;    // Width of the picture
    parameter PIC_HEIGHT  = 11'd200;    // Height of the picture
    parameter sobel = 16'd15625;

    wire [7:0] rgb_gray;
    wire [23:0] gray_data;
    reg line_clk;
    reg state;
    reg [23:0] sobel_out;
    reg [7:0] line1[199:0];
    reg [7:0] line2[199:0];
    reg [7:0] p0, p1, p2;
    reg [9:0] cov_out;  // Convolution in y-direction
    reg [9:0] cov_out1; // Convolution in x-direction
    wire [20:0] cov_square;

    // Initial state setting
    initial state = 1'b0;

    // Gray scale conversion
    assign rgb_gray = (rgb_data[23:16] * 5) / 16 + (rgb_data[15:8] * 9) / 16 + (rgb_data[7:0] * 2) / 16;
    assign gray_data = {rgb_gray, rgb_gray, rgb_gray};

   // Line clock generation
    always @(posedge clk) begin
        if (pixel_y > 100 && pixel_y <= 299) begin
            if (pixel_x == 200) 
                line_clk <= 1'b1;
            else 
                line_clk <= 1'b0;
        end
    end

    // State toggling for each row
    always @(posedge line_clk) begin
        if (pixel_y == 101)
            state <= 0;
        else
            state <= ~state;
    end

// Convolution Process
always @(posedge clk) begin
    if ((pixel_y >= PIC_Y_START) && (pixel_y < PIC_Y_START + PIC_HEIGHT) 
        && (pixel_x >= PIC_X_START) && (pixel_x < PIC_X_START + PIC_WIDTH)) begin
        case (state)
            1'b0: begin
                line1[pixel_x - 200] <= rgb_gray;
                line2[pixel_x - 200] <= line2[pixel_x - 200];
                p2 <= rgb_gray; // p2 is always the current value of rgb_gray, p1 and p0 are the previous two values
                p1 <= p2;
                p0 <= p1;
                if (pixel_x >= 202 && pixel_y >= 103) begin
                    // Convolution logic for state 0
                    cov_out <= add_out1[10] ? ~add_out1[9:0] + 1 : add_out1[9:0];
                end
            end

            1'b1: begin
                line2[pixel_x - 200] <= rgb_gray;
                line1[pixel_x - 200] <= line1[pixel_x - 200];
                p2 <= rgb_gray;
                p1 <= p2;
                p0 <= p1;
                if (pixel_x >= 202 && pixel_y >= 103) begin
                    // Convolution logic for state 1
                    cov_out <= add_out2[10] ? ~add_out2[9:0] + 1 : add_out2[9:0];
                end
            end
            
            default: begin
                line1[pixel_x] <= line1[pixel_x];
                line2[pixel_x] <= line2[pixel_x];
                cov_out <= cov_out;
            end
        endcase
    end
end

always @(posedge clk) begin
    if ((pixel_y >= PIC_Y_START) && (pixel_y < PIC_Y_START + PIC_HEIGHT) 
        && (pixel_x >= PIC_X_START) && (pixel_x < PIC_X_START + PIC_WIDTH)) begin
        case (state)
            1'b0: begin
                if (pixel_x >= 202 && pixel_y >= 103) begin
                    // Additional convolution logic for state 0
                    cov_out1 <= add_out3[10] ? ~add_out3[9:0] + 1 : add_out3[9:0];
                end
            end

            1'b1: begin
                if (pixel_x >= 202 && pixel_y >= 103) begin
                    // Additional convolution logic for state 1
                    cov_out1 <= add_out4[10] ? ~add_out4[9:0] + 1 : add_out4[9:0];
                end
            end

            default: begin
                cov_out1 <= cov_out1;
            end
        endcase
    end
end

// Calculate the square of the convolution results
assign cov_square = cov_out * cov_out + cov_out1 * cov_out1;

// Determine the sobel output based on the convolution square
always @(*) begin
    k_sobel_out <= (cov_square > sobel) ? 24'd0 : 24'b111111111111111111111111;
end

// Optimized Adders
add_add add1(
    .num1(line1[pixel_x - 202]),
    .num2(line1[pixel_x - 200]),
    .num3(line1[pixel_x - 201]),
    .num4(p1),
    .num5(p0),
    .num6(p2),
    .num(add_out1)
);

add_add add2(
    .num1(line2[pixel_x - 202]),
    .num2(line2[pixel_x - 200]),
    .num3(line2[pixel_x - 201]),
    .num4(p1),
    .num5(p0),
    .num6(p2),
    .num(add_out2)
);

add_add add3(
    .num1(line1[pixel_x - 202]),
    .num2(p0),
    .num3(line2[pixel_x - 202]),
    .num4(line2[pixel_x - 200]),
    .num5(line1[pixel_x - 200]),
    .num6(p2),
    .num(add_out3)
);

add_add add4(
    .num1(line2[pixel_x - 202]),
    .num2(p0),
    .num3(line1[pixel_x - 202]),
    .num4(line1[pixel_x - 200]),
    .num5(line2[pixel_x - 200]),
    .num6(p2),
    .num(add_out4)
);

endmodule
