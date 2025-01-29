// DO NOT CHANGE THE INPUT/OUTPUT NAMES, OTHERWISE WE CAN'T GRADE YOUR SUBMISSION

module CLA_15bit_tb ();

reg signed [14:0] A;
reg  signed [14:0] B; 
reg         mode;       
wire [14:0] S;   
wire        Ovf;        //overflow
wire        Cout;       // Carry_out

CLA_15bit_top dut (A, B, mode, S, Cout, Ovf); // Design-under-test.

initial begin
  $dumpfile("CLA_15bit_top.vcd");
  $dumpvars(0, CLA_15bit_tb);

  $display("Simulation started.");
  
  A = 15'd0;
  B = 15'd0;
  mode = 0;
  #10;   //I set both inputs to 0 here
  
  
  A = 15'd9;  //I used binary version of 9 here  
  B = 15'd7;  //also binary version of 7 
  mode = 0;     
  #10; //Addition without a carry and without an overflow

  A = 15'd16383;  //binary version of 16383
  B = 15'd1;  //binary version of 1 
  mode = 0;       //Addition without a carry and with an overflow
  #10;

  A = -15'd2;  //I used -2 here 
  B = 15'd4; 
  mode = 0;   
  #10; //Addition with a carry without an overflow

  A = -15'd8192;  //I used -8192 here 
  B = -15'd16384;  //I used -16384 here max neg
  mode = 0;        
  #10; //Addition with a carry and with an overflow

  A = 15'd30;    // signed  version of 30
  B = 15'd70;     // signed version of  70
  mode = 1;       
  #10; //Subtraction without a carry and without an overflow

  A = 15'd8192; // binary version 8192
  B = -15'd8192; // binary version -8192 
  mode = 1;               // 8192 --(+) 8192 = 16384 so bigger than 2^14-1 (highest number can be present with 15 bit in signed numbers.)
  #10; //Subtraction without a carry and with an overflow


  A = 15'd10; // binary version of 10
  B = 15'd7; // binary version 5
  mode = 1;               // 10-5 = 5 carry ok overflow no 
  #10; //Subtraction with a carry and without an overflow

  A = -15'd16382; // Binary for -16382
  B = 15'd3; // Binary for 3  
  mode = 1;               //-16382-3= -16385 we can at least present -2^14 = -16384 with signed 15 bit numbers
  #10; //Subtraction with a carry and with an overflow

  $display("Simulation finished.");
  $finish;
end

endmodule
