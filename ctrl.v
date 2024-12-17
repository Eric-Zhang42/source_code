`include "defines.v"

module ctrl(
    input wire rst,
    input wire stallreq_upstream_from_id,   //��������׶ε���ͣ���ε�����������תʱclear����һ����ָ�
    input wire stallreq_downstream_from_id, //��������׶ε���ͣ���ε�����(�����е㲻����)
    input wire stallreq_from_ex,            //����ִ�н׶ε���ͣ�����εģ�����

    output reg[`StallBus] stall       //��ͣ��ˮ�ߵĿ����ź�
);

always @ (*)begin
    if(rst == `RstEnable) begin                     //��λ�ź���Ч����ˮ�߲���ͣ
        stall =6'b000000;
    end 
    else if(stallreq_from_ex == `Stop) begin        //ִ�н׶���ͣ����ִ�н׶μ���ǰ�ĸ��׶ξ���ͣ������ĸ��׶μ�������
        stall =6'b001111;
    end 
    else if(stallreq_upstream_from_id == `Stop) begin        //����׶���ͣ���ε�����
        stall =6'b000010;
    end
    else if(stallreq_downstream_from_id == `Stop) begin        //����׶���ͣ���ε�����
        stall = 6'b000111;
    end
    else begin
        stall =6'b000000;
    end
end
endmodule