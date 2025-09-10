package mypackage;
/*
    class MemTrans;
        logic [7:0] data_in_;
        logic [3:0] address_;

        function new(
            logic [7:0] data_in = 0,
            logic [3:0] address = 0
        );
            data_in_ = data_in;
            address_ = address;
        endfunction

        function void display();
            $display("data_in = %d | address = %d", data_in_, address_);
        endfunction

    endclass
*/
    class Exercise;
        rand bit [7:0] data_;
        rand bit [3:0] address_;

        constraint range { 
            data_ == 5;
            address_ dist {0:=10, [1:14]:= 80, 15:=10};
        }

        function void display();
            $display("data = %d | address = %d", data_, address_);
        endfunction
        
    endclass: Exercise

endpackage