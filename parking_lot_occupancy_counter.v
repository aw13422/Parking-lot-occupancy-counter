`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2021 10:31:12 PM
// Design Name: 
// Module Name: parking_lot_occupancy_counter
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


module parking_lot_occupancy_counter(
    input clk,
    input button0,
    input button1,
    input button_reset,
    output [6:0]sseg,
    output [0:7]AN,
    output DP,
    output h
    );
    wire [1:0]x;
    wire car_enter;
    wire car_exit;
    wire counter_mode;
    wire en;
    wire [7:0]count_bin;
    wire [11:0]count_bcd;
    wire counter_reset;

// for testbench
//    assign x[0] = button0;
//    assign x[1] = button1;
//    assign counter_reset = button_reset;
//    assign h = car_enter;
    debouncer_delayed DD0(  // right button
        .clk(clk),
        .reset_n(1),
        .noisy(button0),
        .debounced(x[0])
    );
    debouncer_delayed DD1(  // left button
        .clk(clk),
        .reset_n(1),
        .noisy(button1),
        .debounced(x[1])
    );
    debouncer_delayed DD2(  // reset button
        .clk(clk),
        .reset_n(1),
        .noisy(button_reset),
        .debounced(counter_reset)
    );
    parking_lot_fsm FSM0(
        .clk(clk),
        .reset_n(1),
        .x(x),
        .car_enter(car_enter),
        .car_exit(car_exit)
    );
    
    assign en = car_enter | car_exit;
    assign counter_mode = car_enter;
     
    udl_counter #(.BITS(8)) UC1(
        .clk(clk),
        .reset_n(counter_reset),
        .enable(en),
        .up(counter_mode),
        .load(0),
        .D('b0),
        .Q(count_bin)
    );  
    bin2bcd BB0(
        .bin(count_bin),
        .bcd(count_bcd)
    );
    sseg_driver SD0(
        .clk(clk),
        //.reset_n(counter_reset),
        .I7({1'b1, count_bcd[3:0], 1'b1}),
        .I6({1'b1, count_bcd[7:4], 1'b1}),
        .I5({1'b1, count_bcd[11:8], 1'b1}),
        .I4(6'b00001),
        .I3(6'b00001),
        .I2(6'b00001),
        .I1(6'b00001),
        .I0(6'b00001),
        .AN(AN),
        .sseg(sseg),
        .DP(DP)
    );

endmodule
