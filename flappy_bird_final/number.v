module number     ( clk 
                  , rst_n
                  , h_line
                  , v_line
                  , number_0
                  , number_1
                  , number_2
                  , number_3
                  , highest_1
                  , highest_2
                  , highest_3
                  , highest_0	
                  , valid_in
                  , valid_out
                  , color_out );

  input           clk 
                  , rst_n
                  , h_line
                  , v_line
                  , number_0
                  , number_1
                  , number_2
                  , number_3	
                  , highest_1
                  , highest_2
                  , highest_3
                  , highest_0	
                  , valid_in ;
          
  output valid_out ,
         color_out ;


  wire clk , rst_n ;
  wire [8:0]v_line ;
  wire [8:0]h_line ;
  wire [3:0]number_0 ;
  wire [3:0]number_1 ;
  wire [3:0]number_2 ;
  wire [3:0]number_3 ;
  wire [3:0]highest_0;
  wire [3:0]highest_1;
  wire [3:0]highest_2;
  wire [3:0]highest_3;
  wire valid_in ;
  reg  valid_out ;
  reg  [23:0]color_out ;
  wire  [19:0]color_select_1 ;
  wire  [19:0]color_select_2 ;
  wire  [19:0]color_select_3 ;
  wire  [19:0]color_select_4 ;
  wire  [19:0]color_select_5 ;
  wire  [19:0]color_select_6 ;
  wire  [19:0]color_select_7 ;
  wire  [19:0]color_select_8 ;
  reg  state_1;
  reg  state_2;
  reg  state_3;
  reg  state_4;
  reg  state_5;
  reg  state_6;
  reg  state_7;
  reg  state_8;
  reg  [1:0]black_white_select;
  
  wire [8:0]add_1;
  wire [8:0]add_2;
  wire [8:0]add_3;  
  wire [8:0]add_4; 
  wire [8:0]add_5;
  wire [8:0]add_6;
  wire [8:0]add_7;
  wire [8:0]add_8;
  
  
  parameter std_1_h = 10'd385;
  parameter std_1_v = 10'd250;
  parameter std_2_h = 10'd410;
  parameter std_2_v = 10'd250;
  parameter std_3_h = 10'd435;
  parameter std_3_v = 10'd250;
  parameter std_4_h = 10'd460;
  parameter std_4_v = 10'd250;
  parameter std_high_1_h = 10'd385;
  parameter std_high_1_v = 10'd200;
  parameter std_high_2_h = 10'd410;
  parameter std_high_2_v = 10'd200;
  parameter std_high_3_h = 10'd435;
  parameter std_high_3_v = 10'd200;
  parameter std_high_4_h = 10'd460;
  parameter std_high_4_v = 10'd200;
  
  
  
  
  assign add_1 = (h_line - std_1_h)+ 10* (std_1_v +19 - v_line)+1 ;
  assign add_2 = (h_line - std_2_h)+ 10* (std_2_v +19 - v_line)+1 ;
  assign add_3 = (h_line - std_3_h)+ 10* (std_3_v +19 - v_line)+1 ;
  assign add_4 = (h_line - std_4_h)+ 10* (std_4_v +19 - v_line)+1 ;
  assign add_5 = (h_line - std_high_1_h)+ 10* (std_high_1_v + 19 - v_line)+1 ;
  assign add_6 = (h_line - std_high_2_h)+ 10* (std_high_2_v + 19 - v_line)+1 ;
  assign add_7 = (h_line - std_high_3_h)+ 10* (std_high_3_v + 19 - v_line)+1 ;
  assign add_8 = (h_line - std_high_4_h)+ 10* (std_high_4_v + 19 - v_line)+1 ;
  

  num_rom num_rom_1( 
                  .clka(clk),
                  .addra(add_1),
                  .douta(color_select_1)); 
                  
  num_rom num_rom_2( 
                  .clka(clk),
                  .addra(add_2),
                  .douta(color_select_2)); 
    
  num_rom num_rom_3( 
                  .clka(clk),
                  .addra(add_3),
                  .douta(color_select_3)); 
                  
  num_rom num_rom_4( 
                  .clka(clk),
                  .addra(add_4),
                  .douta(color_select_4)); 
                  
  num_rom num_rom_5( 
                  .clka(clk),
                  .addra(add_5),
                  .douta(color_select_5)); 
                  
  num_rom num_rom_6( 
                  .clka(clk),
                  .addra(add_6),
                  .douta(color_select_6)); 
                  
                  
  num_rom num_rom_7( 
                  .clka(clk),
                  .addra(add_7),
                  .douta(color_select_7)); 
                  
                
  num_rom num_rom_8( 
                  .clka(clk),
                  .addra(add_8),
                  .douta(color_select_8));                  
                  
                  
                  
  
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0	)
 if((h_line >= std_1_h)&&(h_line <= std_1_h + 9)&&(v_line >= std_1_v)&&(v_line <= std_1_v +19))
   state_1 <= 1;
 else
   state_1 <= 0;
   
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0	)
 if((h_line >= std_2_h)&&(h_line <= std_2_h + 9)&&(v_line >= std_2_v)&&(v_line <= std_2_v +19))
   state_2 <= 1;
 else
   state_2 <= 0;
   
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0	)
 if((h_line >= std_3_h)&&(h_line <= std_3_h + 9)&&(v_line >= std_3_v)&&(v_line <= std_3_v +19))
   state_3 <= 1;
 else
   state_3 <= 0;
   
   
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0	)
 if((h_line >= std_4_h)&&(h_line <= std_4_h + 9)&&(v_line >= std_4_v)&&(v_line <= std_4_v +19))
   state_4 <= 1;
 else
   state_4 <= 0;
   
   
   always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0	)
 if((h_line >= std_high_1_h)&&(h_line <= std_high_1_h + 9)&&(v_line >= std_high_1_v)&&(v_line <= std_high_1_v +19))
   state_5 <= 1;
 else
   state_5 <= 0;  
   
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0	)
 if((h_line >= std_high_2_h)&&(h_line <= std_high_2_h + 9)&&(v_line >= std_high_2_v)&&(v_line <= std_high_2_v +19))
   state_6 <= 1;
 else
   state_6 <= 0;   
   
   
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0	)
 if((h_line >= std_high_3_h)&&(h_line <= std_high_3_h + 9)&&(v_line >= std_high_3_v)&&(v_line <= std_high_3_v +19))
   state_7 <= 1;
 else
   state_7 <= 0;   
   
   
   
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0	)
 if((h_line >= std_high_4_h)&&(h_line <= std_high_4_h + 9)&&(v_line >= std_high_4_v)&&(v_line <= std_high_4_v +19))
   state_8 <= 1;
 else
   state_8 <= 0;   
   
   
   
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0,
         color_select_1, 
			color_select_2, 
			color_select_3, 
			color_select_4, 
			color_select_5, 
			color_select_6, 
			color_select_7, 
			color_select_8, 
         black_white_select	)
  if((state_1)&&valid_in )
    begin
  case(number_0)
    4'd0: black_white_select = color_select_1[19:18];
    4'd1: black_white_select = color_select_1[17:16];
    4'd2: black_white_select = color_select_1[15:14];
    4'd3: black_white_select = color_select_1[13:12];
    4'd4: black_white_select = color_select_1[11:10];
    4'd5: black_white_select = color_select_1[9:8];
    4'd6: black_white_select = color_select_1[7:6];
    4'd7: black_white_select = color_select_1[5:4];
    4'd8: black_white_select = color_select_1[3:2];
    4'd9: black_white_select = color_select_1[1:0];
  endcase
  end
    else if((state_2) && valid_in)
    begin
  case(number_1)
    4'd0: black_white_select = color_select_2[19:18];
    4'd1: black_white_select = color_select_2[17:16];
    4'd2: black_white_select = color_select_2[15:14];
    4'd3: black_white_select = color_select_2[13:12];
    4'd4: black_white_select = color_select_2[11:10];
    4'd5: black_white_select = color_select_2[9:8];
    4'd6: black_white_select = color_select_2[7:6];
    4'd7: black_white_select = color_select_2[5:4];
    4'd8: black_white_select = color_select_2[3:2];
    4'd9: black_white_select = color_select_2[1:0];
  endcase
  end
    else if((state_3) && valid_in)
    begin
  case(number_2)
    4'd0: black_white_select = color_select_3[19:18];
    4'd1: black_white_select = color_select_3[17:16];
    4'd2: black_white_select = color_select_3[15:14];
    4'd3: black_white_select = color_select_3[13:12];
    4'd4: black_white_select = color_select_3[11:10];
    4'd5: black_white_select = color_select_3[9:8];
    4'd6: black_white_select = color_select_3[7:6];
    4'd7: black_white_select = color_select_3[5:4];
    4'd8: black_white_select = color_select_3[3:2];
    4'd9: black_white_select = color_select_3[1:0];
  endcase
  end
   else if((state_4) && valid_in)
    begin
  case(number_3)
    4'd0: black_white_select = color_select_4[19:18];
    4'd1: black_white_select = color_select_4[17:16];
    4'd2: black_white_select = color_select_4[15:14];
    4'd3: black_white_select = color_select_4[13:12];
    4'd4: black_white_select = color_select_4[11:10];
    4'd5: black_white_select = color_select_4[9:8];
    4'd6: black_white_select = color_select_4[7:6];
    4'd7: black_white_select = color_select_4[5:4];
    4'd8: black_white_select = color_select_4[3:2];
    4'd9: black_white_select = color_select_4[1:0];
  endcase
  end
    else if((state_5) && valid_in)
    begin
  case(highest_0)
    4'd0: black_white_select = color_select_5[19:18];
    4'd1: black_white_select = color_select_5[17:16];
    4'd2: black_white_select = color_select_5[15:14];
    4'd3: black_white_select = color_select_5[13:12];
    4'd4: black_white_select = color_select_5[11:10];
    4'd5: black_white_select = color_select_5[9:8];
    4'd6: black_white_select = color_select_5[7:6];
    4'd7: black_white_select = color_select_5[5:4];
    4'd8: black_white_select = color_select_5[3:2];
    4'd9: black_white_select = color_select_5[1:0];
  endcase
  end
  else if((state_6) &&valid_in)
    begin
  case(highest_1)
    4'd0: black_white_select = color_select_6[19:18];
    4'd1: black_white_select = color_select_6[17:16];
    4'd2: black_white_select = color_select_6[15:14];
    4'd3: black_white_select = color_select_6[13:12];
    4'd4: black_white_select = color_select_6[11:10];
    4'd5: black_white_select = color_select_6[9:8];
    4'd6: black_white_select = color_select_6[7:6];
    4'd7: black_white_select = color_select_6[5:4];
    4'd8: black_white_select = color_select_6[3:2];
    4'd9: black_white_select = color_select_6[1:0];
  endcase
  end
  else if((state_7)&& valid_in)
    begin
  case(highest_2)
    4'd0: black_white_select = color_select_7[19:18];
    4'd1: black_white_select = color_select_7[17:16];
    4'd2: black_white_select = color_select_7[15:14];
    4'd3: black_white_select = color_select_7[13:12];
    4'd4: black_white_select = color_select_7[11:10];
    4'd5: black_white_select = color_select_7[9:8];
    4'd6: black_white_select = color_select_7[7:6];
    4'd7: black_white_select = color_select_7[5:4];
    4'd8: black_white_select = color_select_7[3:2];
    4'd9: black_white_select = color_select_7[1:0];
  endcase
  end
  else if((state_8) &&valid_in)
    begin
  case(highest_3)
    4'd0: black_white_select = color_select_8[19:18];
    4'd1: black_white_select = color_select_8[17:16];
    4'd2: black_white_select = color_select_8[15:14];
    4'd3: black_white_select = color_select_8[13:12];
    4'd4: black_white_select = color_select_8[11:10];
    4'd5: black_white_select = color_select_8[9:8];
    4'd6: black_white_select = color_select_8[7:6];
    4'd7: black_white_select = color_select_8[5:4];
    4'd8: black_white_select = color_select_8[3:2];
    4'd9: black_white_select = color_select_8[1:0];
  endcase
  end
  else
  black_white_select = 2'b00;
  
 

   

	
	
  always @(h_line ,
         v_line ,
         number_0 ,
         number_1 ,
         number_2 ,
         number_3 ,
         valid_in ,
         highest_1,
         highest_2,
         highest_3,
         highest_0,
         black_white_select	)	
	  if(!black_white_select[1])
    valid_out <= 0;
  else
    if(black_white_select[0])
      begin
        valid_out <= 1;
        color_out <= {8'd255,8'd255,8'd255};
      end
    else
      begin
        valid_out <= 1;
        color_out <= {8'd 0,8'd0,8'd0};
      end
	
	
	
	
	
	
	
endmodule
  
  
  
  
  
  
  
  
  