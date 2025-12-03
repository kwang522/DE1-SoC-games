module card_drawer (
    input [9:0] x,
    input [8:0] y,
    input [9:0] card_x,
    input [8:0] card_y,
    input [3:0] card_value,  // 1=A, 2-10=numbers, 11=J, 12=Q, 13=K
	 input card_visible,  
    output logic [7:0] r_out,
    output logic [7:0] g_out,
    output logic [7:0] b_out
);
    parameter CARD_WIDTH = 60;
    parameter CARD_HEIGHT = 84;
    parameter BORDER_WIDTH = 2;
    
    logic in_card, in_border, in_symbol;
    logic [9:0] symbol_x;
    logic [8:0] symbol_y;
    
    always_comb begin
        // Check if pixel is within card bounds
        in_card = (x >= card_x && x < card_x + CARD_WIDTH && 
                   y >= card_y && y < card_y + CARD_HEIGHT);
        
        // Check if pixel is in border area
        in_border = in_card && ((x - card_x < BORDER_WIDTH) || 
                               (x - card_x >= CARD_WIDTH - BORDER_WIDTH) ||
                               (y - card_y < BORDER_WIDTH) || 
                               (y - card_y >= CARD_HEIGHT - BORDER_WIDTH));
        
        // Symbol position (top-left corner)
        symbol_x = x - card_x - 8;
        symbol_y = y - card_y - 8;
        in_symbol = in_card && (x - card_x >= 8 && x - card_x <= 25) &&
                              (y - card_y >= 8 && y - card_y <= 35);
        
        // Default to black
        {r_out, g_out, b_out} = {8'h00, 8'h00, 8'h00};
        
        // Draw border
        if (in_border) begin
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
        end
        // Draw card symbol/number
        else if (in_symbol) begin
            case(card_value)
                4'd1:  draw_ace();      // A
                4'd2:  draw_number_2();
                4'd3:  draw_number_3();
                4'd4:  draw_number_4();
                4'd5:  draw_number_5();
                4'd6:  draw_number_6();
                4'd7:  draw_number_7();
                4'd8:  draw_number_8();
                4'd9:  draw_number_9();
                4'd10: draw_number_10();
                4'd11: draw_jack();     // J
                4'd12: draw_queen();    // Q
                4'd13: draw_king();     // K
                default: {r_out, g_out, b_out} = {8'h00, 8'h00, 8'h00};
            endcase
        end
    end
    
    // Drawing functions for each card type
    task draw_ace();
        if ((symbol_x < 2) || (symbol_x > 15) ||        // Vertical lines
            (symbol_y < 3) ||                           // Top horizontal
            (symbol_y > 10 && symbol_y < 13))           // Middle horizontal
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
    task draw_number_2();
        if ((symbol_y < 3) ||                           // Top
            (symbol_y > 10 && symbol_y < 13) ||         // Middle
            (symbol_y > 20) ||                          // Bottom
            (symbol_x < 2 && symbol_y > 13) ||          // Left bottom
            (symbol_x > 15 && symbol_y < 10))           // Right top
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
    task draw_number_3();
        if ((symbol_y < 3) ||                           // Top
            (symbol_y > 10 && symbol_y < 13) ||         // Middle
            (symbol_y > 20) ||                          // Bottom
            (symbol_x > 15))                            // Right side
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
 	 task draw_number_4();
		 // Left vertical bar
		 if (symbol_x < 2 && symbol_y < 13) begin
			  {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
		 end
		 // Horizontal bar (middle)
		 else if (symbol_y > 10 && symbol_y < 13) begin
			  {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
		 end
		 // Right vertical bar
		 else if (symbol_x > 15) begin
			  {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
		 end
	 endtask
    
    task draw_number_5();
        if ((symbol_y < 3) ||                           // Top
            (symbol_y > 10 && symbol_y < 13) ||         // Middle
            (symbol_y > 20) ||                          // Bottom
            (symbol_x < 2 && symbol_y < 13) ||          // Left top
            (symbol_x > 15 && symbol_y > 10))           // Right bottom
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
    task draw_number_6();
        if ((symbol_y < 3) ||                           // Top
            (symbol_y > 10 && symbol_y < 13) ||         // Middle
            (symbol_y > 20) ||                          // Bottom
            (symbol_x < 2) ||                           // Left
            (symbol_x > 15 && symbol_y > 10))           // Right bottom
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
    task draw_number_7();
        if ((symbol_y < 3) ||                           // Top
            (symbol_x > 15))                            // Right
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
    task draw_number_8();
        if ((symbol_y < 3) ||                           // Top
            (symbol_y > 10 && symbol_y < 13) ||         // Middle
            (symbol_y > 20) ||                          // Bottom
            (symbol_x < 2) ||                           // Left
            (symbol_x > 15))                            // Right
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
    task draw_number_9();
        if ((symbol_y < 3) ||                           // Top
            (symbol_y > 10 && symbol_y < 13) ||         // Middle
            (symbol_y > 20) ||                          // Bottom
            (symbol_x < 2 && symbol_y < 13) ||          // Left top
            (symbol_x > 15))                            // Right
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
	 task draw_number_10();
		 // "1" vertical, shifted left
		 if ((symbol_x >= 3 && symbol_x <= 6)) begin
			  {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
		 end
		 // "0" left vertical, shifted left
		 else if ((symbol_x >= 9 && symbol_x <= 10)) begin
			  {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
		 end
		 // "0" right vertical
		 else if ((symbol_x >= 15 && symbol_x <= 16)) begin
			  {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
		 end
		 // "0" top
		 else if ((symbol_y < 3 && symbol_x >= 9 && symbol_x <= 16)) begin
			  {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
		 end
		 // "0" bottom
		 else if ((symbol_y > 20 && symbol_x >= 9 && symbol_x <= 16)) begin
			  {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
		 end
	 endtask
		 
    task draw_jack();
        // Draw "J"
        if ((symbol_y > 20) ||                          // Bottom
            (symbol_x > 15) ||                          // Right
            (symbol_x < 2 && symbol_y > 15))            // Left bottom
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
    task draw_queen();
        // Draw "Q" - simplified
        if ((symbol_y < 3) ||                           // Top
            (symbol_y > 20) ||                          // Bottom
            (symbol_x < 2) ||                           // Left
            (symbol_x > 15) ||                          // Right
            (symbol_x == symbol_y && symbol_x > 10))    // Diagonal
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
    task draw_king();
        // Draw "K"
        if ((symbol_x < 2) ||                           // Left
            (symbol_x + symbol_y == 15 && symbol_y < 12) || // Upper diagonal
            (symbol_x - symbol_y == -5 && symbol_y > 11))   // Lower diagonal
            {r_out, g_out, b_out} = {8'hFF, 8'hFF, 8'hFF};
    endtask
    
endmodule
