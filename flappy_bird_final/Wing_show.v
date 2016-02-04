
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    15:04:20 07/014/2009 
// Design Name: 
// Module Name:    Wing_show 
//////////////////////////////////////////////////////////////////////////////////

module Wing_show( clk , 
						rst_n , 
						current_pixel_x, 
						current_pixel_y, 
						wing_valid, 
						wing_height, 
						wing_color_select,
						wing_angle,
						wing_state,
						
						wing_pixel, 
						wing_pixel_valid
						);
    
	 input clk;
    input rst_n;
    input current_pixel_x;
    input current_pixel_y;
	 input wing_color_select;
	 input wing_angle;
	 input wing_state;
    input wing_valid;
    input wing_height;
    output wing_pixel;
    output wing_pixel_valid;
	 
	 parameter wing_length = 5'd31;
	 parameter wing_width  = 5'd31;
	 parameter wing_location_horizontal = 7'd99;
	 
	 parameter black = 24'b0;
	 parameter white = 24'b11111111_11111111_11111111;
	 parameter red   = 24'b11111110_01101001_01001001;
	 parameter grey  = 24'b11110100_11110000_11110001;
	 
	 parameter body_yellow = 24'b11111000_11110010_00010010;
	 
	 wire clk,rst_n;
	 wire wing_valid;
	 wire [ 9 : 0 ]current_pixel_x , current_pixel_y;
	 wire [ 8 : 0 ]wing_height;
	 wire [ 1 : 0 ]wing_color_select;
	 wire [ 3 : 0 ]wing_angle;
	 wire [ 2 : 0 ]wing_state;
	 
	 reg [ 23 : 0 ]wing_pixel;
	 reg wing_pixel_valid;
	 
	 
	 wire if_not_valid;
	 wire [ 4 : 0 ]row_in_pic;
	 wire [ 4 : 0 ]column_in_pic;
	 
	 wire [9:0]rom_address;
	 reg [2:0]rom_output_select;
	 wire [50:0]rom_output;
	 
	 wire [ 23 : 0 ]wing_color;
	 reg [ 23 : 0 ]pixel_output;
	 
	 
	 assign if_not_valid =  ( (current_pixel_x < wing_location_horizontal) 
									||(current_pixel_x > wing_location_horizontal + wing_width)
									||(current_pixel_y < wing_height)
									||(current_pixel_y > wing_height + wing_length)
									||(!wing_valid)
									);
	
	 assign row_in_pic    = wing_height + wing_length - current_pixel_y;
	 assign column_in_pic = current_pixel_x - wing_location_horizontal;
	 assign rom_address = (!if_not_valid)?((row_in_pic*(wing_width+1)) + column_in_pic):10'b0;
	 
	 wing_rom wing_rom_0( 
								.clka(clk),
								.addra(rom_address),
								.douta(rom_output)
							 );
	//select the angle
	always@(rom_output_select,rom_output,wing_angle,wing_state)
	case(wing_angle)
    4'b0000 :	case(wing_state)
						2'b00 : rom_output_select <= rom_output[50:48];
						2'b01 : rom_output_select <= rom_output[47:45];
						2'b10 : rom_output_select <= rom_output[44:42];
					endcase
	 4'b0001 :	case(wing_state)
						2'b00 : rom_output_select <= rom_output[41:39];
						2'b01 : rom_output_select <= rom_output[38:36];
						2'b10 : rom_output_select <= rom_output[35:33];
					endcase
	 4'b0010 :	case(wing_state)
						2'b00 : rom_output_select <= rom_output[32:30];
						2'b01 : rom_output_select <= rom_output[29:27];
						2'b10 : rom_output_select <= rom_output[26:24];
					endcase
	 4'b0011 :	rom_output_select <= rom_output[23:21];
	 4'b0100 :	rom_output_select <= rom_output[20:18];
	 4'b0101 :	rom_output_select <= rom_output[17:15];
	 4'b0110 :	rom_output_select <= rom_output[14:12];
	 4'b0111 :	rom_output_select <= rom_output[11:9];
	 4'b1000 :	rom_output_select <= rom_output[8:6];
	 4'b1001 :	rom_output_select <= rom_output[5:3];
	 4'b1010 :	rom_output_select <= rom_output[2:0];
	endcase
	
	 
	//select the color
	 assign wing_color = body_yellow;
						 
	 always@(pixel_output,rom_output_select)
	 case(rom_output_select)
	   3'b100 : pixel_output <= wing_color;                                                                                                                                                       
		3'b101 : pixel_output <= white ;
		3'b110 : pixel_output <= (wing_color_select != 2'b11)?black : white;
	   default : pixel_output <= 24'b0;
	 endcase
						
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   wing_pixel <= 24'b0;
	 else if(if_not_valid)
	   wing_pixel <= 24'b0;
	 else
	   wing_pixel[23:0] <= pixel_output;
		
		
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   wing_pixel_valid <= 0;
	 else if(if_not_valid)
	   wing_pixel_valid <= 0;
	 else
	   wing_pixel_valid <= rom_output_select[2];
		
endmodule