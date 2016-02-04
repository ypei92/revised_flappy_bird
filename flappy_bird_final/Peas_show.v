
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:29:37 07/16/2014 
// Design Name: 
// Module Name:    peas_show
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Peas_show(
								clk , 
								rst_n , 
								current_pixel_x, 
								current_pixel_y, 
								peas_valid, 
								peas_x,
								peas_y,
								peas_type,
						
								peas_pixel, 
								peas_pixel_valid
								);


  input clk ,
		    rst_n ,
		    current_pixel_x,
		    current_pixel_y,
		    peas_valid, 
		    peas_x,
		    peas_y,
		    peas_type
		    ;
  output peas_pixel, 
			   peas_pixel_valid
			   ;  
 
  parameter peas_body_height = 4'd15;
  
  parameter peas_body_width  = 4'd15;
 
  parameter white = 24'b11111111_11111111_11111111;
  parameter black = 24'b00000000_00000000_00000000;
  parameter green = 24'b00000000_11111111_00000000;
  parameter red   = 24'b11111111_00000000_00000000;
  
  wire clk,rst_n;
  wire [ 9 : 0 ]current_pixel_x , current_pixel_y;
  wire [ 9 : 0 ]peas_x , peas_y;
  wire [ 2 : 0 ]peas_type;
  wire peas_valid;
  
  reg [ 23 : 0 ]peas_pixel;
  reg peas_pixel_valid;
  
  
  wire if_not_valid;
	wire [ 3 : 0 ]row_in_pic;
	wire [ 3 : 0 ]column_in_pic;
	wire [ 7 : 0 ]rom_address;
	wire [ 23: 0 ]rom_output;
	reg  [ 2 : 0 ]rom_output_select;

	reg [ 23 : 0 ]pixel_output;
	 
	 
	 assign if_not_valid =  ( (current_pixel_x < peas_x) 
									||(current_pixel_x > peas_x + peas_body_width)
									||(current_pixel_y < peas_y)
									||(current_pixel_y > peas_y + peas_body_height - 1)
									||(!peas_valid)
									);
	
	 assign row_in_pic    = peas_y + peas_body_height -1 - current_pixel_y;
	 assign column_in_pic = current_pixel_x - peas_x;
	 assign rom_address = (!if_not_valid)?((row_in_pic*peas_body_width) + column_in_pic):8'b0;
	 
	 
	 peas_rom rom_peas( 
												.clka(clk),
												.addra(rom_address),
												.douta(rom_output)
										);

												
	 always@(rom_output_select,rom_output,peas_type)
		case(peas_type)
			3'b000 :	rom_output_select <= rom_output[23:21];
			3'b001 :	rom_output_select <= rom_output[20:18];
			3'b010 :	rom_output_select <= rom_output[17:15];
			3'b011 :	rom_output_select <= rom_output[14:12];
			3'b100 :	rom_output_select <= rom_output[11:9];
			3'b101 :	rom_output_select <= rom_output[8:6];
			3'b110 :	rom_output_select <= rom_output[5:3];
			3'b111 :	rom_output_select <= rom_output[2:0];
		endcase
		
	 always@(pixel_output,rom_output_select)
		case(rom_output_select[1:0])
		  2'b00 : pixel_output <= black;
			2'b01 : pixel_output <= red;
			2'b10 : pixel_output <= green;
			2'b11 : pixel_output <= red;
    endcase


always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   peas_pixel <= 24'b0;
	 else if(if_not_valid)
	   peas_pixel <= 24'b0;
	 else
	   peas_pixel[23:0] <= pixel_output;
		
		
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   peas_pixel_valid <= 0;
	 else if(if_not_valid)
	   peas_pixel_valid <= 0;
	 else
	   peas_pixel_valid <= rom_output_select[2];

endmodule
