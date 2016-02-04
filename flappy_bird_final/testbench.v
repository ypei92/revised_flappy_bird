`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:00:49 07/02/2014 
// Design Name: 
// Module Name:    testbench 
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
module testbench();

reg rst_n,clk;
wire       clk_ps2,data_ps2,
           h_sysc,v_sysc,vga_red,vga_green,
           vga_clk,vga_blue,vga_out_blank,vga_comp_synch;

initial
begin clk <= 0; rst_n <= 0; #7 rst_n <= 1; end

always #5 clk <= ~clk; 


top    top(rst_n,clk,
           clk_ps2,data_ps2,
           h_sysc,v_sysc,vga_red,vga_green,
           vga_clk,vga_blue,vga_out_blank,vga_comp_synch);

endmodule
