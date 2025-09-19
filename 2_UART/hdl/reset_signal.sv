module reset_signal(
    input logic clk,
    input logic ck_rst,
    output logic rst
);

logic rst_ff1;
logic rst_ff2;

always_ff @ (posedge clk)
begin
    rst_ff1 <= ck_rst;
    rst_ff2 <= rst_ff1;
    rst <= rst_ff2; 
end
endmodule
