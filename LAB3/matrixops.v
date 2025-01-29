module matrixops (
  input            clk,
  input            rst,
  input            enter,
  input      [1:0] X,
  input      [1:0] Y,
  output reg       Z
);

  parameter S0 = 2'b00; //Default State
  parameter S1 = 2'b01; //Input Waiting 
  parameter S2 = 2'b10; //Input Process
  parameter S3 = 2'b11; //Output Process
  //Taken from Verilog_3.pptx

  reg [1:0] cState; //current state of FSM 
  reg matrix [3:0][3:0]; //4x4 matrix implementation 
  reg [2:0] input_count; //from log2(5)>2 our needed space is 3
  integer i, j; //will use them for reset the matrix
  reg other_Z;

  always @(posedge clk or posedge rst) 
  begin
    if (rst) //if reset is high
    begin
      for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
          matrix[i][j] <= 0; //Setting all matrix cells into 0 here
        end
      end
      input_count <= 0; //reset input count 
      Z <= 0; 
      other_Z <= 0; 
      cState <= S0; //setting current state to default 
    end //reset all the states 
    else 
    begin
      if (cState == S0) 
      begin
        if (enter) 
          cState <= S1; //transition to S1
      end 
      else if (cState == S1) 
      begin
        cState <= S2;
      end  //going into s2
      else if (cState == S2) 
      begin
        if (input_count == 4 && enter) 
        begin
          matrix[Y][X] <= 1;
          input_count <= input_count + 1;
          cState <= S3; 
        end //input processing state if(user entered 5 inputs set current state into next state ( state 3 output query state)).
        else if (enter) 
        begin
          matrix[Y][X] <= 1; 
          input_count <= input_count + 1; //while count is not 5 add 1 into the corresponding cell and increase input count.
        end
      end 
      else if (cState == S3) 
      begin
        if (rst) 
        begin
          Z <= 0;
          other_Z <= 0;
        end //if reset is high set both Z's to 0 
        else if (enter) 
        begin
          other_Z <= matrix[Y][X]; //while user enters enter output the corresponding cells 
        end
        Z <= other_Z;
      end
    end
  end
endmodule






