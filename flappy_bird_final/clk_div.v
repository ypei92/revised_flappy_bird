module clk_div(rst_n,clk,
               clk_25mhz,clk_60hz,clk_2hz,clk_400hz);
    input rst_n,clk;
    output clk_25mhz,clk_60hz,clk_2hz;//,clk_12_5hz;
	 output clk_400hz;
	 reg clk_400hz;
    wire rst_n,clk;
    
    reg [20:0]counter1;
    reg counter2;
	 reg [25:0] counter3;
	 reg [16:0] counter4;
	  
    reg clk_25mhz,clk_60hz,clk_2hz;//,clk_12_5hz;
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
        clk_25mhz<=0;
        clk_60hz<=1;
        clk_2hz<=0;
		  clk_400hz<=0;
		  
		  //clk_12_5hz<=0;
        counter1<=0;
        counter2<=0;
        counter3<=0;
		  counter4<=0;
    end
        else begin
            counter1<=counter1+1;
            counter2<=counter2+1;
            counter3<=counter3+1;
				counter4<=counter4+1;
            if(counter2==1)begin
                  clk_25mhz<=~clk_25mhz; counter2<=0; end
            //if(counter1==499999) begin
				if(counter1==833599) begin 
                  clk_60hz<=~clk_60hz; counter1<=0; end
		      if(counter3==24999999)begin
			         clk_2hz<=~clk_2hz;counter3<=0;end
				if(counter4==124999)begin
			         clk_400hz<=~clk_400hz;counter4<=0;end
              end
          end
      endmodule      
            
            
        

