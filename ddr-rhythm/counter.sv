module counter (clk, reset, ones, tens, huns, thous, tenThous, hunThous, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, score);
    input logic clk, reset; 
    input logic [19:0] score;
	 output logic [3:0] ones, tens, huns, thous, tenThous, hunThous;
	 output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 
    logic [19:0] temp1, temp2, temp3, temp4, temp5, temp6;

    always_ff @(posedge clk) begin
        if (reset) begin
            temp1 <= 19'd0;
            temp2 <= 19'd0;				
            temp3 <= 19'd0;				
            temp4 <= 19'd0;				
            temp5 <= 19'd0;				
            temp6 <= 19'd0;				
            ones <= 4'd0;
            tens <= 4'd0;
            huns <= 4'd0;
            thous <= 4'd0;
            tenThous <= 4'd0;
            hunThous <= 4'd0;
        end else begin
            temp1 = score;
				temp2 = score / 10;
				temp3 = score / 100;
				temp4 = score / 1000;
				temp5 = score / 10000;
				temp6 = score / 100000;
            
            ones <= temp1 % 10;
            
            tens <= temp2 % 10;
            
            huns <= temp3 % 10;
            
            thous = temp4 % 10;
            
            tenThous = temp5 % 10;
            
            hunThous = temp6 % 10;
        end
    end

    seg7 s71 (.bcd(ones), .leds(HEX0));
    seg7 s72 (.bcd(tens), .leds(HEX1));
    seg7 s73 (.bcd(huns), .leds(HEX2));
    seg7 s74 (.bcd(thous), .leds(HEX3));
    seg7 s75 (.bcd(tenThous), .leds(HEX4));
    seg7 s76 (.bcd(hunThous), .leds(HEX5));
endmodule

module counter_testbench();
   logic clk, reset;
	logic [19:0] score;
	logic [3:0] ones, tens, huns, thous, tenThous, hunThous;
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	counter dut (.clk, .reset, .ones, .tens, .huns, .thous, .tenThous, .hunThous, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .score);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
								  @(posedge clk);							  						  
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
		score <= 0; 		  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);		
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);				
		score <= 13; 		  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		score <= 172; 		  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		score <= 2954; 	  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		score <= 36493; 	  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);								  
		score <= 499494; 	  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		score <= 1047564;   @(posedge clk);		
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);								 								
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		$stop; // End the simulation.
	end
endmodule