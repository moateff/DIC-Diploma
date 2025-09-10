`timescale 1ns / 1ps

module Tesla_Control_tb();
    // Testbench signals
    reg clk;
    reg rst;
    reg [7:0] speed_limit;
    reg [7:0] car_speed;
    reg [6:0] leading_distance;

    wire unlock_doors;
    wire accelerate_car;

    // Instantiate DUT
    Tesla_Control DUT (
        .clk(clk),
        .rst(rst),
        .speed_limit(speed_limit),
        .car_speed(car_speed),
        .leading_distance(leading_distance),
        .unlock_doors(unlock_doors),
        .accelerate_car(accelerate_car)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Stimulus
    initial begin
        // Initialize signals
        rst = 1;
        speed_limit = 8'd100;    // 100 km/h speed limit
        car_speed = 8'd0;
        leading_distance = 7'd20; // 20m (too close)

        // Apply reset
        #12 rst = 0;

        // Car is too close (should be STOP)
        #20;

        // Increase distance (safe to accelerate)
        leading_distance = 7'd50;
        car_speed = 8'd20;
        #40;

        // Car accelerates until close to speed limit
        car_speed = 8'd95;
        #40;

        // Exceed speed limit (should DECELERATE)
        car_speed = 8'd110;
        #40;

        // Reduce speed gradually
        car_speed = 8'd80;
        leading_distance = 7'd30; // too close again
        #40;

        // Car slows down to stop
        car_speed = 8'd0;
        #40;

        // Resume safe distance
        leading_distance = 7'd70;
        car_speed = 8'd50;
        #40;

        // End simulation
        $stop;
    end

    // Monitor output
    initial begin
        $display("Time\tState\tSpeed\tLimit\tDistance\tUnlock\tAccel");
        $monitor("%0t\t%d\t%d\t%d\t%d\t%b\t%b",
                 $time, DUT.crnt_state, car_speed, speed_limit, leading_distance,
                 unlock_doors, accelerate_car);
    end
    
endmodule
