grammar iloc;

program
  : (
			(DATA data)? TEXT procedures
			| (ilocInstruction)+
		)
	;

data
	: ( pseudoOp )*
	;

procedures
	: ( procedure )+
	;

procedure
	: frameInstruction (ilocInstruction)+
	;

ilocInstruction
	: (LABEL ':')? ( operation | LBRACKET operationList RBRACKET )
	;

frameInstruction
	: FRAME LABEL COMMA NUMBER (COMMA virtualReg)*
	;

operationList
  : operation (SEMICOLON operation)*
	;

operation
	 : (ADD virtualReg COMMA virtualReg ASSIGN virtualReg
    	| ADDI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| ANDI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| AND virtualReg COMMA virtualReg ASSIGN virtualReg
    	| C2C virtualReg ASSIGN virtualReg
    	| C2I virtualReg ASSIGN virtualReg
    	| CALL LABEL ( COMMA virtualReg )*
    	| CBR virtualReg ARROW LABEL
    	| CBRNE virtualReg ARROW LABEL
    	| CBR_LT virtualReg ARROW LABEL  LABEL
    	| CBR_LE virtualReg ARROW LABEL  LABEL
    	| CBR_EQ virtualReg ARROW LABEL  LABEL
    	| CBR_NE virtualReg ARROW LABEL  LABEL
    	| CBR_GT virtualReg ARROW LABEL  LABEL
    	| CBR_GE virtualReg ARROW LABEL  LABEL
    	| CLOADAI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| CLOADAO virtualReg COMMA virtualReg ASSIGN virtualReg
    	| CLOAD virtualReg ASSIGN virtualReg
    	| CMP_LT virtualReg COMMA virtualReg ASSIGN virtualReg
    	| CMP_LE virtualReg COMMA virtualReg ASSIGN virtualReg
    	| CMP_EQ virtualReg COMMA virtualReg ASSIGN virtualReg
    	| CMP_NE virtualReg COMMA virtualReg ASSIGN virtualReg
    	| CMP_GT virtualReg COMMA virtualReg ASSIGN virtualReg
    	| CMP_GE virtualReg COMMA virtualReg ASSIGN virtualReg
    	| COMP virtualReg COMMA virtualReg ASSIGN virtualReg
    	| CREAD virtualReg
    	| CSTOREAI virtualReg ASSIGN virtualReg COMMA NUMBER
    	| CSTOREAO virtualReg ASSIGN virtualReg COMMA virtualReg
    	| CSTORE virtualReg ASSIGN virtualReg
    	| CWRITE virtualReg
    	| EXIT
    	| DIVI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| DIV virtualReg COMMA virtualReg ASSIGN virtualReg
    	| F2F virtualReg ASSIGN virtualReg
    	| F2I virtualReg ASSIGN virtualReg
    	| FADD virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FCALL LABEL (COMMA virtualReg )* ASSIGN virtualReg
    	| FCMP_LT virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FCMP_LE virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FCMP_EQ virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FCMP_NE virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FCMP_GT virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FCMP_GE virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FCOMP virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FDIV virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FLOADAI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| FLOADAO virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FLOAD virtualReg ASSIGN virtualReg
    	| FMULT virtualReg COMMA virtualReg ASSIGN virtualReg
    	| FREAD virtualReg
    	| FRET virtualReg
    	| FWRITE virtualReg
    	| FSTOREAI virtualReg ASSIGN virtualReg COMMA NUMBER
    	| FSTOREAO virtualReg ASSIGN virtualReg COMMA virtualReg
    	| FSTORE virtualReg ASSIGN virtualReg
    	| FSUB virtualReg COMMA virtualReg ASSIGN virtualReg
    	| I2F virtualReg ASSIGN virtualReg
    	| I2I virtualReg ASSIGN virtualReg
    	| ICALL LABEL (COMMA virtualReg )* ASSIGN virtualReg
    	| IRCALL virtualReg (COMMA virtualReg )* ASSIGN virtualReg
    	| IREAD virtualReg
    	| IRET virtualReg
    	| IWRITE virtualReg
    	| JUMPI ARROW LABEL
    	| JUMP ARROW virtualReg
    	| LOADAI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| LOADAO virtualReg COMMA virtualReg ASSIGN virtualReg
    	| LOAD virtualReg ASSIGN virtualReg
    	| LOADI immediateVal ASSIGN virtualReg
    	| LSHIFTI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| LSHIFT virtualReg COMMA virtualReg ASSIGN virtualReg
  	| MALLOC virtualReg ASSIGN virtualReg
    	| MOD virtualReg COMMA virtualReg ASSIGN virtualReg
    	| MULTI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| MULT virtualReg COMMA virtualReg ASSIGN virtualReg
    	| NOP
    	| NOT virtualReg ASSIGN virtualReg
    	| ORI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| OR virtualReg COMMA virtualReg ASSIGN virtualReg
    	| RSHIFTI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| RSHIFT virtualReg COMMA virtualReg ASSIGN virtualReg
    	| RET
    	| STOREAI virtualReg ASSIGN virtualReg COMMA NUMBER
    	| STOREAO virtualReg ASSIGN virtualReg COMMA virtualReg
    	| STORE virtualReg ASSIGN virtualReg
    	| SUBI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| SUB virtualReg COMMA virtualReg ASSIGN virtualReg
    	| SWRITE virtualReg
    	| TBL virtualReg  LABEL
    	| TESTEQ virtualReg ASSIGN virtualReg
    	| TESTGE virtualReg ASSIGN virtualReg
    	| TESTGT virtualReg ASSIGN virtualReg
    	| TESTLE virtualReg ASSIGN virtualReg
    	| TESTLT virtualReg ASSIGN virtualReg
    	| TESTNE virtualReg ASSIGN virtualReg
    	| XORI virtualReg COMMA NUMBER ASSIGN virtualReg
    	| XOR virtualReg COMMA virtualReg ASSIGN virtualReg
    )
	;

