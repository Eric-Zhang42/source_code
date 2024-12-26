
`include "defines.v"

module regfile(
    input clk,
    input rst,

    //д�˿�
    input we,                                       //дʹ���ź�
    input wire[`RegAddrBus] waddr,                  //дĿ��Ĵ�����ַ
    input wire[`RegBus] wdata,                      //д�������

    //�������˿�
    input re1,                                      //�˿�1��ʹ���ź�
    input re2,                                      //�˿�2��ʹ���ź�
    input wire[`RegAddrBus] raddr1,                 //�˿�1��Ŀ��Ĵ�����ַ
    input wire[`RegAddrBus] raddr2,                 //�˿�2��Ŀ��Ĵ�����ַ
    output reg[`RegBus] rdata1,                     //�˿�1�����ļĴ�������
    output reg[`RegBus] rdata2,                     //�˿�2�����ļĴ�������

    input wire in,
    output wire out
);

//����32��32λ�Ĵ���
reg[`RegBus] regs[0:`RegNum-1]; 
//������ǰ���һ�����������к�32���ߣ���һ���Ĵ�����32λ��
//��������������ֱ�ʾ����ĸ�������32���Ĵ���

//д����
integer i = 0;
always@(posedge clk) begin
    if(rst == `RstEnable) begin
        for(i=0 ; i<`RegNum ; i = i+1) begin        //�����������forѭ������
            regs[i] <= `ZeroWord;                   //��λʱ��32���Ĵ���ȫ������
        end
    end
    else begin
        if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin                 //дʹ�ܣ����ǵ�һ���Ĵ�������һֱ���㣬�ų�д��ַΪ0���������Ϊ��ַΪ0�ļĴ�����ʾʼ�մ���0�ļĴ�������ʲô�ã�
            regs[waddr] <= wdata;
        end
        else begin
            regs[waddr] <= regs[waddr];                                             //��������±��ֲ���
        end
    end
end


//���˿�1�Ķ�����
always@(*) begin
    if(rst == `RstEnable) begin
        rdata1 = `ZeroWord;
    end
    else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin    //����ȡ�Ķ˿����ڱ�дʱ��ֱ�Ӷ�ȡд���ֵ
        rdata1 = wdata;  //��һ����������������ָ�������ݳ�ͻ
    end
    else if(re1 == `ReadEnable) begin
        rdata1 = regs[raddr1];
    end
    else begin
        rdata1 = `ZeroWord;                         //����ʹ�ܹرգ�Ĭ�����0
    end
end


//���˿�2�Ķ�����
always@(*) begin
    if(rst == `RstEnable) begin
        rdata2 = `ZeroWord;
    end
    else if((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin    //����ȡ�Ķ˿����ڱ�дʱ��ֱ�Ӷ�ȡд���ֵ
        rdata2 = wdata;
    end
    else if(re2 == `ReadEnable) begin
        rdata2 = regs[raddr2];
    end
    else begin
        rdata2 = `ZeroWord;
    end
end

assign out = regs[3][0];

endmodule
/*
���������ᵽ�����Ը�ֵ�ͷ������Ը�ֵ������
�����Ը�ֵ����ʱ���·��ʹ�õģ���Ƴ����ĵ�·����D��������
�������Ը�ֵ������ϵ�·��ʹ�õ�

ע��ʱ���·���ʱ����clk���ƣ���D��������д����ʱע��1. posedge clk, 2. <=��ֵ
ע�ⴿ��ϵ�·���ʱ��д����ʱע��1. always@(*), 2. =�����Ը�ֵ
*/