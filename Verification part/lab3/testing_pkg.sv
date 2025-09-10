package testing_pkg;
    typedef enum {ADD, SUB, MULT, DIV} opcode_e;

    class Transaction;
        parameter MAXPOS = 127;
        parameter ZERO = 0;
        parameter MAXNEG = -128;

        rand opcode_e opcode;
        rand byte operand1;
        rand byte operand2;
        bit clk;

        covergroup g1 @(posedge clk);
            opcode_cp: coverpoint opcode {
                bins opcode_add_or_sub = {ADD, SUB};
                bins opcode_add_to_sub = (ADD => SUB);
                illegal_bins opcode_not_DIV = {DIV};
            }
            operand1_cp: coverpoint operand1 {
                bins operand1_maxpos = {MAXPOS};
                bins operand1_zero = {ZERO};
                bins operand1_maxneg = {MAXNEG};
                bins misc = default;
            }
        endgroup

        function new;
            g1 = new;
        endfunction
    endclass

endpackage