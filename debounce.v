module de_bounce(
    input clk,       // Use clk from your top module
    input btn_in,    
    output reg pulse 
);
    reg [19:0] count; // ~1ms at 25MHz is 25,000 counts. 20ms is 500,000.
    reg btn_stable;
    reg btn_sync_0, btn_sync_1;
    reg pulse_reg;

    always @(posedge clk) begin
        // 1. Sync to clock to prevent metastability
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;

        // 2. Filter noise (20ms check)
        if (btn_sync_1 != btn_stable) begin
            if (count == 20'd500_000) begin 
                btn_stable <= btn_sync_1;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end else begin
            count <= 0;
        end

        // 3. One-cycle pulse generator
        pulse_reg <= btn_stable;
        pulse <= btn_stable && !pulse_reg;
    end
endmodule