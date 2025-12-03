// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
    assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal	 
//	 assign SYSTEM_CLOCK = CLOCK_50;
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */

	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic reset;                   // reset - toggle this on startup
	 assign GrnPixels[1:0] = '0;
	 assign GrnPixels[3:2] = '1;
	 assign GrnPixels[15:4] = '0;
	 assign reset = SW[9];
	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST(reset), .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);

	 logic sig1, sig2, sig3, sig4;
	 logic r1, r2, r3, r4;
	 logic KEY1, KEY2, KEY3, KEY4;
	 logic [9:0] speed;
	 logic en;
	 assign speed[8:0] = ~SW[8:0];
	 assign speed [9] = 1'b1;
	 logic [9:0] A, B1, B2, B3, B4;
	 assign A = 256;
	 logic [19:0] score;
	 logic [3:0] ones, tens, huns, thous, tenThous, hunThous; 
	 enable e (.clk(SYSTEM_CLOCK), .reset, .speed, .en);
	 lfsr b1 (.clk(SYSTEM_CLOCK), .reset, .out(B1), .start(0), .en);
	 lfsr b2 (.clk(SYSTEM_CLOCK), .reset, .out(B2), .start(250), .en);	 
	 lfsr b3 (.clk(SYSTEM_CLOCK), .reset, .out(B3), .start(500), .en);	 
	 lfsr b4 (.clk(SYSTEM_CLOCK), .reset, .out(B4), .start(750), .en);	 
	 comparator c1 (.A, .B(B1), .out(r1));	 
	 comparator c2 (.A, .B(B2), .out(r2));	 
	 comparator c3 (.A, .B(B3), .out(r3));	 
	 comparator c4 (.A, .B(B4), .out(r4));	 
	 metastability key1 (.clk(SYSTEM_CLOCK), .reset, .KEY(~KEY[3]), .KEY_out(KEY1));	
	 metastability key2 (.clk(SYSTEM_CLOCK), .reset, .KEY(~KEY[2]), .KEY_out(KEY2));
	 metastability key3 (.clk(SYSTEM_CLOCK), .reset, .KEY(~KEY[1]), .KEY_out(KEY3));
	 metastability key4 (.clk(SYSTEM_CLOCK), .reset, .KEY(~KEY[0]), .KEY_out(KEY4));	
	 userInput i1 (.clk(SYSTEM_CLOCK), .reset, .KEY(KEY1), .sig(sig1));
	 userInput i2 (.clk(SYSTEM_CLOCK), .reset, .KEY(KEY2), .sig(sig2));
	 userInput i3 (.clk(SYSTEM_CLOCK), .reset, .KEY(KEY3), .sig(sig3));
	 userInput i4 (.clk(SYSTEM_CLOCK), .reset, .KEY(KEY4), .sig(sig4));
	 
	 LEDMatrix matrix (.clk(SYSTEM_CLOCK), .reset, .r1, .r2, .r3, .r4, .sig1, .sig2, .sig3, .sig4, .RedPixels, .score, .speed, .en);
    counter c (.clk(SYSTEM_CLOCK), .reset, .ones, .tens, .huns, .thous, .tenThous, .hunThous, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .score);
endmodule

