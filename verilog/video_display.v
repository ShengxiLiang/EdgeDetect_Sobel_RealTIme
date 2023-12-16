`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:07:56
// Design Name: 
// Module Name: video_display
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


module video_display(
    input             pixel_clk,     //时钟
    input             sys_rst_n,        //复位，低电平有效                                
    input      [10:0] pixel_xpos,   //像素点横坐标
    input      [10:0] pixel_ypos,   //像素点纵坐标    
    output  reg[23:0] pixel_data    //像素点数据,
);                                   
                                     
//parameter define                   
localparam PIC_X_START = 11'd200;      //图片起始点横坐标
localparam PIC_Y_START = 11'd100;      //图片起始点纵坐标
localparam PIC_WIDTH   = 11'd200;    //图片宽度
localparam PIC_HEIGHT  = 11'd200;    //图片高度                 
parameter  H_DISP = 11'd1280;                       //分辨率--行
parameter  V_DISP = 11'd720;                        //分辨率--列
reg [23:0]pixel_data1;
//reg define
reg   [127:0] char[31:0];  //字符数组
reg   [15:0]  rom_addr  ;  //ROM地址
reg   [15:0]  rom_addr1  ;  //ROM地址
//wire define   
wire  [10:0]  x_cnt;       //横坐标计数器
wire  [10:0]  y_cnt;       //纵坐标计数器
wire          rom_rd_en ;  //ROM读使能信号
wire  [23:0]  rom_rd_data ;//ROM数据
wire  [23:0]  rom_rd_data1 ;//ROM数据
wire [23:0]pixel_data2;
wire [23:0]pixel_data3;
wire [23:0]pixel_data4;
//*****************************************************
//**                    main code
//*****************************************************


assign  rom_rd_en = 1'b1;                  //读使能拉高，即一直读ROM数据

//为LCD不同显示区域绘制图片、字符和背景色
always @(posedge pixel_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pixel_data1 <= 24'b111111111111111111;
    else if( (pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH) 
          && (pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) )
        pixel_data1 <= rom_rd_data ;  //显示图片
    else
        pixel_data1 <= 24'b111111111111111111;        //屏幕背景色
end

//根据当前扫描点的横纵坐标为ROM地址赋值
always @(posedge pixel_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rom_addr <= 16'd0;
    //当横纵坐标位于图片显示区域时,累加ROM地址    
    else if((pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) 
        && (pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH)) 
        rom_addr <= rom_addr + 1'b1;
    //当横纵坐标位于图片区域最后一个像素点时,ROM地址清零    
    else if((pixel_ypos >= PIC_Y_START + PIC_HEIGHT))
        rom_addr <= 16'd0;
end
always @(posedge pixel_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rom_addr1 <= 16'd0;
    //当横纵坐标位于图片显示区域时,累加ROM地址    
    else if((pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) 
        && (pixel_xpos >= PIC_X_START+300) && (pixel_xpos < PIC_X_START + PIC_WIDTH+300)) 
        rom_addr1 <= rom_addr1 + 1'b1;
    //当横纵坐标位于图片区域最后一个像素点时,ROM地址清零    
    else if((pixel_ypos >= PIC_Y_START + PIC_HEIGHT))
        rom_addr1 <= 16'd0;
end
//ROM：存储图片
blk_mem_gen_0  blk_mem_gen_0 (
  .clka  (pixel_clk),    // input wire clka
  .ena   (rom_rd_en),   // input wire ena
  .addra (rom_addr),    // input wire [13 : 0] addra
  .douta (rom_rd_data)  // output wire [23 : 0] douta
);
blk_mem_gen_1  blk_mem_gen_1 (
  .clka  (pixel_clk),    // input wire clka
  .ena   (rom_rd_en),   // input wire ena
  .addra (rom_addr1),    // input wire [13 : 0] addra
  .douta (rom_rd_data1)  // output wire [23 : 0] douta
);
cov_sobel  cov_sobel (
  .clk  (pixel_clk),    // input wire clka
  .rst_n   (sys_rst_n),   // input wire ena
  .pixel_x (pixel_xpos),    // input wire [13 : 0] addra
  .pixel_y (pixel_ypos),  // output wire [23 : 0] douta
  .rgb_data    (pixel_data1),
  .k_sobel_out  (pixel_data2)
);
erosion erosion(
.clk(pixel_clk),
.rst_n(sys_rst_n),
.pixel_x(pixel_xpos),
.pixel_y(pixel_ypos),
.rgb_data(pixel_data2),
.k_sobel_out(pixel_data3)
    );
expansion expansion(
.clk(pixel_clk),
.rst_n(sys_rst_n),
.pixel_x(pixel_xpos),
.pixel_y(pixel_ypos),
.rgb_data(pixel_data3),
.k_sobel_out(pixel_data4)
    );
 always @(posedge pixel_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pixel_data <= 24'b111111111111111111111111;
    else if( (pixel_xpos >= PIC_X_START+10) && (pixel_xpos < PIC_X_START + PIC_WIDTH-10) 
          && (pixel_ypos >= PIC_Y_START+10) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT-10) )
        pixel_data <= pixel_data4 ;  //显示图片
    else if( (pixel_xpos >= PIC_X_START+300) && (pixel_xpos < PIC_X_START + PIC_WIDTH+300) 
          && (pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) )
        pixel_data <= rom_rd_data1 ;  //显示图片
    else
        pixel_data <= 24'b111111111111111111111111;        //屏幕背景色
end
endmodule 