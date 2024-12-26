//���ļ���ΪMISP_CPU��Ŀ�ĺ궨��

//****************************  ȫ�ֺ궨��  **************************//
`define RstEnable           1'b1            //��λ�ź���Ч
`define RstDisable          1'b0            //��λ�ź���Ч
`define ZeroWord            32'h00000000    //32λ��ֵ0
`define WriteEnable         1'b1            //дʹ��
`define WriteDisable        1'b0            //д��ֹ
`define ReadEnable          1'b1            //��ʹ��
`define ReadDisable         1'b0            //����ֹ

`define AluOpBus            7:0             //����׶ε����aluop_o�����ݿ��
`define AluSelBus           2:0             //����׶ε����alusel_o�����ݿ��

`define InstValid           1'b0            //ָ����Ч
`define InstInvalid         1'b1            //ָ����Ч

`define True_df             1'b1            //�߼���  ?
`define False_df            1'b0            //�߼���
`define ChipEnable          1'b1            //оƬʹ��
`define ChipDisable         1'b0            //оƬ��ֹ

`define Stop                1'b1            //��ͣ
`define NoStop              1'b0            //����

//**************************    ����ת�йصĺ궨��    **********************//
`define JumpEnable          1'b1            //��תʹ��
`define JumpDisable         1'b0            //��ת��ֹ

`define IsDelaySlot         1'b1            //���ӳٲ�
`define IsNotDelaySlot      1'b0            //�����ӳٲ�

//**************************    ����ָ���йغ궨��  **********************//
//ָ���벿�ֵĺ궨��(��ǰ��6λ)
`define EXE_SPECIAL_INST    6'b000000       //����ָ����(���������߼�����)
`define EXE_NOP             6'b000000       //�ղ���nopָ����
`define EXE_PREF            6'b110011       //Ԥȡprefָ��ָ����            ?

`define EXE_ANDI            6'b001100       //��������andiָ����
`define EXE_ORI             6'b001101       //��������oriָ����
`define EXE_XORI            6'b001110       //���������xoriָ����
`define EXE_LUT             6'b001111       //����������lutָ����

//��תָ����
`define EXE_J               6'b000010       //��תָ����
`define EXE_JAL             6'b000011       //��ת������jalָ����

//��ָ֧����
`define EXE_BEQ             6'b000100       //��֧���beqָ����
`define EXE_BNE             6'b000101       //��֧����bneָ����
`define EXE_BLEZ            6'b000110       //��֧С�ڵ���blezָ����
`define EXE_BGTZ            6'b000111       //��֧����bgzָ����
`define EXE_REGIMM          6'b000001       //ʣ���ָ֧����
    //EXE_REGIMM��rt��
    `define EXE_BLTZ            5'b00000        //��֧С��bltzָ����
    `define EXE_BGEZ            5'b00001        //��֧���ڵ���bgezָ����
    `define EXE_BLTZAL          5'b10000        //��֧С��bltzalָ����
    `define EXE_BGEZAL          5'b10001        //��֧���ڵ���bgezalָ����

//���ش洢ָ����
`define EXE_LB              6'b100000       //����lbָ����
`define EXE_LBU             6'b100100       //����lbuָ����
`define EXE_LH              6'b100001       //����lhָ����
`define EXE_LHU             6'b100101       //����lhuָ����
`define EXE_LW              6'b100011       //����lwָ����
`define EXE_SB              6'b101000       //�洢sbָ����
`define EXE_SH              6'b101001       //�洢shָ����
`define EXE_SW              6'b101011       //�洢swָ����

//�����벿�ֵĺ궨��(���6λ)
`define EXE_FUN_AND         6'b100100       //andָ�����
`define EXE_FUN_OR          6'b100101       //orָ�����
`define EXE_FUN_XOR         6'b100110       //xorָ�����
`define EXE_FUN_NOR         6'b100111       //norָ�����

`define EXE_FUN_SLL         6'b000000       //�߼�����sllָ�����
`define EXE_FUN_SLLV        6'b000100       //�߼�����sllvָ�����
`define EXE_FUN_SRL         6'b000010       //�߼�����srlָ�����
`define EXE_FUN_SRLV        6'b000110       //�߼�����srlvָ�����
`define EXE_FUN_SRA         6'b000011       //��������sraָ�����
`define EXE_FUN_SRAV        6'b000111       //��������sravָ�����
`define EXE_FUN_SYNC        6'b001111       //ͬ��syncָ�����            ?

