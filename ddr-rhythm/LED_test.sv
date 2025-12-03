//module LED_matrix(clk, RST, redRow, redCol, GrnPixels, goal, near, miss);
//	input logic               clk, RST;
//   output logic [15:0][15:0] GrnPixels; // 16x16 array of green LEDs
//	output logic [15:0] redRow;
//	output logic [15:0] redCol;
//	output logic [3:0] goal;
//	output logic [3:0] near;
//	output logic [3:0] miss;
//   
//	logic [3:0] actRow [3:0];
//	logic [15:0] actCol [3:0];
//
//	always_ff @(posedge clk) begin
//        if (RST) begin
//            redRow <= '0;
//				redCol <= '0;
//            GrnPixels <= '0;
//				actRow <= '0;
//				actCol <= '0;
//				goal <= '0;
//				near <= '0;
//				miss <= '0;
//		  end else
//		      ps <= ns;
//    end
//	 	 
//	 
//
//endmodule


//module LED_matrix_testbench();
//
//	logic RST;
//	logic [15:0][15:0] RedPixels, GrnPixels;
//	
//	LED_matrix dut (.RST, .RedPixels, .GrnPixels);
//	
//	initial begin
//	RST = 1'b1; #10;
//	RST = 1'b0; #10;
//	end
//	
//endmodule