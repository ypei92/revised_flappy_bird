
module control(clk,rst_n,choose1,choose2,left,right,up,down,enter,
  
               bird_crash,peas_get,
					
					flash,
					
					background_select,
					
					pillar_valid_0, pillar_valid_1,
               pillar_v_0_sum, pillar_v_1_sum,
               pillar_h_0_sum, pillar_h_1_sum,
					position_stripe_sum,
					gap_width,
					
					bird_height,bird_valid,
					bird_color_select,
				   bird_angle,wing_state,
					
					all_score,
					
					shooter_valid,shooter_state,
               shooter_x,shooter_y,
					peas_valid,peas_type,
					peas_x,peas_y,
					
					life,
					intro_type,
               intro_valid,
					intro_height
					);
					
input clk,rst_n,choose1,choose2,left,right,up,down,enter;
input bird_crash,peas_get;

//flash
output flash;
reg flash;

//definition of background
output background_select;
wire background_select;

//definition of pillar
output pillar_valid_0, pillar_valid_1,
       pillar_v_0_sum, pillar_v_1_sum,
       pillar_h_0_sum, pillar_h_1_sum,
		 position_stripe_sum,
		 gap_width;

reg pillar_valid_0, pillar_valid_1;
reg [8:0] pillar_v_0_sum, pillar_v_1_sum;
reg [8:0] pillar_h_0_sum, pillar_h_1_sum;
reg [8:0] position_stripe_sum;

reg [8:0] pillar_v_0, pillar_v_1;
reg [8:0] pillar_h_0, pillar_h_1;
reg [8:0] position_stripe;
reg [9:0] gap_width;

reg [8:0] last_pillar_h_0, last_pillar_h_1;

wire [7:0] random_256_1;
wire [7:0] random_256_2;

reg [2:0] pillar_move_0;
reg [2:0] pillar_move_1;

reg [2:0] pillar_speed;
reg pillar_zero_0, pillar_zero_1;

//definition of bird
output [12:0] bird_height;
output bird_valid;
output bird_color_select;
output bird_angle;
output wing_state;
reg signed [12:0] bird_height;
reg bird_valid;
wire [3:0] bird_angle;
wire [1:0] wing_state;

reg signed [12:0] bird_tap_height;
reg [9:0] bird_tap_time;
wire signed [12:0] bird_go_up;

reg [9:0] peas_get_counter;
reg [1:0] bird_color_select;
reg [1:0] bird_color_select_real;

//definition of score
output [31:0] all_score;
wire [31:0] all_score;

reg [3:0] score_3;
reg [3:0] score_2;
reg [3:0] score_1;
reg [3:0] score_0;
reg [3:0] high_score_3;
reg [3:0] high_score_2;
reg [3:0] high_score_1;
reg [3:0] high_score_0;
assign all_score = {high_score_3,high_score_2,high_score_1,high_score_0,score_3,score_2,score_1,score_0};

//definition of shooter
output shooter_valid,shooter_state;
output shooter_x,shooter_y;
output peas_valid,peas_type;
output peas_x,peas_y;
reg shooter_valid;
wire [3:0] shooter_state;
reg [6:0] shooter_state_8x;
reg [9:0] shooter_x,shooter_y;
reg peas_valid;
reg [2:0] peas_type;
reg [9:0] peas_y;
reg [9:0] peas_x;

//random_256
random_256_gen random_256_gen1(.clk(clk),.rst_n(rst_n),.change(enter==1),.random_256(random_256_1));
random_256_gen random_256_gen2(.clk(clk),.rst_n(rst_n),.change(up==1),.random_256(random_256_2));

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
// game state machine                                                          //
//                                                                             //        
/////////////////////////////////////////////////////////////////////////////////
reg [2:0] game_state;
reg [10:0] dead_counter;
reg [3:0] game_mode;

output life;
reg [3:0] life;
output intro_type;
output intro_valid;
reg intro_type;
reg intro_valid;
output intro_height;
reg [9:0] intro_height;

parameter WELCOME = 0;
parameter INITIAL_GAME = 1;
parameter NORMAL_MODE = 2;
parameter CHEAT_MODE = 3;
parameter DEAD = 4;
always @(posedge clk or negedge rst_n)
if (!rst_n)
  game_state <= WELCOME;