module DE1_SoC_testbench();
		logic 		CLOCK_50;
		logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
		logic [9:0] LEDR;
		logic [3:0] KEY;
		logic [9:0] SW;
		logic [35:0] GPIO_1;

		DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .GPIO_1);

		// Set up a simulated clock.
		parameter CLOCK_PERIOD=100;
		initial begin
			CLOCK_50 <= 0;
			forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
		end

		// Test the design.
		initial begin
										 @(posedge CLOCK_50);
			SW[9] <= 1;           @(posedge CLOCK_50);
			SW[9] <= 0;           @(posedge CLOCK_50);
			SW[8:0] = 0;				 @(posedge CLOCK_50);
	                  repeat(1000) @(posedge CLOCK_50);
			KEY[0] <= 0; repeat(1000) @(posedge CLOCK_50);
			KEY[0] <= 0; repeat(1000) @(posedge CLOCK_50);			
			KEY[0] <= 0; repeat(1000) @(posedge CLOCK_50);			
			KEY[0] <= 0; repeat(1000) @(posedge CLOCK_50);						
			KEY[1] <= 0; repeat(1000) @(posedge CLOCK_50);			
			KEY[1] <= 0; repeat(1000)  @(posedge CLOCK_50);
			KEY[1] <= 0; repeat(1000) @(posedge CLOCK_50);
			KEY[1] <= 0; repeat(1000)  @(posedge CLOCK_50);					
			KEY[2] <= 0;  repeat(1000)        @(posedge CLOCK_50);
			KEY[2] <= 0;  repeat(1000)        @(posedge CLOCK_50);
			KEY[2] <= 0;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[2] <= 0;  repeat(1000)        @(posedge CLOCK_50);					
			KEY[3] <= 0;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[3] <= 0;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[3] <= 0;  repeat(1000)        @(posedge CLOCK_50);
			KEY[3] <= 0;  repeat(1000)        @(posedge CLOCK_50);				
			KEY[0] <= 1;  repeat(1000)        @(posedge CLOCK_50);
			KEY[0] <= 0;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[0] <= 1;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[0] <= 0;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[0] <= 1;  repeat(1000)        @(posedge CLOCK_50);
			KEY[0] <= 0;  repeat(1000)        @(posedge CLOCK_50);												
			KEY[0] <= 0;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[1] <= 1;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[1] <= 0;  repeat(1000)        @(posedge CLOCK_50);
			KEY[1] <= 1;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[1] <= 0;  repeat(1000)        @(posedge CLOCK_50);			
			KEY[1] <= 1;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[1] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1;   repeat(1000)       @(posedge CLOCK_50);														
			KEY[2] <= 0;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[2] <= 1;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[2] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[2] <= 1;    repeat(1000)      @(posedge CLOCK_50);			
			KEY[2] <= 0;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[2] <= 1;    repeat(1000)      @(posedge CLOCK_50);			
			KEY[2] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[2] <= 1;    repeat(1000)      @(posedge CLOCK_50);													
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[3] <= 1;    repeat(1000)      @(posedge CLOCK_50);							
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[0] <= 0; KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[0] <= 1; KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);
			KEY[0] <= 0; KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[0] <= 1; KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);
			KEY[0] <= 0; KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[0] <= 1; KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);
			KEY[0] <= 0; KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1;   repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1;   repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1;   repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1; KEY[0] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0; KEY[0] <= 0;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1; KEY[0] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0; KEY[0] <= 0;  repeat(1000)       @(posedge CLOCK_50);	
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1; KEY[0] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0; KEY[0] <= 0;  repeat(1000)       @(posedge CLOCK_50);	
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1; KEY[0] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0; KEY[0] <= 0;  repeat(1000)       @(posedge CLOCK_50);	
			KEY[1] <= 1; KEY[2] <= 1; KEY[3] <= 1; KEY[0] <= 1;  repeat(1000)       @(posedge CLOCK_50);
			KEY[1] <= 0; KEY[2] <= 0; KEY[3] <= 0; KEY[0] <= 0;  repeat(1000)       @(posedge CLOCK_50);				
			KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 1;   repeat(1000)       @(posedge CLOCK_50);			
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);
			KEY[3] <= 1;    repeat(1000)      @(posedge CLOCK_50);							
			KEY[3] <= 0;   repeat(1000)       @(posedge CLOCK_50);				
			SW[8] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[7] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[6] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[5] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[4] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[3] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[2] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[1] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[0] <= 1; repeat(1000) @(posedge CLOCK_50);
			SW[0] <= 0; repeat(1000) @(posedge CLOCK_50);
			SW[1] <= 0; repeat(1000) @(posedge CLOCK_50);
			SW[2] <= 0; repeat(1000) @(posedge CLOCK_50);
			SW[3] <= 0; repeat(1000) @(posedge CLOCK_50);
			SW[4] <= 0; repeat(1000) @(posedge CLOCK_50);
			SW[5] <= 0; repeat(1000) @(posedge CLOCK_50);
			SW[6] <= 0; repeat(1000) @(posedge CLOCK_50);
			SW[7] <= 0; repeat(1000) @(posedge CLOCK_50);
			SW[8] <= 0; repeat(1000) @(posedge CLOCK_50);			

											  repeat(4) @(posedge CLOCK_50);
			$stop; // End the simulation.
		end
endmodule

