// DO NOT CHANGE THE INPUT/OUTPUT NAMES, OTHERWISE WE CAN'T GRADE YOUR SUBMISSION

module CLA_15bit_top (
  input  [14:0] A   ,
  input  [14:0] B   ,
  input         mode, // 0 --> addition , 1 --> subtraction
  output [14:0] S   ,
  output        Cout,
  output        OVF
);

  /* Your design goes here */
 
wire [4:0] Carry_out; 


CLA_3bit CLA0(
  .C(A[2:0]), 
  .D(B[2:0]), 
  .Cin(mode), 
  .mode(mode), 
  .RES(S[2:0]), 
  .Carry(Carry_out[0]));
CLA_3bit CLA1 (
  .C(A[5:3]), 
  .D(B[5:3]), 
  .Cin(Carry_out[0]), 
  .mode(mode), 
  .RES(S[5:3]), 
  .Carry(Carry_out[1]));
CLA_3bit CLA2 (
  .C(A[8:6]), 
  .D(B[8:6]), 
  .Cin(Carry_out[1]), 
  .mode(mode), 
  .RES(S[8:6]), 
  .Carry(Carry_out[2]));
CLA_3bit CLA3 (
  .C(A[11:9]), 
  .D(B[11:9]), 
  .Cin(Carry_out[2]), 
  .mode(mode), 
  .RES(S[11:9]), 
  .Carry(Carry_out[3]));
CLA_3bit CLA4 (
  .C(A[14:12]), 
  .D(B[14:12]), 
  .Cin(Carry_out[3]), 
  .mode(mode), 
  .RES(S[14:12]), 
  .Carry(Carry_out[4]));


assign Cout = Carry_out[4];
assign OVF = Carry_out[3] ^ Carry_out[4];




endmodule