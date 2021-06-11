`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2021 10:01:59 PM
// Design Name: 
// Module Name: parking_lot_fsm
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


module parking_lot_fsm(
    input clk,
    input reset_n,
    input [1:0]x,
    output car_enter,
    output car_exit
    );
    reg [2:0] state_reg, state_next;
    localparam s0 = 0;
    localparam s1 = 1;
    localparam s2 = 2;
    localparam s3 = 3;
    localparam s4 = 4;
    localparam s5 = 5;
    localparam s6 = 6;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(~reset_n)
            state_reg <= 0;
        else
            state_reg <= state_next;
    end
    
    always @(*)
    begin
        case(state_reg)
            s0: if(x == 2'b01)
                    state_next = s1;
                else if(x == 2'b10)
                    state_next = s2;
                else if(x == 2'b11)
                    state_next = s0;
                else
                    state_next = s0;
            s1: if(x == 2'b01)
                    state_next = s1;
                else if(x == 2'b10)
                    state_next = s0;
                else if(x == 2'b11)
                    state_next = s3;
                else
                    state_next = s0;
            s2: if(x == 2'b01)
                    state_next = s0;
                else if(x == 2'b10)
                    state_next = s2;
                else if(x == 2'b11)
                    state_next = s4;
                else
                    state_next = s0;
            s3: if(x == 2'b01)
                    state_next = s1;
                else if(x == 2'b10)
                    state_next = s5;
                else if(x == 2'b11)
                    state_next = s3;
                else
                    state_next = s0;
            s4: if(x == 2'b01)
                    state_next = s6;
                else if(x == 2'b10)
                    state_next = s2;
                else if(x == 2'b11)
                    state_next = 4;
                else
                    state_next = s0;
            s5: if(x == 2'b01)
                    state_next = s0;
                else if(x == 2'b10)
                    state_next = s5;
                else if(x == 2'b11)
                    state_next = 3;
                else
                    state_next = s0;
            s6: if(x == 2'b01)
                    state_next = s6;
                else if(x == 2'b10)
                    state_next = s0;
                else if(x == 2'b11)
                    state_next = s4;
                else
                    state_next = s0;
            default: state_next = state_reg;
        endcase
    end
    
    assign car_enter = (state_reg == s6 & x == 2'b00);
    assign car_exit = (state_reg == s5 & x == 2'b00);
endmodule
