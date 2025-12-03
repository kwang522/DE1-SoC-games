module card_stack_manager (
    input [3:0] player_card_count,
    input [3:0] dealer_card_count,
    input [3:0] card_values [0:21],
    output logic [9:0] card_x [0:21],
    output logic [8:0] card_y [0:21],
    output logic card_visible [0:21]
);
    
    parameter DEALER_Y = 80;
    parameter PLAYER_Y = 280;
    // INCREASED OFFSETS for better visibility
    parameter DIAG_X_OFFSET = 30;
    parameter DIAG_Y_OFFSET = 18; 
    
    logic [9:0] stack_base_x [0:3] = '{50, 180, 310, 440};
    
    always_comb begin
        // Initialize all cards as hidden
        for (int i = 0; i < 22; i++) begin
            card_visible[i] = 0;
            card_x[i] = 0;
            card_y[i] = 0;
        end
        
        // Dealer cards (indices 0-10) - FIXED: Only show cards with valid values
        for (int i = 0; i < dealer_card_count && i < 11; i++) begin
            if (card_values[i] != 0) begin  // Only show non-zero cards
                automatic int stack = i / 3;
                automatic int pos = i % 3;
                
                card_x[i] = stack_base_x[stack] + (pos * DIAG_X_OFFSET);
                card_y[i] = DEALER_Y + (pos * DIAG_Y_OFFSET);
                card_visible[i] = 1;
            end
        end
        
        // Player cards (indices 11-21) - FIXED: Only show cards with valid values  
        for (int i = 0; i < player_card_count && i < 11; i++) begin
            if (card_values[11 + i] != 0) begin  // Only show non-zero cards
                automatic int stack = i / 3;
                automatic int pos = i % 3;
                
                card_x[11 + i] = stack_base_x[stack] + (pos * DIAG_X_OFFSET);
                card_y[11 + i] = PLAYER_Y + (pos * DIAG_Y_OFFSET);
                card_visible[11 + i] = 1;
            end
        end
    end
endmodule
