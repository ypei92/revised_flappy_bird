`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:07:31 07/03/2014 
// Design Name: 
// Module Name:    bird_info_gen 
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
module bird_info_gen( bird_tap_time, bird_go_up, bird_angle , wing_state);
input bird_tap_time;
output bird_go_up, bird_angle, wing_state;

wire [12:0] bird_tap_time;
reg signed [12:0] bird_go_up;
reg [3:0] bird_angle;
reg [1:0] wing_state;

always @(bird_tap_time)
case (bird_tap_time)
  10'd0: bird_go_up <= 0;
  10'd1: bird_go_up <= 5;
  10'd2: bird_go_up <= 10;
  10'd3: bird_go_up <= 15;
  10'd4: bird_go_up <= 19;
  10'd5: bird_go_up <= 23;
  10'd6: bird_go_up <= 26;
  10'd7: bird_go_up <= 29;
  10'd8: bird_go_up <= 32;
  10'd9: bird_go_up <= 34;
  10'd10: bird_go_up <= 36;
  10'd11: bird_go_up <= 38;
  10'd12: bird_go_up <= 39;
  10'd13: bird_go_up <= 39;
  10'd14: bird_go_up <= 40;
  10'd15: bird_go_up <= 40;
  10'd16: bird_go_up <= 40;
  10'd17: bird_go_up <= 39;
  10'd18: bird_go_up <= 38;
  10'd19: bird_go_up <= 36;
  10'd20: bird_go_up <= 35;
  10'd21: bird_go_up <= 32;
  10'd22: bird_go_up <= 30;
  10'd23: bird_go_up <= 27;
  10'd24: bird_go_up <= 24;
  10'd25: bird_go_up <= 20;
  10'd26: bird_go_up <= 16;
  10'd27: bird_go_up <= 11;
  10'd28: bird_go_up <= 7;
  10'd29: bird_go_up <= 2;
  10'd30: bird_go_up <= -4;
  10'd31: bird_go_up <= -10;
  10'd32: bird_go_up <= -16;
  10'd33: bird_go_up <= -23;
  10'd34: bird_go_up <= -30;
  10'd35: bird_go_up <= -37;
  10'd36: bird_go_up <= -45;
  10'd37: bird_go_up <= -53;
  10'd38: bird_go_up <= -62;
  10'd39: bird_go_up <= -71;
  10'd40: bird_go_up <= -80;
  10'd41: bird_go_up <= -90;
  10'd42: bird_go_up <= -100;
  10'd43: bird_go_up <= -110;
  10'd44: bird_go_up <= -121;
  10'd45: bird_go_up <= -132;
  10'd46: bird_go_up <= -144;
  10'd47: bird_go_up <= -155;
  10'd48: bird_go_up <= -168;
  10'd49: bird_go_up <= -180;
  10'd50: bird_go_up <= -193;
  10'd51: bird_go_up <= -207;
  10'd52: bird_go_up <= -220;
  10'd53: bird_go_up <= -235;
  10'd54: bird_go_up <= -249;
  10'd55: bird_go_up <= -264;
  10'd56: bird_go_up <= -279;
  10'd57: bird_go_up <= -295;
  10'd58: bird_go_up <= -311;
  10'd59: bird_go_up <= -327;
  10'd60: bird_go_up <= -344;
  10'd61: bird_go_up <= -361;
  10'd62: bird_go_up <= -379;
  10'd63: bird_go_up <= -396;
  10'd64: bird_go_up <= -415;
  10'd65: bird_go_up <= -433;
  10'd66: bird_go_up <= -452;
  10'd67: bird_go_up <= -472;
  10'd68: bird_go_up <= -491;
  10'd69: bird_go_up <= -512;
  10'd70: bird_go_up <= -532;
  10'd71: bird_go_up <= -553;
  10'd72: bird_go_up <= -574;
  10'd73: bird_go_up <= -596;
  10'd74: bird_go_up <= -618;
  10'd75: bird_go_up <= -640;
  10'd76: bird_go_up <= -663;
  10'd77: bird_go_up <= -686;
  10'd78: bird_go_up <= -709;
  10'd79: bird_go_up <= -733;
  10'd80: bird_go_up <= -757;
  10'd81: bird_go_up <= -782;
  10'd82: bird_go_up <= -807;
  10'd83: bird_go_up <= -832;
  10'd84: bird_go_up <= -858;
  10'd85: bird_go_up <= -884;
  10'd86: bird_go_up <= -910;
  10'd87: bird_go_up <= -937;
  10'd88: bird_go_up <= -964;
  10'd89: bird_go_up <= -992;
  10'd90: bird_go_up <= -1020;
  10'd91: bird_go_up <= -1048;
  10'd92: bird_go_up <= -1077;
  10'd93: bird_go_up <= -1106;
  10'd94: bird_go_up <= -1135;
  10'd95: bird_go_up <= -1165;
  10'd96: bird_go_up <= -1195;
  10'd97: bird_go_up <= -1226;
  10'd98: bird_go_up <= -1257;
  10'd99: bird_go_up <= -1288;
  10'd100: bird_go_up <= -1320;
  10'd101: bird_go_up <= -1352;
  10'd102: bird_go_up <= -1384;
  10'd103: bird_go_up <= -1417;
  10'd104: bird_go_up <= -1450;
  10'd105: bird_go_up <= -1484;
  10'd106: bird_go_up <= -1518;
  10'd107: bird_go_up <= -1552;
  10'd108: bird_go_up <= -1587;
  10'd109: bird_go_up <= -1622;
  10'd110: bird_go_up <= -1657;
  10'd111: bird_go_up <= -1693;
  10'd112: bird_go_up <= -1729;
  10'd113: bird_go_up <= -1766;
  10'd114: bird_go_up <= -1803;
  10'd115: bird_go_up <= -1840;
  10'd116: bird_go_up <= -1877;
  10'd117: bird_go_up <= -1915;
  10'd118: bird_go_up <= -1954;
  10'd119: bird_go_up <= -1993;
  10'd120: bird_go_up <= -2032;
  10'd121: bird_go_up <= -2071;
  10'd122: bird_go_up <= -2111;
  10'd123: bird_go_up <= -2151;
  10'd124: bird_go_up <= -2192;
  10'd125: bird_go_up <= -2233;
  10'd126: bird_go_up <= -2274;
  10'd127: bird_go_up <= -2316;
  default: bird_go_up <= 13'd0;
endcase

always @(bird_tap_time)
if (bird_tap_time == 0)
  bird_angle <= 4'd2; //0
else if (bird_tap_time <= 25)
  bird_angle <= 4'd0; //20
else if (bird_tap_time <= 26)
  bird_angle <= 4'd1; //10
else if (bird_tap_time <= 27)
  bird_angle <= 4'd2; //0
else if (bird_tap_time <= 28)
  bird_angle <= 4'd3; //-10
else if (bird_tap_time <= 29)
  bird_angle <= 4'd4; //-20
else if (bird_tap_time <= 30)
  bird_angle <= 4'd5; //-30
else if (bird_tap_time <= 32)
  bird_angle <= 4'd6; //-40
else if (bird_tap_time <= 34)
  bird_angle <= 4'd7; //-50
else if (bird_tap_time <= 36)
  bird_angle <= 4'd8; //-60
else if (bird_tap_time <= 38)
  bird_angle <= 4'd9; //-75
else if (bird_tap_time > 39)
  bird_angle <= 4'd10; //-90
else
  bird_angle <= 4'd2;

always @(bird_tap_time)
if (bird_tap_time == 0)
  wing_state <= 2'd1;
else if (bird_tap_time[2:1]==2'd1)
  wing_state <= 2'd0;
else if (bird_tap_time[2:1]==2'd2)
  wing_state <= 2'd1;
else if (bird_tap_time[2:1]==2'd3)
  wing_state <= 2'd2;
else if (bird_tap_time[2:1]==2'd0)
  wing_state <= 2'd1;
else
  wing_state <= 2'd1;

endmodule