pseudoOp
		: ( STRING LABEL COMMA STRING_CONST
   		| FLOAT LABEL COMMA FLOAT_CONST
   		| GLOBAL LABEL COMMA NUMBER COMMA NUMBER
  		)
		;

virtualReg: VR
	;

immediateVal
	: ( LABEL
     	| NUMBER
	  )
	;

ADD: 'add' ;
ADDI: 'addI' ;
AND: 'and' ;
ANDI: 'andI';
C2C: 'c2c';
C2I: 'c2i';
CALL: 'call' ;
CBR: 'cbr' ;
CBRNE: 'cbrne' ;
CBR_LT: 'cbr_LT';
CBR_LE: 'cbr_LE';
CBR_EQ: 'cbr_EQ';
CBR_NE: 'cbr_NE';
CBR_GT: 'cbr_GT';
CBR_GE: 'cbr_GE';
CLOADAI: 'cloadAI' ;
CLOADAO: 'cloadAO' ;
CLOAD: 'cload' ;
CMP_LT: 'cmp_LT';
CMP_LE: 'cmp_LE';
CMP_EQ: 'cmp_EQ';
CMP_NE: 'cmp_NE';
CMP_GT: 'cmp_GT';
CMP_GE: 'cmp_GE';
COMP: 'comp' ;
CREAD: 'cread' ;
CSTOREAI: 'cstoreAI' ;
CSTOREAO: 'cstoreAO' ;
CSTORE: 'cstore' ;
CWRITE: 'cwrite' ;
DATA: '.data' ;
DIVI: 'divI' ;
DIV: 'div' ;
EXIT: 'exit' ;
F2F:'f2f' ;
F2I: 'f2i' ;
FADD: 'fadd' ;
FCALL: 'fcall' ;
FCOMP: 'fcomp' ;
FCMP_LT: 'fcmp_LT';
FCMP_LE: 'fcmp_LE';
FCMP_EQ: 'fcmp_EQ';
FCMP_NE: 'fcmp_NE';
FCMP_GT: 'fcmp_GT';
FCMP_GE: 'fcmp_GE';
FDIV: 'fdiv' ;
FLOADAI: 'floadAI' ;
FLOADAO: 'floadAO' ;
FLOAD: 'fload' ;
FLOAT: '.float' ;
FMULT: 'fmult' ;
FRAME: '.frame' ;
FREAD: 'fread' ;
FRET: 'fret' ;
FWRITE: 'fwrite' ;
FSTOREAI: 'fstoreAI' ;
FSTOREAO: 'fstoreAO' ;
FSTORE: 'fstore' ;
FSUB: 'fsub' ;
GLOBAL: '.global' ;
I2F: 'i2f' ;
I2I: 'i2i' ;
ICALL: 'icall' ;
IRCALL: 'ircall' ;
IREAD: 'iread' ;
IRET: 'iret' ;
IWRITE: 'iwrite' ;
JUMPI: 'jumpI' ;
JUMP: 'jump' ;
LOADAI: 'loadAI' ;
LOADAO: 'loadAO' ;
LOAD: 'load' ;
LOADI: 'loadI' ;
LSHIFTI: 'lshiftI' ;
LSHIFT: 'lshift' ;
MALLOC: 'malloc' ;
MOD: 'mod' ;
MULTI: 'multI' ;
MULT: 'mult' ;
NOP: 'nop' ;
NOT: 'not' ;
OR: 'or' ;
ORI: 'orI';
RSHIFTI: 'rshiftI' ;
RSHIFT: 'rshift' ;
RET: 'ret' ;
STOREAI: 'storeAI' ;
STOREAO: 'storeAO' ;
STORE: 'store' ;
STRING: '.string' ;
SUBI: 'subI' ;
SUB: 'sub' ;
SWRITE: 'swrite' ;
TBL: 'tbl';
TESTEQ: 'testeq' ;
TESTGE: 'testge' ;
TESTGT: 'testgt' ;
TESTLE: 'testle' ;
TESTLT: 'testlt' ;
TESTNE: 'testne' ;
TEXT: '.text' ;
XOR: 'xor';
XORI: 'xorI';

fragment
EXPONENT: ('e' | 'E') ('+' | '-')? (DIGIT)+;

fragment
INITIAL: DOT | UNDERSCORE;

fragment
UNDERSCORE: '_';

fragment
ALPHA: [a-zA-Z];

fragment
DIGIT: [0-9];

fragment
DOT: '.';

ASSIGN: '=>';
ARROW: '->';
LON: ':' ;
SEMICOLON: ';';
LBRACKET: '[';
RBRACKET: ']';
COMMA: ',';
VR: '%vr' NUMBER;
STRING_CONST: '"' ( ~('"') )* '"';
LABEL: (INITIAL)* ALPHA (ALPHA | INITIAL | DIGIT)*;
FLOAT_CONST: NUMBER ('.' (DIGIT)+ (EXPONENT)? | EXPONENT);
NUMBER: '0' | ('-')? [1-9](DIGIT)*;


WS : [ \t\r\n]+ -> skip ;
COMMENT: '#' (~[\n\r])* -> skip;
