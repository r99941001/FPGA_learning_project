`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 03:43:01 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input logic clk,  //name need to match constraint file
    input logic sw0,
    output logic led0
    );
    logic sw_ff1;
    logic sw_ff2;
    always_ff@ (posedge clk)
    begin
        sw_ff1 <= sw0;
        sw_ff2 <= sw_ff1;
        led0 <=sw_ff2;
    end
    
endmodule
