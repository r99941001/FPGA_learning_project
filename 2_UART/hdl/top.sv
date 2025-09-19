module top (
    input logic clk,  //name need to match constraint file
    input logic ck_rst,
    input logic [7:0] data_in,
    input logic btn0,
    output logic tx,
    output logic busy
);



logic rst;
logic send;


reset_signal rst_signal(
  .clk (clk),
  .ck_rst (ck_rst),
  .rst (rst)
);

button button (
    .clk (clk),
    .btn0 (btn0),
    .send (send)
);


uart_tx #(
    .CLK_FREQ  (100E6), 
    .BAUD_RATE (115200)) 
uartx (
    .clk     (clk),
    .rst     (rst),
    .data_in (data_in),
    .send    (send),
    .tx      (tx),
    .busy    (busy)
);

endmodule