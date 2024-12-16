`include "defines.v"

module my_mips_cpu(
    input rst,
    input clk,
    input wire[`RegBus] rom_data_i,
    output wire[`RegBus] rom_addr_o,
    output rom_ce_o
);

//****************************************************************//
//**************************�˿ڶ���*******************************//
//****************************************************************//

//����if/idģ����idģ��
wire [`InstAddrBus] pc;
wire [`InstAddrBus] if_id2id__pc;
wire [`InstBus] if_id2id__inst;


//����idģ����id/exģ��
wire [`AluOpBus] id2id_ex__aluop;
wire [`AluSelBus] id2id_ex__alusel;
wire [`RegBus] id2id_ex__rdata1;
wire [`RegBus] id2id_ex__rdata2;
wire id2id_ex__we_reg;
wire [`RegAddrBus] id2id_ex__waddr_reg;
wire id2id_ex__now_in_delayslot;
wire id2id_ex__next_in_delayslot;
wire [`RegAddrBus] id2id_ex__return_addr;
wire id_ex2id__now_in_delayslot;


//����exģ����idģ��
wire ex2id__we_reg;
wire [`RegBus] ex2id__wdata;
wire [`RegAddrBus] ex2id__waddr_reg;


//����memģ����idģ��
wire mem2id__we_reg;
wire [`RegBus] mem2id__wdata;
wire [`RegAddrBus] mem2id__waddr_reg;


//����idģ����regfileģ��
wire id2regfile__re1;
wire id2regfile__re2;
wire [`RegBus] regfile2id__rdata1;
wire [`RegBus] regfile2id__rdata2;
wire [`RegAddrBus] id2regfile__raddr1;
wire [`RegAddrBus] id2regfile__raddr2;


//����id/exģ����exģ��
wire [`AluOpBus] id_ex2ex__aluop;
wire [`AluSelBus] id_ex2ex__alusel;
wire [`RegBus] id_ex2ex__rdata1;
wire [`RegBus] id_ex2ex__rdata2;
wire [`RegAddrBus] id_ex2ex__waddr_reg;
wire id_ex2ex__we_reg;


//����exģ��ex/memģ��
wire ex2ex_mem__we_reg;
wire [`RegAddrBus] ex2ex_mem__waddr_reg;
wire [`RegBus] ex2ex_mem__wdata;


//����ex/mem��memģ��
wire ex_mem2mem__we_reg;
wire [`RegAddrBus] ex_mem2mem__waddr_reg;
wire [`RegBus] ex_mem2mem__wdata;


//����memģ����mem/wbģ��
wire mem2mem_wb__we_reg;
wire [`RegAddrBus] mem2mem_wb__waddr_reg;
wire [`RegBus] mem2mem_wb__wdata;


//����mem/wb��regfileģ��
wire mem_wb2regfile__we;
wire [`RegAddrBus] mem_wb2regfile__waddr;
wire [`RegBus] mem_wb2regfile__wdata;

//����id��pcģ��
wire [`RegAddrBus] id2pc__branch_target_addr;
wire id2pc__branch_flag;

//****************************************************************//
//**************************ʵ����ģ��*****************************//
//****************************************************************//

//pc_regʵ����
(*DONT_TOUCH = "yes"*)pc_reg pc_reg_inst0(
    .clk(clk),
    .rst(rst),
    .branch_target_addr_i(id2pc__branch_target_addr),
    .branch_flag_i(id2pc__branch_flag),
    // <-in out->
    .pc(pc),
    .ce(rom_ce_o)
);


//ָ��洢�������ַrom_addr_o����pc
assign rom_addr_o = pc;


//if/idʵ����
(*DONT_TOUCH = "yes"*)if_id if_id_inst0(
    .clk(clk),
    .rst(rst),
    .if_pc(pc),
    .if_inst(rom_data_i),
    .id_pc(if_id2id__pc),
    .id_inst(if_id2id__inst)
);


// idʵ����
(*DONT_TOUCH = "yes"*) id id_inst0(
    .rst(rst),
    .pc_i(if_id2id__pc),
    .inst_i(if_id2id__inst),

    // �����ļĴ���ֵ
    .rdata1_i(regfile2id__rdata1),
    .rdata2_i(regfile2id__rdata2),

    // ִ�н׶�������
    .ex_we_reg_i(ex2id__we_reg),
    .ex_wdata_i(ex2id__wdata),
    .ex_waddr_reg_i(ex2id__waddr_reg),

    // �ô�׶ν��
    .mem_we_reg_i(mem2id__we_reg),
    .mem_wdata_i(mem2id__wdata),
    .mem_waddr_reg_i(mem2id__waddr_reg),

    //��ǰ�Ƿ�Ϊ�ӳٲ�ָ��
    .now_in_delayslot_i(id_ex2id__now_in_delayslot),

    //<-in out->                      

    // ���Ĵ����ѵĿ����ź�
    .raddr1_o(id2regfile__raddr1),
    .raddr2_o(id2regfile__raddr2),
    .re1_o(id2regfile__re1),
    .re2_o(id2regfile__re2),

    // �͸�ִ�н׶ε�����
    .aluop_o(id2id_ex__aluop),
    .alusel_o(id2id_ex__alusel),
    .rdata1_o(id2id_ex__rdata1),
    .rdata2_o(id2id_ex__rdata2),
    .waddr_reg_o(id2id_ex__waddr_reg),
    .we_reg_o(id2id_ex__we_reg),

    ////��ȡָ�׶Σ�����ʵ����ת
    .branch_flag_o(id2pc__branch_flag),
    .branch_target_addr_o(id2pc__branch_target_addr),

    //������һ�׶���һ��ָ���Լ���ǰָ���Ƿ�Ϊ�ӳٲ�
    .next_in_delayslot_o(id2id_ex__next_in_delayslot),
    .now_in_delayslot_o(id2id_ex__now_in_delayslot),
    //��ת�ɹ�����ܻ᷵�ص�ǰ��һ�����ĵ�ַ
    .return_addr_o(id2id_ex__return_addr)
);


//��exģ������Լ�memģ��������ӵ�idģ��
assign ex2id__we_reg = ex2ex_mem__we_reg;
assign ex2id__wdata = ex2ex_mem__wdata;
assign ex2id__waddr_reg = ex2ex_mem__waddr_reg;
assign mem2id__we_reg = ex_mem2mem__we_reg;
assign mem2id__wdata = ex_mem2mem__wdata;
assign mem2id__waddr_reg = ex_mem2mem__waddr_reg;


//regfileʵ����
(*DONT_TOUCH = "yes"*)regfile regfile_inst0(
    .clk(clk),
    .rst(rst),

    .we(mem_wb2regfile__we),
    .waddr(mem_wb2regfile__waddr),
    .wdata(mem_wb2regfile__wdata),
    .re1(id2regfile__re1),
    .re2(id2regfile__re2),
    .raddr1(id2regfile__raddr1),
    .raddr2(id2regfile__raddr2),

    .rdata1(regfile2id__rdata1),
    .rdata2(regfile2id__rdata2)
);


//id/exʵ����
(*DONT_TOUCH = "yes"*)id_ex id_ex_inst0(
    .clk(clk),
    .rst(rst),

    .id_aluop_i(id2id_ex__aluop),
    .id_alusel_i(id2id_ex__alusel),
    .id_rdata1_i(id2id_ex__rdata1),
    .id_rdata2_i(id2id_ex__rdata2),
    .id_waddr_reg_i(id2id_ex__waddr_reg),
    .id_we_reg_i(id2id_ex__we_reg),

    //<-in out->

    .ex_aluop_o(id_ex2ex__aluop),
    .ex_alusel_o(id_ex2ex__alusel),
    .ex_rdata1_o(id_ex2ex__rdata1),
    .ex_rdata2_o(id_ex2ex__rdata2),
    .ex_waddr_reg_o(id_ex2ex__waddr_reg),
    .ex_we_reg_o(id_ex2ex__we_reg),

    .now_in_delayslot_o(id_ex2id__now_in_delayslot)
);


//exʵ����
(*DONT_TOUCH = "yes"*) ex ex_inst0(
    .rst(rst),

    .aluop_i(id_ex2ex__aluop),
    .alusel_i(id_ex2ex__alusel),
    .rdata1_i(id_ex2ex__rdata1),
    .rdata2_i(id_ex2ex__rdata2),
    .waddr_reg_i(id_ex2ex__waddr_reg),
    .we_reg_i(id_ex2ex__we_reg),
    
    .waddr_reg_o(ex2ex_mem__waddr_reg),
    .we_reg_o(ex2ex_mem__we_reg),
    .wdata_o(ex2ex_mem__wdata)
);


// ex/memʵ����
(*DONT_TOUCH = "yes"*)ex_mem ex_mem_inst0(
    .clk(clk),
    .rst(rst),
    .ex_waddr_reg_i(ex2ex_mem__waddr_reg),
    .ex_we_reg_i(ex2ex_mem__we_reg),
    .ex_wdata_i(ex2ex_mem__wdata),
    .mem_waddr_reg_o(ex_mem2mem__waddr_reg),
    .mem_we_reg_o(ex_mem2mem__we_reg),
    .mem_wdata_o(ex_mem2mem__wdata)
);


// memʵ����
(*DONT_TOUCH = "yes"*) mem mem_inst0(
    .rst(rst),
    .waddr_reg_i(ex_mem2mem__waddr_reg),
    .we_reg_i(ex_mem2mem__we_reg),
    .wdata_i(ex_mem2mem__wdata),
    .waddr_reg_o(mem2mem_wb__waddr_reg),
    .we_reg_o(mem2mem_wb__we_reg),
    .wdata_o(mem2mem_wb__wdata)
);


// mem/wbʵ����
(*DONT_TOUCH = "yes"*)mem_wb mem_wb_inst0(
    .clk(clk),
    .rst(rst),
    .mem_waddr_reg_i(mem2mem_wb__waddr_reg),
    .mem_we_reg_i(mem2mem_wb__we_reg),
    .mem_wdata_i(mem2mem_wb__wdata),
    
    .wb_waddr_reg_o(mem_wb2regfile__waddr),
    .wb_we_reg_o(mem_wb2regfile__we),
    .wb_wdata_o(mem_wb2regfile__wdata)
);


endmodule