`define EXE_FUN_MOVZ        6'b001010       //����0�ƶ�ָ��
`define EXE_FUN_MOVN        6'b001011       //������0�ƶ�ָ��
`define EXE_FUN_MFHI        6'b010000       //��HI�ƶ�����ָ��
`define EXE_FUN_MTHI        6'b010001       //��HI�ƶ�����ָ��
`define EXE_FUN_MFLO        6'b010010       //��LO�ƶ�����ָ��
`define EXE_FUN_MTLO        6'b010011       //��LO�ƶ�����ָ��

//��ת������
`define EXE_FUN_JR           6'b001000       //��תָ�����
`define EXE_FUN_JALR         6'b001001       //��ת������jalָ�����

//**************************    ��ALU�йصĺ궨��    **********************//
//ALUOP���ֵĺ궨��
`define EXE_NOP_OP          8'b00000000     //?��SLL�ظ���
`define EXE_OR_OP           8'b00100101     //���Ǹ��ݹ�����ǰ������0����
`define EXE_AND_OP          8'b00100100
`define EXE_XOR_OP          8'b00100110
`define EXE_NOR_OP          8'b00100111
`define EXE_SLL_OP          8'b00000000
`define EXE_SRL_OP          8'b00000010
`define EXE_SRA_OP          8'b00000011
`define EXE_JR_OP           8'b00001000
`define EXE_JALR_OP         8'b00001001

`define EXE_MOVZ_OP        6'b00001010       
`define EXE_MOVN_OP        6'b00001011       
`define EXE_MFHI_OP        6'b00010000       
`define EXE_MTHI_OP        6'b00010001       
`define EXE_MFLO_OP        6'b00010010       
`define EXE_MTLO_OP        6'b00010011   

//ALUSEL���ֵĺ궨��
`define EXE_RES_NOP         3'b000
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_SHIFT       3'b010
`define EXE_RES_JUMP_BRANCH 3'b011          //���ܺ����������ظ�����Ҫ��
`define EXE_RES_MOVE        3'b100
`define EXE_RES_LOAD_STORE  3'b101          //���ܺ����������ظ�����Ҫ��

//**************************    ��ô�׶��йصĺ궨��    **********************//
`define AluOpBus            7:0             //ALU�Ĳ�������
`define SelBus              3:0             //RAM��ѡ���źſ��
//�ô�׶εĲ����룬����غʹ洢�й�
`define MEM_LB_OP           8'b00010000
`define MEM_LBU_OP          8'b00010001
`define MEM_LH_OP           8'b00010010
`define MEM_LHU_OP          8'b00010011
`define MEM_LW_OP           8'b00010100
`define MEM_SB_OP           8'b00011000
`define MEM_SH_OP           8'b00011001
`define MEM_SW_OP           8'b00011010


//**************************    ��ָ��洢��ROM�йصĺ궨��     *****************//
`define InstAddrBus         31:0            //ROM�ĵ�ַ���߿��
`define InstBus             31:0            //ROM���������߿��(�ֳ�32 width)
`define InstMenNum          1023            //ROM������1023 (depth)
`define InstMemNumLog2      10              //ROMʵ��ʹ�õĵ�ַ�߿��

//**************************    �����ݴ洢��RAM�йصĺ궨��     *****************//
`define DataAddrBus         31:0            //RAM�ĵ�ַ���߿��(�ٵģ���ʵ��17λ����32λ��ֻ��Ϊ�˷���)
`define DataBus             31:0            //RAM���������߿��
`define DataMemNum          1024            //RAM������1024 (depth)
`define DataMemNumLog2      10              //RAMʵ��ʹ�õĵ�ַ�߿��
`define ByteWidth           7:0             //һ���ֽڵĿ��

//*************************     ��ͨ�üĴ���regs�йصĺ궨��    *******************//
`define RegAddrBus          4:0             //Regsģ��ĵ�ַ�߿��
`define RegBus              31:0            //regsģ��������߿��
`define RegWidth            32              //ͨ�üĴ������
`define DoubleRegWidth      64              //������ͨ�üĴ����Ŀ��
`define DoubleRegBus        63:0            //������ͨ�üĴ��������߿��
`define RegNum              32              //ͨ�üĴ�������
`define RegNumLog2          5               //ͨ�üĴ���ʹ�õĵ�ַλ��
`define NOPRegAddr          5'b00000        //

//*************************     ����ͣ��ˮ��ctrlģ���йصĺ궨��    *******************//
`define StallBus            5:0             //��ͣ��ˮ�ߵĿ����źſ��
