module battleship_tb();

  reg clk;
  reg rst;
  reg start;
  reg [1:0] X;
  reg [1:0] Y;
  reg pAb;
  reg pBb;
  wire [7:0] disp0;
  wire [7:0] disp1;
  wire [7:0] disp2;
  wire [7:0] disp3;
  wire [7:0] led;

  battleship  ba00 (
    .clk(clk),
    .rst(rst),
    .start(start),
    .X(X),
    .Y(Y),
    .pAb(pAb),
    .pBb(pBb),
    .disp0(disp0),
    .disp1(disp1),
    .disp2(disp2),
    .disp3(disp3),
    .led(led)
  );
  
  parameter HP = 5;
  parameter FP = (20*HP);

  always #HP  clk = ~clk ;

  initial begin
      $dumpfile("battleship_tb.vcd"); 
      $dumpvars(0,battleship_tb);

      $display("Simulation started.");
      clk = 1;
      rst = 1;
      start = 0;
      X = 0;
      Y = 0;
      pAb = 0;
      pBb = 0;
      #FP;
      rst = 0;
      #FP;
      start = 1;
      #(5*FP);
      start = 0;
      #FP;

      //Player A placing
      pAb = 1; X = 0; Y = 0; #FP; pAb = 0; #FP;
      pAb = 1; X = 0; Y = 1; #FP; pAb = 0; #FP;
      pAb = 1; X = 1; Y = 0; #FP; pAb = 0; #FP;
      pAb = 1; X = 1; Y = 1; #FP; pAb = 0; #FP;

      //Player B placing
      pBb = 1; X = 0; Y = 0; #FP; pBb = 0; #FP;
      pBb = 1; X = 0; Y = 1; #FP; pBb = 0; #FP;
      pBb = 1; X = 1; Y = 0; #FP; pBb = 0; #FP;
      pBb = 1; X = 1; Y = 1; #FP; pBb = 0; #FP;

      //Player A and B shoot
      pAb = 1; X = 0; Y = 0; #FP; pAb = 0; #FP;
      pBb = 1; X = 0; Y = 0; #FP; pBb = 0; #FP;

      pAb = 1; X = 0; Y = 1; #FP; pAb = 0; #FP;
      pBb = 1; X = 1; Y = 0; #FP; pBb = 0; #FP;

      pAb = 1; X = 1; Y = 1; #FP; pAb = 0; #FP;
      pBb = 1; X = 1; Y = 1; #FP; pBb = 0; #FP;

      pAb = 1; X = 1; Y = 1; #FP; pAb = 0; #FP;
      pBb = 1; X = 0; Y = 1; #FP; pBb = 0; #FP;


      $display("Simulation finished.");
      $finish(); // Finish simulation.
  end

  // Dinamik bitirme için kazanan kontrolü
  always @(posedge clk) begin
      if (ba00.state == 10 || ba00.state == 13) begin
          $display("Game Over! Winner detected at time %0t. State = %0d", $time, ba00.state);
          $finish;
      end
  end

  // Durum takibi
  always @(posedge clk) begin
      $display("Time: %0t, State: %0d, Next State: %0d, Score A: %0d, Score B: %0d", 
               $time, ba00.state, ba00.next_state, ba00.score_A, ba00.score_B);
  end

endmodule

