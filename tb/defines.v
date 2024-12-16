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


//**************************    ����ָ���йغ궨��  **********************//
//ָ���벿�ֵĺ궨��(��ǰ��6λ)
`define EXE_SPECIAL_INST    6'b000000       //����ָ����(���������߼�����)
`define EXE_NOP             6'b000000       //�ղ���nopָ����
`define EXE_PREF            6'b110011       //Ԥȡprefָ��ָ����            ?

`define EXE_ANDI            6'b001100       //��������andiָ����
`define EXE_ORI             6'b001101       //��������oriָ����
`define EXE_XORI            6'b001110       //���������xoriָ����
`define EXE_LUT             6'b001111       //����������lutָ����

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

//**************************    ��ALU�йصĺ궨��    **********************//
//ALUOP���ֵĺ궨��
`define EXE_OR_OP           8'b00100101     //���Ǹ��ݹ�����ǰ������0����
`define EXE_NOP_OP          8'b00000000
`define EXE_AND_OP          8'b00100100
`define EXE_XOR_OP          8'b00100110
`define EXE_NOR_OP          8'b00100111
`define EXE_SLL_OP          8'b00000000
`define EXE_SRL_OP          8'b00000010
`define EXE_SRA_OP          8'b00000011

//ALUSEL���ֵĺ궨��
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_NOP         3'b000
`define EXE_RES_SHIFT       3'b010


//**************************    ��ָ��洢��ROM�йصĺ궨��     *****************//
`define InstAddrBus         31:0            //ROM�ĵ�ַ���߿��
`define InstBus             31:0            //ROM���������߿��(�ֳ�32 width)
`define InstMenNum          1023            //ROM������1023 (depth)
`define InstMemNumLog2      10              //ROMʵ��ʹ�õĵ�ַ�߿��


//*************************     ��ͨ�üĴ���regs�йصĺ궨��    *******************//
`define RegAddrBus          4:0             //Regsģ��ĵ�ַ�߿��
`define RegBus              31:0            //regsģ��������߿��
`define RegWidth            32              //ͨ�üĴ������
`define DoubleRegWidth      64              //������ͨ�üĴ����Ŀ��
`define DoubleRegBus        63:0            //������ͨ�üĴ��������߿��
`define RegNum              32              //ͨ�üĴ�������
`define RegNumLog2          5               //ͨ�üĴ���ʹ�õĵ�ַλ��
`define NOPRegAddr          5'b00000        //
