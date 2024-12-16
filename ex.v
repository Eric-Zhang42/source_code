`include "defines.v"

module ex(
    input rst,
    
    //���������
    input wire[`AluOpBus] aluop_i,                  //����������
    input wire[`AluSelBus] alusel_i,                //��������
    input wire[`RegBus] rdata1_i,                   //������1
    input wire[`RegBus] rdata2_i,                   //������2
    input wire[`RegAddrBus] waddr_reg_i,            //дĿ��Ĵ�����ַ
    input wire we_reg_i,                            //дʹ���ź�

    //ִ�к���
    output reg[`RegAddrBus] waddr_reg_o,            //дĿ��Ĵ�����ַ
    output reg we_reg_o,                            //дʹ���ź�
    output reg[`RegBus] wdata_o                     //����������

);

//�����߼�����Ľ��
reg[`RegBus] logicout;
reg[`RegBus] shiftres;

//***************************************************************************************************//
//*******************************��������������aluop_i���м���*****************************************//
//***************************************************************************************************//

always@(*) begin
    if(rst == `RstEnable) begin
        logicout = `ZeroWord;
    end
    else begin
        case(aluop_i) 
            `EXE_OR_OP: begin                                   //������
                logicout = rdata1_i | rdata2_i;
            end
            `EXE_AND_OP: begin                                  //������
                logicout = rdata1_i & rdata2_i;
            end
            `EXE_NOR_OP: begin
                logicout = ~(rdata1_i | rdata2_i);
            end
            `EXE_XOR_OP: begin                                  //�������
                logicout = rdata1_i ^ rdata2_i;
            end
            default: begin
                logicout = `ZeroWord;
            end
        endcase
    end
end

always@(*) begin
    if(rst == `RstEnable) begin
        shiftres = `ZeroWord;
    end
    else begin
        case(aluop_i) 
            `EXE_SLL_OP: begin                                   //�߼�����
                shiftres = rdata1_i << rdata2_i[4:0];
                                                // rdata1_i��Ҫ�������Ʋ�������ֵ��
                                                // rdata2_i�����Ƶ�λ����
            end
            `EXE_SRL_OP: begin                                  //�߼�����
                shiftres = rdata1_i >> rdata2_i[4:0];
            end
            `EXE_SRA_OP: begin                                  //��������
                // shiftres = rdata1_i >>> rdata2_i[4:0];
                shiftres = ({32{rdata2_i[31]}}<<(6'd32-{1'b0,rdata1_i[4:0]})) | rdata2_i >> rdata1_i[4:0]; //�����㷨
            end
            default: begin
                shiftres = `ZeroWord;
            end
        endcase
    end
end

//***************************************************************************************************//
//*******************************������������alusel_iѡ��������**************************************//
//***************************************************************************************************//

always@(*) begin
    waddr_reg_o = waddr_reg_i;
    we_reg_o = we_reg_i;                                //дĿ���ַ��дʹ���ź�ֱ��ͨ��
    case(alusel_i) 
        `EXE_RES_LOGIC: begin           //�߼���������
            wdata_o = logicout;
        end
        `EXE_RES_SHIFT: begin           //��λ��������
            wdata_o = shiftres;
        end
        default: begin
            wdata_o = `ZeroWord;
        end
    endcase
end

endmodule

//����Ĵ����ŵ㣺����logicout��shiftres����������
//�ֱ𱣴��߼��������λ����Ľ����Ȼ����ݲ�ͬ���������ͣ�ѡ��ͬ�Ľ�������
//�����Ĵ���ṹ��������Ƕ�׵�case�����������Σ�ʹ�ô���Ŀɶ��ԺͿ�ά���Զ��кܴ����ߡ�
//���ǲ�������idģ�飬��Ϊ�Ǳ��������̫���ˣ����˴�exģ��ֻ��1��������������Կ�������д��