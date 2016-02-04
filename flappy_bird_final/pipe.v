module pipe       ( clk 
                  , rst_n
                  , h_line
                  , v_line
                  , position_1_v
                  , position_1_h
                  , position_2_v
                  , position_2_h
                  , valid_1
                  , valid_2
						, position_stripe
						, gap_width
                  , valid_out
                  , color_out );

  input clk ,
        rst_n ,
        h_line ,
        v_line ,
        position_1_v ,
        position_1_h ,
        position_2_v ,
        position_2_h ,
        valid_1 ,
        valid_2 ,
		  position_stripe,
		  gap_width;
        
  output valid_out ,
         color_out ;
  
  parameter pipe_width = 10'd52;
  //parameter gap_width = 10'd178;
  parameter pipe_retract = 10'd2 ;
  parameter head_width = 10'd20;
  parameter stripe_height = 10'd20 ;
  parameter blank_height = 10'd30;
  
  parameter color_1 = {8'd210,8'd236,8'd125};
  parameter color_2 = {8'd217,8'd243,8'd131};
  parameter color_3 = {8'd223,8'd248,8'd135};
  parameter color_4 = {8'd228,8'd253,8'd139};
  parameter color_5 = {8'd223,8'd248,8'd135};
  parameter color_6 = {8'd217,8'd244,8'd130};
  parameter color_7 = {8'd209,8'd236,8'd125};
  parameter color_8 = {8'd201,8'd230,8'd119};
  parameter color_9 = {8'd192,8'd222,8'd112};
  parameter color_10 = {8'd183,8'd213,8'd106};
  parameter color_11 = {8'd172,8'd204,8'd98};
  parameter color_12 = {8'd162,8'd195,8'd90};
  parameter color_13 = {8'd152,8'd186,8'd83};
  parameter color_14 = {8'd141,8'd176,8'd75};
  parameter color_15 = {8'd131,8'd168,8'd68};
  parameter color_16 = {8'd121,8'd160,8'd60};
  parameter color_17 = {8'd112,8'd151,8'd53};
  parameter color_18 = {8'd104,8'd144,8'd48};
  parameter color_19 = {8'd97,8'd138,8'd42};
  parameter color_20 = {8'd90,8'd132,8'd37};
  parameter color_21 = {8'd85,8'd128,8'd34};
  
  wire clk , rst_n ;
  wire [8:0]v_line ;
  wire [8:0]h_line ;
  wire [8:0]position_1_v ;
  wire [8:0]position_2_v ;
  wire [8:0]position_1_h ;
  wire [8:0]position_2_h ;
  wire valid_1 ;
  wire valid_2 ;
  wire [8:0]position_stripe;
  wire [9:0]gap_width;
  reg  valid_out ;
  reg  [23:0]color_out ;
  
  
  reg test_valid ;
  reg black_valid ;
  wire stripe_valid ;
  wire [7:0]check_color_1; 
  wire [7:0]check_color_2;
  wire [7:0]check_color_3;
  wire [7:0]check_color_4;
  
  reg [8:0]stripe_b ;
  reg stripe_color_mux;
  reg state_1, state_2, state_3, state_4, state_5, state_6, state_7, state_8  ;
  reg [23:0]color_state ;
  
always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
if(( h_line +pipe_width >= position_1_h ) && ( h_line <= position_1_h )&& ( v_line >= position_1_v ) && ( v_line <= position_1_v + head_width) && valid_1 )
     test_valid <= 1; 
else if(( h_line +pipe_width >= position_2_h ) && ( h_line <= position_2_h ) &&( v_line >= position_2_v && (v_line <= position_2_v + head_width ) && valid_2 ))
     test_valid <= 1; 
else if (( h_line +pipe_width >= position_1_h ) && ( h_line <= position_1_h) && ( v_line +gap_width <= position_1_v ) && (v_line + gap_width + head_width >= position_1_v ) && valid_1 )
     test_valid <= 1;
else if ((h_line +pipe_width >= position_2_h) && (h_line <= position_2_h) && (v_line +gap_width <= position_2_v ) && (v_line + gap_width + head_width >= position_2_v ) && valid_2 )
     test_valid <= 1;
else if (( h_line +pipe_width >= position_1_h + pipe_retract ) && ( h_line + pipe_retract<= position_1_h )&& ( v_line >= position_1_v + head_width) && valid_1 ) 
     test_valid <= 1;
else if (( h_line +pipe_width >= position_2_h + pipe_retract ) && ( h_line + pipe_retract<= position_2_h )&& ( v_line >= position_2_v + head_width ) && valid_2 ) 
     test_valid <= 1;
else if (( h_line +pipe_width >= position_1_h + pipe_retract ) && ( h_line + pipe_retract<= position_1_h ) && ( v_line +gap_width +head_width <= position_1_v ) && (v_line >= blank_height + stripe_height) && valid_1 )
     test_valid <= 1; 
else if (( h_line +pipe_width >= position_2_h + pipe_retract ) && ( h_line + pipe_retract<= position_2_h )&& ( v_line +gap_width +head_width <= position_2_v ) && ( v_line >= blank_height + stripe_height) && valid_2 )
     test_valid <= 1;  
else if  (stripe_valid )
     test_valid <= 1;
else
     test_valid <= 0;
                      
always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
 if (valid_1 && ( h_line + pipe_width == position_1_h ) && ( v_line >= position_1_v )&& (v_line <= position_1_v + head_width))
   black_valid <= 1;
 else if (valid_1 && ( h_line + pipe_width == position_1_h ) && ( v_line +gap_width <= position_1_v ) && (v_line +gap_width +head_width >=position_1_v))
   black_valid <= 1;
 else if (valid_1 && ( h_line == position_1_h ) && ( v_line >= position_1_v )&& (v_line <= position_1_v +head_width))
   black_valid <= 1;
 else if (valid_1 && ( h_line == position_1_h ) && ( v_line +gap_width <= position_1_v )&& (v_line +gap_width +head_width >=position_1_v))
   black_valid <= 1;
 else if (valid_1 && ( h_line + pipe_width >= position_1_h ) && ( h_line <= position_1_h )&& ( v_line == position_1_v ))
   black_valid <= 1;  
 else if (valid_1 && ( h_line +pipe_width >= position_1_h ) && ( h_line <= position_1_h )&& ( v_line +gap_width == position_1_v ))
   black_valid <= 1;
 else if (valid_1 && ( h_line + pipe_width >= position_1_h ) && ( h_line <= position_1_h )&& ( v_line == position_1_v +head_width ))
   black_valid <= 1; 
 else if (valid_1 && ( h_line +pipe_width >= position_1_h ) && ( h_line <= position_1_h )&& ( v_line +gap_width +head_width == position_1_v )) 
   black_valid <= 1;
 else if (valid_1 && ( h_line +pipe_width == position_1_h + pipe_retract ) && ( v_line >= position_1_v +head_width )) 
   black_valid <= 1;
 else if (valid_1 && ( h_line +pipe_width == position_1_h + pipe_retract ) && ( v_line <= position_1_v -head_width -gap_width) && (v_line >= blank_height+ stripe_height )) 
   black_valid <= 1;
 else if (valid_1 && ( h_line == position_1_h - pipe_retract ) && ( v_line >= position_1_v +head_width )) 
  black_valid <= 1; 
 else if (valid_1 && ( h_line == position_1_h - pipe_retract ) && ( v_line <= position_1_v -head_width -gap_width ) &&(v_line >= blank_height + stripe_height) ) 
   black_valid <= 1;
 else if (valid_2 && ( h_line + pipe_width == position_2_h ) && ( v_line >= position_2_v )&& (v_line <= position_2_v + head_width))
   black_valid <= 1;
 else if (valid_2 && ( h_line + pipe_width == position_2_h ) && ( v_line +gap_width <= position_2_v ) && (v_line +gap_width +head_width >=position_2_v)) 
   black_valid <= 1;
 else if (valid_2 && ( h_line == position_2_h ) && ( v_line >= position_2_v )&& (v_line <= position_2_v +head_width)) 
   black_valid <= 1;
 else if (valid_2 && ( h_line == position_2_h ) && ( v_line +gap_width <= position_2_v )&& (v_line +gap_width +head_width >=position_2_v)) 
   black_valid <= 1;
 else if (valid_2 && ( h_line + pipe_width >= position_2_h ) && ( h_line <= position_2_h )&& ( v_line == position_2_v )) 
   black_valid <= 1;
 else if (valid_2 && ( h_line +pipe_width >= position_2_h ) && ( h_line <= position_2_h ) && ( v_line +gap_width == position_2_v )) 
   black_valid <= 1;
 else if (valid_2 && ( h_line + pipe_width >= position_2_h ) && ( h_line <= position_2_h ) && ( v_line == position_2_v +head_width )) 
 black_valid <= 1;  
 else if (valid_2 && ( h_line +pipe_width >= position_2_h ) && ( h_line <= position_2_h )&& ( v_line +gap_width +head_width == position_2_v )) 
   black_valid <= 1;
 else if (valid_2 && ( h_line +pipe_width == position_2_h + pipe_retract ) && ( v_line >= position_2_v +head_width )) 
   black_valid <= 1;
 else if (valid_2 && ( h_line +pipe_width == position_2_h + pipe_retract ) && ( v_line <= position_2_v -head_width -gap_width) && (v_line >=blank_height + stripe_height )) 
   black_valid <= 1;
 else if (valid_2 && ( h_line == position_2_h - pipe_retract ) && ( v_line >= position_2_v +head_width )) 
   black_valid <= 1;
 else if (valid_2 && ( h_line == position_2_h - pipe_retract ) && ( v_line <= position_2_v -head_width -gap_width ) && (v_line >= blank_height+ stripe_height)) 
   black_valid <= 1;
 else if (v_line == blank_height + stripe_height)
   black_valid <= 1;
 else if (v_line == blank_height)
   black_valid <= 1;
 else
   black_valid <= 0;
   
   
always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
if(( h_line +pipe_width >= position_1_h ) && ( h_line <= position_1_h )&& ( v_line >= position_1_v ) && ( v_line <= position_1_v + head_width) && valid_1 )
     state_1 <= 1; 
else
     state_1 <= 0;
     

always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
if(( h_line +pipe_width >= position_2_h ) && ( h_line <= position_2_h ) &&( v_line >= position_2_v && (v_line <= position_2_v + head_width ) && valid_2 ))
     state_2 <= 1;  
else
     state_2 <= 0;
     
     
     
always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
 if (( h_line +pipe_width >= position_1_h ) && ( h_line <= position_1_h) && ( v_line +gap_width <= position_1_v ) && (v_line + gap_width + head_width >= position_1_v ) && valid_1 )
     state_3 <= 1;
else
     state_3 <= 0;

always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
if ((h_line +pipe_width >= position_2_h) && (h_line <= position_2_h) && (v_line +gap_width <= position_2_v ) && (v_line + gap_width + head_width >= position_2_v ) && valid_2 )
     state_4 <= 1;
else
     state_4 <= 0;



always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
 if (( h_line +pipe_width >= position_1_h + pipe_retract ) && ( h_line + pipe_retract<= position_1_h )&& ( v_line >= position_1_v + head_width) && valid_1 ) 
     state_5 <= 1;
else
     state_5 <= 0;
     
     
always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
 if (( h_line +pipe_width >= position_2_h + pipe_retract ) && ( h_line + pipe_retract<= position_2_h )&& ( v_line >= position_2_v + head_width ) && valid_2 ) 
     state_6 <= 1;
else
     state_6 <= 0;     

     
always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
 if (( h_line +pipe_width >= position_1_h + pipe_retract ) && ( h_line + pipe_retract<= position_1_h ) && ( v_line +gap_width +head_width <= position_1_v ) && (v_line > blank_height + stripe_height) && valid_1 )
     state_7 <= 1;   
else
     state_7 <= 0;



always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
 if (( h_line +pipe_width >= position_2_h + pipe_retract ) && ( h_line + pipe_retract<= position_2_h )&& ( v_line +gap_width +head_width <= position_2_v ) && ( v_line > blank_height + stripe_height) && valid_2 )
     state_8 <= 1;  
else
     state_8 <= 0;
     
     
          
     
always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2)
        if(stripe_valid)
        begin
        stripe_b = h_line +30- v_line  - position_stripe;
        stripe_color_mux = stripe_b[3];
    end

     
         
         
  assign  check_color_1 = (position_1_h - h_line) /2;
  assign  check_color_2 = (position_1_h - pipe_retract - h_line) /2;
  assign  check_color_3 = (position_2_h - h_line) /2 ; 
  assign  check_color_4 = (position_2_h - pipe_retract - h_line) /2;      
  assign  stripe_valid = ((v_line <= stripe_height + blank_height) &&(v_line >= blank_height));
  
  always @(h_line ,
         v_line ,
         position_1_v ,
         position_1_h ,
         position_2_v ,
         position_2_h ,
         valid_1 ,
         valid_2,
         check_color_1,
			check_color_2,
			check_color_3,
			check_color_4)
			begin
    if(state_1)
      begin
      if((v_line == position_1_v + head_width - 1 || v_line == position_1_v + head_width - 2)&& (h_line +2<= position_1_h)&&(h_line + pipe_width>= position_1_h  +2))
       color_state = {8'd85,8'd128,8'd34};
      else
      case(check_color_1)
        8'd0: color_state = {8'd85,8'd56,8'd71};
        8'd1: color_state = color_21;
        8'd2: color_state = color_21;
        8'd3: color_state = color_21;
        8'd4: color_state = color_21;
        8'd5: color_state = color_20;
        8'd6: color_state = color_19;
        8'd7: color_state = color_18;
        8'd8: color_state = color_17;
        8'd9: color_state = color_16;
        8'd10: color_state = color_15;
        8'd11: color_state = color_14;
        8'd12: color_state = color_13;
        8'd13: color_state = color_12;
        8'd14: color_state = color_11;
        8'd15: color_state = color_10;
        8'd16: color_state = color_9;
        8'd17: color_state = color_8;
        8'd18: color_state = color_7;
        8'd19: color_state = color_6;
        8'd20: color_state = color_5;
        8'd21: color_state = color_4;
        8'd22: color_state = color_3;
        8'd23: color_state = color_2;
        8'd24: color_state = color_1;
        8'd25: color_state = {8'd84,8'd56,8'd71};
      endcase
      end
		
		    if(state_3)
      begin
      if((v_line == position_1_v - head_width -gap_width + 1 || v_line == position_1_v - head_width -gap_width + 2)&& (h_line +2<= position_1_h )&&(h_line +pipe_width >= position_1_h  +2))
       color_state = {8'd85,8'd128,8'd34};
      else
      case(check_color_1)
        8'd0: color_state = {8'd85,8'd56,8'd71};
        8'd1: color_state = color_21;
        8'd2: color_state = color_21;
        8'd3: color_state = color_21;
        8'd4: color_state = color_21;
        8'd5: color_state = color_20;
        8'd6: color_state = color_19;
        8'd7: color_state = color_18;
        8'd8: color_state = color_17;
        8'd9: color_state = color_16;
        8'd10: color_state = color_15;
        8'd11: color_state = color_14;
        8'd12: color_state = color_13;
        8'd13: color_state = color_12;
        8'd14: color_state = color_11;
        8'd15: color_state = color_10;
        8'd16: color_state = color_9;
        8'd17: color_state = color_8;
        8'd18: color_state = color_7;
        8'd19: color_state = color_6;
        8'd20: color_state = color_5;
        8'd21: color_state = color_4;
        8'd22: color_state = color_3;
        8'd23: color_state = color_2;
        8'd24: color_state = color_1;
        8'd25: color_state = {8'd84,8'd56,8'd71};
      endcase
      end
		
       else  if(state_2 )
      begin
      if((v_line == position_2_v + head_width - 1 || v_line == position_2_v + head_width - 2)&&(h_line +2<= position_2_h)&&(h_line + pipe_width >= position_2_h +2))
        color_state = {8'd85,8'd128,8'd34};
      else
      case(check_color_3)
        8'd0: color_state = {8'd85,8'd56,8'd71};
        8'd1: color_state = color_21;
        8'd2: color_state = color_21;
        8'd3: color_state = color_21;
        8'd4: color_state = color_21;
        8'd5: color_state = color_20;
        8'd6: color_state = color_19;
        8'd7: color_state = color_18;
        8'd8: color_state = color_17;
        8'd9: color_state = color_16;
        8'd10: color_state = color_15;
        8'd11: color_state = color_14;
        8'd12: color_state = color_13;
        8'd13: color_state = color_12;
        8'd14: color_state = color_11;
        8'd15: color_state = color_10;
        8'd16: color_state = color_9;
        8'd17: color_state = color_8;
        8'd18: color_state = color_7;
        8'd19: color_state = color_6;
        8'd20: color_state = color_5;
        8'd21: color_state = color_4;
        8'd22: color_state = color_3;
        8'd23: color_state = color_2;
        8'd24: color_state = color_1;
        8'd25: color_state = {8'd84,8'd56,8'd71};
      endcase
      end 
		
		    else  if(state_4 )
      begin
      if((v_line == position_2_v - head_width -gap_width + 1|| v_line == position_2_v - head_width -gap_width + 2)&&(h_line +2<= position_2_h)&&(h_line +pipe_width >= position_2_h +2))
        color_state = {8'd85,8'd128,8'd34};
      else
      case(check_color_3)
        8'd0: color_state = {8'd85,8'd56,8'd71};
        8'd1: color_state = color_21;
        8'd2: color_state = color_21;
        8'd3: color_state = color_21;
        8'd4: color_state = color_21;
        8'd5: color_state = color_20;
        8'd6: color_state = color_19;
        8'd7: color_state = color_18;
        8'd8: color_state = color_17;
        8'd9: color_state = color_16;
        8'd10: color_state = color_15;
        8'd11: color_state = color_14;
        8'd12: color_state = color_13;
        8'd13: color_state = color_12;
        8'd14: color_state = color_11;
        8'd15: color_state = color_10;
        8'd16: color_state = color_9;
        8'd17: color_state = color_8;
        8'd18: color_state = color_7;
        8'd19: color_state = color_6;
        8'd20: color_state = color_5;
        8'd21: color_state = color_4;
        8'd22: color_state = color_3;
        8'd23: color_state = color_2;
        8'd24: color_state = color_1;
        8'd25: color_state = {8'd84,8'd56,8'd71};
      endcase
      end 
		
		
       else if(state_5 )
      begin
      if((v_line == position_1_v + head_width + 1 || v_line == position_1_v + head_width + 2)&&(h_line +2 + pipe_retract<= position_1_h )&&(h_line + pipe_width >= position_1_h  +pipe_retract +2))
        color_state = {8'd85,8'd128,8'd34};
      else
      case(check_color_2)
        8'd0: color_state = {8'd85,8'd56,8'd71};
        8'd1: color_state = color_18;
        8'd2: color_state = color_17;
        8'd3: color_state = color_16;
        8'd4: color_state = color_15;
        8'd5: color_state = color_14;
        8'd6: color_state = color_13;
        8'd7: color_state = color_12;
        8'd8: color_state = color_11;
        8'd9: color_state = color_10;
        8'd10: color_state = color_9;
        8'd11: color_state = color_8;
        8'd12: color_state = color_7;
        8'd13: color_state = color_6;
        8'd14: color_state = color_5;
        8'd15: color_state = color_4;
        8'd16: color_state = color_5;
        8'd17: color_state = color_6;
        8'd18: color_state = color_7;
        8'd19: color_state = color_8;
        8'd20: color_state = color_9;
        8'd21: color_state = color_10;
        8'd22: color_state = color_11;
        8'd23: color_state = {8'd85,8'd56,8'd71};
      endcase
      end 

 else if(state_7 )
      begin
      if((v_line == position_1_v - head_width -gap_width - 1 || v_line == position_1_v - head_width -gap_width - 2)&&(h_line +2+ pipe_retract<= position_1_h )&&(h_line +pipe_width >= position_1_h  +pipe_retract +2))
        color_state = {8'd85,8'd128,8'd34};
      else
      case(check_color_2)
        8'd0: color_state = {8'd85,8'd56,8'd71};
        8'd1: color_state = color_18;
        8'd2: color_state = color_17;
        8'd3: color_state = color_16;
        8'd4: color_state = color_15;
        8'd5: color_state = color_14;
        8'd6: color_state = color_13;
        8'd7: color_state = color_12;
        8'd8: color_state = color_11;
        8'd9: color_state = color_10;
        8'd10: color_state = color_9;
        8'd11: color_state = color_8;
        8'd12: color_state = color_7;
        8'd13: color_state = color_6;
        8'd14: color_state = color_5;
        8'd15: color_state = color_4;
        8'd16: color_state = color_5;
        8'd17: color_state = color_6;
        8'd18: color_state = color_7;
        8'd19: color_state = color_8;
        8'd20: color_state = color_9;
        8'd21: color_state = color_10;
        8'd22: color_state = color_11;
        8'd23: color_state = {8'd85,8'd56,8'd71};
      endcase
      end 


		
     else if(state_6 )
      begin
      if((v_line == position_2_v + head_width + 1|| v_line == position_2_v + head_width + 2)&&(h_line + pipe_retract +2 <= position_2_h )&&(h_line +pipe_width>= position_2_h  +pipe_retract +2))
        color_state = {8'd85,8'd128,8'd34};
      else
      case(check_color_4)
        8'd0: color_state = {8'd85,8'd56,8'd71};
        8'd1: color_state = color_18;
        8'd2: color_state = color_17;
        8'd3: color_state = color_16;
        8'd4: color_state = color_15;
        8'd5: color_state = color_14;
        8'd6: color_state = color_13;
        8'd7: color_state = color_12;
        8'd8: color_state = color_11;
        8'd9: color_state = color_10;
        8'd10: color_state = color_9;
        8'd11: color_state = color_8;
        8'd12: color_state = color_7;
        8'd13: color_state = color_6;
        8'd14: color_state = color_5;
        8'd15: color_state = color_4;
        8'd16: color_state = color_5;
        8'd17: color_state = color_6;
        8'd18: color_state = color_7;
        8'd19: color_state = color_8;
        8'd20: color_state = color_9;
        8'd21: color_state = color_10;
        8'd22: color_state = color_11;
        8'd23: color_state = {8'd85,8'd56,8'd71};
      endcase
      end   
		
		
     else if(state_8 )
      begin
      if((v_line == position_2_v - head_width -gap_width - 1 || v_line == position_2_v - head_width -gap_width - 2)&&(h_line +pipe_retract +2<= position_2_h )&&(h_line +pipe_width>= position_2_h  +pipe_retract +2))
        color_state = {8'd85,8'd128,8'd34};
      else
      case(check_color_4)
        8'd0: color_state = {8'd85,8'd56,8'd71};
        8'd1: color_state = color_18;
        8'd2: color_state = color_17;
        8'd3: color_state = color_16;
        8'd4: color_state = color_15;
        8'd5: color_state = color_14;
        8'd6: color_state = color_13;
        8'd7: color_state = color_12;
        8'd8: color_state = color_11;
        8'd9: color_state = color_10;
        8'd10: color_state = color_9;
        8'd11: color_state = color_8;
        8'd12: color_state = color_7;
        8'd13: color_state = color_6;
        8'd14: color_state = color_5;
        8'd15: color_state = color_4;
        8'd16: color_state = color_5;
        8'd17: color_state = color_6;
        8'd18: color_state = color_7;
        8'd19: color_state = color_8;
        8'd20: color_state = color_9;
        8'd21: color_state = color_10;
        8'd22: color_state = color_11;
        8'd23: color_state = {8'd85,8'd56,8'd71};
      endcase
      end 
		
		
end
  


  
   always @(posedge clk or negedge rst_n)
  if(!rst_n)
  begin
    valid_out <= 0 ;
    color_out <= 24'b0 ;
  end
  else
    if(!test_valid )
      begin
        valid_out <= 0 ;
        color_out <=24'b0 ;
      end
	 
     else 
	  if(black_valid)
        begin
          valid_out <= 1 ;
          color_out <= {8'd84,8'd56,8'd71};
        end
		 
      else
        if(stripe_valid)
          begin
          valid_out <= 1 ;
          if(stripe_color_mux)
          //color_out <= {8'd121,8'd65,8'd35};
			 color_out <= {8'd141,8'd229,8'd72};
          else
          //color_out <= {8'd2,8'd125,8'd25};
			 color_out <= {8'd98,8'd182,8'd35};
          end
       else
	  	      begin 
            valid_out <= 1 ;  
            color_out <= color_state;
            end
			 

      
    
endmodule
  
  
  
      
                  


