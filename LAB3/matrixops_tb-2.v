module matrixops_tb ();

  reg        clk;
  reg        rst;
  reg        enter;
  reg  [1:0] X;
  reg  [1:0] Y;
  wire       Z;

  matrixops dut (
    .clk  (clk),
    .rst  (rst),
    .enter(enter),
    .X    (X),
    .Y    (Y),
    .Z    (Z)
  );

  parameter HP = 5;
  parameter FP = (2 * HP);

  always #HP clk = ~clk;

  initial begin
    $dumpfile("matrixops_tb.vcd");
    $dumpvars(0, matrixops_tb);

    $display("Simulation started.");

    //I tried TestCase2 here lately

    clk = 1;
    rst = 1;
    X = 0;
    Y = 0;
    enter = 0;
    #(FP - 1);

    rst = 0;
    X = 0;
    Y = 0;
    enter = 1;
    #FP;

    rst = 0;
    X = 0;
    Y = 0;
    enter = 0;
    #FP;

    rst = 0;
    X = 0;
    Y = 1;
    enter = 1;
    #FP;

    rst = 0;
    X = 2;
    Y = 3;
    enter = 1;
    #FP;

    rst = 0;
    X = 3;
    Y = 2;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 0;
    enter = 1;
    #FP;

    rst = 0;
    X = 0;
    Y =0;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 1;
    enter = 1;
    #FP;

    rst = 0;
    X = 1;
    Y = 1;
    enter = 0;
    #FP;


    rst = 0;
    X = 1;
    Y = 1;
    enter = 0;
    #FP;

    rst = 0;
    X = 0;
    Y = 0;
    enter = 0;
    #FP;

    rst = 0;
    X = 0;
    Y = 0;
    enter = 1;
    #FP;

    rst = 0;
    X = 2;
    Y = 0;
    enter = 1;
    #FP;

    rst = 0;
    X = 2;
    Y = 0;
    enter = 0;
    #FP;

    $display("Simulation finished.");
    $finish();
  end

endmodule

