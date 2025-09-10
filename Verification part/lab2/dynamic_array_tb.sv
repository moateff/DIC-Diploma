module dynamic_array_tb;

    // Declare dynamic arrays
    int dyn_arr1[];
    int dyn_arr2[];

    initial begin
        // initialize dyn_arr2 array elements with (9,1,8,3,4,4)
        dyn_arr2 = '{9,1,8,3,4,4};

        // Allocate 6 elements in dyn_arr1 using new
        dyn_arr1 = new[6];
        
        // Initialize dyn_arr1 with its index as value using foreach
        foreach (dyn_arr1[i]) begin
            dyn_arr1[i] = i;
        end

        // Display dyn_arr1 and its size
        $display("dyn_arr1: %p", dyn_arr1);
        $display("dyn_arr1 size: %0d", dyn_arr1.size());

        // Delete dyn_arr1
        dyn_arr1.delete();

        // Display dyn_arr2 before any operations
        // $display("Original dyn_arr2: %p", dyn_arr2);

        // Reverse dyn_arr2
        dyn_arr2.reverse();
        $display("Reversed dyn_arr2: %p", dyn_arr2); 

        // Sort dyn_arr2
        dyn_arr2.sort();
        $display("Sorted dyn_arr2: %p", dyn_arr2); 

        // Reverse sort (descending)
        dyn_arr2.rsort();
        $display("Reverse Sorted dyn_arr2: %p", dyn_arr2);

        // Shuffle dyn_arr2
        dyn_arr2.shuffle();
        $display("Shuffled dyn_arr2: %p", dyn_arr2); 
    end

endmodule