else if (game_state == WELCOME && up == 1'b1)
  game_state <= INITIAL_GAME;
else if (game_state == INITIAL_GAME)
  game_state <= NORMAL_MODE;
else if (game_state == NORMAL_MODE && choose2 == 1'b1)
  game_state <= CHEAT_MODE;
else if (game_state == CHEAT_MODE && choose1 == 1'b1)
  game_state <= NORMAL_MODE;
else if (game_state == NORMAL_MODE && life == 4'd0)
  game_state <= DEAD;
else if (game_state == DEAD && enter == 1'b1)
  game_state <= WELCOME;
else
  game_state <= game_state;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  dead_counter <= 0;
else if (game_state == INITIAL_GAME)
  dead_counter <= 0;
else if ((bird_crash == 1'b1 || (peas_get && peas_type == 3'd1)) && dead_counter == 0 && !(game_state==DEAD))
  dead_counter <= 1;
else if (dead_counter == 200)
  dead_counter <= 0;
else if (dead_counter > 0)
  dead_counter <= dead_counter + 1;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  flash <= 0;
else if (dead_counter > 0 && dead_counter < 10)
  flash <= 1;
else
  flash <= 0;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  life <= 4'd0;
else if (game_state == INITIAL_GAME)
  life <= 4'd5;
else if (peas_get && peas_type == 3'd2 && life != 4'd15)
  life <= life + 4'd1;
else if (peas_get && peas_type == 3'd1 && dead_counter == 0 && life != 4'd0 && game_state == NORMAL_MODE)
  life <= life - 4'd1;
else if (bird_crash == 1'b1 && dead_counter == 0 && life != 4'd0 && game_state == NORMAL_MODE)
  life <= life - 4'd1;
else
  life <= life;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  begin intro_valid <= 0; intro_type <= 0; end
else if (game_state == WELCOME)
  begin intro_valid <= 1; intro_type <= 0; end
else if (game_state == DEAD)
  begin intro_valid <= 1; intro_type <= 1; end
else
  begin intro_valid <= 0; intro_type <= 0; end
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  intro_height <= 10'd300;
else if ((game_state == WELCOME || game_state == DEAD) && dead_counter == 0)
  intro_height <= 10'd300;
else
  intro_height <= (dead_counter <= 100) ? 10'd500 - dead_counter * 2 : 10'd300;

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
// Background control                                                          //
//                                                                             //        
/////////////////////////////////////////////////////////////////////////////////
assign background_select = 1'b1;



/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
// Pillar control                                                              //
//                                                                             //        
/////////////////////////////////////////////////////////////////////////////////
parameter UP_PILLAR_BOTTOM = 9'd200;


//pillar valid====================================================================================
always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_valid_0 <= 0;
else if (game_state == WELCOME)
  pillar_valid_0 <= 0;
else if (game_state == INITIAL_GAME)
  pillar_valid_0 <= 0;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE) && pillar_zero_0)
  pillar_valid_0 <= 1;
else
  pillar_valid_0 <= pillar_valid_0;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_valid_1 <= 0;
else if (game_state == WELCOME)
  pillar_valid_1 <= 0;
else if (game_state == INITIAL_GAME)
  pillar_valid_1 <= 0;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE) && pillar_zero_1)
  pillar_valid_1 <= 1;
else
  pillar_valid_1 <= pillar_valid_1;

//gap_width========================================================================================
always @(posedge clk or negedge rst_n)
if (!rst_n)
  gap_width <= 10'd178;
else if (game_state == INITIAL_GAME)
  gap_width <= 10'd178;
