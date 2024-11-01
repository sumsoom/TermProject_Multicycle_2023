module ArithUnit
(input[31:0] inpa,	input[31:0] inpb, input cin, input addsub, input carryop,	output[31:0] outp, output cout, output overflow);
	wire [32:0] temp;
  
  assign temp = addsub ? inpa+inpb+(carryop ? cin : 0) : inpa-inpb-(carryop? (cin ? 0 : 1) : 0);
  assign cout = temp[32];
  assign outp = temp[31:0];
  assign overflow = (inpa[31]^outp[31])&(inpb[31]^outp[31]);
 
endmodule


module ALUopdecoder(
 input[3:0] instop,
 output reg[2:0] aluop);
	always @ (*)
		case(instop)
		0 : aluop='b011;
		1 : aluop='b111;
		2 : aluop='b000;
		4 : aluop='b001;
		5 : aluop='b101;
		6 : aluop='b100;
		10 : aluop='b000;
		12 : aluop='b010;
		13 : aluop='b001;
		default : aluop='bxxx;
		endcase
endmodule 


module LogicUnit
(input[31:0] inpa, input[31:0] inpb, input andor, input xorop, output[31:0] outp);
  
  assign outp = xorop ? inpa^inpb : andor ? inpa&inpb : inpa|inpb;
  
endmodule


module ALU32bit
(input[31:0] inpa,	input[31:0] inpb,	input cin, input[2:0] aluop,	output[31:0] result, output negative, output zero, output cout, output overflow);
  
  //aluop
   //logic op - 111 : xor, 011 : and, 010 : or
   //arith op - 101 : adc, 100 : sbc, 001 : add, 000 : sub
   
  
  wire[31:0] resultl;
  wire[31:0] resulta;
  wire carrya, overflowa;
  wire carryl = cin;
  wire overflowl = overflow; 
  wire al = aluop[1]; // arith : 0, logic 1
  
  LogicUnit logicop(inpa,	inpb,	aluop[0], aluop[2],	resultl);
  ArithUnit arithop(inpa,	inpb,	cin, aluop[0], aluop[2],	resulta, carrya, overflowa);
 
  assign result = al ? resultl : resulta;
  assign negative = result[31];
  assign zero = (result=='h00000000) ? 'b1 : 'b0; 
  assign cout = al ? carryl : carrya;
  assign overflow = al ? overflowl : overflowa;
    
endmodule