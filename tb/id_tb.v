`timescale 1ns/1ns
`include "defines.v"

module id_tb;

reg clk;
reg rst;

reg [`InstAddrBus] pc_i;                      //����ĳ��������ֵ
reg [`InstBus] inst_i;                        //�����ָ��

//�����ļĴ���ֵ
reg [`RegBus] rdata1_i;                       //�ӼĴ���������ֵ1
reg [`RegBus] rdata2_i;                       //�ӼĴ���������ֵ2

//���Ĵ����ѵĿ����ź�
wire re1_o;                                   //���˿�1�Ķ�ʹ���ź�
wire re2_o;                                   //���˿�2�Ķ�ʹ���ź�
wire[`RegAddrBus] raddr1_o;                   //���˿�1��Ŀ��Ĵ�����ַ
wire[`RegAddrBus] raddr2_o;                   //���˿�2��Ŀ��Ĵ�����ַ

//�͸�ִ�н׶ε�����
wire[`AluOpBus] aluop_o;                      //��alu���Ӳ�����
wire[`AluSelBus] alusel_o;                    //��alu�Ĳ�������
wire[`RegBus] rdata1_o;                       //�����Ĳ�����1������
wire[`RegBus] rdata2_o;                       //�����Ĳ�����2������
wire[`RegAddrBus] waddr_reg_o;                //Ҫд�ļĴ����ĵ�ַ
wire we_reg_o;   


//-----------ʵ��������ģ��-----------

id inst_id(
    rst,
    pc_i,                 
    inst_i,               

    //�����ļĴ���ֵ
    rdata1_i,             
    rdata2_i,             

    //���Ĵ����ѵĿ�����
    re1_o,                
    re2_o,                
    raddr1_o,             
    raddr2_o,             

    //�͸�ִ�н׶ε�����
    aluop_o,              
    alusel_o,             
    rdata1_o,             
    rdata2_o,             
    waddr_reg_o,          
    we_reg_o              
);

//-----------�������źŸ�ֵ-----------

always#5 clk = ~clk;

initial begin
    rst = 1;
    clk = 0;
    #50
    rst = 0;
end

always@(posedge clk) begin
end


endmodule