`include "defines.v"

module ctrl(
    input wire rst,
    input wire stallreq_from_id,//��������׶ε���ͣ����
    input wire stallreq_from_ex, //����ִ�н׶ε���ͣ����

    output reg[`StallBus] stall       //��ͣ��ˮ�ߵĿ����ź�
);

always @ (*)begin
    if(rst == `RstEnable) begin                     //��λ�ź���Ч����ˮ�߲���ͣ
        stall =6'b000000;
    end 
    else if(stallreq_from_ex == `Stop) begin        //ִ�н׶���ͣ����ִ�н׶μ���ǰ�ĸ��׶ξ���ͣ������ĸ��׶μ�������
        stall =6'b001111;
    end 
    else if(stallreq_from_id == `Stop) begin        //����׶���ͣ����
        stall = 6'b000111;
    end
    else begin
        stall =6'b000000;
    end
end
endmodule