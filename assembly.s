ori $4,$0,0x0001    //1
beq             //2
ori $4,$0,0x0002
ori $4,$0,0x1111
ori $4,$0,0x1100
label1:ori $4,$0,0x0003 //3
jal label2          //4
ori $5, $0, 0x0101  //6 
ori $4, $0, 0x0005  //7
ori $4, $0, 0x0006  //8
j label3            //9
nop
label2:jalr $2, $31 //5£¿
or $4, $2, $0
ori $4, $0, 0x0009
label3:ori $4, $0, 0x0007//10
jr $2
ori $4, $0, 0x0008
ori $4, $0, 0x1111
ori $4, $0, 0x1100
labelnop:nop