module card_dealer (
    input  logic clk,
    input  logic reset,
    input  logic draw_card,
    output logic [8:0] rom_address,
    output logic [3:0] card_value,
    output logic card_valid
);
    logic [8:0] lfsr_val;

    // Instantiate the LFSR
    lfsr9 lfsr_inst (
        .clk(clk),
        .rst(reset),
        .rnd(lfsr_val)
    );

    deck_ROM rom(
        .address(rom_address),
        .clock(clk),
        .q(card_value)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            rom_address <= 0;
            card_valid <= 0;
        end else if (draw_card) begin
            rom_address <= lfsr_val % 312;
            card_valid <= 1;
        end else begin
            card_valid <= 0;
        end
    end
endmodule
