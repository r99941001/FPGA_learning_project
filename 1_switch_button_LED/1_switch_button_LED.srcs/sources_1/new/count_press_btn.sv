`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 03:43:01 PM
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Push button to turn on/off LED. When we press/release button, the On/OFF signal will have ripple. We need to apply glich filter to make sure that the signal is settleed.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module count_press_btn(
    input logic clk,  //name need to match constraint file
    input logic sw0,
    input logic btn0,
    output logic [3:0] led
    );
    logic sw_ff1;     //Because, sw0 is asyncronos, need two Flip_Flops to make sure that the signal is stable. (Prevent meta-stability)
    logic sw_ff2;
    always_ff@ (posedge clk)
    begin
        sw_ff1 <= sw0;
        sw_ff2 <= sw_ff1;
        //led0 <=sw_ff2;
    end
    logic btn_ff1;     
    logic btn_ff2;
    logic btn_ff3;
    logic led0_in;
    logic led0_out;
    logic ctrl;

    always_ff @ (posedge clk)
    begin
        btn_ff1 <=btn0;
        btn_ff2 <=btn_ff1;
        btn_ff3 <=btn_ff2; // use two flip-flop to make sure btn0 signal is syncroniced with clk.
        
    end
    
    localparam int COUNT_MAX = 128;
    logic [$clog2(COUNT_MAX)-1:0] counter_filter = '0;
    logic btn_filter;
    logic btn_filter_ff;
    always_ff @ (posedge clk)
    begin
    // detect no changing signal for a fix times (COUNT_MAX)
    // when the time is long enough, the signal will be settled and no ripple.
    // We will use the counter_filter to determine whether there's a rise/lower edge.
    
        if(btn_ff2 == btn_ff3 && counter_filter < COUNT_MAX-1)  // when there's no signal change, counter_filter keep increase until counter reach COUNT_MAX.
        begin
            counter_filter<=counter_filter+1;
        end
        else if (btn_ff2 != btn_ff3) // when there's a signal change, counter_filter will reset to 0.
        begin
            counter_filter<=0;
        end
            
        if (counter_filter == COUNT_MAX-1) btn_filter <=btn_ff3; // when counter_filter reach COUNT_MAX, btn_filter will start take btn_ff3 signal. (otherwise keep previous value.)
        
        btn_filter_ff <= btn_filter;  // use btn_filter_ff to crease 1 clk delay.
        
        if(btn_filter_ff == 1 && btn_filter == 0) // check if rising edge happen, if yes, then invert ctrl signal.
        begin
            ctrl <= ~ctrl;                          
        end
        
        //led0 <= ctrl;  // pass ctrl to led0.
        
    end 

    logic [3:0] counter = '0;
    always_ff @ (posedge clk)
    begin
        if(btn_filter_ff == 1 && btn_filter == 0 ) // check if rising edge happen, if yes, then invert ctrl signal.
        begin
            counter <=counter +1;                          
        end
        // No need extra if. counter will overflow and go back to 0 when counter readh 4'b1111
        //if (counter == '1)  // 15 or 4'hF or 4'd15
        //begin
        //    counter = '0
        //end
        led <= counter;
    end
// when both if state true, the last if will take over.     

    
    

    
endmodule
