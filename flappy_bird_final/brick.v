module brick    ( clk 
                  , rst_n
                  , h_line
                  , v_line
                  , valid_out
                  , color_out );

  input           clk 
                  , rst_n
                  , h_line
                  , v_line;
                   
        
  output valid_out ,
         color_out ;
  wire clk , rst_n ;
  wire [9:0]v_line ;
  wire [9:0]h_line ;
  wire valid_out;
  wire [23:0]color_out;
         
  wire odd;
  wire [9:0] h_line_revised;
  assign h_line_revised = h_line - 32;
  assign odd = v_line[5];
  wire [10:0] addr;
  assign addr = (odd == 1) ? h_line[5:0] - v_line[4:0]*64: h_line_revised[5:0] - v_line[4:0]*64;
  wire [1:0]color_select;
         
  brick_rom brick_rom1( 
                  .clka(clk),
                  .addra(addr),
                  .douta(color_select));
					
					
  assign valid_out = (h_line > 300);
  assign color_out = (color_select[0]==0) ? {8'd161,8'd43,8'd3} : {8'd95,8'd95,8'd105};
         
//  parameter std_h = 10'd320;
//  parameter std_v = 10'd0;
//
//
//  wire clk , rst_n ;
//  wire [8:0]v_line ;
//  wire [8:0]h_line ;
//  reg  valid_out ;
//  reg  [23:0]color_out ;
//  wire [2:0]color_select ;
//  wire brick_valid ;
//  wire odd_or_even ;
//  wire [8:0]add;
//  wire [4:0]v_line_check ;
//  wire [2:0]h_line_check ;
//  reg  [8:0]v_line_virtual ;
//  reg [8:0]h_line_virtual ;
//  wire [8:0]h_line_check_1;
//  wire [8:0]h_line_check_2;
//  
//  assign h_line_check_1 = (h_line-320) / 64 ;
//  assign h_line_check_2 = (h_line-320 +32 ) / 64 ;
//  assign v_line_check = v_line / 32 ;
//  assign brick_valid = (h_line >= 320) ;
//  assign odd_or_even = (v_line <32)||((v_line>=64)&&(v_line<96))||((v_line>=128)&&(v_line<160))||((v_line>=192)&&(v_line<224))||((v_line>=256)&&(v_line<288))||((v_line>=320)&&(v_line<352))||((v_line>=384)&&(v_line<416))||(v_line>=448)   ;                 
//  
//    always @(h_line ,
//         v_line , v_line_check)
//    case(v_line_check)
//      5'd0: v_line_virtual <= v_line ;
//      5'd1: v_line_virtual <= v_line -32;
//      5'd2: v_line_virtual <= v_line -64;
//      5'd3: v_line_virtual <= v_line -96;
//      5'd4: v_line_virtual <= v_line -128;
//      5'd5: v_line_virtual <= v_line -160;
//      5'd6: v_line_virtual <= v_line -192;
//      5'd7: v_line_virtual <= v_line -224;
//      5'd8: v_line_virtual <= v_line -256;
//      5'd9: v_line_virtual <= v_line -288;
//      5'd10: v_line_virtual <= v_line -320;
//      5'd11: v_line_virtual <= v_line -352;
//      5'd12: v_line_virtual <= v_line -384;
//      5'd13: v_line_virtual <= v_line -416;
//      5'd14: v_line_virtual <= v_line -448;
//		5'd15: v_line_virtual <= v_line -480;
//    endcase
//
//      always @(h_line ,
//         v_line , odd_or_even	,h_line_check_2 ,h_line_check_1)
//         if(!odd_or_even)
//    case(h_line_check_2)
//      3'd0: h_line_virtual <= h_line + 32;
//      3'd1: h_line_virtual <= h_line + 32 -64;
//      3'd2: h_line_virtual <= h_line + 32 -128;
//      3'd3: h_line_virtual <= h_line + 32 -192;
//      3'd4: h_line_virtual <= h_line + 32 -256;
//		3'd5: h_line_virtual <= h_line + 32 -320;
//    endcase
//  else
//    case(h_line_check_1)
//      3'd0: h_line_virtual <= h_line ;
//      3'd1: h_line_virtual <= h_line  -64;
//      3'd2: h_line_virtual <= h_line  -128;
//      3'd3: h_line_virtual <= h_line  -192;
//      3'd4: h_line_virtual <= h_line  -256;
//		3'd5: h_line_virtual <= h_line  -320;
//    endcase
//  
//  
//  
//  
//  
//  assign add = (h_line_virtual - std_h)+ 2* (v_line_virtual - std_v)+1 ;
//  
//  
//  
//  
//  
//  
//
//  brick_rom brick_rom1( 
//                  .clka(clk),
//                  .addra(add),
//                  .douta(color_select)); 
//                  
//
//                                  
//
//   
//  always @(h_line ,
//         v_line ,
//         color_select, brick_valid 	)
//  if(brick_valid )
//      if(color_select[1])
//		begin
//        valid_out<= 1;
//  case(color_select)
//    2'd2: color_out <= {8'd161,8'd43,8'd3};
//    2'd3: color_out <= {8'd95,8'd95,8'd105};
//  endcase
//  end
//  else
//    valid_out <= 0;
//	 else
//	 valid_out <= 0;

   

endmodule
  
  
  