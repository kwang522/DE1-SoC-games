module userInput (clk, reset, KEY, sig);
    input logic clk, reset;
    input logic KEY;
    output logic sig;

	 enum { on, off } ps, ns;
    always_ff @(posedge clk) begin
        if (reset)
            ps <= off;
		  else
		      ps <= ns;
    end
	 
    always_comb begin
        case (ps)
            on: begin
                if (KEY) begin
                    ns = on;
						  sig = 0;
                end else begin
                    ns = off;
						  sig = 0;
                end
            end
            off: begin
                if (KEY) begin
                    ns = on;
						  sig = 1;
                end else begin
                    ns = off;
						  sig = 0;
                end
            end

            default: begin 
					ns = off;
					sig = 0;
				end
        endcase
    end

endmodule

module userInput_testbench();
    logic clk, reset;
    logic [1:0] KEY;
    logic sig;


	userInput dut (.clk, .reset, .KEY, .sig);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		KEY <= 0;			  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);							  
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		KEY <= 1;           @(posedge clk);
		KEY <= 0;           @(posedge clk);
								  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 0;           @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		KEY <= 0;           @(posedge clk);
								  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 0;           @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);  
		$stop; // End the simulation.
	end
endmodule