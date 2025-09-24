interface alsu_if(clk);
    input bit clk;
    logic rst; 
    logic cin; 
    logic red_op_A; 
    logic red_op_B;
    logic bypass_A; 
    logic bypass_B;
    logic direction; 
    logic serial_in;
    logic [2:0] opcode;
    logic signed [2:0] A; 
    logic signed [2:0] B;
    logic [15:0] leds;
    logic signed [5:0] out;
endinterface: alsu_if

