module battleship (
  input            clk,
  input            rst,
  input            start,
  input      [1:0] X,
  input      [1:0] Y,
  input            pAb,
  input            pBb,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

parameter IDLE = 4'd0, SHOW_A = 4'd1, A_IN = 4'd2, ERROR_A = 4'd3, SHOW_B = 4'd4;
parameter B_IN = 4'd5, ERROR_B = 4'd6, SHOW_SCORE = 4'd7, A_SHOOT = 4'd8, A_SINK = 4'd9;
parameter A_WIN = 4'd10, B_SHOOT = 4'd11, B_SINK = 4'd12, B_WIN = 4'd13;

reg [3:0] state, next_state;
reg [3:0] mapA [15:0];
reg [3:0] mapB [15:0];
reg [2:0] score_A=0, score_B=0;
reg [15:0] timer, timer_winner;
reg [1:0] input_count_A, input_count_B;
reg [3:0] index;

// Combinational block for SSDs and LEDs
always @(*) begin
  // Default values
  disp0 = 8'b00000000;
  disp1 = 8'b00000000;
  disp2 = 8'b00000000;
  disp3 = 8'b00000000;
  led = 8'b00000000;

  case (state)
    IDLE: begin
      disp3 = 8'b00000110;  // 'I'
      disp2 = 8'b00111111;  // 'd'
      disp1 = 8'b00111000;  // 'l'
      disp0 = 8'b01111001;  // 'E'
      led = 8'b10011001;
    end
    SHOW_A: begin
      disp3 = 8'b01110111;  // 'A'
    end
    A_IN: begin
      led <= 8'b10000000; //LED 7 blink
      led[7:6] <= input_count_A;

      // Display X coordinate
      case (X)
        2'b00: disp1 = 8'b00111111; // 0
        2'b01: disp1 = 8'b00000110; // 1
        2'b10: disp1 = 8'b01011011; // 2
        2'b11: disp1 = 8'b01001111; // 3
        default: disp1 = 8'b11111111; // Undefined
      endcase

      // Display Y coordinate
      case (Y)
        2'b00: disp0 = 8'b00111111; // 0
        2'b01: disp0 = 8'b00000110; // 1
        2'b10: disp0 = 8'b01011011; // 2
        2'b11: disp0 = 8'b01001111; // 3
        default: disp0 = 8'b11111111; // Undefined
      endcase
    end
    ERROR_A: begin
      disp3 = 8'b01111001;  // 'E'
      disp2 = 8'b00110001;  // 'r'
      disp1 = 8'b00110001;  // 'r'
      disp0 = 8'b0011111;  // 'o'
      led = 8'b10011001;
    end
    SHOW_B: begin
      disp3 = 8'b01111111;  // 'B'
    end
    B_IN: begin
      led <= 8'b10000000; //All leds off
      led <= input_count_B;

      // Display X coordinate
      case (X)
        2'b00: disp1 = 8'b00111111; // 0
        2'b01: disp1 = 8'b00000110; // 1
        2'b10: disp1 = 8'b01011011; // 2
        2'b11: disp1 = 8'b01001111; // 3
        default: disp1 = 8'b11111111; // Undefined
      endcase

      // Display Y coordinate
      case (Y)
        2'b00: disp0 = 8'b00111111; // 0
        2'b01: disp0 = 8'b00000110; // 1
        2'b10: disp0 = 8'b01011011; // 2
        2'b11: disp0 = 8'b01001111; // 3
        default: disp0 = 8'b11111111; // Undefined
      endcase
    end
    ERROR_B: begin
      disp3 = 8'b01111001;  // 'E'
      disp2 = 8'b00110001;  // 'r'
      disp1 = 8'b00110001;  // 'r'
      disp0 = 8'b00111111;   // 'o'
      led = 8'b10011001;
    end
    SHOW_SCORE: begin
      case (timer_winner)
        2'b00: disp2 = 8'b00111111; // 0
        2'b01: disp2 = 8'b00000110; // 1
        2'b10: disp2 = 8'b01011011; // 2
        2'b11: disp2 = 8'b01001111; // 3
        default: disp2 = 8'b11111111; // Undefined
      endcase
      disp1 = 8'b01000000;  // '-'
      case (timer_winner)
        2'b00: disp0 = 8'b00111111;
        2'b01: disp0 = 8'b00000110; // 1
        2'b10: disp0 = 8'b01011011; // 2
        2'b11: disp0 = 8'b01001111; // 3
        default: disp0 = 8'b11111111; // Undefined
      endcase
      led = 8'b10010101;
      // Score for B
    end
    A_SHOOT:begin
      led <= 8'b10011001;
      led[5:4] <= score_A[1:0];  //score A blink
      led[3:2] <= score_B[1:0];  //score B blink
      case (X)
        2'b00: disp1 = 8'b00111111; // 0
        2'b01: disp1 = 8'b00000110; // 1
        2'b10: disp1 = 8'b01011011; // 2
        2'b11: disp1 = 8'b01001111; // 3
        default: disp1 = 8'b11111111; // Undefined
      endcase

      // Display Y coordinate
      case (Y)
        2'b00: disp0 = 8'b00111111; // 0
        2'b01: disp0 = 8'b00000110; // 1
        2'b10: disp0 = 8'b01011011; // 2
        2'b11: disp0 = 8'b01001111; // 3
        default: disp0 = 8'b11111111; // Undefined
      endcase
      
    end
    A_SINK:begin
      led = 8'b10011001;
   
      case (score_A)
      3'b000: disp2 = 8'b00111111; // 0
      3'b001: disp2 = 8'b00000110; // 1
      3'b010: disp2 = 8'b01011011; // 2
      3'b011: disp2 = 8'b01001111; // 3
      3'b100: disp2 = 8'b01100110; // 4
      default: disp2 = 8'b11111111; // Undefined
    endcase
    disp1 = 8'b01000000;  // '-'
    case (score_B)
    3'b000: disp0 = 8'b00111111; // 0
    3'b001: disp0 = 8'b00000110; // 1
    3'b010: disp0 = 8'b01011011; // 2
    3'b011: disp0 = 8'b01001111; // 3
    3'b100: disp0 = 8'b01100110; // 4
      default: disp0 = 8'b11111111; // Undefined
    endcase
  end

   
    
    B_SINK:begin
      disp3= 8'b00000000;
      case (score_A)
      3'b000: disp2 = 8'b00111111; // 0
      3'b001: disp2 = 8'b00000110; // 1
      3'b010: disp2 = 8'b01011011; // 2
      3'b011: disp2 = 8'b01001111; // 3
      3'b100: disp2 = 8'b01100110; // 4
      default: disp2 = 8'b11111111; // Undefined
    endcase
    disp1 = 8'b01000000;  // '-'
    case (score_B)
    3'b000: disp0 = 8'b00111111; // 0
    3'b001: disp0 = 8'b00000110; // 1
    3'b010: disp0 = 8'b01011011; // 2
    3'b011: disp0 = 8'b01001111; // 3
    3'b100: disp0 = 8'b01100110; // 4
      default: disp0 = 8'b11111111; // Undefined
    endcase
    end
    B_SHOOT:begin
      led <= 8'b00000000;
      led[5:4] <= score_A[1:0];  //score A blink
      led[3:2] <= score_B[1:0];  //score B blink
     
      case (X)
        2'b00: disp1 = 8'b00111111; // 0
        2'b01: disp1 = 8'b00000110; // 1
        2'b10: disp1 = 8'b01011011; // 2
        2'b11: disp1 = 8'b01001111; // 3
        default: disp1 = 8'b11111111; // Undefined
      endcase

      // Display Y coordinate
      case (Y)
        2'b00: disp0 = 8'b00111111; // 0
        2'b01: disp0 = 8'b00000110; // 1
        2'b10: disp0 = 8'b01011011; // 2
        2'b11: disp0 = 8'b01001111; // 3
        default: disp0 = 8'b11111111; // Undefined
      endcase
      
    end
    A_WIN: begin

    disp3 = 8'b01110111;  // 'A'

    case (score_A)
      3'b000: disp2 = 8'b00111111; // 0
      3'b001: disp2 = 8'b00000110; // 1
      3'b010: disp2 = 8'b01011011; // 2
      3'b011: disp2 = 8'b01001111; // 3
      3'b100: disp2 = 8'b01100110; // 4
      default: disp2 = 8'b11111111; // Undefined
    endcase
    disp1 = 8'b01000000;  // '-'
    case (score_B)
    3'b000: disp0 = 8'b00111111; // 0
    3'b001: disp0 = 8'b00000110; // 1
    3'b010: disp0 = 8'b01011011; // 2
    3'b011: disp0 = 8'b01001111; // 3
    3'b100: disp0 = 8'b01100110; // 4
      default: disp0 = 8'b11111111; // Undefined
    endcase
    led = 8'b11111111;  // LED dance

    end
    B_WIN: begin
    disp3 = 8'b01111111;  // 'B'

    // Display Player A's score on disp2
    case (score_A)
      3'b000: disp2 = 8'b00111111; // 0
      3'b001: disp2 = 8'b00000110; // 1
      3'b010: disp2 = 8'b01011011; // 2
      3'b011: disp2 = 8'b01001111; // 3
      3'b100: disp2 = 8'b01100110; // 4
      default: disp2 = 8'b11111111; // Undefined
    endcase

    disp1 = 8'b01000000;  // '-'

    // Display Player B's score on disp0
    case (score_B)
      3'b000: disp0 = 8'b00111111; // 0
      3'b001: disp0 = 8'b00000110; // 1
      3'b010: disp0 = 8'b01011011; // 2
      3'b011: disp0 = 8'b01001111; // 3
      3'b100: disp0 = 8'b01100110; // 4
      default: disp0 = 8'b11111111; // Undefined
    endcase

    led = 8'b11111111;  // LED dance
end

  
  endcase
end


// Sequential block for state and game logic
always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= IDLE;
    next_state <= IDLE;
    score_A <= 0;
    score_B <= 0;
    input_count_A <= 0;
    input_count_B <= 0;
    timer <= 0;
    timer_winner<= 0;
    

    mapA[0] <= 0; mapA[1] <= 0; mapA[2] <= 0; mapA[3] <= 0;
    mapA[4] <= 0; mapA[5] <= 0; mapA[6] <= 0; mapA[7] <= 0;
    mapA[8] <= 0; mapA[9] <= 0; mapA[10] <= 0; mapA[11] <= 0;
    mapA[12] <= 0; mapA[13] <= 0; mapA[14] <= 0; mapA[15] <= 0;

    mapB[0] <= 0; mapB[1] <= 0; mapB[2] <= 0; mapB[3] <= 0;
    mapB[4] <= 0; mapB[5] <= 0; mapB[6] <= 0; mapB[7] <= 0;
    mapB[8] <= 0; mapB[9] <= 0; mapB[10] <= 0; mapB[11] <= 0;
    mapB[12] <= 0; mapB[13] <= 0; mapB[14] <= 0; mapB[15] <= 0;
  end else begin
    state <= next_state;
    index <= Y * 4 + X;

    case (state)
    IDLE: if (start) begin
      timer <= 0;
      next_state <= SHOW_A;
    end         
    SHOW_A: if (timer == 50) begin // Adjusted for longer display duration
      next_state <= A_IN ;
      timer <= 0;
    end else begin
      timer <= timer + 1;
    end 
    A_IN: begin
      timer <= 0;
      if (pAb && mapA[index] == 0) begin
        mapA[index] <= 1;
        if (input_count_A == 3) 
          next_state <= SHOW_B;
        else 
          input_count_A <= input_count_A + 1;
      end else if (pAb && mapA[index] == 1) 
        //next_state <= ERROR_A;
        next_state <= A_IN;
    end
    ERROR_A: if (timer == 100) begin // Increased duration for error visibility
      next_state <= A_IN;
      timer <= 0;
    end else begin
      timer <= timer + 1;
    end
    SHOW_B: if (timer == 100) begin // Adjusted for longer display duration
      next_state <= B_IN ;
      timer <= 0;
    end else begin
      timer <= timer + 1;
    end 
    B_IN: begin
      timer <= 0;
      if (pBb) begin
        if (mapB[index] == 0) begin
          mapB[index] <= 1;
          if (input_count_B < 3) begin
            input_count_B <= input_count_B + 1;
            next_state <= B_IN;
          end else begin
            input_count_B <= input_count_B + 1; // Final input for Player B
            next_state <= SHOW_SCORE;
          end
        end else begin
          //next_state <= ERROR_B;
          next_state <= B_IN;
        end
      end
    end
    ERROR_B: if (timer == 100) begin // Increased duration for error visibility
      next_state <= B_IN;
      timer <= 0;
    end else begin
      timer <= timer + 1;
    end
    SHOW_SCORE: if (timer == 200) next_state <= A_SHOOT; else timer <= timer + 1;
    A_SHOOT: if (pAb) begin
      timer <= 0;
      if (mapB[index]) begin
        score_A <= score_A + 1;
        mapB[index] <= 0;
        next_state <= A_SINK;
      end else 
        next_state <= A_SINK;
    end
    A_SINK: if (timer == 100) begin // Adjusted sink display time
      timer_winner <= timer_winner + 1;
      timer <= 0;
      if (score_A >= 4) 
        next_state <= A_WIN;
      else 
        next_state <= B_SHOOT;
    end else timer <= timer + 1;
    B_SHOOT: if (pBb) begin
      if (mapA[index]) begin
        score_B <= score_B + 1;
        mapA[index] <= 0;
        next_state <= B_SINK;
      end else 
        next_state <= B_SINK;
    end
    B_SINK: if (timer == 100) begin 
      timer=0;
      timer_winner=0;// Adjusted sink display time
      if (score_B >=4) 
        next_state <= B_WIN;
      else 
        next_state <= A_SHOOT;
    end else timer <= timer + 1;

      A_WIN: begin
      
          // Kazanma durumu tamamlandı, tüm oyun değişkenlerini sıfırla
          next_state <= state; // IDLE durumuna geçiş yap
         
      
        
        
      end
      
      B_WIN: begin
    
          // Kazanma durumu tamamlandı, tüm oyun değişkenlerini sıfırla
          next_state <= state; // IDLE durumuna geçiş yap
          
      
 
       
      end
      
    endcase
  end
end

endmodule









