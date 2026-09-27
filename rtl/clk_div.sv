// Simple clock divider for I2C SCL timing (teaching example).
// Generates a 1-cycle-wide clk_div_tick pulse every DIVIDER cycles of clk.

`timescale 1ns/1ps

module clk_div #(
    parameter int DIVIDER = 8
) (
    input  wire clk,
    input  wire rst_n,       // Active-low async reset
    output reg  clk_div_tick // One-cycle pulse at divided rate
);
    int count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count        <= 0;
            clk_div_tick <= 1'b0;
        end else begin
            if (count == DIVIDER - 1) begin
                count        <= 0;
                clk_div_tick <= 1'b1;
            end else begin
                count        <= count + 1;
                clk_div_tick <= 1'b0;
            end
        end
    end

endmodule

