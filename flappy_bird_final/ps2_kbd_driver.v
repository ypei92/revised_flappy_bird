//////////////////////////////////////////////////////////////////////////////////
// Company: SOME SJTU
// Engineer: 	
// 
// Create Date:    16:41:21 05/07/2011 
// Design Name: 
// Module Name:    ps2_kbd_driver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This file was first created by taoyuliang for spartan
// 3 platform and revised in 2011 by jiang.  Update in 2012 by Huzhongxing
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - This verison does not support key with extend code.
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ps2_kbd_driver(
                                rst_n, 
                                clk_ps2, 
                                data_ps2, 
										  keyword
                             );
                             
    input              	   rst_n;             // system reset signal
    input                  clk_ps2;           // clock from ps2 device
    input                  data_ps2;          // data from ps2 device
     
	 output     [15:0]      keyword; 
	 reg        [15:0]    keyword;
    reg        [3:0]     count;             // record the current data num in temp_shift
    reg        [9:0]     temp_shift;        // temp reg using recieve the data from keycode bit by bit
     
     
     /////////////////////////////////////////////////////////////////////////////////////////////
     //                                                                                         //
     // Get the key code bit by bit .                                                           //
     // The order of arrival: 0,8 bits of data (LSB first),odd parity,1.                        //
     // We use temp_shift store the first 10 bits and do not store the last bit - stop bit(1)   //
     //                                                                                         //
     /////////////////////////////////////////////////////////////////////////////////////////////
     always @( negedge clk_ps2 or negedge rst_n )
     begin
        if(!rst_n)
            begin
                count <= 0;
                temp_shift <= 0;
                //keycode <= 0;
					 keyword <= 0;
            end
        else if( (count==10) && (data_ps2==1) && (^temp_shift[9:1]==1) && (temp_shift[0]==0) )
            begin
                //keycode[7:0] <= temp_shift[8:1];
					 keyword <= {keyword[7:0], temp_shift[8:1]};
                count <= 0;        
            end
        else begin
                temp_shift <= {data_ps2,temp_shift[9:1]};
                count <= count + 1;
            end
     end
	 

endmodule  			  
