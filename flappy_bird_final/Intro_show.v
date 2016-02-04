`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    15:04:20 07/22/2014
// Design Name: 
// Module Name:    Intro_show 
//////////////////////////////////////////////////////////////////////////////////

module Intro_show( 
                  clk , 
                  rst_n , 
                  current_pixel_x, 
                  current_pixel_y,
                  intro_x,
                  intro_y, 
                  intro_type,
                  intro_valid,
                  score_intro_valid, 
						
                  intro_pixel, 
                  intro_pixel_valid,
                  score_intro_pixel, 
                  score_intro_pixel_valid
                  );
    
  input clk;
  input rst_n;
  input current_pixel_x;
  input current_pixel_y;
  input intro_x;
  input intro_y;
  input intro_type;
  input intro_valid;
  input score_intro_valid;
  
  output intro_pixel;
  output intro_pixel_valid;
  output score_intro_pixel;
  output score_intro_pixel_valid;
	 
  parameter intro_height = 10'd54;
  parameter intro_width  = 10'd198;
  parameter score_intro_height = 10'd15;
  parameter score_intro_width  = 10'd49;
  
  parameter score_intro_x = 10'd421;
  parameter score_intro_y_score = 10'd277;
  parameter score_intro_y_best  = 10'd227;
  

  parameter black = 24'b0;
  parameter white = 24'b11111111_11111111_11111111;
  
  parameter light_green = 24'b01011000_11011000_01011000;
  parameter dark_green  = 24'b00000000_10101000_01001000;
  parameter light_orange = 24'b11111100_10100000_01001000;
  parameter dark_orange  = 24'b11100100_01100000_00011000;
  
	 
	 wire clk,rst_n;
	 wire [ 9 : 0 ]current_pixel_x , current_pixel_y;
	 wire [ 9 : 0 ]intro_x , intro_y;
	 wire intro_type;
	 wire intro_valid , score_intro_valid;
	 
	 
	 reg [ 23 : 0 ]intro_pixel;
	 reg [ 23 : 0 ]score_intro_pixel;
	 reg intro_pixel_valid;
	 reg score_intro_pixel_valid;
	 
	 wire if_not_valid_intro ;
	 wire if_not_valid_score_intro ;
	 wire [ 9 : 0 ]row_in_pic_intro;
	 wire [ 9 : 0 ]column_in_pic_intro;
	 wire [ 9 : 0 ]row_in_pic_score_intro;
	 wire [ 9 : 0 ]column_in_pic_score_intro;
	 
	 wire [ 13 : 0]rom_address_intro;
	 wire [ 7 : 0]rom_output_intro;
	 reg [ 3 : 0]rom_output_intro_select;
	 
	 wire [ 9 : 0]rom_address_score_intro;
	 wire [ 3 : 0]rom_output_score_intro;
	 reg [ 1 : 0]rom_output_score_intro_select;
	 
	 reg [ 23 : 0 ]pixel_output_intro;
	 reg [ 23 : 0 ]pixel_output_score_intro;
	
	
   assign if_not_valid_intro =  ( (current_pixel_x < intro_x) 
                                ||(current_pixel_x > intro_x + intro_width)
                                ||(current_pixel_y < intro_y)
                                ||(current_pixel_y > intro_y + intro_height - 1)
                                ||(!intro_valid)
									               );
									               
   assign if_not_valid_score_intro = ( (current_pixel_x < score_intro_x) 
                                     ||(current_pixel_x > score_intro_x + score_intro_width)
                                     ||(current_pixel_y < score_intro_y_best)
                                     ||(current_pixel_y > score_intro_y_score + score_intro_height - 1)
                                     ||((current_pixel_y > (score_intro_y_best + score_intro_height - 1))&&(current_pixel_y < score_intro_y_score))
                                     ||(!score_intro_valid)
									           );
	
//    assign if_not_vaild_score_intro = !((current_pixel_x >= score_intro_x)
//												 && (current_pixel_x <= score_intro_x + score_intro_width))
	 //assign if_not_valid_score_intro = 1;
	 assign row_in_pic_intro    = intro_y + intro_height - 1 - current_pixel_y;
	 assign column_in_pic_intro = current_pixel_x - intro_x;
	 assign rom_address_intro = (!if_not_valid_intro)?(row_in_pic_intro*(intro_width) + column_in_pic_intro):14'b0;
	 
	 assign row_in_pic_score_intro    = (current_pixel_y >= score_intro_y_score)
	                                  ? (score_intro_y_score + score_intro_height - 1 - current_pixel_y)
	                                  : (score_intro_y_best  + score_intro_height - 1 - current_pixel_y);                      
	 assign column_in_pic_score_intro = current_pixel_x - score_intro_x;
	 assign rom_address_score_intro = (!if_not_valid_score_intro)?(row_in_pic_score_intro*(score_intro_width) + column_in_pic_score_intro):10'b0;	
  
	 
	 intro_rom rom_intro_0( 
                       .clka(clk),
                       .addra(rom_address_intro),
                       .douta(rom_output_intro)
                       );
   score_intro_rom rom_score_intro_0( 
                                     .clka(clk),
                                     .addra(rom_address_score_intro),
                                     .douta(rom_output_score_intro)
                                     );
                       
                       
	always@(rom_output_intro,rom_output_intro_select,intro_type)
	if(!intro_type)
	  rom_output_intro_select <= rom_output_intro[7:4];
	else
	  rom_output_intro_select <= rom_output_intro[3:0];
	
	always@(rom_output_score_intro,rom_output_score_intro_select ,current_pixel_y)
	if(current_pixel_y >= score_intro_y_score)
	  rom_output_score_intro_select <= rom_output_score_intro[3:2];
	else
	  rom_output_score_intro_select <= rom_output_score_intro[1:0];
	  
	  
	always@(rom_output_intro_select,pixel_output_intro)
	case(rom_output_intro_select[2:0])
	  3'b000 : pixel_output_intro <= black;
	  3'b001 : pixel_output_intro <= white;
	  3'b010 : pixel_output_intro <= light_green;
	  3'b011 : pixel_output_intro <= dark_green;
	  3'b100 : pixel_output_intro <= light_orange;
	  3'b101 : pixel_output_intro <= dark_orange;
	endcase
	
	always@(rom_output_score_intro_select,pixel_output_score_intro)
	case(rom_output_score_intro_select[0])
	  1'b0 : pixel_output_score_intro <= white; 
	  1'b1 : pixel_output_score_intro <= 24'b10000000_10000000_10000000;
	endcase
	  
				
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   intro_pixel <= 24'b0;
	 else if(if_not_valid_intro)
	   intro_pixel <= 24'b0;
	 else
	   intro_pixel[23:0] <= pixel_output_intro;
	   
	   
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   score_intro_pixel <= 24'b0;
	 else if(if_not_valid_score_intro)
	   score_intro_pixel <= 24'b0;
	 else
	   score_intro_pixel[23:0] <= pixel_output_score_intro;
		
		
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   intro_pixel_valid <= 0;
	 else if(if_not_valid_intro)
	   intro_pixel_valid <= 0;
	 else
	   intro_pixel_valid <= rom_output_intro_select[3];
	   
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   score_intro_pixel_valid <= 0;
	 else if(if_not_valid_score_intro)
	   score_intro_pixel_valid <= 0;
	 else
	   score_intro_pixel_valid <= rom_output_score_intro_select[1];
		
endmodule
				