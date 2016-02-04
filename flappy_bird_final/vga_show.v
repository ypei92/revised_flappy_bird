module vga_show(
             rst_n,
             clk,
				 clk_2hz,//applied for the twinkle chess
				 
				 flash,
				 
				 background_select,				 

				 pillar_valid_0, pillar_valid_1,
             pillar_v_0, pillar_v_1,
             pillar_h_0, pillar_h_1,
				 position_stripe,
				 gap_width,
				 
             bird_height,
				 bird_valid,
				 bird_color_select,
				 bird_angle,
				 wing_state,
				 
				 all_score,
				 
				 shooter_valid,shooter_state,
             shooter_x,shooter_y,
				 peas_valid,peas_type,
             peas_x,peas_y,
				 
				 life,
				 intro_type,
             intro_valid,
				 intro_height,
				 
				 clk_25mhz,
				 h_sysc,
				 v_sysc,	
             vga_red,
             vga_green,
             vga_blue,
             vga_out_pixel_clock,
				 
				 bird_crash,
				 peas_get
				 );
				 
input clk;//board clock frequency 60HZ
input clk_2hz;//applied for the twinkle chess
input rst_n;//reset signal

input flash;

input background_select;

input        pillar_valid_0, pillar_valid_1,
             pillar_v_0, pillar_v_1,
             pillar_h_0, pillar_h_1,
				 position_stripe,
				 gap_width;
				 
input bird_height,bird_valid;
input bird_color_select, bird_angle, wing_state;

input all_score;

input shooter_valid,shooter_state;
input shooter_x,shooter_y;
input peas_valid,peas_type;
input peas_x,peas_y;

input life;
input intro_type,intro_valid;
input [9:0] intro_height;

wire flash;

wire background_select;

wire pillar_valid_0, pillar_valid_1;
wire [8:0] pillar_v_0, pillar_v_1;
wire [8:0] pillar_h_0, pillar_h_1;
wire [9:0] gap_width;
wire [8:0] position_stripe;

wire [9:0] bird_height;
wire bird_valid;
wire [1:0] bird_color_select;
wire [3:0] bird_angle;
wire [1:0] wing_state;

wire [31:0] all_score;

wire shooter_valid;
wire [3:0] shooter_state;
wire [9:0] shooter_x,shooter_y;
wire peas_valid;
wire [2:0] peas_type;
wire [9:0] peas_x,peas_y;

wire [3:0] life;
wire intro_type,intro_valid;
wire [9:0] intro_height;

input clk_25mhz;//25 MHZ frequency clk
output vga_out_pixel_clock;	  
output h_sysc;// horizontal sysc signal
output v_sysc;//vertical sysc signal

output [7:0] vga_red,vga_green,vga_blue;
output bird_crash,peas_get;

reg [7:0] vga_red,vga_green,vga_blue;
wire bird_crash,peas_get;

assign vga_out_pixel_clock=clk_25mhz;

wire h_sysc;
wire v_sysc;
wire h_enable_write; //horizontal enable signal
wire v_enable_write;//vertical enable signal

wire [9:0] x,xx; // current horizontal position
wire [9:0] y,yy;// // current vertical position
wire [9:0] xx_last,yy_last;


////////////////////////////////////////////////////////////////////
//                                                                //
//  VGA.v module                                                  //
//                                                                //
////////////////////////////////////////////////////////////////////
assign xx_last = xx - 1;
assign yy_last = xx == 0 ? yy-1 : yy;
//assign x=xx-132;//112
assign x=xx-144;
//assign y=yy-32;//12
//assign y=yy-31;
assign y=511-yy;

 VGA  vga(
		   .Rst_N(rst_n), 
		   .Clk_Pixel(clk_25mhz), 
		   .H_Sysc(h_sysc), 
		   .V_Sysc(v_sysc),
		   .H_Enable_Write(h_enable_write),
		   .V_Enable_Write(v_enable_write),
		   .H_Pixel_Count(xx), 
		   .V_Line_Count(yy)				
		 );

////////////////////////////////////////////////////////////////////
//                                                                //
//  connect with background module                                //
//                                                                //
////////////////////////////////////////////////////////////////////
wire bg_valid_out;
wire [23:0] bg_color_out;

back back(  .current_print_row(y),
            .current_print_column(x+2),
				.valid_array(),
				.clk(clk_25mhz),
				.rst_n(rst_n),
				.background_pixel(bg_color_out),
				.background_pixel_valid(bg_valid_out)
				);


////////////////////////////////////////////////////////////////////
//                                                                //
//  connect with pillar vga module                                //
//                                                                //
////////////////////////////////////////////////////////////////////
wire pipe_valid_out;
wire [23:0] pipe_color_out;

pipe pipe( .clk(clk_25mhz), 
           .rst_n(rst_n),
           .h_line(x),
           .v_line(y),
           .position_1_v(pillar_v_0),
           .position_1_h(pillar_h_0),
           .position_2_v(pillar_v_1),
           .position_2_h(pillar_h_1),
           .valid_1(pillar_valid_0),
           .valid_2(pillar_valid_1),
			  .position_stripe(position_stripe),
			  .gap_width(gap_width),
           .valid_out(pipe_valid_out),
           .color_out(pipe_color_out)  );


