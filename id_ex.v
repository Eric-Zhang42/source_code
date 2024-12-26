
`include "defines.v"

module id_ex(
    input clk,
    input rst,

    //ȡ����׶���Ϣ
    input wire[`AluOpBus] id_aluop_i,
    input wire[`AluSelBus] id_alusel_i,
    input wire[`RegBus] id_rdata1_i,
    input wire[`RegBus] id_rdata2_i,
    input wire[`RegAddrBus] id_waddr_reg_i,
    input wire id_we_reg_i,

    input wire id_now_in_delayslot_i,   //��ǰָ���Ƿ����ӳٲ�ָ��
    input wire id_next_in_delayslot_i,  //��һ��ָ���Ƿ����ӳٲ�ָ��
    input wire [`InstAddrBus] id_return_addr_i,        //���ص�ַ

    //��ͣ�ź�
    input wire[`StallBus] stall,

    //��ִ�н׶���Ϣ
    output reg[`AluOpBus] ex_aluop_o,
    output reg[`AluSelBus] ex_alusel_o,
    output reg[`RegBus] ex_rdata1_o,
    output reg[`RegBus] ex_rdata2_o,
    output reg[`RegAddrBus] ex_waddr_reg_o,
    output reg ex_we_reg_o,

    output reg ex_now_in_delayslot_o,   //��ǰָ���Ƿ����ӳٲ�ָ����ݸ�ִ�н׶�
    output reg [`InstAddrBus] ex_return_addr_o,        //���ص�ַ

    //���ظ�����׶���Ϣ
    output reg now_in_delayslot_o       //��ǰָ���Ƿ����ӳٲ�ָ����ظ�����׶�

);

always@(posedge clk) begin
    if(rst == `RstEnable) begin
        ex_aluop_o <= `EXE_NOP_OP;
        ex_alusel_o <= `EXE_RES_NOP;
        ex_rdata1_o <= `ZeroWord;
        ex_rdata2_o <= `ZeroWord;
        ex_waddr_reg_o <= `NOPRegAddr;
        ex_we_reg_o <= `WriteDisable;

        ex_return_addr_o <= `ZeroWord;
        ex_now_in_delayslot_o <= `IsNotDelaySlot;
        now_in_delayslot_o <= `IsNotDelaySlot;
    end
    else if(stall[2] == `Stop) begin        //ִ�н׶���ͣ
        if(stall[3] == `NoStop)begin        //������׶β���ͣ
            ex_aluop_o <= `EXE_NOP_OP;
            ex_alusel_o <= `EXE_RES_NOP;
            ex_rdata1_o <= `ZeroWord;
            ex_rdata2_o <= `ZeroWord;
            ex_waddr_reg_o <= `NOPRegAddr;
            ex_we_reg_o <= `WriteDisable;

            ex_return_addr_o <= `ZeroWord;
            ex_now_in_delayslot_o <= `IsNotDelaySlot;
            now_in_delayslot_o <= `IsNotDelaySlot;
        end
        else begin                          //������׶���ͣ
            ex_aluop_o <= ex_aluop_o;
            ex_alusel_o <= ex_alusel_o;
            ex_rdata1_o <= ex_rdata1_o;
            ex_rdata2_o <= ex_rdata2_o;
            ex_waddr_reg_o <= ex_waddr_reg_o;
            ex_we_reg_o <= ex_we_reg_o;

            ex_return_addr_o <= ex_return_addr_o;
            ex_now_in_delayslot_o <= ex_now_in_delayslot_o;
        end
    end
    else begin                          //������������
        ex_aluop_o <= id_aluop_i;       
        ex_alusel_o <= id_alusel_i;
        ex_rdata1_o <= id_rdata1_i;
        ex_rdata2_o <= id_rdata2_i;
        ex_waddr_reg_o <= id_waddr_reg_i;
        ex_we_reg_o <= id_we_reg_i;

        ex_return_addr_o <= id_return_addr_i;
        ex_now_in_delayslot_o <= id_now_in_delayslot_i;     //���ݸ�ִ�н׶�
        now_in_delayslot_o <= id_next_in_delayslot_i;       //���ظ�����׶�
    end
end

endmodule