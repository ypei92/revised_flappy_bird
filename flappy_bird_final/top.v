module top(rst_n,clk,
           clk_ps2,data_ps2,
           h_sysc,v_sysc,vga_red,vga_green,
           vga_clk,vga_blue,vga_out_blank,vga_comp_synch);
input rst_n,clk;
input clk_ps2,data_ps2;
output h_sysc,v_sysc,vga_red,vga_green,vga_blue,vga_out_blank,vga_comp_synch;
output vga_clk;

//clk_div
wire clk_25mhz,clk_60hz,clk_2hz,clk_400hz;

//ps2_ctrl
wire choose1,choose2,left,right,up,down,enter;

//control
wire background_select;
wire pillar_valid_0, pillar_valid_1;
wire [8:0] pillar_v_0, pillar_v_1;
wire [8:0] pillar_h_0, pillar_h_1;
wire [8:0] position_stripe;
wire [9:0] gap_width;
wire [9:0] bird_height;
wire [1:0] bird_color_select;
wire [3:0] bird_angle;
wire [1:0] wing_state;
wire flash;
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

//vga_show
wire h_sysc;
wire v_sysc;
wire vga_clk;
wire [7:0] vga_red,vga_green,vga_blue;
wire bird_crash,peas_get;

wire vga_out_blank;
assign vga_out_blank=1;
wire vga_comp_synch;
assign vga_comp_synch=0;


clk_div clk_div1(
               .rst_n(rst_n),
               .clk(clk),//100mhz system clock
					
               .clk_25mhz(clk_25mhz),
               .clk_60hz(clk_60hz),
               .clk_2hz(clk_2hz),
					.clk_400hz(clk_400hz)
               );
 
 
 
ps2_ctlr ps2_ctlr1(
            .rst_n(rst_n), 
		      .sys_clk(clk),//100mhz
		      .clk_ps2(clk_ps2), 
		      .data_ps2(data_ps2), 
				
				.choose1(choose1),
				.choose2(choose2),
				.left(left),
				.right(right),
				.up(up),
				.down(down),
				.enter(enter)
		      
		      );
 
control control1(
              .rst_n(rst_n),
              .clk(clk_60hz),
              .left(left),
              .right(right),
              .up(up),
              .down(down),
              .enter(enter),
				  .choose1(choose1),//choose person-person competition
				  .choose2(choose2),
				  
				  .bird_crash(bird_crash),
				  .peas_get(peas_get),
				  
				  .flash(flash),
				  
				  .background_select(background_select),
								
              .pillar_valid_0(pillar_valid_0),
				  .pillar_valid_1(pillar_valid_1),
				  .pillar_v_0_sum(pillar_v_0),
				  .pillar_v_1_sum(pillar_v_1),
				  .pillar_h_0_sum(pillar_h_0),
				  .pillar_h_1_sum(pillar_h_1),
				  .position_stripe_sum(position_stripe),
				  .gap_width(gap_width),
				  
				  .bird_height(bird_height),
				  .bird_valid(bird_valid),
				  .bird_color_select(bird_color_select),
				  .bird_angle(bird_angle),
				  .wing_state(wing_state),
				  
				  .all_score(all_score),
				  
				  .shooter_valid(shooter_valid),
				  .shooter_state(shooter_state),
              .shooter_x(shooter_x),
				  .shooter_y(shooter_y),
				  .peas_valid(peas_valid),
				  .peas_type(peas_type),
				  .peas_x(peas_x),
				  .peas_y(peas_y),
				  
				  .life(life),
				  .intro_type(intro_type),
              .intro_valid(intro_valid),
				  .intro_height(intro_height)
              );
			  
vga_show vga_show1(
              .rst_n(rst_n),
				  
              .clk(clk_60hz),
              .clk_25mhz(clk_25mhz),
				  .clk_2hz(clk_2hz),//applied for the twinkle chess
				  
				  .flash(flash),
				  
				  .background_select(background_select),
				  
              .pillar_valid_0(pillar_valid_0),
				  .pillar_valid_1(pillar_valid_1),
				  .pillar_v_0(pillar_v_0),
				  .pillar_v_1(pillar_v_1),
				  .pillar_h_0(pillar_h_0),
				  .pillar_h_1(pillar_h_1),
				  .position_stripe(position_stripe),
				  .gap_width(gap_width),
				  
				  .bird_height(bird_height),
				  .bird_valid(bird_valid),
				  .bird_color_select(bird_color_select),
				  .bird_angle(bird_angle),
				  .wing_state(wing_state),
				  
				  .all_score(all_score),
				  
				  .shooter_valid(shooter_valid),
				  .shooter_state(shooter_state),
              .shooter_x(shooter_x),
				  .shooter_y(shooter_y),
				  .peas_valid(peas_valid),
				  .peas_type(peas_type),
				  .peas_x(peas_x),
				  .peas_y(peas_y),
				  
				  .life(life),
				  .intro_type(intro_type),
              .intro_valid(intro_valid),
				  .intro_height(intro_height),
				  
				  .h_sysc(h_sysc),
				  .v_sysc(v_sysc),	
              .vga_red(vga_red),
              .vga_green(vga_green),
              .vga_blue(vga_blue),
              .vga_out_pixel_clock(vga_clk),

              .bird_crash(bird_crash),
              .peas_get(peas_get)				  
				  );
              
              
endmodule


