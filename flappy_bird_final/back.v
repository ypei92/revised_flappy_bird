`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:34 07/02/2009 
// Design Name: 
// Module Name:    back 
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
module back(current_print_row, current_print_column, valid_array, clk, rst_n, background_pixel, background_pixel_valid);
    input [9:0] current_print_row;
    input [9:0] current_print_column;
    input valid_array;
    input clk;
    input rst_n;
    output [23:0] background_pixel;
    output background_pixel_valid;
	 
    reg [23:0] background_pixel;
    wire background_pixel_valid;
	 reg [13:0] addra;
	 wire [23:0] douta;
/*
always @ (posedge clk or negedge rst_n)
begin
if(!rst_n£©
counter_volumn <= 10'b0;
else if(counter_row == 10'd299 && counter_column==10'd479)
counter_column <= 10'b0;
else if(counter_row == 10'd299)
counter_column <= counter_column +1;
else
counter_column <= counter_column;
end

always @ (posedge clk or negedge rst_n)
begin
if(!rst_n£©
counter_volumn <= 10'b0;
else if(counter_row == 10'd299)
counter_column <= 10'b0;
else
counter_column <= counter_column+1;
end
*/

always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
background_pixel <= 24'b0;
else if(current_print_row >= 10'd162)
//background_pixel <= 24'b010011100100111001001110;
background_pixel <= 24'b01001110_11000000_11001010;
else if(current_print_row <= 10'd30)
//background_pixel <= 24'b010110000101110101011110;
background_pixel <= 24'b11101110_11111110_10010001;
else 
background_pixel <= douta;
end

always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
addra <= 14'b0;
else if(current_print_column <= 10'd74)
addra <= (180-current_print_row) + current_print_column * 132;
else if(10'd75 <= current_print_column && current_print_column <= 10'd149)
addra <= (180-current_print_row) + (current_print_column-15'd75) * 15'd132;
else if(10'd150 <= current_print_column && current_print_column <= 10'd224)
addra <= (180-current_print_row) + (current_print_column-15'd150) * 15'd132;
else if(10'd225 <= current_print_column && current_print_column <= 10'd299)
addra <= (180-current_print_row) + (current_print_column-15'd225) * 15'd132;
else
addra <= 14'b0;
end

assign background_pixel_valid = 1;

bgd bgd(
	.clka(clk),
	.addra(addra),
	.douta(douta));
endmodule
