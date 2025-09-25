`timescale 1ns/1ps
//compter default each cycle is 1ns.
//noted that if we use 1ps/1fs, then each #1 will be 1ps.
//for 100MB, it will use finder resolution to run ismulation => longer time. 
module uart_tx_tb;



initial begin
    ck_rst = 0; //begin sumualtion with rest.
    btn0 = 0;
    #100;
    ck_rst = 1;
    // Load data 0xA5 (binary 1010_0101) to transmit
    data_in = 8'hA5;
    //#100;
    //send    = 1;
    //#10;              // one clock pulse
    //send    = 0;
    #100;
    btn0 = 1;
    #1300;
    btn0 =0;

    // Wait long enough for full transmission
    #(200us);  // ~200 us simulation time
end

initial clk = 0;
always #5 clk = ~clk; // #5 is only working in testbench. (means wait 5 cycles.) 
localparam DATA_WIDTH = 8;


logic clk;
logic ck_rst;
logic [DATA_WIDTH-1:0] data_in;
logic tx;
logic busy;
logic btn0;


//To simulate 100E6Hz in FPGA, we need 10mn as period.
//uut : unit under test
//dut: desgin under test



top dut(
    .clk     (clk),
    .ck_rst  (ck_rst),
    //.data_in (data_in),
    .btn0    (btn0),
    .uart_rxd_out      (tx)
    //.busy    (busy)
);




endmodule