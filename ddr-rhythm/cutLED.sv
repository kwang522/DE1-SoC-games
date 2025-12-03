module cutLED (clk, reset, RedPixels, goal1, goal2, goal3, goal4, upN1, upN2, upN3, upN4, downN1, downN2, downN3, downN4);
    input logic clk, reset;
	 input logic goal1, goal2, goal3, goal4;
	 input logic upN1, upN2, upN3, upN4;
	 input logic downN1, downN2, downN3, downN4;
    output logic [15:0][15:0] RedPixels;
	 
	 integer i, j; 
	 
    always_ff @(posedge clk) begin
        if (reset) begin
            RedPixels <= '0;
        end else if (goal1) begin
            for (i = 2; i < 4; i = i + 1) begin
                for (j = 12; j < 16; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (goal2) begin
            for (i = 2; i < 4; i = i + 1) begin
                for (j = 8; j < 12; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end

        if (reset) begin
            RedPixels <= '0;
        end else if (goal3) begin
            for (i = 2; i < 4; i = i + 1) begin
                for (j = 4; j < 8; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end

        if (reset) begin
            RedPixels <= '0;
        end else if (goal4) begin
            for (i = 2; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (upN1) begin
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 12; j < 16; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (upN2) begin
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 8; j < 12; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (upN3) begin
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 4; j < 8; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (upN4) begin
            for (i = 0; i < 2; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    RedPixels[i][j] <= 1'b1;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (downN1) begin
            for (i = 4; i < 6; i = i + 1) begin
                for (j = 12; j < 16; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (downN2) begin
            for (i = 4; i < 6; i = i + 1) begin
                for (j = 8; j < 12; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (downN3) begin
            for (i = 4; i < 6; i = i + 1) begin
                for (j = 4; j < 8; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
		  
        if (reset) begin
            RedPixels <= '0;
        end else if (downN4) begin
            for (i = 4; i < 6; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    RedPixels[i][j] <= 1'b0;
                end
            end
        end
												  		  
    end
endmodule	 