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

parameter IDLE = 8'd0;         
parameter SHOW_A = 8'd1;       
parameter A_IN = 8'd2;         
parameter ERROR_A = 8'd3;      
parameter SHOW_B = 8'd4;       
parameter B_IN = 8'd5;         
parameter ERROR_B = 8'd6;      
parameter SHOW_SCORE = 8'd7;   
parameter A_SHOOT = 8'd8;      
parameter A_SINK = 8'd9;      
parameter A_WIN = 8'd10;       
parameter B_SHOOT = 8'd11;     
parameter B_SINK = 8'd12;      
parameter B_WIN = 8'd13;       
parameter ROUND_SCORE = 8'd14; 
parameter A_GAME_OVER = 8'd15; 
parameter A_GAME_OVER1 = 8'd16;
parameter B_GAME_OVER = 8'd17; 
parameter B_GAME_OVER1 = 8'd18;




reg [1:0] z;
reg [4:0] state; 
reg [4:0] next_state;
reg [15:0]mapA;
reg [15:0]mapB;
reg [2:0] score_A; 
reg [2:0]score_B;
reg [15:0] timer;  
reg [15:0] timer_winner;
reg [1:0] input_count_A;
reg [1:0] input_count_B;
reg [3:0] index; 
reg [2:0] A_game;        
reg [2:0] B_game;        
reg [2:0] player_will_start;   

