module card_dealer_tb;

    // Testbench signals
    logic clk;
    logic reset;
    logic draw_card;
    logic [8:0] rom_address;
    logic [3:0] card_value;
    logic card_valid;

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Instantiate DUT (Device Under Test)
    card_dealer dut (
        .clk(clk),
        .reset(reset),
        .draw_card(draw_card),
        .rom_address(rom_address),
        .card_value(card_value),
        .card_valid(card_valid)
    );

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        draw_card = 0;

        // Wait 2 clock cycles then release reset
        #12;
        reset = 0;

        // Draw 5 cards, 1 every 2 clock cycles
        repeat (5) begin
            @(negedge clk);
            draw_card = 1;
            @(negedge clk);
            draw_card = 0;
            @(negedge clk);
        end

        // Finish simulation
        #10;
        $finish;
    end

    // Monitor output
    initial begin
        $display("Time\tReset\tDraw\tAddr\tCard\tValid");
        $monitor("%0t\t%b\t%b\t%3d\t%2d\t%b",
                 $time, reset, draw_card, rom_address, card_value, card_valid);
    end

endmodule
