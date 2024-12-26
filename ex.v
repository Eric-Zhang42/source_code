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

    input wire now_in_delayslot_i,                  //��ǰָ���Ƿ����ӳٲ�ָ��
    input wire [`InstAddrBus] return_addr_i,         //���ص�ַ

    // HILOģ�����HI,LO�Ĵ�����ֵ
    input wire[`RegBus] hi_i,
    input wire[`RegBus] lo_i,

    //��HILO������ؿ������ݴ�����
    input wire[`RegBus] wb_hi_i,
    input wire[`RegBus] wb_lo_i,
    input wire wb_whilo_i,
    input wire[`RegBus] mem_hi_i,
    input wire[`RegBus] mem_lo_i,
    input wire mem_whilo_i,

    //ִ�к���
    output reg[`RegAddrBus] waddr_reg_o,            //дĿ��Ĵ�����ַ
    output reg we_reg_o,                            //дʹ���ź�
    output reg[`RegBus] wdata_o,                     //����������

    output reg stallreq_o,                           //��ͣ�����ź�

    //HILOд��ص����
    output reg[`RegBus] hi_o,
    output reg[`RegBus] lo_o,
    output reg whilo_o
);

//�����߼�����Ľ��
reg[`RegBus] logicout;
//��λ������
reg[`RegBus] shiftres;
//�ƶ��������
reg[`RegBus] moveres;
//HI�Ĵ�������ֵ
reg[`RegBus] HI;
//LO�Ĵ�������ֵ
reg[`RegBus] LO;


//***************************************************************************************************//
//*******************************�õ�����HILO��ֵ������������****************************************//
//***************************************************************************************************//

always@(*) begin
    if(rst == `RstEnable) begin
        {HI,LO} = {`ZeroWord,`ZeroWord};
    end
    else if(mem_whilo_i == `WriteEnable) begin
        {HI,LO} = {mem_hi_i,mem_lo_i};
    end
    else if(wb_whilo_i == `WriteEnable) begin
        {HI,LO} = {wb_hi_i,wb_lo_i};
    end
    else begin
        {HI,LO} = {hi_i,lo_i};
    end
end

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
            `EXE_SLL_OP: begin
                shiftres = (rdata2_i << rdata1_i[4:0]);
            end
            `EXE_SRL_OP: begin
                shiftres = (rdata2_i >> rdata1_i[4:0]);
            end
            `EXE_SRA_OP: begin
                shiftres = ({32{rdata2_i[31]}}<<(6'd32-{1'b0,rdata1_i[4:0]})) | rdata2_i >> rdata1_i[4:0]; 
            end
            default: begin
                shiftres = `ZeroWord;
            end
        endcase
    end
end

always@(*) begin
    if(rst == `RstEnable) begin
        moveres = `ZeroWord;
    end
    else begin
        moveres = `ZeroWord;
        case(aluop_i)
            `EXE_MFHI_OP: begin
                moveres = HI;
            end
            `EXE_MFLO_OP: begin
                moveres = LO;
            end
            `EXE_MOVZ_OP: begin
                moveres = rdata1_i;
            end
            `EXE_MOVN_OP: begin
                moveres = rdata1_i;
            end
            default: begin
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
        `EXE_RES_MOVE: begin
            wdata_o = moveres;
        end
        `EXE_RES_JUMP_BRANCH: begin     //��ת������ͣ�������תǰλ�ô���ָ�����ڵ�ַ
            wdata_o = return_addr_i;
        end
        default: begin
            wdata_o = `ZeroWord;
        end
    endcase
end

//��ͣ�����ź�
always @(*)begin
    if(rst == `RstEnable)begin
        stallreq_o = `NoStop;
    end
    else begin
        stallreq_o = `NoStop;
    end
end




//***************************************************************************************************//
//*******************************����LO��HI��ؽ��***************************************************//
//***************************************************************************************************//

always@(*) begin
    if(rst == `RstEnable) begin
        whilo_o = `WriteDisable;
        hi_o = `ZeroWord;
        lo_o = `ZeroWord;
    end
    else if(aluop_i == `EXE_MTLO_OP) begin
        whilo_o = `WriteEnable;
        hi_o = HI;                  
        lo_o = rdata1_i;
    end
    else if(aluop_i == `EXE_MTHI_OP) begin
        whilo_o = `WriteEnable;
        hi_o = rdata1_i;
        lo_o = LO;
    end
    else begin
        whilo_o = `WriteDisable;
        hi_o = `ZeroWord;
        lo_o = `ZeroWord;
    end
end


endmodule

//����Ĵ����ŵ㣺����logicout��shiftres����������
//�ֱ𱣴��߼��������λ����Ľ����Ȼ����ݲ�ͬ���������ͣ�ѡ��ͬ�Ľ�������
//�����Ĵ���ṹ��������Ƕ�׵�case�����������Σ�ʹ�ô���Ŀɶ��ԺͿ�ά���Զ��кܴ����ߡ�
//���ǲ�������idģ�飬��Ϊ�Ǳ��������̫���ˣ����˴�exģ��ֻ��1��������������Կ�������д��