module debounce (
    input clk,
    input reset,
    input noisy,
    output logic clean
);
    logic [15:0] count;
    logic new_clean;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            clean <= 0;
        end else if (noisy != clean) begin
            count <= count + 1;
            if (&count) begin
                clean <= noisy;
                count <= 0;
            end
        end else begin
            count <= 0;
        end
    end
endmodule
