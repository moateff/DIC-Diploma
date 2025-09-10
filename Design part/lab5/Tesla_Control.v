`timescale 1ns / 1ps

module Tesla_Control #(
    parameter MIN_DISTANCE = 7'd40      // 40 meters
)(
    input  wire        clk,
    input  wire        rst,             // active high async reset
    input  wire [7:0]  speed_limit,     // allowable speed limit
    input  wire [7:0]  car_speed,       // current car speed
    input  wire [6:0]  leading_distance,// distance to front vehicle
    
    output reg         unlock_doors,    // unlock doors when HIGH
    output reg         accelerate_car   // accelerate car when HIGH
);

    // FSM state encoding
    localparam STOP       = 2'b00;
    localparam ACCELERATE = 2'b01;
    localparam DECELERATE = 2'b10;

    // State registers
    reg [1:0] crnt_state, nxt_state;

    // Sequential block: state update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crnt_state <= STOP;
        end else begin
            crnt_state <= nxt_state;
        end
    end

    // Next state logic
    always @(*) begin
        nxt_state = crnt_state; // default hold
        case (crnt_state)
            STOP: begin
                if (leading_distance >= MIN_DISTANCE) begin
                    nxt_state = ACCELERATE;
                end else begin
                    nxt_state = STOP;
                end
            end

            ACCELERATE: begin
                if (leading_distance < MIN_DISTANCE || car_speed > speed_limit) begin
                    nxt_state = DECELERATE;
                end else begin
                    nxt_state = ACCELERATE;
                end
            end

            DECELERATE: begin
                if (car_speed == 0) begin
                    nxt_state = STOP;
                end else if (leading_distance >= MIN_DISTANCE && car_speed < speed_limit) begin
                    nxt_state = ACCELERATE;
                end else begin
                    nxt_state = DECELERATE;
                end
            end

            default: nxt_state = STOP;
        endcase
    end

    // Output logic (Moore FSM: depends only on crnt_state)
    always @(*) begin
        case (crnt_state)
            STOP: begin
                unlock_doors   = 1'b1;
                accelerate_car = 1'b0;
            end

            ACCELERATE: begin
                unlock_doors   = 1'b0;
                accelerate_car = 1'b1;
            end

            DECELERATE: begin
                unlock_doors   = 1'b0;
                accelerate_car = 1'b0;
            end

            default: begin
                unlock_doors   = 1'b1;
                accelerate_car = 1'b0;
            end
        endcase
    end

endmodule