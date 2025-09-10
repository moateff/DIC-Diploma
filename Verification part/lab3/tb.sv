import my_pkg::*;

module tb;
    
    screen img1;

    initial begin
        img1 = new();
        repeat(20) begin
            assert (img1.randomize())
            else $error("Assertion label failed!");
            img1.print_screen();
            #10;
        end
        $stop;
    end

endmodule
