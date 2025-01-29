// DO NOT CHANGE THE INPUT/OUTPUT NAMES, OTHERWISE WE CAN'T GRADE YOUR SUBMISSION

module CLA_3bit (
  input  [2:0] C    ,
  input  [2:0] D    ,
  input        Cin  ,
  input        mode , // 0 --> addition , 1 --> subtraction
  output [2:0] RES  ,
  output       Carry
);
  wire[2:0] Gen, Propagate; 
  wire [2:0] D_situation;
  wire [3:0] Carry_out;
  
  
  assign D_situation[2] = D[2] ^ mode; //D-situation stands for if mode is 1 or 0
	assign D_situation[1] = D[1] ^ mode;
	assign D_situation[0] = D[0] ^ mode;
  
  
  assign Gen = C & D_situation; //we implement generate logic by looking at D's situation. 
  assign Propagate = C ^ D_situation; //we implement propagate logic by looking at D's situation.
  
  assign Carry_out[0] = Cin; //First we assign carry out as cin (input)
  assign Carry_out[1] = Gen[0] | (Propagate[0] & Carry_out[0]); 
  assign Carry_out[2] = Gen[1] | (Propagate[1] & Carry_out[1]);
  assign Carry_out[3] = Gen[2] | (Propagate[2] & Carry_out[2]);


  assign RES = C ^ D_situation ^ Carry_out[2:0]; //For finding result we do both XoR statments between C D's situation and Carry out 



  assign Carry = Carry_out[3]; //At the end to use in other bit implementation we assign Carry as the result of carry out.

  
endmodule