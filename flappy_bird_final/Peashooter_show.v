
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:29:37 07/16/2014 
// Design Name: 
// Module Name:    peashooter 
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
module Peashooter_show(
								clk , 
								rst_n , 
								current_pixel_x, 
								current_pixel_y, 
								cloud_valid,
								peashooter_valid, 
								peashooter_x,
								peashooter_y,
								peashooter_state,
						
								peashooter_pixel, 
								peashooter_pixel_valid
								);


  input clk ,
		  rst_n ,
		  current_pixel_x,
		  current_pixel_y,
		  cloud_valid,
		  peashooter_valid, 
		  peashooter_x,
		  peashooter_y,
		  peashooter_state
		  ;
  output  peashooter_pixel, 
			 peashooter_pixel_valid
			 ;  
 
  parameter peashooter_body_height = 9'd84;
  parameter peashooter_body_width  = 9'd88;
  parameter cloud_height = 9'd44;
  parameter cloud_width = 9'd80;
  parameter dark_yellow = {8'd214,8'd150,8'd33};
  parameter light_yellow = {8'd255,8'd219,8'd133};
 
  parameter c0  = 24'b10101010_11011110_00110000;//170 222 48
  parameter c1  = 24'b10000101_11001010_00011100;//133 202 28
  parameter c2  = 24'b01010000_01011001_00101000;//80  89  40
  parameter c3  = 24'b00011000_01010101_00000100;//24  85  4
  parameter c4  = 24'b01111101_01111001_01111001;//125 121 121
  parameter c5  = 24'b00000000_00000100_00000000;//0   4   0
  parameter c6  = 24'b00010000_00010000_00001100;//16  16  12
  parameter c7  = 24'b01010000_01011001_00111000;//80  89  56
  parameter c8  = 24'b00111000_11000010_00001000;//56  194 8
  parameter c9  = 24'b11001110_11010010_11000110;//206 210 198
  parameter c10 = 24'b00100100_00100100_00100100;//36  36  36
  parameter c11 = 24'b01011001_10001001_00001000;//89  137  8
  parameter c12 = 24'b01101101_01111001_01010101;//109 121 85
  parameter c13 = 24'b00110000_10100101_00000100;//48  165 4
  parameter c14 = 24'b01111101_10000101_01101101;//125 133 109
  parameter c15 = 24'b01000100_01000100_01000100;//68  68  68
  parameter c16 = 24'b00011000_00110000_00010000;//24  48  16
  parameter c17 = 24'b00110100_00110100_00110100;//52  52  52
  parameter c18 = 24'b01101001_01110001_01001000;//105 113 72
  parameter c19 = 24'b00000100_00010100_00000000;//4   20  0
  parameter c20 = 24'b01100001_01100001_01100001;//97  97  97
  parameter c21 = 24'b00100100_10010001_00000000;//36  145 0
  parameter c22 = 24'b01010101_01010101_01010101;//85  85  85
  parameter c23 = 24'b01110001_10101010_00001000;//113 170 16
  parameter c24 = 24'b01011001_01100101_00110000;//89  101 48
  parameter c25 = 24'b10011101_10100001_10011001;//157 161 153
  parameter c26 = 24'b00111100_11011010_00001100;//60  218 12
  parameter c27 = 24'b00010100_00100000_00001100;//20  32  12
  parameter c28 = 24'b00110100_10110110_00001000;//52  182 8
  parameter c29 = 24'b00000100_00100100_00000000;//4   36  0
  parameter c30 = 24'b01010000_01100001_00001000;//80  97  8
  parameter c31 = 24'b11111111_11111111_11111111;//255 255 255
  
    wire clk,rst_n;
    wire [ 9 : 0 ]current_pixel_x , current_pixel_y;
    wire [ 9 : 0 ]peashooter_x , peashooter_y;
    wire [ 9 : 0 ]cloud_x , cloud_y;
    wire [ 3 : 0 ]peashooter_state;
    wire peashooter_valid;
    wire cloud_valid;
  
    reg [ 23 : 0 ]peashooter_pixel;
    reg peashooter_pixel_valid;
  
  
	 wire if_not_valid;
	 wire [ 6 : 0 ]row_in_pic,row_in_pic_cloud;
	 wire [ 6 : 0 ]column_in_pic,column_in_pic_cloud;
	 wire [ 12: 0 ]rom_address;
	 wire [ 12: 0 ]rom_address_cloud;
	 reg  [ 5 : 0 ]rom_output_select;
	 wire [ 1 : 0 ]rom_output_cloud;
	 wire [23:0]rom_output0;
	 wire [23:0]rom_output1;
	 wire [29:0]rom_output2;
	 
	 wire [ 23 : 0 ]body_color;
	 reg [ 23 : 0 ]pixel_output;
	 reg [ 23 : 0 ]pixel_output_cloud;
	 
	 
	 assign cloud_x = peashooter_x + 10;
	 assign cloud_y = peashooter_y - 15;
	 
	 assign if_not_valid_peashooter =  ( (current_pixel_x < peashooter_x) 
									                   ||(current_pixel_x > peashooter_x + peashooter_body_width)
									                   ||(current_pixel_y < peashooter_y)
									                   ||(current_pixel_y > peashooter_y + peashooter_body_height - 1)
									                   ||(!peashooter_valid)
									                   );
									
	 assign if_not_valid_cloud =  (  (current_pixel_x < cloud_x) 
									               ||(current_pixel_x > cloud_x + cloud_width)
									               ||(current_pixel_y < cloud_y)
									               ||(current_pixel_y > cloud_y + cloud_height - 1)
									               ||(!cloud_valid)
									               );
	 assign if_not_valid = (if_not_valid_peashooter && if_not_valid_cloud);
	
	 assign row_in_pic    = peashooter_y + peashooter_body_height - 1 - current_pixel_y;
	 assign column_in_pic = current_pixel_x - peashooter_x;
	 assign rom_address = (!if_not_valid_peashooter)?((row_in_pic*peashooter_body_width) + column_in_pic):13'b0;
	 
	 assign row_in_pic_cloud    = cloud_y + cloud_height - 1 - current_pixel_y;
	 assign column_in_pic_cloud = current_pixel_x - cloud_x;
	 assign rom_address_cloud = (!if_not_valid_cloud)?((row_in_pic_cloud*cloud_width) + column_in_pic_cloud):13'b0;
	 
	 
	 peashooter_rom_0 rom_peashooter_0( 
												.clka(clk),
												.addra(rom_address),
												.douta(rom_output0)
												);
	 peashooter_rom_1 rom_peashooter_1( 
												.clka(clk),
												.addra(rom_address),
												.douta(rom_output1)
												);
	 peashooter_rom_2 rom_peashooter_2( 
												.clka(clk),
												.addra(rom_address),
												.douta(rom_output2)
												);
												
												
	 cloud_rom rom_cloud(
	                      .clka(clk),
												.addra(rom_address_cloud),
												.douta(rom_output_cloud)
												);
												
	 always@(rom_output_select,rom_output0,rom_output1,rom_output2,peashooter_state)
		case(peashooter_state)
			4'b0000 :	rom_output_select <= rom_output0[23:18];
			4'b0001 :	rom_output_select <= rom_output0[17:12];
			4'b0010 :	rom_output_select <= rom_output0[11:6];
			4'b0011 :	rom_output_select <= rom_output0[5:0];
			4'b0100 :	rom_output_select <= rom_output1[23:18];
			4'b0101 :	rom_output_select <= rom_output1[17:12];
			4'b0110 :	rom_output_select <= rom_output1[11:6];
			4'b0111 :	rom_output_select <= rom_output1[5:0];
			4'b1000 :	rom_output_select <= rom_output2[29:24];
			4'b1001 :	rom_output_select <= rom_output2[23:18];
			4'b1010 :	rom_output_select <= rom_output2[17:12];
			4'b1011 :	rom_output_select <= rom_output2[11:6];
			4'b1100 :	rom_output_select <= rom_output2[5:0];
		endcase
		
	 always@(pixel_output,rom_output_select)
		case(rom_output_select[4:0])
		  5'b00000 : pixel_output <= c0;
			5'b00001 : pixel_output <= c1;
			5'b00010 : pixel_output <= c2;
			5'b00011 : pixel_output <= c3;
			5'b00100 : pixel_output <= c4;
			5'b00101 : pixel_output <= c5;
			5'b00110 : pixel_output <= c6;
			5'b00111 : pixel_output <= c7;
			5'b01000 : pixel_output <= c8;
			5'b01001 : pixel_output <= c9;
			5'b01010 : pixel_output <= c10;
			5'b01011 : pixel_output <= c11;
			5'b01100 : pixel_output <= c12;
			5'b01101 : pixel_output <= c13;
			5'b01110 : pixel_output <= c14;
			5'b01111 : pixel_output <= c15;
			5'b10000 : pixel_output <= c16;
			5'b10001 : pixel_output <= c17;
			5'b10010 : pixel_output <= c18;
			5'b10011 : pixel_output <= c19;
			5'b10100 : pixel_output <= c20;
			5'b10101 : pixel_output <= c21;
			5'b10110 : pixel_output <= c22;
			5'b10111 : pixel_output <= c23;
			5'b11000 : pixel_output <= c24;
			5'b11001 : pixel_output <= c25;
			5'b11010 : pixel_output <= c26;
			5'b11011 : pixel_output <= c27;
			5'b11100 : pixel_output <= c28;
			5'b11101 : pixel_output <= c29;
			5'b11110 : pixel_output <= c30;
			5'b11111 : pixel_output <= c31;
    endcase
    
    always@(pixel_output_cloud,rom_output_cloud)
		case(rom_output_cloud[0])
		  1'b0 : pixel_output_cloud <= dark_yellow;
		  1'b1 : pixel_output_cloud <= light_yellow;
		endcase


   always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   peashooter_pixel <= 24'b0;
	 else if(if_not_valid)
	   peashooter_pixel <= 24'b0;
	 else if((!if_not_valid_peashooter)&&rom_output_select[5])
	   peashooter_pixel[23:0] <= pixel_output;
	 else
	   peashooter_pixel[23:0] <= pixel_output_cloud;
		
		
	 always@(posedge clk or negedge rst_n)
	 if(!rst_n)
	   peashooter_pixel_valid <= 0;
	 else if(if_not_valid)
	   peashooter_pixel_valid <= 0;
	 else
	   peashooter_pixel_valid <= (rom_output_select[5]||rom_output_cloud[1]);

endmodule
