import mypackage::*;

module class_tb;
    /*
    MemTrans object1, object2;

    initial begin
        object1 = new(, 2);
        object2 = new(3, 4);
        object1.display();
        object2.display();
    end
    */
    Exercise object1;

    initial begin
        object1 = new();
        repeat(20) begin
            assert (object1.randomize())
            else $error("Assertion label failed!");
            object1.display();
            #10;
        end
        $stop;
    end

endmodule