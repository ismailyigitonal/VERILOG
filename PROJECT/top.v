// DO NOT MODIFY THE MODULE NAMES, SIGNAL NAMES, SIGNAL PROPERTIES

module top (
  input        clk    ,  // Main clock signal
  input  [3:0] sw     ,  // Switch inputs for coordinates
  input  [3:0] btn    ,  // Button inputs
  output [7:0] led    ,  // LED outputs
  output [7:0] seven  ,  // Seven-segment display data
  output [3:0] segment // Seven-segment display selection
);
wire clk_div;

wire btn_rst;
wire btn_start;
wire btn_A;
wire btn_B;

wire [7:0] disp0;
wire [7:0] disp1;
wire [7:0] disp2;
wire [7:0] disp3;


  clk_divider clk_div_inst (
    .clk_in(clk),
    .divided_clk(clk_div)
  );

  debouncer db_rst (
    .clk(clk_div),
    .rst(1'b0),
    .noisy_in(btn[2]),
    .clean_out(btn_rst)
  );

  debouncer db_start (
    .clk(clk_div),
    .rst(1'b0),
    .noisy_in(btn[1]),
    .clean_out(btn_start)
  );

  debouncer db_A (
    .clk(clk_div),
    .rst(1'b0),
    .noisy_in(btn[3]),
    .clean_out(btn_A)
  );

  debouncer db_B (
    .clk(clk_div),
    .rst(1'b0),
    .noisy_in(btn[0]),
    .clean_out(btn_B)
  );

  battleship battleship_inst (
    .clk(clk_div),
    .rst(btn_rst),
    .start(btn_start),
    .X(sw[3:2]),
    .Y(sw[1:0]),
    .pAb(btn_A),
    .pBb(btn_B),
    .disp0(disp0),
    .disp1(disp1),
    .disp2(disp2),
    .disp3(disp3),
    .led(led)
  );
  ssd ssd_inst (
    .clk(clk),
    .disp0(disp0),
    .disp1(disp1),
    .disp2(disp2),
    .disp3(disp3),
    .seven(seven),
    .segment(segment)
  );

endmodule