always @(*) begin
disp0 = 8'b00000000;
disp1 = 8'b00000000;
disp2 = 8'b00000000;
disp3 = 8'b00000000;
led = 8'b00000000;
case (state)
  IDLE: begin
    disp3 = 8'b00000110;  
    disp2 = 8'b01011110;  
    disp1 = 8'b00111000; 
    disp0 = 8'b01111001;  
    led = 8'b10011001;
  end
  SHOW_A: begin
    disp3 = 8'b01110111; 
    led <= 8'b10011001;
  end
  A_IN: begin
    led <= 8'b10000000;
    led[7:4] <= {1'b1,1'b0, input_count_A};

    
    case (X)
      2'b00: disp1 = 8'b00111111; 
      2'b01: disp1 = 8'b00000110; 
      2'b10: disp1 = 8'b01011011; 
      2'b11: disp1 = 8'b01001111; 
      default: disp1 = 8'b11111111; 
    endcase

    case (Y)
      2'b00: disp0 = 8'b00111111; 
      2'b01: disp0 = 8'b00000110; 
      2'b10: disp0 = 8'b01011011; 
      2'b11: disp0 = 8'b01001111; 
      default: disp0 = 8'b11111111; 
    endcase
  end
  ERROR_A: begin
    disp3 = 8'b01111001;  
    disp2 = 8'b01010000;  
    disp1 = 8'b01010000;  
    disp0 = 8'b01011100;  
    led = 8'b10011001;
  end
  SHOW_B: begin
    disp3 = 8'b01111100;  
    led <= 8'b10011001;
  end
  B_IN: begin
    led[4:0] <= {input_count_B,1'b0,1'b1};

    
    case (X)
      2'b00: disp1 = 8'b00111111; 
      2'b01: disp1 = 8'b00000110; 
      2'b10: disp1 = 8'b01011011; 
      2'b11: disp1 = 8'b01001111; 
      default: disp1 = 8'b11111111; 
    endcase

    
    case (Y)
      2'b00: disp0 = 8'b00111111; 
      2'b01: disp0 = 8'b00000110; 
      2'b10: disp0 = 8'b01011011; 
      2'b11: disp0 = 8'b01001111;
      default: disp0 = 8'b11111111; 
    endcase
  end
  ERROR_B: begin
    disp3 = 8'b01111001;  
    disp2 = 8'b01010000;  
    disp1 = 8'b01010000;  
    disp0 = 8'b01011100;  
    led = 8'b10011001;
  end
  SHOW_SCORE: begin
    
    case (A_game)
    3'b000: disp2 = 8'b00111111; 
    3'b001: disp2 = 8'b00000110;
    3'b010: disp2 = 8'b01011011; 

    default: disp2 = 8'b11111111; 
  endcase
  disp1 = 8'b01000000;  
  case (B_game)
  3'b000: disp0 = 8'b00111111; 
  3'b001: disp0 = 8'b00000110; 
  3'b010: disp0 = 8'b01011011; 

    default: disp0 = 8'b11111111; 
  endcase
  led = 8'b10101010;
    
  end
  A_SHOOT:begin
    led[7]={1'b1};
    led[6:4] = {1'b0,score_A};
    led[3:2]={score_B};
   
    case (X)
      2'b00: disp1 = 8'b00111111; 
      2'b01: disp1 = 8'b00000110; 
      2'b10: disp1 = 8'b01011011; 
      2'b11: disp1 = 8'b01001111; 
      default: disp1 = 8'b11111111; 
    endcase

    // Display Y coordinate
    case (Y)
      2'b00: disp0 = 8'b00111111; 
      2'b01: disp0 = 8'b00000110; 
      2'b10: disp0 = 8'b01011011; 
      2'b11: disp0 = 8'b01001111; 
      default: disp0 = 8'b11111111; 
    endcase
  end
  A_SINK:begin
    if (z) begin
      led = 8'b11111111; 
    end
else begin
  led = 8'b00000000; 

end

    case (score_A)
    3'b000: disp2 = 8'b00111111; 
    3'b001: disp2 = 8'b00000110; 
    3'b010: disp2 = 8'b01011011; 
    3'b011: disp2 = 8'b01001111; 
    3'b100: disp2 = 8'b01100110; 
    default: disp2 = 8'b11111111; 
  endcase
  disp1 = 8'b01000000;  
  case (score_B)
  3'b000: disp0 = 8'b00111111; 
  3'b001: disp0 = 8'b00000110; 
  3'b010: disp0 = 8'b01011011;
  3'b011: disp0 = 8'b01001111; 
  3'b100: disp0 = 8'b01100110; 
    default: disp0 = 8'b11111111; 
  endcase
end

 
  
  B_SINK:begin
    if (z) begin
      led = 8'b11111111; 

    end
else begin
  led = 8'b00000000; 

end
    case (score_A)
    3'b000: disp2 = 8'b00111111; 
    3'b001: disp2 = 8'b00000110; 
    3'b010: disp2 = 8'b01011011; 
    3'b011: disp2 = 8'b01001111; 
    3'b100: disp2 = 8'b01100110;
    default: disp2 = 8'b11111111; 
  endcase
  disp1 = 8'b01000000;  
  case (score_B)
  3'b000: disp0 = 8'b00111111; 
  3'b001: disp0 = 8'b00000110; 
  3'b010: disp0 = 8'b01011011; 
  3'b011: disp0 = 8'b01001111; 
  3'b100: disp0 = 8'b01100110; 
    default: disp0 = 8'b11111111; 
  endcase
  end
  B_SHOOT:begin
    led[0]={1'b1};
    led[1]={1'b0};
    led[2:3]={score_B};
    led[4:5]={score_A}; 
   
    case (X)
      2'b00: disp1 = 8'b00111111; 
      2'b01: disp1 = 8'b00000110; 
      2'b10: disp1 = 8'b01011011; 
      2'b11: disp1 = 8'b01001111; 
      default: disp1 = 8'b11111111; 
    endcase

    case (Y)
      2'b00: disp0 = 8'b00111111; 
      2'b01: disp0 = 8'b00000110; 
      2'b10: disp0 = 8'b01011011; 
      2'b11: disp0 = 8'b01001111; 
      default: disp0 = 8'b11111111;
    endcase
    
  end

  A_WIN: begin

  disp3 = 8'b01110111;  

  case (score_A)
    3'b000: disp2 = 8'b00111111; 
    3'b001: disp2 = 8'b00000110;
    3'b010: disp2 = 8'b01011011; 
    3'b011: disp2 = 8'b01001111; 
    3'b100: disp2 = 8'b01100110; 
    default: disp2 = 8'b11111111; 
  endcase
  disp1 = 8'b01000000;  
  case (score_B)
  3'b000: disp0 = 8'b00111111; 
  3'b001: disp0 = 8'b00000110; 
  3'b010: disp0 = 8'b01011011; 
  3'b011: disp0 = 8'b01001111; 
  3'b100: disp0 = 8'b01100110; 
    default: disp0 = 8'b11111111; 
  endcase
  led = 8'b10101010;
  end
  B_WIN: begin

    disp3 = 8'b01111100;  

    case (score_A)
      3'b000: disp2 = 8'b00111111; 
      3'b001: disp2 = 8'b00000110;
      3'b010: disp2 = 8'b01011011; 
      3'b011: disp2 = 8'b01001111; 
      3'b100: disp2 = 8'b01100110; 
      default: disp2 = 8'b11111111; 
    endcase
    disp1 = 8'b01000000;  
    case (score_B)
    3'b000: disp0 = 8'b00111111; 
    3'b001: disp0 = 8'b00000110; 
    3'b010: disp0 = 8'b01011011; 
    3'b011: disp0 = 8'b01001111; 
    3'b100: disp0 = 8'b01100110; 
      default: disp0 = 8'b11111111; 
    endcase
    led = 8'b10101010;
    end
    
    ROUND_SCORE:begin
      if(player_will_start==0)begin
        disp3 = 8'b01110111; 
      end
       else begin
        disp3 = 8'b01111100;  
      end
       
  
      case (A_game)
        3'b000: disp2 = 8'b00111111; 
        3'b001: disp2 = 8'b00000110;
        3'b010: disp2 = 8'b01011011; 
  
        default: disp2 = 8'b11111111; 
      endcase
      disp1 = 8'b01000000;  
      case (B_game)
      3'b000: disp0 = 8'b00111111; 
      3'b001: disp0 = 8'b00000110; 
      3'b010: disp0 = 8'b01011011; 
  
        default: disp0 = 8'b11111111; 
      endcase
      led = 8'b10101010;
    end
  
  A_GAME_OVER: begin

    disp3 = 8'b01110111;  

    case (A_game)
      3'b000: disp2 = 8'b00111111; 
      3'b001: disp2 = 8'b00000110;
      3'b010: disp2 = 8'b01011011;
    

      default: disp2 = 8'b11111111; 
    endcase
    disp1 = 8'b01000000;  
    case (B_game)
    3'b000: disp0 = 8'b00111111; 
    3'b001: disp0 = 8'b00000110; 
    3'b010: disp0 = 8'b01011011; 

      default: disp0 = 8'b11111111; 
    endcase
    led = 8'b10101010;
  
 
   

    end
    A_GAME_OVER1:begin
      disp3 = 8'b01110111;  

      case (A_game)
        3'b000: disp2 = 8'b00111111; 
        3'b001: disp2 = 8'b00000110; 
        3'b010: disp2 = 8'b01011011;  

        default: disp2 = 8'b11111111; 
      endcase
      disp1 = 8'b01000000;  
      case (B_game)
      3'b000: disp0 = 8'b00111111; 
      3'b001: disp0 = 8'b00000110; 
      3'b010: disp0 = 8'b01011011; 

        default: disp0 = 8'b11111111; 
      endcase
      led = 8'b01010101;
    end
    B_GAME_OVER: begin
    disp3 = 8'b01111100;  

    case (A_game)
      3'b000: disp2 = 8'b00111111; 
      3'b001: disp2 = 8'b00000110; 
      3'b010: disp2 = 8'b01011011; 

      default: disp2 = 8'b11111111; 
    endcase

    disp1 = 8'b01000000;  

    case (B_game)
      3'b000: disp0 = 8'b00111111; 
      3'b001: disp0 = 8'b00000110; 
      3'b010: disp0 = 8'b01011011; 
   
      default: disp0 = 8'b11111111; 
    endcase
    led = 8'b10101010;
    
    
end
  B_GAME_OVER1:begin
    disp3 = 8'b01111100;  

    case (A_game)
      3'b000: disp2 = 8'b00111111; 
      3'b001: disp2 = 8'b00000110; 
      3'b010: disp2 = 8'b01011011;
    
      default: disp2 = 8'b11111111; 
    endcase

    disp1 = 8'b01000000;  

    case (B_game)
      3'b000: disp0 = 8'b00111111; 
      3'b001: disp0 = 8'b00000110; 
      3'b010: disp0 = 8'b01011011; 
 
      default: disp0 = 8'b11111111; 
    endcase
    led = 8'b01010101;
  end
  
  endcase
end


always @(posedge clk or posedge rst) begin
if (rst) begin
  state <= IDLE;
  next_state <= IDLE;
  score_A <= 0;
  A_game<=0;
  score_B <= 0;
  B_game<=0;
  input_count_A <= 0;
  input_count_B <= 0;
  timer <= 0;
  timer_winner<= 0;
  player_will_start<=0;

 
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
    player_will_start<=0;
    timer <= 0;
    next_state <= SHOW_A;

  end         
  SHOW_A: if (timer == 30) begin 
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
        if (player_will_start==0)begin
          next_state <= SHOW_B;
        end

        else begin
          next_state<=SHOW_SCORE;
        end
      else 
        input_count_A <= input_count_A + 1;
    end else if (pAb && mapA[index] == 1) 
      next_state <= ERROR_A;
  end
  ERROR_A: if (timer == 30) begin 
    next_state <= A_IN;
    timer <= 0;
  end else begin
    timer <= timer + 1;
  end
  SHOW_B: if (timer == 30) begin
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
          input_count_B <= input_count_B + 1; 
          if(player_will_start==1)begin
            next_state<=SHOW_A;
          end else begin
            next_state <= SHOW_SCORE;

          end
        end
      end else begin
        next_state <= ERROR_B;
      end
    end
  end
  ERROR_B: if (timer == 30) begin 
    next_state <= B_IN;
    timer <= 0;
  end else begin
    timer <= timer + 1;
  end
  SHOW_SCORE: if (timer == 50)begin

    if(player_will_start==1)begin
      next_state <= B_SHOOT;
    end else begin
      next_state <= A_SHOOT;

    end 
    
  end

  else begin
    timer <= timer + 1;
  end 
  A_SHOOT: if (pAb) begin
    timer <= 0;
    if (mapB[index]) begin
      score_A <= score_A + 1;
      mapB[index] <= 0;
      z <= 1; 
      next_state <= A_SINK;
    end else 
      z <= 0; 
      next_state <= A_SINK;
  end
  A_SINK: if (timer == 50) begin 
    timer_winner <= timer_winner + 1;
    timer <= 0;
    if (score_A >= 4) 
      next_state <= A_WIN;
    else 
      next_state <= B_SHOOT;
  end else timer <= timer + 1;
  B_SHOOT: if (pBb) begin
    timer<=0;
    if (mapA[index]) begin
      score_B <= score_B + 1;
      mapA[index] <= 0;
      z <= 1; 
      next_state <= B_SINK;
    end else 
      z <= 0; 
      next_state <= B_SINK;
  end
  B_SINK: if (timer == 50) begin 
    timer=0;
    timer_winner=0;
    if (score_B >=4) 
      next_state <= B_WIN;
    else 
      next_state <= A_SHOOT;
  end else timer <= timer + 1;

    A_WIN:if(timer==50) begin
      player_will_start <= 0; 
      timer <= 0;
      if (A_game+1==2) begin 
        A_game<=A_game+1;

        next_state <= A_GAME_OVER;
      end else begin
        A_game <= A_game + 1; 
        next_state <= ROUND_SCORE;
      end
    
      
    end else begin
      
        timer <= timer + 1;
      
    end
    
    B_WIN: if (timer==50) begin
      player_will_start <= 1; 
      timer <= 0;
      if (B_game +1== 2) begin 
        B_game<=B_game+1;
        next_state <= B_GAME_OVER;
      end else begin
        B_game <= B_game + 1; 
        next_state <= ROUND_SCORE; 
      end
    end else begin
      timer <= timer + 1;

    end
     
    ROUND_SCORE: if (timer == 100) begin
     
      score_A <= 0;         
      score_B <= 0;
      input_count_A <= 0;   
      input_count_B <= 0;
      timer <= 0;
      
      mapA[0] <= 0; mapA[1] <= 0; mapA[2] <= 0; mapA[3] <= 0;
      mapA[4] <= 0; mapA[5] <= 0; mapA[6] <= 0; mapA[7] <= 0;
      mapA[8] <= 0; mapA[9] <= 0; mapA[10] <= 0; mapA[11] <= 0;
      mapA[12] <= 0; mapA[13] <= 0; mapA[14] <= 0; mapA[15] <= 0;

      mapB[0] <= 0; mapB[1] <= 0; mapB[2] <= 0; mapB[3] <= 0;
      mapB[4] <= 0; mapB[5] <= 0; mapB[6] <= 0; mapB[7] <= 0;
      mapB[8] <= 0; mapB[9] <= 0; mapB[10] <= 0; mapB[11] <= 0;
      mapB[12] <= 0; mapB[13] <= 0; mapB[14] <= 0; mapB[15] <= 0;
    
      
      if (player_will_start == 0) begin
        next_state <= SHOW_A;
      end else begin
        next_state <= SHOW_B; 
      end
    end else begin
      timer <= timer + 1;
    end
    
      
    A_GAME_OVER: if(timer==50)begin
        timer<=0;
        next_state<=A_GAME_OVER1;
      end else begin
        timer<=timer+1;
      end
      

      A_GAME_OVER1: if(timer==50)begin
        timer<=0;
        next_state<=A_GAME_OVER;
      end else begin
        timer<=timer+1;
      end
    
      B_GAME_OVER: if(timer==50)begin
        timer<=0;
        next_state<=B_GAME_OVER1;
      end else begin
        timer<=timer+1;
      end

      B_GAME_OVER1: if(timer==50)begin
        timer<=0;
        next_state<=B_GAME_OVER;
      end else begin
        timer<=timer+1;
      end
      
      
   
    
  endcase
end
end

endmodule










