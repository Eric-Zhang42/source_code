//PCģ�����ȡָ����

`include "defines.v"

module pc_reg (
    input wire clk,
    input wire rst,
    input wire [`RegBus]branch_target_addr_i, //��ת��Ŀ���ַ
    input wire branch_flag_i,       //��תʹ��
    input wire [`StallBus] stall,         //��ͣ�ź�

    output reg[`InstAddrBus] pc,    //ָ��ĵ�ַ
    output reg ce                   //��ָ��Ĵ���rom_programģ���ʹ���ź�
);

//ָ��洢��ce
always @(posedge clk) begin
    if(rst == `RstEnable) begin
        ce <= `ChipDisable;                     //��λ��ʱ��ָ��洢������
    end
    else begin
        ce <= `ChipEnable;                      //��λ����ʹ��
    end
end

//pc���������
always@(posedge clk) begin
    if(ce == `ChipDisable) begin
        pc <= `ZeroWord;                        //��λʱ��pc����
    end
    else if(branch_flag_i == `JumpEnable)begin
        pc <= branch_target_addr_i;             //��תʱ��pc��ֵΪ��תĿ���ַ
    end
    else if(stall[0] == `Stop)begin
        pc <= pc;                               //��ͣʱ��pc����
    end
    else begin
        pc <= pc + 1;                           //��������ʱ��ʱ����Ч�ص���pc+4
    end
end

    
endmodule
//ע����ʱ���·����clk���ƣ���D������������д����ʱע��1. posedge clk, 2. <=��ֵ