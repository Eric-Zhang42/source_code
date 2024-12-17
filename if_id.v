
`include "defines.v"

module if_id(   //ȡָ��׶� instruction fetch to instruction decode
    input clk,
    input rst,
    input wire[`InstAddrBus] if_pc, //ָ���ַ
    input wire[`InstBus] if_inst,   //ָ�����ָ��洢��
    input wire[`StallBus] stall,    //��ͣ�ź�

    output reg[`InstAddrBus] id_pc, 
    output reg[`InstBus] id_inst
);
    reg [`InstAddrBus] pc_temp;  //��ʱ�洢pc��Ϊ�˵���ָ����rom_program��������һ��ʱ�ӵ��ӳ٣�Ҳ��pc��һ���ӳ�
    always@(posedge clk) begin
        if(rst == `RstEnable) begin
            pc_temp <= `ZeroWord;
        end
        else begin
            pc_temp <= if_pc;
        end
    end

    always@(posedge clk) begin 
        if(rst == `RstEnable) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else if(stall[1] == `Stop) begin    //��ȡָ��ͣ
            if(stall[2] == `NoStop) begin   //���벻��ͣ�������ָ�� ?��ʲô���������������һ��ָ�
                id_pc <= `ZeroWord;
                id_inst <= `ZeroWord;
            end
            else begin                      //������ͣ�����ָ��ά�ֲ���
                id_pc <= id_pc;
                id_inst <= id_inst;
            end
        end
        else begin  //����ȡָ
            id_pc <= pc_temp;
            id_inst <= if_inst;
        end
    end

endmodule