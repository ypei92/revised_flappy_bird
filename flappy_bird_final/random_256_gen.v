`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:31:33 07/02/2014 
// Design Name: 
// Module Name:    random_256 
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
module random_256_gen(clk, rst_n, change, random_256);
input clk,rst_n,change;
output random_256;

wire [7:0] random_256;
reg [11:0] random;
assign random_256 = random[7:0];

always @(posedge clk or negedge rst_n)
if (!rst_n)
  random <= 12'd100;
else
  random <= {random[0],random[11:3],random[2]^random[0],random[1]^change};
endmodule
