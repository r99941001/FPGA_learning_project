module top (
    input logic clk,  //name need to match constraint file
    input logic ck_rst,
    //input logic [7:0] data_in,
    input logic btn0,
    output logic uart_rxd_out
    //output logic busy
);

logic rst;
logic btn_out;
logic [7:0]data_in = 'ha5;

reset_signal rst_signal(
  .clk (clk),
  .ck_rst (ck_rst),
  .rst (rst)
);

button button (
    .clk (clk),
    .btn0 (btn0),
    .btn_out (btn_out)
);

logic btn_ff1;
logic btn_re;


always_ff @( posedge clk ) begin
    btn_ff1 <= btn_out;
    btn_re <= btn_out && !btn_ff1; 
end

//always_comb btn_re = btn_out && !btn_ff1; 


uart_tx #(
    .CLK_FREQ  (100E6), 
    .BAUD_RATE (115200)) 
uartx (
    .clk     (clk),
    .rst     (rst),
    .data_in (data_in),
    .send    (btn_re),
    .tx      (uart_rxd_out),
    .busy    ()
);


endmodule