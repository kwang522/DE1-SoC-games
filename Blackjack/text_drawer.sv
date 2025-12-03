module text_drawer (
    input [9:0] x,
    input [8:0] y,
    input [1:0] game_result,
    input natural_blackjack,
    input [2:0] player_bet,
    input game_active,
    output logic [7:0] r,
    output logic [7:0] g,
    output logic [7:0] b
);
    // Text positions
    parameter HIT_X    = 180;
    parameter HIT_Y    = 425;
    parameter STAND_X  = 400;
    parameter STAND_Y  = 425;
    parameter BET_X    = 20;
    parameter BET_Y    = 425;
    parameter LOSE_X   = 220;
    parameter LOSE_Y   = 215;
    parameter WIN_X    = 220;  
    parameter WIN_Y    = 215;
    parameter TIE_X    = 240;
    parameter TIE_Y    = 215; 
    parameter CONTINUE_X = 75;
    parameter CONTINUE_Y = 20;

    always_comb begin
        // Default to black
        {r, g, b} = {8'h00, 8'h00, 8'h00};

        // BET: X00
        if (y >= BET_Y && y < BET_Y + 20) begin
            // 'B'
            if (x >= BET_X && x < BET_X + 15) begin
                if ((x - BET_X < 2) || (y - BET_Y < 3) || (y - BET_Y > 8 && y - BET_Y < 12) ||
                    (y - BET_Y > 17) || (x - BET_X > 13 && ((y - BET_Y < 10) || (y - BET_Y > 10))))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'E'
            if (x >= BET_X + 18 && x < BET_X + 33) begin
                if ((x - BET_X - 18 < 2) || (y - BET_Y < 3) || (y - BET_Y > 17) ||
                    (y - BET_Y > 8 && y - BET_Y < 12))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'T'
            if (x >= BET_X + 36 && x < BET_X + 51) begin
                if ((y - BET_Y < 3) || (x - BET_X - 36 > 6 && x - BET_X - 36 < 10))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // ':'
            if (x >= BET_X + 54 && x < BET_X + 58) begin
                if ((y - BET_Y > 5 && y - BET_Y < 8) || (y - BET_Y > 12 && y - BET_Y < 15))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // First digit (0, 1, 2, 3, 4, or 5 based on bet_digit)
            if (x >= BET_X + 62 && x < BET_X + 72) begin
                case (player_bet)
                    3'd0: // '0'
                        if ((x - BET_X - 62 < 2) || (x - BET_X - 62 > 8) ||
                            (y - BET_Y < 3) || (y - BET_Y > 17))
                            {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
                    3'd1: // '1'
                        if ((x - BET_X - 62 > 6 && x - BET_X - 62 < 10) ||
                            (y - BET_Y < 3 && x - BET_X - 62 > 2 && x - BET_X - 62 < 14) ||
                            (y - BET_Y > 17 && x - BET_X - 62 > 2 && x - BET_X - 62 < 14))
                            {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
                    3'd2: // '2'
                        if ((y - BET_Y < 3) || (y - BET_Y > 17) || (y - BET_Y > 8 && y - BET_Y < 12) ||
                            (x - BET_X - 62 < 2 && y - BET_Y > 10) || (x - BET_X - 62 > 8 && y - BET_Y < 10))
                            {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
                    3'd3: // '3'
                        if ((y - BET_Y < 3) || (y - BET_Y > 17) || (y - BET_Y > 8 && y - BET_Y < 12) ||
                            (x - BET_X - 62 > 8))
                            {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
                    3'd4: // '4'
                        if ((x - BET_X - 62 < 2 && y - BET_Y < 10) || (x - BET_X - 62 > 8) ||
                            (y - BET_Y > 8 && y - BET_Y < 12))
                            {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
                    3'd5: // '5'
                        if ((y - BET_Y < 3) || (y - BET_Y > 17) || (y - BET_Y > 8 && y - BET_Y < 12) ||
                            (x - BET_X - 62 < 2 && y - BET_Y < 10) || (x - BET_X - 62 > 8 && y - BET_Y > 10))
                            {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
                    default: // '0'
                        if ((x - BET_X - 62 < 2) || (x - BET_X - 62 > 8) ||
                            (y - BET_Y < 3) || (y - BET_Y > 17))
                            {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
                endcase
            end
            // '0' (first)
            if (x >= BET_X + 76 && x < BET_X + 91) begin
                if ((x - BET_X - 76 < 2) || (x - BET_X - 76 > 13) ||
                    (y - BET_Y < 3) || (y - BET_Y > 17))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // '0' (second)
            if (x >= BET_X + 94 && x < BET_X + 109) begin
                if ((x - BET_X - 94 < 2) || (x - BET_X - 94 > 13) ||
                    (y - BET_Y < 3) || (y - BET_Y > 17))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
        end

        // HIT (KEY0)
        if (y >= HIT_Y && y < HIT_Y + 20) begin
            // 'H'
            if (x >= HIT_X && x < HIT_X + 15) begin
                if ((x - HIT_X < 2) || (x - HIT_X > 13) || 
                    (y - HIT_Y > 8 && y - HIT_Y < 12))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'I'
            if (x >= HIT_X + 20 && x < HIT_X + 30) begin
                if ((x - HIT_X - 20 > 6 && x - HIT_X - 20 < 10) ||
                    (y - HIT_Y < 3 && x - HIT_X - 20 > 2 && x - HIT_X - 20 < 14) ||
                    (y - HIT_Y > 17 && x - HIT_X - 20 > 2 && x - HIT_X - 20 < 14))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'T'
            if (x >= HIT_X + 35 && x < HIT_X + 50) begin
                if ((y - HIT_Y < 3) || 
                    (x - HIT_X - 35 > 6 && x - HIT_X - 35 < 10))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // '('
            if (x >= HIT_X + 60 && x < HIT_X + 65) begin
                if ((x - HIT_X - 60 < 2 && (y - HIT_Y > 2 && y - HIT_Y < 17)) ||
                    (y - HIT_Y < 3 && x - HIT_X - 60 > 0 && x - HIT_X - 60 < 4) ||
                    (y - HIT_Y > 16 && x - HIT_X - 60 > 0 && x - HIT_X - 60 < 4))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'K'
            if (x >= HIT_X + 70 && x < HIT_X + 85) begin
                if ((x - HIT_X - 70 < 2) ||
                    ((x - HIT_X - 70 + y - HIT_Y == 10) && (y - HIT_Y < 10)) ||
                    ((x - HIT_X - 70 - y + HIT_Y == -8) && (y - HIT_Y > 8)))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'E'
            if (x >= HIT_X + 90 && x < HIT_X + 105) begin
                if ((x - HIT_X - 90 < 2) || (y - HIT_Y < 3) || (y - HIT_Y > 17) ||
                    (y - HIT_Y > 8 && y - HIT_Y < 12))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'Y'
            if (x >= HIT_X + 110 && x < HIT_X + 125) begin
                if (((x - HIT_X - 110 == y - HIT_Y) && (y - HIT_Y < 10)) ||
                    ((x - HIT_X - 110 == 14 - (y - HIT_Y)) && (y - HIT_Y < 10)) ||
                    ((x - HIT_X - 110 > 6 && x - HIT_X - 110 < 10) && (y - HIT_Y > 8)))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // '0'
            if (x >= HIT_X + 130 && x < HIT_X + 145) begin
                if ((x - HIT_X - 130 < 2) || (x - HIT_X - 130 > 13) ||
                    (y - HIT_Y < 3) || (y - HIT_Y > 17))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // ')'
            if (x >= HIT_X + 150 && x < HIT_X + 155) begin
                if ((x - HIT_X - 150 > 2 && (y - HIT_Y > 2 && y - HIT_Y < 17)) ||
                    (y - HIT_Y < 3 && x - HIT_X - 150 > 0 && x - HIT_X - 150 < 4) ||
                    (y - HIT_Y > 16 && x - HIT_X - 150 > 0 && x - HIT_X - 150 < 4))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
        end

        // STAND (KEY1)
        if (y >= STAND_Y && y < STAND_Y + 20) begin
            // 'S'
            if (x >= STAND_X && x < STAND_X + 15) begin
                if ((y - STAND_Y < 3) || 
                    (y - STAND_Y > 8 && y - STAND_Y < 12) || 
                    (y - STAND_Y > 17) ||
                    (x - STAND_X < 2 && y - STAND_Y < 10) ||
                    (x - STAND_X > 13 && y - STAND_Y > 10))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'T'
            if (x >= STAND_X + 20 && x < STAND_X + 35) begin
                if ((y - STAND_Y < 3) || 
                    (x - STAND_X - 20 > 6 && x - STAND_X - 20 < 10))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'A'
            if (x >= STAND_X + 40 && x < STAND_X + 55) begin
                if ((x - STAND_X - 40 < 2) || (x - STAND_X - 40 > 13) ||
                    (y - STAND_Y < 3) || 
                    (y - STAND_Y > 8 && y - STAND_Y < 12))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'N'
            if (x >= STAND_X + 60 && x < STAND_X + 75) begin
                if ((x - STAND_X - 60 < 2) || (x - STAND_X - 60 > 13) ||
                    (x - STAND_X - 60 == y - STAND_Y + 2))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'D'
            if (x >= STAND_X + 80 && x < STAND_X + 95) begin
                if ((x - STAND_X - 80 < 2) || 
                    (y - STAND_Y < 3) || (y - STAND_Y > 17) ||
                    (x - STAND_X - 80 > 10 && y - STAND_Y > 3 && y - STAND_Y < 17))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // '('
            if (x >= STAND_X + 105 && x < STAND_X + 110) begin
                if ((x - STAND_X - 105 < 2 && (y - STAND_Y > 2 && y - STAND_Y < 17)) ||
                    (y - STAND_Y < 3 && x - STAND_X - 105 > 0 && x - STAND_X - 105 < 4) ||
                    (y - STAND_Y > 16 && x - STAND_X - 105 > 0 && x - STAND_X - 105 < 4))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'K'
            if (x >= STAND_X + 115 && x < STAND_X + 130) begin
                if ((x - STAND_X - 115 < 2) ||
                    ((x - STAND_X - 115 + y - STAND_Y == 10) && (y - STAND_Y < 10)) ||
                    ((x - STAND_X - 115 - y + STAND_Y == -8) && (y - STAND_Y > 8)))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'E'
            if (x >= STAND_X + 135 && x < STAND_X + 150) begin
                if ((x - STAND_X - 135 < 2) || (y - STAND_Y < 3) || (y - STAND_Y > 17) ||
                    (y - STAND_Y > 8 && y - STAND_Y < 12))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'Y'
            if (x >= STAND_X + 155 && x < STAND_X + 170) begin
                if (((x - STAND_X - 155 == y - STAND_Y) && (y - STAND_Y < 10)) ||
                    ((x - STAND_X - 155 == 14 - (y - STAND_Y)) && (y - STAND_Y < 10)) ||
                    ((x - STAND_X - 155 > 6 && x - STAND_X - 155 < 10) && (y - STAND_Y > 8)))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // '1'
            if (x >= STAND_X + 175 && x < STAND_X + 185) begin
                if ((x - STAND_X - 175 > 6 && x - STAND_X - 175 < 10) ||
                    (y - STAND_Y < 3 && x - STAND_X - 175 > 2 && x - STAND_X - 175 < 14) ||
                    (y - STAND_Y > 17 && x - STAND_X - 175 > 2 && x - STAND_X - 175 < 14))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // ')'
            if (x >= STAND_X + 190 && x < STAND_X + 195) begin
                if ((x - STAND_X - 190 > 2 && (y - STAND_Y > 2 && y - STAND_Y < 17)) ||
                    (y - STAND_Y < 3 && x - STAND_X - 190 > 0 && x - STAND_X - 190 < 4) ||
                    (y - STAND_Y > 16 && x - STAND_X - 190 > 0 && x - STAND_X - 190 < 4))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
        end

        // YOU WIN (green, centered)
        if ((game_result == 2'b01) && y >= WIN_Y && y < WIN_Y + 40) begin
            // 'Y'
            if (x >= WIN_X && x < WIN_X + 30) begin
                if ((x - WIN_X < 2 && y - WIN_Y < 20) || 
                    (x - WIN_X > 28 && y - WIN_Y < 20) || 
                    (x - WIN_X > 13 && x - WIN_X < 17 && y - WIN_Y > 18))
                    {r, g, b} = {8'h00, 8'hFF, 8'h00};
            end
            // 'O'
            if (x >= WIN_X + 35 && x < WIN_X + 65) begin
                if ((x - WIN_X - 35 < 2) || (x - WIN_X - 35 > 28) ||
                    (y - WIN_Y < 2) || (y - WIN_Y > 38))
                    {r, g, b} = {8'h00, 8'hFF, 8'h00};
            end
            // 'U'
            if (x >= WIN_X + 70 && x < WIN_X + 100) begin
                if ((x - WIN_X - 70 < 2) || (x - WIN_X - 70 > 28) ||
                    (y - WIN_Y > 38))
                    {r, g, b} = {8'h00, 8'hFF, 8'h00};
            end
            // 'W'
            if (x >= WIN_X + 110 && x < WIN_X + 140) begin
                if ((x - WIN_X - 110 < 2) || 
                    (x - WIN_X - 110 > 26) || 
                    (y - WIN_Y == 39 - (x - WIN_X - 110) && x - WIN_X - 110 < 14) || 
                    (y - WIN_Y == (x - WIN_X - 110) + 13 && x - WIN_X - 110 >= 14))
                    {r, g, b} = {8'h00, 8'hFF, 8'h00};
            end
            // 'I'
            if (x >= WIN_X + 145 && x < WIN_X + 160) begin
                if ((x - WIN_X - 145 > 6 && x - WIN_X - 145 < 10) ||
                    (y - WIN_Y < 2) || (y - WIN_Y > 38))
                    {r, g, b} = {8'h00, 8'hFF, 8'h00};
            end
            // 'N'
            if (x >= WIN_X + 165 && x < WIN_X + 195) begin
                if ((x - WIN_X - 165 < 2) || (x - WIN_X - 165 > 28) ||
                    (x - WIN_X - 165 == y - WIN_Y))
                    {r, g, b} = {8'h00, 8'hFF, 8'h00};
            end
        end
        else if (game_result == 2'b10 && y >= LOSE_Y && y < LOSE_Y + 40) begin
            // 'Y'
            if (x >= LOSE_X && x < LOSE_X + 30) begin
                if ((x - LOSE_X < 2 && y - LOSE_Y < 20) || 
                    (x - LOSE_X > 28 && y - LOSE_Y < 20) || 
                    (x - LOSE_X > 13 && x - LOSE_X < 17 && y - LOSE_Y > 18))
                    {r, g, b} = {8'hFF, 8'h00, 8'h00};
            end
            // 'O'
            if (x >= LOSE_X + 35 && x < LOSE_X + 65) begin
                if ((x - LOSE_X - 35 < 2) || (x - LOSE_X - 35 > 28) ||
                    (y - LOSE_Y < 2) || (y - LOSE_Y > 38))
                    {r, g, b} = {8'hFF, 8'h00, 8'h00};
            end
            // 'U'
            if (x >= LOSE_X + 70 && x < LOSE_X + 100) begin
                if ((x - LOSE_X - 70 < 2) || (x - LOSE_X - 70 > 28) ||
                    (y - LOSE_Y > 38))
                    {r, g, b} = {8'hFF, 8'h00, 8'h00};
            end
            // 'L'
            if (x >= LOSE_X + 110 && x < LOSE_X + 140) begin
                if ((x - LOSE_X - 110 < 2) || (y - LOSE_Y > 38))
                    {r, g, b} = {8'hFF, 8'h00, 8'h00};
            end
            // 'O'
            if (x >= LOSE_X + 145 && x < LOSE_X + 175) begin
                if ((x - LOSE_X - 145 < 2) || (x - LOSE_X - 145 > 28) ||
                    (y - LOSE_Y < 2) || (y - LOSE_Y > 38))
                    {r, g, b} = {8'hFF, 8'h00, 8'h00};
            end
            // 'S'
            if (x >= LOSE_X + 180 && x < LOSE_X + 210) begin
                if ((y - LOSE_Y < 3) || (y - LOSE_Y > 18 && y - LOSE_Y < 22) || (y - LOSE_Y > 36) ||
                    (x - LOSE_X - 180 < 2 && y - LOSE_Y < 20) ||
                    (x - LOSE_X - 180 > 28 && y - LOSE_Y > 20))
                    {r, g, b} = {8'hFF, 8'h00, 8'h00};
            end
            // 'E'
            if (x >= LOSE_X + 215 && x < LOSE_X + 245) begin
                if ((x - LOSE_X - 215 < 2) || (y - LOSE_Y < 2) || (y - LOSE_Y > 38) ||
                    (y - LOSE_Y > 18 && y - LOSE_Y < 22))
                    {r, g, b} = {8'hFF, 8'h00, 8'h00};
            end
        end
        else if (game_result == 2'b11 && y >= TIE_Y && y < TIE_Y + 40) begin
            // 'T'
            if (x >= TIE_X && x < TIE_X + 30) begin
                if (y - TIE_Y < 2 || 
                    (x - TIE_X > 12 && x - TIE_X < 18))
                    {r, g, b} = {8'hFF, 8'hFF, 8'h00};
            end
            // 'I'
            if (x >= TIE_X + 35 && x < TIE_X + 50) begin
                if (x - TIE_X - 35 > 6 && x - TIE_X - 35 < 10)
                    {r, g, b} = {8'hFF, 8'hFF, 8'h00};
            end
            // 'E'
            if (x >= TIE_X + 55 && x < TIE_X + 85) begin
                if (x - TIE_X - 55 < 2 || 
                    y - TIE_Y < 2 || 
                    y - TIE_Y > 38 ||
                    (y - TIE_Y > 17 && y - TIE_Y < 21))
                    {r, g, b} = {8'hFF, 8'hFF, 8'h00};
            end
        end

        // KEY3 TO CONTINUE SIGN (white, top of screen when round ends)
        if ((game_result != 2'b00) && y >= CONTINUE_Y && y < CONTINUE_Y + 20) begin
            // 'K'
            if (x >= CONTINUE_X && x < CONTINUE_X + 15) begin
                if ((x - CONTINUE_X < 2) ||
                    ((x - CONTINUE_X + y - CONTINUE_Y == 10) && (y - CONTINUE_Y < 10)) ||
                    ((x - CONTINUE_X - y + CONTINUE_Y == -8) && (y - CONTINUE_Y > 8)))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'E'
            if (x >= CONTINUE_X + 15 && x < CONTINUE_X + 30) begin
                if ((x - CONTINUE_X - 15 < 2) || (y - CONTINUE_Y < 3) || (y - CONTINUE_Y > 17) ||
                    (y - CONTINUE_Y > 8 && y - CONTINUE_Y < 12))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'Y'
            if (x >= CONTINUE_X + 30 && x < CONTINUE_X + 45) begin
                if (((x - CONTINUE_X - 30 == y - CONTINUE_Y) && (y - CONTINUE_Y < 10)) ||
                    ((x - CONTINUE_X - 30 == 14 - (y - CONTINUE_Y)) && (y - CONTINUE_Y < 10)) ||
                    ((x - CONTINUE_X - 30 > 6 && x - CONTINUE_X - 30 < 10) && (y - CONTINUE_Y > 8)))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // '3'
            if (x >= CONTINUE_X + 45 && x < CONTINUE_X + 60) begin
                if ((y - CONTINUE_Y < 3) || (y - CONTINUE_Y > 17) || (y - CONTINUE_Y > 8 && y - CONTINUE_Y < 12) ||
                    (x - CONTINUE_X - 45 > 8))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // ' '
            // No action, 15-pixel gap
            // 'T'
            if (x >= CONTINUE_X + 75 && x < CONTINUE_X + 90) begin
                if ((y - CONTINUE_Y < 3) || 
                    (x - CONTINUE_X - 75 > 6 && x - CONTINUE_X - 75 < 10))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'O'
            if (x >= CONTINUE_X + 90 && x < CONTINUE_X + 105) begin
                if ((x - CONTINUE_X - 90 < 2) || (x - CONTINUE_X - 90 > 13) ||
                    (y - CONTINUE_Y < 3) || (y - CONTINUE_Y > 17))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // ' '
            // No action, 15-pixel gap
            // 'C'
            if (x >= CONTINUE_X + 117 && x < CONTINUE_X + 132) begin
                if ((x - CONTINUE_X - 117 < 2) || (y - CONTINUE_Y < 3) || (y - CONTINUE_Y > 17))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'O'
            if (x >= CONTINUE_X + 135 && x < CONTINUE_X + 150) begin
                if ((x - CONTINUE_X - 135 < 2) || (x - CONTINUE_X - 135 > 13) ||
                    (y - CONTINUE_Y < 3) || (y - CONTINUE_Y > 17))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'N'
            if (x >= CONTINUE_X + 150 && x < CONTINUE_X + 165) begin
                if ((x - CONTINUE_X - 150 < 2) || (x - CONTINUE_X - 150 > 13) ||
                    (x - CONTINUE_X - 150 == y - CONTINUE_Y + 2))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'T'
            if (x >= CONTINUE_X + 165 && x < CONTINUE_X + 180) begin
                if ((y - CONTINUE_Y < 3) || 
                    (x - CONTINUE_X - 165 > 6 && x - CONTINUE_X - 165 < 10))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'I'
            if (x >= CONTINUE_X + 180 && x < CONTINUE_X + 195) begin
                if ((x - CONTINUE_X - 180 > 6 && x - CONTINUE_X - 180 < 10) ||
                    (y - CONTINUE_Y < 3 && x - CONTINUE_X - 180 > 2 && x - CONTINUE_X - 180 < 14) ||
                    (y - CONTINUE_Y > 17 && x - CONTINUE_X - 180 > 2 && x - CONTINUE_X - 180 < 14))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'N'
            if (x >= CONTINUE_X + 195 && x < CONTINUE_X + 210) begin
                if ((x - CONTINUE_X - 195 < 2) || (x - CONTINUE_X - 195 > 13) ||
                    (x - CONTINUE_X - 195 == y - CONTINUE_Y + 2))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'U'
            if (x >= CONTINUE_X + 210 && x < CONTINUE_X + 225) begin
                if ((x - CONTINUE_X - 210 < 2) || (x - CONTINUE_X - 210 > 13) ||
                    (y - CONTINUE_Y > 17))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
            // 'E'
            if (x >= CONTINUE_X + 225 && x < CONTINUE_X + 240) begin
                if ((x - CONTINUE_X - 225 < 2) || (y - CONTINUE_Y < 3) || (y - CONTINUE_Y > 17) ||
                    (y - CONTINUE_Y > 8 && y - CONTINUE_Y < 12))
                    {r, g, b} = {8'hFF, 8'hFF, 8'hFF};
            end
        end
    end
endmodule
