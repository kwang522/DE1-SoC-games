module LEDBank3(clk, RST, KEY, sig, RedPixels, score, near, miss);
   input logic clk, RST;
	input logic KEY;
	input logic sig;
   output logic [15:0][15:0] RedPixels;
	output logic score, near, miss;
	integer i, j; 
	logic [8:0] count;
	
    always_ff @(posedge clk) begin
        if (RST) begin
            RedPixels <= '0;
            count <= '0;
        end else if (sig) begin
            for (i = 14; i < 16; i = i + 1) begin
                for (j = 4; j < 8; j = j + 1) begin
                    RedPixels[i][j] <= 1'b1;
                end
            end
        end
		  
		  count <= count + 1;
		  
		  if (count == 9'b111111111) begin
				  for (i = 0; i < 14; i = i + 1) begin
						for (j = 4; j < 8; j = j + 1) begin
							RedPixels[i][j] = RedPixels[i+2][j];
						end
				  end
		  
					for (i = 14; i < 16; i = i + 1) begin
						for (j = 4; j < 8; j = j + 1) begin
							RedPixels[i][j] ='0;
						end
				  end
			     count <= '0;
		  end
    end
	
	
	
endmodule
