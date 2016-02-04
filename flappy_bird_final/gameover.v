module gameover     ( clk 
                  , rst_n
                  , h_line
                  , v_line
                  , control
						, valid_in
                  , valid_out
                  , color_out );

  input           clk 
                  , rst_n
                  , h_line
                  , v_line
                  , control
						, valid_in;
                   
        
  output valid_out ,
         color_out ;


  wire clk , rst_n ;
  wire [9:0]v_line ;
  wire [9:0]h_line ;
  wire control ;
  wire valid_in;
  reg  valid_out ;
  reg  [23:0]color_out ;
  wire [7:0]color_select ;
  wire gameover_valid ;
  
  wire [14:0]add;

  
  
//  parameter std_1_h = 10'd340;
//  parameter std_1_v = 10'd350;
//  parameter std_2_h = 10'd538;
//  parameter std_2_v = 10'd350;
  parameter std_3_h = 10'd340;
  parameter std_3_v = 10'd296;
//  parameter std_4_h = 10'd538;
//  parameter std_4_v = 10'd296;

  
  
  assign gameover_valid = (h_line >= std_3_h)&&(h_line <=std_3_h+197)&&(v_line >=std_3_v)&&(v_line <=std_3_v+53) ;
  assign add = (h_line - std_3_h)+ 198* (std_3_v + 53- v_line)+1 ;

  

  intro_rom intro_rom_1( 
                  .clka(clk),
                  .addra(add),
                  .douta(color_select)); 
                  

                               

   
  always @(h_line ,
         v_line ,
         color_select	)
  if(gameover_valid && valid_in && control && color_select[3])      
    begin
      valid_out<= 1;
  case(color_select[3:0])
    4'd8: color_out <= {8'd0,8'd0,8'd0};
    4'd9: color_out <= {8'd255,8'd255,8'd255};
    4'd10: color_out <= {8'd88,8'd216,8'd88};
    4'd11: color_out <= {8'd0,8'd168,8'd72};
    4'd12: color_out <= {8'd252,8'd160,8'd72};
    4'd13: color_out <= {8'd228,8'd96,8'd24};
  endcase
  end
   else if(gameover_valid && valid_in && (!control) && color_select[7])      
    begin
      valid_out<= 1;
  case(color_select[7:4])
    4'd8: color_out <= {8'd0,8'd0,8'd0};
    4'd9: color_out <= {8'd255,8'd255,8'd255};
    4'd10: color_out <= {8'd88,8'd216,8'd88};
    4'd11: color_out <= {8'd0,8'd168,8'd72};
    4'd12: color_out <= {8'd252,8'd160,8'd72};
    4'd13: color_out <= {8'd228,8'd96,8'd24};
  endcase
  end
else
  valid_out <= 0;

  
  
endmodule
  
  
  