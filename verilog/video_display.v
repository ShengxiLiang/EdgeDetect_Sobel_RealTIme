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
    input             pixel_clk,     //ʱ��
    input             sys_rst_n,        //��λ���͵�ƽ��Ч                                
    input      [10:0] pixel_xpos,   //���ص������
    input      [10:0] pixel_ypos,   //���ص�������    
    output  reg[23:0] pixel_data    //���ص�����,
);                                   
                                     
//parameter define                   
localparam PIC_X_START = 11'd200;      //ͼƬ��ʼ�������
localparam PIC_Y_START = 11'd100;      //ͼƬ��ʼ��������
localparam PIC_WIDTH   = 11'd200;    //ͼƬ���
localparam PIC_HEIGHT  = 11'd200;    //ͼƬ�߶�                 
parameter  H_DISP = 11'd1280;                       //�ֱ���--��
parameter  V_DISP = 11'd720;                        //�ֱ���--��
reg [23:0]pixel_data1;
//reg define
reg   [127:0] char[31:0];  //�ַ�����
reg   [15:0]  rom_addr  ;  //ROM��ַ
reg   [15:0]  rom_addr1  ;  //ROM��ַ
//wire define   
wire  [10:0]  x_cnt;       //�����������
wire  [10:0]  y_cnt;       //�����������
wire          rom_rd_en ;  //ROM��ʹ���ź�
wire  [23:0]  rom_rd_data ;//ROM����
wire  [23:0]  rom_rd_data1 ;//ROM����
wire [23:0]pixel_data2;
wire [23:0]pixel_data3;
wire [23:0]pixel_data4;
//*****************************************************
//**                    main code
//*****************************************************


assign  rom_rd_en = 1'b1;                  //��ʹ�����ߣ���һֱ��ROM����

//ΪLCD��ͬ��ʾ�������ͼƬ���ַ��ͱ���ɫ
always @(posedge pixel_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pixel_data1 <= 24'b111111111111111111;
    else if( (pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH) 
          && (pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) )
        pixel_data1 <= rom_rd_data ;  //��ʾͼƬ
    else
        pixel_data1 <= 24'b111111111111111111;        //��Ļ����ɫ
end

//���ݵ�ǰɨ���ĺ�������ΪROM��ַ��ֵ
always @(posedge pixel_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rom_addr <= 16'd0;
    //����������λ��ͼƬ��ʾ����ʱ,�ۼ�ROM��ַ    
    else if((pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) 
        && (pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH)) 
        rom_addr <= rom_addr + 1'b1;
    //����������λ��ͼƬ�������һ�����ص�ʱ,ROM��ַ����    
    else if((pixel_ypos >= PIC_Y_START + PIC_HEIGHT))
        rom_addr <= 16'd0;
end
always @(posedge pixel_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        rom_addr1 <= 16'd0;
    //����������λ��ͼƬ��ʾ����ʱ,�ۼ�ROM��ַ    
    else if((pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) 
        && (pixel_xpos >= PIC_X_START+300) && (pixel_xpos < PIC_X_START + PIC_WIDTH+300)) 
        rom_addr1 <= rom_addr1 + 1'b1;
    //����������λ��ͼƬ�������һ�����ص�ʱ,ROM��ַ����    
    else if((pixel_ypos >= PIC_Y_START + PIC_HEIGHT))
        rom_addr1 <= 16'd0;
end
//ROM���洢ͼƬ
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
        pixel_data <= pixel_data4 ;  //��ʾͼƬ
    else if( (pixel_xpos >= PIC_X_START+300) && (pixel_xpos < PIC_X_START + PIC_WIDTH+300) 
          && (pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) )
        pixel_data <= rom_rd_data1 ;  //��ʾͼƬ
    else
        pixel_data <= 24'b111111111111111111111111;        //��Ļ����ɫ
end
endmodule 