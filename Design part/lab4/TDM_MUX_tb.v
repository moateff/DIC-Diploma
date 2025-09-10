module TDM_MUX_tb;
    reg clk;
    reg rst;
    reg [1:0] in0, in1, in2, in3;
    wire [1:0] out;
    
    // Instantiate the TDM_MUX module
    TDM_MUX uut (
        .clk(clk),
        .rst(rst),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        in0 = 2'b00;
        in1 = 2'b00;
        in2 = 2'b00;
        in3 = 2'b00;
        
        // Apply reset
        #10 rst = 0;
        
        repeat (1000) begin
            in0 = $random;
            in1 = $random;
            in2 = $random;
            in3 = $random;

            @(negedge clk);
            
            case (uut.counter) 
                2'b00: if (out !== in0) begin 
                            $display("Error at time %0t: Expected %b, got %b", $time, in0, out); 
                            $stop; 
                        end
                2'b01: if (out !== in1) begin 
                            $display("Error at time %0t: Expected %b, got %b", $time, in1, out); 
                            $stop; 
                        end
                2'b10: if (out !== in2) begin 
                            $display("Error at time %0t: Expected %b, got %b", $time, in2, out); 
                            $stop; 
                        end
                2'b11: if (out !== in3) begin 
                            $display("Error at time %0t: Expected %b, got %b", $time, in3, out); 
                            $stop; 
                        end
            endcase
        
            $display("Test passed successfully!");
        end
        $stop;
    end
    
endmodule
