`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:07:56
// Design Name: 
// Module Name: erosion
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


module erosion(
input clk,
input rst_n,
input [10:0] pixel_x,
input [10:0] pixel_y,
input wire [23:0] rgb_data,
output  reg [23:0] k_sobel_out
    );
parameter PIC_X_START = 11'd200;      //图片起始点横坐标
parameter PIC_Y_START = 11'd100;      //图片起始点纵坐标
parameter PIC_WIDTH   = 11'd200;    //图片宽度
parameter PIC_HEIGHT  = 11'd200;    //图片高度
parameter sobel=16'd15625;
 wire [7:0]rgb_gray;
 wire [23:0]gray_data;
 reg line_clk;
 reg state;
 reg [23:0]sobel_out;
 reg [23:0] line1[199:0];
 reg [23:0] line2[199:0];
 reg [7:0] p0;
 reg [7:0] p1;
 reg [7:0] p2;
 reg [9:0] cov_out;//y方向卷积
 reg [9:0] cov_out1;//x方向卷积
 wire [20:0] cov_square;
initial state=1'b0;

always@(posedge clk)begin
        if(pixel_y>100 &&pixel_y<=299)begin//舍弃了第一行
            if(pixel_x==200) 
                line_clk<=1'b1;
            else 
                line_clk<=1'b0;//当换行成第一个像素点后会产生一个上升沿
        end
end        
                    
always@(posedge line_clk)begin
    if(pixel_y==101)
        state<=0;//每当扫到了这张图像每一行的起始像素时state反转，state=0代表第一行
    else
        state<=~state;
end
//-------------------卷积

always@(posedge clk)begin
    if((pixel_y >= PIC_Y_START) && (pixel_y < PIC_Y_START + PIC_HEIGHT) 
        && (pixel_x >= PIC_X_START) && (pixel_x < PIC_X_START + PIC_WIDTH)) begin
        case(state)
             1'b0:begin 
                line1[pixel_x-200]<=rgb_data;
                line2[pixel_x-200]<=line2[pixel_x-200];
                p2<=rgb_data;//p2一直是当前的rgb_gray的值，p1和p0是前两个值
                p1<=p2;
                if(pixel_x>=201 && pixel_y>=102)begin
    //1 2 3   -1 -2 -1
    //4 5 6   0   0  0
    //7 8 9   1    2  1
               if(p2==24'd0&&p1==24'd0&&line1[pixel_x-201]==24'd0&&line1[pixel_x-200]==24'd0)
                    k_sobel_out<=24'd0;
                else
                    k_sobel_out<= 24'b111111111111111111;
               end 
            end
            1'b1:begin
                line2[pixel_x-200]<=rgb_data;
                line1[pixel_x-200]<=line1[pixel_x-200];
                p2<=rgb_data;//p2一直是当前的rgb_gray的值，p1和p0是前两个值
                p1<=p2;
                if(pixel_x>=201 && pixel_y>=102)begin
    //1 2 3   -1 -2 -1
    //4 5 6   0   0  0
    //7 8 9   1    2  1
                if(p2==24'd0&&p1==24'd0&&line2[pixel_x-201]==24'd0&&line2[pixel_x-200]==24'd0)
                    k_sobel_out<=24'd0;
                else
                    k_sobel_out<= 24'b111111111111111111;
               end 
             end
            default:begin 
                 line1[pixel_x]<=line1[pixel_x];
                 line2[pixel_x]<=line2[pixel_x];
                 k_sobel_out<=k_sobel_out;
            end
   endcase
end
end    





endmodule