module button (
    input logic clk,
    input logic btn0,
    output logic btn_out
);

logic btn_ff1;
logic btn_ff2;
logic btn_ff3;

localparam int COUNT_MAX = 128;
logic [$clog2(COUNT_MAX)-1:0] counter = '0;
logic btn_filter ='0;



always_ff @( posedge clk ) begin
    btn_ff1 <=btn0;
    btn_ff2 <=btn_ff1;
    btn_ff3 <=btn_ff2; // use two flip-flop to make sure btn0 signal is syncroniced with clk.
end

always_ff @( posedge clk) begin
    if (btn_ff3 == btn_ff2 && counter <COUNT_MAX-1) counter <= counter +1;
    else if (btn_ff3 == btn_ff2 && counter == COUNT_MAX-1) btn_filter <=btn_ff3;
    else if (btn_ff3 != btn_ff2) counter <=0;
    
    btn_out <= btn_filter;
    
end
    
endmodule