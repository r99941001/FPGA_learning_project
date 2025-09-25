module uart_tx #(
    parameter DATA_WIDTH = 8,
    parameter CLK_FREQ = 100_000_000,  // 100 MHz clock
    parameter BAUD_RATE = 115200
)(
    input  logic clk,
    input  logic rst,             // Active-low reset
    input  logic [7:0] data_in,
    input  logic send,
    output logic tx,  
    output logic busy             // High when actively sending
);

localparam FRAME_WIDTH = DATA_WIDTH + 3;    // 1 header + payload + 2 footer
localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE; // 868 clk per bit

logic [FRAME_WIDTH-1:0] shift_reg;          // Shift register holds frame bits
logic [$clog2(CLKS_PER_BIT)-1:0] baud_cnt;  // Counter for baud timing
logic [$clog2(FRAME_WIDTH+1)-1:0] bit_cnt;  // Counts how many bits sent


// --------------------------------------------------
// UART line behavior
// --------------------------------------------------
// UART TX idles high (logic '1') when not sending.
// We drive TX from the *LSB* of shift_reg.
assign tx = shift_reg[0];

always_ff @(posedge clk) begin
    if (!rst) begin
        // Reset condition: everything to idle state
        shift_reg <= '1;         //{FRAME_WIDTH{1'b1}};   // Fill with idle '1's
        baud_cnt  <= '0;
        bit_cnt   <= '0;
        busy      <= '0;         // Not transmitting
    end
    else begin
        if (!busy && send) begin
            shift_reg <= {2'b11, data_in, 1'b0};
            baud_cnt  <= '0;
            bit_cnt   <= '0;
            busy      <= '1;                       // Enter busy state
        end
        else if (busy && bit_cnt < DATA_WIDTH+3) begin
            if (baud_cnt < CLKS_PER_BIT+1) begin
                baud_cnt <= baud_cnt +1;
            end
            else begin
                baud_cnt <= '0;
                shift_reg <= {1'b1, shift_reg[10:1]};
                bit_cnt   <= bit_cnt + 1;
            end 
        end
        else if (bit_cnt == DATA_WIDTH+3) begin
            bit_cnt <= '0;
            busy    <= '0;

        end

    end    
end


//always_ff @( clk) begin 
//    if (~rst) begin
        
//    end

    //tx <= 'b0;
    //busy <= 'b0;
//end


endmodule