package counter_pkg;

    parameter int WIDTH = 4;

    class counter_txn;
        bit clk;
        rand bit rst_n;
        rand bit load_n;
        rand bit up_down;
        rand bit ce;
        randc bit [WIDTH - 1:0] data_load;
        bit [WIDTH - 1:0] count_out;
        bit max_count;
        bit zero;
        
        constraint c1 {
            rst_n dist {0 := 5, 1 := 95}; 
            load_n dist {0 := 70, 1 := 30};
            ce dist {0 := 30, 1 := 70};
            up_down dist {0 := 50, 1 := 50};
        }

        covergroup g1 @(posedge clk);
            data_load_cp: coverpoint data_load iff (rst_n && (!load_n));
            count_out_up_cp: coverpoint count_out iff (rst_n && load_n && up_down){
                bins all_values[] = {[{WIDTH{1'b0}}:{WIDTH{1'b1}}]};
                bins max_to_zero = ({WIDTH{1'b1}} => {WIDTH{1'b0}});
            }

            count_out_down_cp: coverpoint count_out iff (rst_n && load_n && (!up_down)){
                bins all_values[] = {[{WIDTH{1'b0}}:{WIDTH{1'b1}}]};
                bins zero_to_max = ({WIDTH{1'b0}} => {WIDTH{1'b1}});
            }
        endgroup 

        function new();
            g1 = new();
        endfunction

    endclass : counter_txn

endpackage : counter_pkg