else if (peas_get && peas_type == 3'd3) // wider
  gap_width <= (gap_width == 10'd228) ? 10'd228 : gap_width + 10'd50;
else if (peas_get && peas_type == 3'd5) // narrower
  gap_width <= (gap_width == 10'd128) ? 10'd128 : gap_width - 10'd50;

//pillar speed=====================================================================================
//0 for default, 1 for 1, 2 for 2, 3 for 3 (pix/s)
always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_speed <= 2'd2;
else if (game_state == INITIAL_GAME)
  pillar_speed <= 2'd2;
else if (peas_get && peas_type == 3'd6) // accelerate
  pillar_speed <= 2'd3;
else if (peas_get && peas_type == 3'd7) // decelerate
  pillar_speed <= 2'd2;
else
  pillar_speed <= pillar_speed;

always @(pillar_speed or pillar_h_0 or last_pillar_h_0)
if (pillar_speed == 2'd1)
  pillar_zero_0 <= (pillar_h_0 == 9'b0);
else if (pillar_speed == 2'd2)
  pillar_zero_0 <= (pillar_h_0 <= 9'd1) && (last_pillar_h_0 > 9'd1);
else if (pillar_speed == 2'd3)
  pillar_zero_0 <= (pillar_h_0 <= 9'd2) && (last_pillar_h_0 > 9'd2);
else
  pillar_zero_0 <= (pillar_h_0 > 9'd500) && (last_pillar_h_0 < 9'd500);

always @(pillar_speed or pillar_h_1 or last_pillar_h_1)
if (pillar_speed == 2'd1)
  pillar_zero_1 <= (pillar_h_1 == 9'b0);
else if (pillar_speed == 2'd2)
  pillar_zero_1 <= (pillar_h_1 <= 9'd1) && (last_pillar_h_1 > 9'd1);
else if (pillar_speed == 2'd3)
  pillar_zero_1 <= (pillar_h_1 <= 9'd2) && (last_pillar_h_1 > 9'd2);
else
  pillar_zero_1 <= (pillar_h_1 > 9'd500) && (last_pillar_h_1 < 9'd500);


//pillar move======================================================================================
//0 for stop, 1 for up, 2 for down
parameter MODE_NORMAL = 0;
parameter MODE_MOVE = 1;
always @(posedge clk or negedge rst_n)
if (!rst_n)
  game_mode <= MODE_NORMAL;
else if (game_state == INITIAL_GAME)
  game_mode <= MODE_NORMAL;
else if (peas_get && peas_type == 3'd0)
  game_mode <= MODE_MOVE;
else if (peas_get && peas_type == 3'd4)
  game_mode <= MODE_NORMAL;
else
  game_mode <= game_mode;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_move_0 <= 2'd0;
else if (pillar_v_0 <= UP_PILLAR_BOTTOM + gap_width - 9'd127)
  pillar_move_0 <= 2'd1;
else if (pillar_v_0 >= UP_PILLAR_BOTTOM + 9'd254)
  pillar_move_0 <= 2'd2;
else if (game_mode != MODE_MOVE)
  pillar_move_0 <= 2'd0;
else if (pillar_zero_0)
  pillar_move_0 <= (random_256_1[0]==0) ? 2'd1 : 2'd2;
else
  pillar_move_0 <= pillar_move_0;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_move_1 <= 2'd0;
else if (pillar_v_1 <= UP_PILLAR_BOTTOM + gap_width - 9'd127)
  pillar_move_1 <= 2'd1;
else if (pillar_v_1 >= UP_PILLAR_BOTTOM + 9'd254)
  pillar_move_1 <= 2'd2;
else if (game_mode != MODE_MOVE)
  pillar_move_1 <= 2'd0;
else if (pillar_zero_1)
  pillar_move_1 <= (random_256_2[0]==0) ? 2'd1 : 2'd2;
else
  pillar_move_1 <= pillar_move_1;

//horizontal=======================================================================================
always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_h_0 <= 0;
else if (game_state == INITIAL_GAME)
  pillar_h_0 <= 9'd50;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE) && pillar_zero_0)
  pillar_h_0 <= 9'd350;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE))
  pillar_h_0 <= pillar_h_0 - pillar_speed;
else if (game_state == DEAD)
  pillar_h_0 <= pillar_h_0;
 
always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_h_1 <= 0;
else if (game_state == INITIAL_GAME)
  pillar_h_1 <= 9'd224;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE) && pillar_zero_1)
  pillar_h_1 <= 9'd350;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE))
  pillar_h_1 <= pillar_h_1 - pillar_speed;
else if (game_state == DEAD)
  pillar_h_1 <= pillar_h_1;
  
//vertical=========================================================================================
always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_v_0 <= 0;
else if (game_state == INITIAL_GAME)
  pillar_v_0 <= random_256_1 + UP_PILLAR_BOTTOM;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE || game_state == DEAD) && pillar_zero_0)
  pillar_v_0 <= random_256_1 + UP_PILLAR_BOTTOM;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE || game_state == DEAD) && (pillar_move_0 == 2'd1))
  pillar_v_0 <= pillar_v_0 + 1;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE || game_state == DEAD) && (pillar_move_0 == 2'd2))
  pillar_v_0 <= pillar_v_0 - 1;
else
  pillar_v_0 <= pillar_v_0;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  pillar_v_1 <= 0;
else if (game_state == INITIAL_GAME)
  pillar_v_1 <= random_256_1 + UP_PILLAR_BOTTOM;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE || game_state == DEAD) && pillar_zero_1)
  pillar_v_1 <= random_256_1 + UP_PILLAR_BOTTOM;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE || game_state == DEAD) && (pillar_move_1 == 2'd1))
  pillar_v_1 <= pillar_v_1 + 1;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE || game_state == DEAD) && (pillar_move_1 == 2'd2))
  pillar_v_1 <= pillar_v_1 - 1;
else
  pillar_v_1 <= pillar_v_1;

//stripe============================================================================================
always @(posedge clk or negedge rst_n)
if (!rst_n)
  position_stripe <= 0;
else if (game_state == WELCOME || game_state == WELCOME)
  position_stripe <= 0;
else if (game_state == NORMAL_MODE || game_state == CHEAT_MODE)
  position_stripe <= position_stripe - pillar_speed;
else if (game_state == DEAD)
  position_stripe <= position_stripe;
else
  position_stripe <= 0;

//last pillar horizontal============================================================================
always @(posedge clk or negedge rst_n)
if (!rst_n)
  begin last_pillar_h_0 <= 0; last_pillar_h_1 <= 0; end
else
  begin last_pillar_h_0 <= pillar_h_0; last_pillar_h_1 <= pillar_h_1; end

//sum===============================================================================================
always @(dead_counter or pillar_v_0 or pillar_v_1 or pillar_h_0 or pillar_h_1 or position_stripe)
if (dead_counter == 0)
begin
  pillar_v_0_sum <= pillar_v_0;
  pillar_v_1_sum <= pillar_v_1;
  pillar_h_0_sum <= pillar_h_0;
  pillar_h_1_sum <= pillar_h_1;
  position_stripe_sum <= position_stripe;
end
else if (dead_counter < 40)
begin
  pillar_v_0_sum <= (random_256_2[7]==0) ? pillar_v_0 + random_256_2[1:0] : pillar_v_0 - random_256_2[1:0];
  pillar_v_1_sum <= (random_256_2[7]==0) ? pillar_v_1 + random_256_2[1:0] : pillar_v_1 - random_256_2[1:0];
  pillar_h_0_sum <= (random_256_1[7]==0) ? pillar_h_0 + random_256_1[1:0] : pillar_h_0 - random_256_1[1:0];
  pillar_h_1_sum <= (random_256_1[7]==0) ? pillar_h_1 + random_256_1[1:0] : pillar_h_1 - random_256_1[1:0];
  position_stripe_sum <= (random_256_1[7]==0) ? position_stripe + random_256_1[1:0] : position_stripe - random_256_1[1:0];
end
else
begin
  pillar_v_0_sum <= pillar_v_0;
  pillar_v_1_sum <= pillar_v_1;
  pillar_h_0_sum <= pillar_h_0;
  pillar_h_1_sum <= pillar_h_1;
  position_stripe_sum <= position_stripe;
end

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
// Bird control                                                                //
//                                                                             //        
/////////////////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)
if (!rst_n)
  bird_valid <= 1;
else if (dead_counter == 0)
  bird_valid <= 1;
else if (dead_counter > 0 && game_state != DEAD)
  bird_valid <= (dead_counter[4:3] != 2'b00);
else
  bird_valid <= 1;

//bird_tap_height
always @(posedge clk or negedge rst_n)
if (!rst_n)
  bird_tap_height <= 13'd222;
else if (game_state == WELCOME || game_state == INITIAL_GAME)
  bird_tap_height <= 13'd222;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE) && (up == 1'b1))
  bird_tap_height <= bird_height;
else
  bird_tap_height <= bird_tap_height;

//bird_tap_time
always @(posedge clk or negedge rst_n)
if (!rst_n)
  bird_tap_time <= 10'b0;
else if (game_state == WELCOME || game_state == INITIAL_GAME)
  bird_tap_time <= 10'b0;
else if ((game_state == NORMAL_MODE || game_state == CHEAT_MODE) && (up == 1'b1))
  bird_tap_time <= 10'd1;
else if (bird_tap_time < 10'd127)
  bird_tap_time <= bird_tap_time + 10'b1;
else
  bird_tap_time <= bird_tap_time;

bird_info_gen bird_info_gen( .bird_tap_time(bird_tap_time), .bird_go_up(bird_go_up) , .bird_angle(bird_angle),
                             .wing_state(wing_state));

parameter BIRD_UP_MAX = 480;
parameter BIRD_DOWN_MAX = 40;
always @(bird_go_up or bird_tap_height)
if (bird_go_up + bird_tap_height > BIRD_UP_MAX)
  bird_height <= BIRD_UP_MAX;
else if (bird_go_up + bird_tap_height < BIRD_DOWN_MAX)
  bird_height <= BIRD_DOWN_MAX;
else
  bird_height <= bird_go_up + bird_tap_height;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  peas_get_counter <= 10'd0;
else if (peas_get && peas_get_counter == 0)
  peas_get_counter <= 10'd1;
else if (peas_get_counter == 10'd80)
  peas_get_counter <= 10'd0;
else if (peas_get_counter != 10'd0)
  peas_get_counter <= peas_get_counter + 10'd1;
else
  peas_get_counter <= peas_get_counter;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  bird_color_select_real <= 2'd0;
else if (peas_get_counter == 10'd80)
  bird_color_select_real <= (bird_color_select_real == 2'd2) ? 2'd0 : bird_color_select_real + 2'd1;
else
  bird_color_select_real <= bird_color_select_real;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  bird_color_select <= 2'd0;
else if (peas_get_counter != 10'd0)
  bird_color_select <= (peas_get_counter[2]==0) ? 2'd3 : bird_color_select_real;
else
  bird_color_select <= bird_color_select_real;

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
// score control                                                               //
//                                                                             //        
/////////////////////////////////////////////////////////////////////////////////
parameter ADD_SCORE_POINT = 9'd100;
wire add_score;
assign add_score = ((pillar_valid_0 && (pillar_h_0 <= ADD_SCORE_POINT) && (last_pillar_h_0 > ADD_SCORE_POINT))
                 || (pillar_valid_1 && (pillar_h_1 <= ADD_SCORE_POINT) && (last_pillar_h_1 > ADD_SCORE_POINT)));

always @(posedge clk or negedge rst_n)
if (!rst_n)
  score_0 <= 0;
else if (game_state <= WELCOME)
  score_0 <= 0;
else if ((game_state <= NORMAL_MODE || game_state <= CHEAT_MODE) && add_score && (score_0 == 4'd9))
  score_0 <= 0;
else if ((game_state <= NORMAL_MODE || game_state <= CHEAT_MODE) && add_score && (score_0 != 4'd9))
  score_0 <= score_0 + 1;
else
  score_0 <= score_0;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  score_1 <= 0;
else if (game_state <= WELCOME)
  score_1 <= 0;
else if ((game_state <= NORMAL_MODE || game_state <= CHEAT_MODE) && add_score && (score_0 == 4'd9) && (score_1 == 4'd9))
  score_1 <= 0;
else if ((game_state <= NORMAL_MODE || game_state <= CHEAT_MODE) && add_score && (score_0 == 4'd9) && (score_1 != 4'd9))
  score_1 <= score_1 + 1;
else
  score_1 <= score_1;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  score_2 <= 0;
else if (game_state <= WELCOME)
  score_2 <= 0;
else if ((game_state <= NORMAL_MODE || game_state <= CHEAT_MODE) && add_score && (score_0 == 4'd9) && (score_1 == 4'd9) && (score_2 == 4'd9))
  score_2 <= 0;
else if ((game_state <= NORMAL_MODE || game_state <= CHEAT_MODE) && add_score && (score_0 == 4'd9) && (score_1 == 4'd9) && (score_2 != 4'd9))
  score_2 <= score_2 + 1;
else
  score_2 <= score_2;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  score_3 <= 0;
else if (game_state <= WELCOME)
  score_3 <= 0;
else if ((game_state <= NORMAL_MODE || game_state <= CHEAT_MODE) && add_score && (score_0 == 4'd9) && (score_1 == 4'd9) && (score_2 == 4'd9) && (score_3 == 4'd9))
  score_3 <= 0;
else if ((game_state <= NORMAL_MODE || game_state <= CHEAT_MODE) && add_score && (score_0 == 4'd9) && (score_1 == 4'd9) && (score_2 == 4'd9) && (score_3 != 4'd9))
  score_3 <= score_3 + 1;
else
  score_3 <= score_3;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  {high_score_3,high_score_2,high_score_1,high_score_0} <= 16'd0;
else if ({score_3,score_2,score_1,score_0} > {high_score_3,high_score_2,high_score_1,high_score_0})
  {high_score_3,high_score_2,high_score_1,high_score_0} <= {score_3,score_2,score_1,score_0};
else
  {high_score_3,high_score_2,high_score_1,high_score_0} <= {high_score_3,high_score_2,high_score_1,high_score_0};

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
// shooter control                                                             //
//                                                                             //        
/////////////////////////////////////////////////////////////////////////////////
//shooter move========================================================================================
reg [1:0] shooter_move;
reg [6:0] shooter_counter;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  shooter_state_8x <= 6'd0;
else if (shooter_state_8x == 6'd48)
  shooter_state_8x <= 6'd0;
else
  shooter_state_8x <= shooter_state_8x + 6'd1;

assign shooter_state = shooter_state_8x[5:2];

always @(posedge clk or negedge rst_n)
if (!rst_n)
  shooter_x <= 10'd500;
else
  shooter_x <= 10'd500;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  shooter_counter <= 7'b0;
else
  shooter_counter <= shooter_counter + 7'b1;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  shooter_move <= 2'd0;
else if (shooter_counter == 7'd1)
  shooter_move <= (random_256_1[1:0] == 2'b11) ? 2'd0 : random_256_1[1:0];
else if (shooter_y <= 10'd50)
  shooter_move <= 2'd1;
else if (shooter_y >= 10'd370)
  shooter_move <= 2'd2;
else
  shooter_move <= shooter_move;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  shooter_y <= 10'd200;
else if (shooter_move == 2'd0)
  shooter_y <= shooter_y;
else if (shooter_move == 2'd1)
  shooter_y <= shooter_y + 1;
else if (shooter_move == 2'd2)
  shooter_y <= shooter_y - 1;
else
  shooter_y <= shooter_y; 

always @(posedge clk or negedge rst_n)
if (!rst_n)
  peas_x <= 10'd0;
//else peas_x <= 10'd200;
else if (shooter_counter == 7'd2 && shooter_move == 2'd0 && (game_state == NORMAL_MODE || game_state == CHEAT_MODE))
  peas_x <= 10'd530;
else if (peas_x > 10'd640)
  peas_x <= peas_x;
else
  peas_x <= peas_x - 4;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  peas_y <= 0;
//else peas_y <= 10'd200;
else if (shooter_counter == 7'd2 && shooter_move == 2'd0)
  peas_y <= shooter_y + 50;
else
  peas_y <= peas_y;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  peas_valid <= 0;
else if (peas_get)
  peas_valid <= 0;
else if (peas_x == 10'd530)
  peas_valid <= 1;

always @(posedge clk or negedge rst_n)
if (!rst_n)
  peas_type <= 3'd0;
else if (shooter_counter == 7'd2 && shooter_move == 2'd0)
  peas_type <= random_256_2[2:0];

endmodule