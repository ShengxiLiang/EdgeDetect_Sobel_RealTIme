`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:07:56
// Design Name: 
// Module Name: asyn_rst_syn
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


module asyn_rst_syn(
    input clk,          //Ŀ��ʱ����
    input reset_n,      //�첽��λ������Ч
    
    output syn_reset    //����Ч
    );
    
//reg define
reg reset_1;
reg reset_2;
    
//*****************************************************
//**                    main code
//***************************************************** 
assign syn_reset  = reset_2;
    
//���첽��λ�źŽ���ͬ���ͷţ���ת���ɸ���Ч
always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        reset_1 <= 1'b1;
        reset_2 <= 1'b1;
    end
    else begin
        reset_1 <= 1'b0;
        reset_2 <= reset_1;
    end
end
    
endmodule