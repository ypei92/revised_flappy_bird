`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    15:04:20 07/22/2009 
// Design Name: 
// Module Name:    Lift_show 
//////////////////////////////////////////////////////////////////////////////////

module Life_show( 
                  clk , 
                  rst_n , 
                  current_pixel_x, 
                  current_pixel_y, 
                  life_number, 
						
                  life_pixel, 
                  life_pixel_valid
                  );
    
  input clk;
  input rst_n;
  input current_pixel_x;
  input current_pixel_y;
  input life_number;
  
  output life_pixel;
  output life_pixel_valid;
	 
  parameter life_length = 5'd16;
  parameter life_width  = 5'd16;
  parameter life_store_start = 10'b0;
	 
  parameter black = 24'b0;
  parameter white = 24'b11111111_11111111_11111111;
  parameter red   = 24'b11111110_01101001_01001001;
  parameter grey  = 24'b11110100_11110000_11110001;
  parameter body_yellow = 24'b11111000_11110010_00010010;
  
	 
	 wire clk,rst_n;
	 wire [ 9 : 0 ]current_pixel_x , current_pixel_y;
	 wire [ 3 : 0 ]life_number;
	 
	 reg [ 23 : 0 ]life_pixel;
	 reg life_pixel_valid;
	 
	 
	 wire if_not_valid;
	 wire [ 9 : 0 ]left_most;
	 wire [ 9 : 0 ]row_in_pic;
	 wire [ 9 : 0 ]column_in_pic;
	 wire [ 7 : 0]rom_address;
	 wire [ 6 : 0]rom_output;
	 reg [ 23 : 0 ]pixel_output;
	 
	 assign left_most = life_number << 4;
    assign if_not_valid =  ((current_pixel_x > left_most)
                          ||(current_pixel_y < 10'd460)
                          );
	
	 assign row_in_pic    = 10'd475 - current_pixel_y;
	 assign column_in_pic = current_pixel_x[3:0];
	 assign rom_address = (!if_not_valid)?((row_in_pic << 4) + column_in_pic):8'b0;
	 
	 life_rom rom_life_0( 
                       .clka(clk),
                       .addra(rom_address),
                       .douta(rom_output)
                       );
                       
                       
	always@(rom_output,pixel_output)
	if(rom_output[2] == 1)
	  case(rom_output[1:0])
	    2'b00 : pixel_output <= white;
	    2'b01 : pixel_output <= white;
		 2'b10 : pixel_output <= black;
	  endcase
	else
	  case(rom_output[5:3])
      3'b000 : pixel_output <= body_yellow;                                                                               
      3'b001 : pixel_output <= white;
      3'b010 : pixel_output <= black;
      3'b011 : pixel_output <= red;
      3'b100 : pixel_output <= grey;
	  endcase
				
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   life_pixel <= 24'b0;
	 else if(if_not_valid)
	   life_pixel <= 24'b0;
	 else
	   life_pixel[23:0] <= pixel_output;
		
		
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   life_pixel_valid <= 0;
	 else if(if_not_valid)
	   life_pixel_valid <= 0;
	 else
	   life_pixel_valid <= (rom_output[6]||rom_output[2]);
		
endmodule
				