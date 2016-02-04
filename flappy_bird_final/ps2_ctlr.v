//////////////////////////////////////////////////////////////////////////////////
// Company: SOME SJTU
// Engineer: 	
// 
// Create Date:    16:41:21 05/07/2011 
// Design Name: 
// Module Name:    ps2_ctrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This file was first created by taoyuliang for spartan
// 3 platform and revised in 2011 by jiang. 
//
// Update: object move one step in every push, revised in 2012 by Huzhongxing
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - This verison does not support key with extend code.
// Additional Comments: 
//
///////////////////////////////////////////////////////////////////////////////////
module ps2_ctlr(
		rst_n, 
		sys_clk,
		clk_ps2, 
		data_ps2, 
		//control_key,
		left,
		right,
		up,
		down,
		enter,
		choose1,
		choose2
	        );							 
							 
    input           rst_n;             // system reset signal
    input	    sys_clk;           // synchronize the ps2 data
    input 	    clk_ps2;           // ps2 clock
    input 	    data_ps2;          // ps2 data 
	 output      choose1,choose2;
	 output left,right,up,down,enter;
    //output       control_key;// control of usr's input													
	 //output left,right,up,down,choose1,choose2,enter;
	 
	 wire    choose1,choose2;
    reg 		[3:0]   control_key;       // 

    wire left,right,up,down,enter;

    wire		[15:0]   key_code;		  		// current keycode recieved from ps2 driver
	 
	 
    //wire left,right,up,down,enter,choose1,choose2;
	 
	 // control key define
	 parameter LEFT = 0;
	 parameter RIGHT = 1;
    parameter UP = 2;
    parameter DOWN = 3;
    parameter CHOOSE1 = 4;
    parameter CHOOSE2 = 5;
    parameter UP2 = 7;
    parameter ENTER = 11;
    parameter INVALID = 13;

	 
	reg	[15:0]	ps2_data_syn1;
	reg	[15:0]	ps2_data_syn2;

	 /////////////////////////////////////////////////////////////////////////////////////////////
	 //                                                                                         //
	 // Synchronize the input asynchronous data                                                 //
	 //                                                                                         //
	 /////////////////////////////////////////////////////////////////////////////////////////////
	// instance of ps2_kbd_driver
	 ps2_kbd_driver ps2driv(
	 			.rst_n(rst_n), 
	 			.clk_ps2(clk_ps2), 
	 			.data_ps2(data_ps2), 
	 			.keyword(key_code)
				  );
				  
	always @(posedge sys_clk or negedge rst_n)begin
        if(!rst_n)
	begin
		ps2_data_syn1<=16'b0;
		ps2_data_syn2<=16'b0;
	end
	else
	begin
		ps2_data_syn1<=key_code;
		ps2_data_syn2<=ps2_data_syn1;
        end						  
	end 
	 /////////////////////////////////////////////////////////////////////////////////////////////
	 //                                                                                         //
	 // decode the keycode into control key.                                                    //
	 //                                                                                         //
	 /////////////////////////////////////////////////////////////////////////////////////////////
	 //always @(current_key)
	 always @ (ps2_data_syn2)
	 begin
	   if ( ps2_data_syn2[15:8]==8'hF0 || ps2_data_syn2[7:0]==8'hF0 )
			control_key = 7;
		else begin
		case(ps2_data_syn2[7:0])
			8'h1c: control_key = LEFT;	// a,left
			8'h23: control_key = RIGHT;	// d,right
			8'h1b: control_key = DOWN;	// s,down
			8'h1d: control_key = UP;		// w,up			
			8'h16: control_key = CHOOSE1;
			8'h1e: control_key = CHOOSE2;	// 
			8'h75: control_key = UP2;		// 7,up				
			8'h5a: control_key = ENTER;	// enter
			default: control_key = 13;			
		endcase		
		end
	 end

assign left=(control_key==LEFT)?1:0;
assign right=(control_key==RIGHT)?1:0;
assign up=(control_key==UP)?1:0;
assign down=(control_key==DOWN)?1:0;
assign enter=(control_key==ENTER)?1:0;

assign choose1=(control_key==CHOOSE1)?1:0;
assign choose2=(control_key==CHOOSE2)?1:0;




endmodule
