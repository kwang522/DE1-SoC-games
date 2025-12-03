module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
                CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, 
                VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output logic [9:0] LEDR;
    input  logic [3:0] KEY;
    input  logic [9:0] SW;
    
    input  CLOCK_50;
    output [7:0] VGA_R;
    output [7:0] VGA_G;
    output [7:0] VGA_B;
    output VGA_BLANK_N;
    output VGA_CLK;
    output VGA_HS;
    output VGA_SYNC_N;
    output VGA_VS;

    logic reset;
    logic [9:0] x;
    logic [8:0] y;
    logic [7:0] r, g, b;
    
    // Game state
    logic game_active;
    logic dealer_turn;
    logic [3:0] player_card_count;
    logic [3:0] dealer_card_count;
    logic [3:0] all_card_values [0:21];
    enum logic [3:0] {
        INIT_DEALER,
		  INIT_HOLD,
        INIT_PLAYER1,
        INIT_PLAYER2,
        GAME_ACTIVE,
		  DEALER_HOLD,
        DEALER_TURN,
        GAME_OVER
    } state;
	 
    // Game status
    logic natural_blackjack;
    logic [7:0] player_total;
    logic [7:0] dealer_total;
	 logic [1:0] game_result;

    // Card display
    logic [9:0] all_card_x [0:21];
    logic [8:0] all_card_y [0:21];
    logic all_card_visible [0:21];
    logic [7:0] card_r [0:21];
    logic [7:0] card_g [0:21];
    logic [7:0] card_b [0:21];

	 // Card dealer signals
    logic [8:0] rom_address;
    logic [3:0] card_value;
    logic card_valid;
    logic dealer_draw;
	 logic pending_hit;

    
    // Input handling
    logic key0_clean, key0_last, key1_clean, key1_last, key2_clean, key2_last, key3_clean, key3_last;
    wire hit_pulse = key0_clean & ~key0_last;
    wire stand_pulse = key1_clean & ~key1_last;
    wire globl_reset_pulse = key2_clean & ~key2_last;	 
    wire reset_pulse = key3_clean & ~key3_last;
    
    // Text signals
    logic [7:0] text_r, text_g, text_b;
	 
	 // Money signals
    logic a_eq_zero, a_lsb, res_eq_zero;
    logic load_a, shift_a, inc_result;
	 logic [2:0] player_bet;
	 logic [3:0] player_balance;

    // Video driver
    video_driver #(.WIDTH(640), .HEIGHT(480)) v1 (
        .CLOCK_50, .reset, .x, .y, .r, .g, .b,
        .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
        .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS
    );

    // Debouncing modules
    debounce db_key0 (.clk(CLOCK_50), .reset(1'b0), .noisy(~KEY[0]), .clean(key0_clean));
    debounce db_key1 (.clk(CLOCK_50), .reset(1'b0), .noisy(~KEY[1]), .clean(key1_clean));
	 debounce db_key2 (.clk(CLOCK_50), .reset(1'b0), .noisy(~KEY[2]), .clean(key2_clean));
    debounce db_key3 (.clk(CLOCK_50), .reset(1'b0), .noisy(~KEY[3]), .clean(key3_clean));

    card_dealer dealer (
        .clk(CLOCK_50),
        .reset(globl_reset_pulse),
        .draw_card(init_draw || hit_pulse || dealer_draw),
        .rom_address,
        .card_value,
        .card_valid
    );
		
	 
    // Consolidated game state machine
    always_ff @(posedge CLOCK_50) begin
        key0_last <= key0_clean;
        key1_last <= key1_clean;
        key2_last <= key2_clean;
        key3_last <= key3_clean;

        // Global reset handling
        if (globl_reset_pulse) begin
            state <= INIT_DEALER;
            player_balance <= 4'd5;
            player_card_count <= 0;
            dealer_card_count <= 0;
            game_active <= 1'b0;
            dealer_turn <= 1'b0;
				pending_hit <= 1'b0;
            natural_blackjack = 1'b0;
            game_result <= 2'b00;
            init_draw <= 1'b1;
				for (int i = 0; i < 22; i++) all_card_values[i] <= 4'd0;
        end
        else if (reset_pulse) begin
            state <= INIT_DEALER;
            player_card_count <= 0;
            dealer_card_count <= 0;
            game_active <= 1'b0;
            dealer_turn <= 1'b0;
				pending_hit <= 1'b0;
            natural_blackjack = 1'b0;
            game_result <= 2'b00;
            init_draw <= 1'b1;
				for (int i = 0; i < 22; i++) all_card_values[i] <= 4'd0;
        end
        else begin
            case(state)
                INIT_DEALER: begin
                    if (card_valid) begin
                        all_card_values[0] <= card_value;
                        dealer_card_count <= 1;
                        state <= INIT_HOLD;
                        init_draw <= 1'b1;
                    end
                end
					 INIT_HOLD: begin
								state <= INIT_PLAYER1;
								init_draw <= 1'b0;
					 end
                
                INIT_PLAYER1: begin
                    if (card_valid) begin
                        all_card_values[11] <= card_value;
                        player_card_count <= 1;
                        state <= INIT_PLAYER2;
                        init_draw <= 1'b1;
                    end
                end
                
                INIT_PLAYER2: begin
                    if (card_valid) begin
                        all_card_values[12] <= card_value;
                        player_card_count <= 2;
                        game_active <= 1'b1;
                        state <= GAME_ACTIVE;
                        init_draw <= 1'b0;
                      
                       
                    end
                end
                
                GAME_ACTIVE: begin
                    automatic logic [7:0] p_temp = 0;
                    automatic logic [3:0] p_aces = 0;
						  if ((all_card_values[11] == 1 && all_card_values[12] >= 10) || 
                           (all_card_values[12] == 1 && all_card_values[11] >= 10)) begin
                            natural_blackjack = 1'b1;
                            game_result <= 2'b01;
                            state <= GAME_OVER;
                            player_balance <= player_balance + (2 * player_bet);
                    end
						  // Player hit/stand logic
                    if (stand_pulse && !(p_temp > 21) && !natural_blackjack) begin
                        state <= DEALER_HOLD;
                        game_active <= 1'b0;
                    end
						  else if (hit_pulse && !natural_blackjack && !(p_temp > 21) && player_card_count < 10) begin
							  pending_hit <= 1'b1;
						  end

						  // When card_valid arrives, add the card
						  if (pending_hit && card_valid) begin
							  all_card_values[11 + player_card_count] <= card_value;
							  player_card_count <= player_card_count + 1;
						 	  pending_hit <= 1'b0; // Clear the request
						  end
                    
                    // Bust calculation
                    for (int i = 11; i < 22; i++) begin
                        if (all_card_values[i] == 1) begin
                            p_temp += 11;
                            p_aces += 1;
                        end
                        else if (all_card_values[i] >= 11) p_temp += 10;
                        else p_temp += all_card_values[i];
                    end
                    
                    // Ace adjustment
                    for (int k = 0; k < 11; k++) begin
                        if (p_temp > 21 && p_aces > 0) begin
                            p_temp -= 10;
                            p_aces -= 1;
                        end
                        else break;
                    end
                    
                    player_total <= p_temp;
                    
                    if (p_temp > 21) begin
                        game_result <= 2'b10;
								game_active <= 1'b0;
                        state <= GAME_OVER;
                        player_balance <= player_balance - player_bet;
                    end
                end
                
					 DEALER_HOLD: begin
					 	 state <= DEALER_TURN; 
					 	 dealer_draw <= 1'b1; 
					 end		
					 
                DEALER_TURN: begin
                    automatic logic [7:0] d_temp = 0;
                    automatic logic [3:0] d_aces = 0;
                    if (dealer_draw && card_valid) begin
							  all_card_values[dealer_card_count] <= card_value;
							  dealer_card_count <= dealer_card_count + 1;
							  dealer_draw <= 1'b0; // Clear draw request
						  end
                    // Calculate dealer total
                    for (int i = 0; i < dealer_card_count; i++) begin
                        if (all_card_values[i] == 1) begin
                            d_temp += 11;
                            d_aces += 1;
                        end
                        else if (all_card_values[i] >= 11) d_temp += 10;
                        else d_temp += all_card_values[i];
                    end
                    
                    // Ace adjustment
                    for (int k = 0; k < 11; k++) begin
                        if (d_temp > 21 && d_aces > 0) begin
                            d_temp -= 10;
                            d_aces -= 1;
                        end
                        else break;
                    end
                    dealer_total <= d_temp;
                    
						  if (d_temp < 17) begin
							   state <= DEALER_HOLD; // Add delay between draws
						  end
                    else begin
                        // Final comparison
                        if (d_temp > 21) begin
                            game_result <= 2'b01;
                            player_balance <= player_balance + player_bet;
                        end
                        else if (player_total > d_temp) begin
                            game_result <= 2'b01;
                            player_balance <= player_balance + player_bet;
                        end
                        else if (player_total < d_temp) begin
                            game_result <= 2'b10;
                            player_balance <= player_balance - player_bet;
                        end
                        else begin
                            game_result <= 2'b11;
                        end
                        state <= GAME_OVER;
                    end
                end
                
                GAME_OVER: begin
                    // Maintain state until reset
                end
            endcase
        end

        // 7-segment display logic
        if (player_balance >= 10) begin
            HEX0 = 7'b0101111;  // R
            HEX1 = 7'b0000110;  // E
            HEX2 = 7'b0101011;  // N
            HEX3 = 7'b0101011;  // N
            HEX4 = 7'b1101111;  // I
            HEX5 = 7'b1100011;  // W
        end
        else if (player_balance == 0) begin
            HEX0 = 7'b0101111;  // R
            HEX1 = 7'b0000110;  // E
            HEX2 = 7'b0010010;  // S
            HEX3 = 7'b0100011;  // O
            HEX4 = 7'b1000111;  // L
            HEX5 = 7'b1111111;  // Blank
        end
        else begin
            HEX0 = 7'b1000000;  // 0
            HEX1 = 7'b1000000;  // 0
            case (player_balance[3:0])
                4'h0: HEX2 = 7'b1000000;  // 0
                4'h1: HEX2 = 7'b1111001;  // 1
                4'h2: HEX2 = 7'b0100100;  // 2
                4'h3: HEX2 = 7'b0110000;  // 3
                4'h4: HEX2 = 7'b0011001;  // 4
                4'h5: HEX2 = 7'b0010010;  // 5
                4'h6: HEX2 = 7'b0000010;  // 6
                4'h7: HEX2 = 7'b1111000;  // 7
                4'h8: HEX2 = 7'b0000000;  // 8
                4'h9: HEX2 = 7'b0010000;  // 9
                default: HEX2 = 7'b1111111;
            endcase
            HEX3 = 7'b1111111;  // Blank
            HEX4 = 7'b1111111;  // Blank
            HEX5 = 7'b1111111;  // Blank
        end
    end

    // Card stack manager
    card_stack_manager stack_mgr (
        .player_card_count,
        .dealer_card_count,
        .card_values(all_card_values),
        .card_x(all_card_x),
        .card_y(all_card_y),
        .card_visible(all_card_visible)
    );

    // Card drawers
    genvar i;
    generate
        for (i = 0; i < 22; i++) begin : all_cards
            card_drawer card_inst (
                .x, .y,
                .card_x(all_card_x[i]),
                .card_y(all_card_y[i]),
                .card_value(all_card_visible[i] ? all_card_values[i] : 4'd0),
					 .card_visible(all_card_visible[i]),
                .r_out(card_r[i]),
                .g_out(card_g[i]),
                .b_out(card_b[i])
            );
        end
    endgenerate

    // Output combination
    always_ff @(posedge CLOCK_50) begin
        {r, g, b} <= {text_r, text_g, text_b};
        for (int j = 0; j < 22; j++) begin
            if ({card_r[j], card_g[j], card_b[j]} != 24'h000000)
                {r, g, b} <= {card_r[j], card_g[j], card_b[j]};
        end
        // Override top-left corner (e.g., 60x84 pixel area) to black
        if (x < 60 && y < 84) begin
            {r, g, b} <= {8'h00, 8'h00, 8'h00};
        end
    end
	 
    bit_counter_control bet_ctrl (
        .clk(CLOCK_50),
        .reset(globl_reset_pulse),
        .s(SW[5]),
        .a_eq_zero(a_eq_zero),
        .a_lsb(a_lsb),
        .res_eq_zero(res_eq_zero),
        .load_a(load_a),
        .shift_a(shift_a),
        .inc_result(inc_result),
        .done(done)
    );

    bit_counter_datapath bet_dp (
        .clk(CLOCK_50),
        .reset(globl_reset_pulse),
        .data_in(SW[4:0]),
        .load_a(load_a),
        .shift_a(shift_a),
        .inc_result(inc_result),
        .a_eq_zero(a_eq_zero),
        .a_lsb(a_lsb),
        .res_eq_zero(res_eq_zero),
        .result(player_bet)
    );
	 
	 // Text display
    text_drawer text_display (
        .x, .y,
        .game_result(game_result),
		  .player_bet(player_bet),
        .natural_blackjack(natural_blackjack),
        .r(text_r), .g(text_g), .b(text_b)
    );

endmodule