`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    15:04:20 07/02/2009 
// Design Name: 
// Module Name:    Bird_show 
//////////////////////////////////////////////////////////////////////////////////

module Bird_show( clk , 
						rst_n , 
						current_pixel_x, 
						current_pixel_y, 
						bird_valid, 
						bird_height, 
						bird_color_select,
						bird_angle,
						
						bird_pixel, 
						bird_pixel_valid
						);
    
	 input clk;
    input rst_n;
    input current_pixel_x;
    input current_pixel_y;
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
	 parameter body_red    = 24'b11111000_00100001_00000000;
	 parameter body_blue   = 24'b01000110_10011110_11010111;
	 
	 parameter lip_red = 24'b11111110_01101001_01001001 ;
	 parameter lip_orange = 24'b11100110_10011110_00101010 ;
	 
	 wire clk,rst_n;
	 wire bird_valid;
	 wire [ 9 : 0 ]current_pixel_x , current_pixel_y;
	 wire [ 8 : 0 ]bird_height;
	 wire [ 1 : 0 ]bird_color_select;
	 wire [ 3 : 0 ]bird_angle;
	 
	 reg [ 23 : 0 ]bird_pixel;
	 reg bird_pixel_valid;
	 
	 
	 wire if_not_valid;
	 wire [ 4 : 0 ]row_in_pic;
	 wire [ 4 : 0 ]column_in_pic;
	 wire [9:0]rom_address;
	 reg [3:0]rom_output_select;
	 wire [43:0]rom_output;
	 
	 reg [ 23 : 0 ]body_color;
	 reg [ 23 : 0 ]lip_color;
	 reg [ 23 : 0 ]pixel_output;
	 
	 
	 assign if_not_valid =  ( (current_pixel_x < bird_location_horizontal + 1) 
									||(current_pixel_x > bird_location_horizontal + bird_width + 1)
									||(current_pixel_y < bird_height)
									||(current_pixel_y > bird_height + bird_length)
									||(!bird_valid)
									);
	
	 assign row_in_pic    = bird_height + bird_length - current_pixel_y;
	 assign column_in_pic = current_pixel_x - bird_location_horizontal;
	 assign rom_address = (!if_not_valid)?((row_in_pic*(bird_width+1)) + column_in_pic):10'b0;
	 
	 bird_rom rom_bird_0( 
								.clka(clk),
								.addra(rom_address),
								.douta(rom_output)
							 );
	//select the angle
	always@(rom_output_select,rom_output,bird_angle)
	case(bird_angle)
    4'b0000 :	rom_output_select <= rom_output[43:40];
	 4'b0001 :	rom_output_select <= rom_output[39:36];
	 4'b0010 :	rom_output_select <= rom_output[35:32];
	 4'b0011 :	rom_output_select <= rom_output[31:28];
	 4'b0100 :	rom_output_select <= rom_output[27:24];
	 4'b0101 :	rom_output_select <= rom_output[23:20];
	 4'b0110 :	rom_output_select <= rom_output[19:16];
	 4'b0111 :	rom_output_select <= rom_output[15:12];
	 4'b1000 :	rom_output_select <= rom_output[11:8];
	 4'b1001 :	rom_output_select <= rom_output[7:4];
	 4'b1010 :	rom_output_select <= rom_output[3:0];
	endcase
	
	 
	//select the color
	 always@(bird_color_select , body_color , lip_color)
	 case(bird_color_select)
	   2'b00 : {body_color , lip_color} <= {body_yellow , lip_red};
		2'b01 : {body_color , lip_color} <= {body_blue , lip_red};
		2'b10 : {body_color , lip_color} <= {body_red , lip_orange};
		2'b11 : {body_color , lip_color} <= {body_yellow , lip_red};
	 endcase
						 
	 always@(pixel_output,rom_output_select , bird_color_select)
	 case(rom_output_select)
	   4'b1000 : pixel_output <= (bird_color_select != 2'b11)?body_color : white;                                                                                                                                        
		4'b1001 : pixel_output <= white;
		4'b1010 : pixel_output <= (bird_color_select != 2'b11)?black : white;
		4'b1011 : pixel_output <= (bird_color_select != 2'b11)?lip_color : white;
		4'b1100 : pixel_output <= (bird_color_select != 2'b11)?grey : white;
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
	   bird_pixel_valid <= rom_output_select[3];
		
endmodule
				