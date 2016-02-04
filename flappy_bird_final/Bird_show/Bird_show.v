`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    15:04:20 07/02/2009 
// Design Name: 
// Module Name:    Bird_show 
//////////////////////////////////////////////////////////////////////////////////

module Bird_show( clk , 
						rst_n , 
						current_pixel_row, 
						current_pixel_column, 
						bird_valid, 
						bird_height, 
						bird_color_select,
						bird_angle,
						
						bird_pixel, 
						bird_pixel_valid
						);
    
	 input clk;
    input rst_n;
    input current_pixel_row;
    input current_pixel_column;
	 input bird_color_select;
	 input bird_angle;
    input bird_valid;
    input bird_height;
    output bird_pixel;
    output bird_pixel_valid;
	 
	 parameter bird_length = 5'd31;
	 parameter bird_width  = 5'd31;
	 parameter bird_location_horizontal = 7'd100;
	 
	 parameter black = 24'b0;
	 parameter white = 24'b11111111_11111111_11111111;
	 parameter red   = 24'b11111110_01101001_01001001;
	 parameter grey  = 24'b11110100_11110000_11110001;
	 
	 parameter body_yellow = 24'b11111000_11110010_00010010;
	 
	 wire clk,rst_n;
	 wire bird_valid;
	 wire [ 9 : 0 ]current_pixel_row , current_pixel_column;
	 wire [ 8 : 0 ]bird_height;
	 wire [ 2 : 0 ]bird_color_select;
	 wire [ 2 : 0 ]bird_angle;
	 
	 reg [ 23 : 0 ]bird_pixel;
	 reg bird_pixel_valid;
	 
	 
	 wire if_not_valid;
	 wire [ 4 : 0 ]row_in_pic;
	 wire [ 4 : 0 ]column_in_pic;
	 wire [9:0]rom_address;
	 wire [3:0]rom_output_0;
	 wire [3:0]rom_output;
	 
	 wire [ 23 : 0 ]body_color;
	 reg [ 23 : 0 ]pixel_output;
	 
	 
	 assign if_not_valid =  ( (current_pixel_row < bird_location_horizontal) 
									||(current_pixel_row > bird_location_horizontal + bird_width)
									||(current_pixel_column < bird_height)
									||(current_pixel_column > bird_height + bird_length)
									||(!bird_valid)
									);
	
	 assign row_in_pic    = bird_height + bird_length - current_pixel_row;
	 assign column_in_pic = current_pixel_column - bird_location_horizontal;
	 assign rom_address = (!if_not_valid)?((row_in_pic*bird_width) + column_in_pic):10'b0;
	 
	 bird_0 rom_bird_0(
	                   .A(rom_address),
							 .SPO(rom_output_0)
							 );
	//select the angle
    assign rom_output = rom_output_0;	
	//select the color
	 assign body_color = body_yellow;
						 
	 always@(pixel_output,rom_output)
	 case(rom_output)
	   4'b1000 : pixel_output <= body_color;                                                                                                                                                       
		4'b1001 : pixel_output <= white;
		4'b1010 : pixel_output <= black;
		4'b1011 : pixel_output <= red;
		4'b1100 : pixel_output <= grey;
	   default : pixel_output <= 24'b0;
	 endcase
						
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   bird_pixel <= 24'b0;
	 else if(if_not_valid)
	   bird_pixel <= 24'b0;
	 else
	   bird_pixel[23:0] <= pixel_output;
		
		
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   bird_pixel_valid <= 0;
	 else if(if_not_valid)
	   bird_pixel_valid <= 0;
	 else
	   bird_pixel_valid <= rom_output[3];
		
endmodule
		