////////////////////////////////////////////////////////////////////
//                                                                //
//  connect with number vga module                                //
//                                                                //
////////////////////////////////////////////////////////////////////
wire score_valid_out;
wire [23:0] score_color_out;			
  
number number( .clk(clk_25mhz), 
               .rst_n(rst_n),
               .h_line(x),
               .v_line(y),
               .number_0(all_score[15:12]),
               .number_1(all_score[11:8]),
               .number_2(all_score[7:4]),
               .number_3(all_score[3:0]),
					.highest_0(all_score[31:28]),
               .highest_1(all_score[27:24]),
               .highest_2(all_score[23:20]),
               .highest_3(all_score[19:16]),
               .valid_in(1'b1),
               .valid_out(score_valid_out),
               .color_out(score_color_out)
					);

////////////////////////////////////////////////////////////////////
//                                                                //
//  connect with bird vga module                                  //
//                                                                //
////////////////////////////////////////////////////////////////////
wire bird_valid_out;
wire [23:0] bird_color_out;

Bird_show Bird_show( .clk(clk_25mhz), 
						   .rst_n(rst_n), 
						   .current_pixel_x(x), 
						   .current_pixel_y(y), 
						   .bird_valid(bird_valid), 
						   .bird_height(bird_height),
							.bird_color_select(bird_color_select),
						   .bird_angle(bird_angle),
						   .bird_pixel(bird_color_out), 
						   .bird_pixel_valid(bird_valid_out)
						   );

////////////////////////////////////////////////////////////////////
//                                                                //
//  connect with wing vga module                                  //
//                                                                //
////////////////////////////////////////////////////////////////////
wire wing_valid_out;
wire [23:0] wing_color_out;

Wing_show Wing_show( .clk(clk_25mhz), 
						   .rst_n(rst_n), 
						   .current_pixel_x(x), 
						   .current_pixel_y(y), 
						   .wing_valid(bird_valid), 
						   .wing_height(bird_height),
							.wing_color_select(bird_color_select),
						   .wing_angle(bird_angle),
						   .wing_state(wing_state),
						
						   .wing_pixel(wing_color_out),
						   .wing_pixel_valid(wing_valid_out)
						   );


////////////////////////////////////////////////////////////////////
//                                                                //
//  connect with Pea shooter vga module                           //
//                                                                //
////////////////////////////////////////////////////////////////////
wire shooter_valid_out;
wire [23:0] shooter_color_out;
wire peas_valid_out;
wire [23:0] peas_color_out;

Peashooter_show Peashooter_show(
							.clk(clk_25mhz), 
						   .rst_n(rst_n), 
						   .current_pixel_x(x), 
						   .current_pixel_y(y),
							.cloud_valid(1'b1),
							.peashooter_valid(1'b1),
							.peashooter_x(shooter_x),
							.peashooter_y(shooter_y),
							.peashooter_state(shooter_state),
						
							.peashooter_pixel(shooter_color_out),
							.peashooter_pixel_valid(shooter_valid_out)
							);

Peas_show Peas_show(
							.clk(clk_25mhz), 
						   .rst_n(rst_n), 
						   .current_pixel_x(x), 
						   .current_pixel_y(y), 
							.peas_valid(peas_valid),
							.peas_x(peas_x),
							.peas_y(peas_y),
							.peas_type(peas_type),
						
							.peas_pixel(peas_color_out),
							.peas_pixel_valid(peas_valid_out)
							);

/////////////////////////////////////////////////////////////////////
//                                                                 //
// others                                                          //
//                                                                 //
/////////////////////////////////////////////////////////////////////
wire brick_valid_out;
wire [23:0] brick_color_out;

brick brick    ( 
           .clk(clk_25mhz), 
           .rst_n(rst_n),
           .h_line(x),
           .v_line(y),
           .valid_out(brick_valid_out),
           .color_out(brick_color_out)
			  );
			  
wire life_valid_out;
wire [23:0] life_color_out;

Life_show Life_show( 
                     .clk(clk_25mhz), 
						   .rst_n(rst_n), 
						   .current_pixel_x(x), 
						   .current_pixel_y(y), 
                     .life_number(life), 
						
                     .life_pixel(life_color_out), 
                     .life_pixel_valid(life_valid_out)
                  );

wire intro_valid_out;
wire [23:0] intro_color_out;

//gameover gameover     ( 
//           .clk(clk_25mhz), 
//           .rst_n(rst_n),
//           .h_line(x),
//           .v_line(y),
//           .control(1'b1),
//			  .valid_in(1'b1),
//           .valid_out(intro_valid_out),
//           .color_out(intro_color_out) );


wire title_valid_out;
wire [23:0] title_color_out;	  
Intro_show Intro_show( 
                     .clk(clk_25mhz), 
						   .rst_n(rst_n), 
						   .current_pixel_x(x), 
						   .current_pixel_y(y), 
                     .intro_x(10'd50),
                     .intro_y(intro_height), 
                     .intro_type(intro_type),
                     .intro_valid(intro_valid),
							.score_intro_valid(1'b1),
							
                     .intro_pixel(intro_color_out), 
                     .intro_pixel_valid(intro_valid_out),
                     .score_intro_pixel(title_color_out), 
                     .score_intro_pixel_valid(title_valid_out)
                  );

/////////////////////////////////////////////////////////////////////
//                                                                 //
// bird_crash & peas_get                                           //
//                                                                 //
/////////////////////////////////////////////////////////////////////
reg [18:0] crash_counter;
assign bird_crash = (crash_counter > 0);

reg [18:0] peas_get_counter;
assign peas_get = (peas_get_counter > 0);

always @(posedge clk_25mhz or negedge rst_n) //clk means clk_60hz
if (!rst_n)
  crash_counter <= 0;
else if ((crash_counter==0) && (pipe_valid_out==1 && bird_valid_out==1))
  crash_counter <= 1;
else if ((crash_counter > 0) && (crash_counter <= 416800))
  crash_counter <= crash_counter + 1;
else if (crash_counter > 416800)
  crash_counter <= 0;
else
  crash_counter <= crash_counter;
  
always @(posedge clk_25mhz or negedge rst_n) //clk means clk_60hz
if (!rst_n)
  peas_get_counter <= 0;
else if ((peas_get_counter==0) && (peas_valid_out==1 && bird_valid_out==1))
  peas_get_counter <= 1;
else if ((peas_get_counter > 0) && (peas_get_counter <= 416800))
  peas_get_counter <= peas_get_counter + 1;
else if (peas_get_counter > 416800)
  peas_get_counter <= 0;
else
  peas_get_counter <= peas_get_counter;


//////////////////////////////////////////////////////////////////////
//                                                                  //
// output the color according to current specific pixel             //
//  1.welcome interface                                             //
//  2.choose 1 interface;3.choose 2 interface                       //
//  4.chesses in the memory:black and white;                        //
//  5.the moving chess                                              //
//  6.win or lose                                                   //                                                                 
//////////////////////////////////////////////////////////////////////					 

always @(posedge clk_25mhz or negedge rst_n)
begin
     if(!rst_n )  {vga_red,vga_green,vga_blue} <=24'b0;
	  else if((h_enable_write && v_enable_write) && life_valid_out)
	    begin
	      vga_red <= life_color_out[23:16];
			vga_green <= life_color_out[15:8];
			vga_blue <= life_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && flash)
       begin
		   vga_red<=255;vga_green<=255;vga_blue<=255;
		 end
	  else if((h_enable_write && v_enable_write) && title_valid_out)
	    begin
	      vga_red <= title_color_out[23:16];
			vga_green <= title_color_out[15:8];
			vga_blue <= title_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && intro_valid_out)
	    begin
	      vga_red <= intro_color_out[23:16];
			vga_green <= intro_color_out[15:8];
			vga_blue <= intro_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && score_valid_out)
	    begin
	      vga_red <= score_color_out[23:16];
			vga_green <= score_color_out[15:8];
			vga_blue <= score_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && shooter_valid_out)
	    begin
	      vga_red <= shooter_color_out[23:16];
			vga_green <= shooter_color_out[15:8];
			vga_blue <= shooter_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && peas_valid_out)
	    begin
	      vga_red <= peas_color_out[23:16];
			vga_green <= peas_color_out[15:8];
			vga_blue <= peas_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && brick_valid_out)
	    begin
	      vga_red <= brick_color_out[23:16];
			vga_green <= brick_color_out[15:8];
			vga_blue <= brick_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && wing_valid_out)
	    begin
	      vga_red <= wing_color_out[23:16];
			vga_green <= wing_color_out[15:8];
			vga_blue <= wing_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && bird_valid_out)
	    begin
	      vga_red <= bird_color_out[23:16];
			vga_green <= bird_color_out[15:8];
			vga_blue <= bird_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && pipe_valid_out)
		 begin
	      vga_red <= pipe_color_out[23:16];
			vga_green <= pipe_color_out[15:8];
			vga_blue <= pipe_color_out[7:0];
	    end
	  else if((h_enable_write && v_enable_write) && bg_valid_out)
		 begin
		   vga_red <= bg_color_out[23:16];
			vga_green <= bg_color_out[15:8];
			vga_blue <= bg_color_out[7:0];
		 end
	  else if((h_enable_write && v_enable_write) && !bg_valid_out)
		 begin
		   vga_red<=0;vga_green<=255;vga_blue<=255;
		 end
	  else
		 begin
		   vga_red<=0;vga_green<=0;vga_blue<=0;
		 end
end
			
														  
endmodule									             
                                    							  
			            				
		       








   

								             
                                    							  
			            				
              				  
		       








   

									             
                                    							  
			            				
              				  
		       








   

								             
                                    							  
			            				
              				  
		       








   

                          							  
			            				
              				  
		       








   

								             
                                    							  
			            				
              				  
		       








   

