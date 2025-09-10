module ALU_tb;
    parameter CLK_PERIOD = 10;

    localparam MAXPOS = 7;
    localparam ZERO   = 0; 
    localparam MAXNEG = -8;

    localparam ADD           = 2'b00;
    localparam SUB           = 2'b01;
    localparam NOT_A         = 2'b10;
    localparam ReductionOR_B = 2'b11;

    int error_count, correct_count;
    int A_temp, B_temp, opcode_temp;

    // Signals
    logic clk, reset;
    logic [1:0] opcode;
    logic signed [3:0] A, B;
    logic signed [4:0] C;

    // Instantiate the DUT 
    ALU DUT (.*);

    // Clock Generation 
    always #(CLK_PERIOD/2) clk = ~clk;

    // Task to apply inputs
    task drive_input (
        input [1:0] in_opcode,
        input signed [3:0] in1, 
        input signed [3:0] in2
    );  
        opcode = in_opcode;
        A = in1; B = in2;
        @(negedge clk);
    endtask

    function signed [4:0] alu_function(
        input [1:0] opcode,
        input signed [3:0] A,
        input signed [3:0] B
    );
        case (opcode)
            2'b00: alu_function = A + B;  // Addition
            2'b01: alu_function = A - B;  // Subtraction
            2'b10: alu_function = ~A;     // Bitwise NOT of A
            2'b11: alu_function = |B;     // Reduction OR of B
            default: alu_function = 5'b0; // Default case
        endcase
    endfunction


    task check_result(
        input signed [4:0] expected_result
    );          
        if (C == expected_result) begin
            correct_count++;
        end else begin
            $display("Error: expected output = %d, got output = %d | A = %d, B = %d, Opcode = %b", 
                    expected_result, C, A, B, opcode);
            error_count++;
        end
    endtask

    task assert_reset;
        reset = 1'b1;        // Assert reset
        @(negedge clk);          
        reset = 1'b0;       
    endtask

    task wait_cycles (
        input integer num_cycles
    );            
        repeat(num_cycles) @(negedge clk);
    endtask

    initial begin
        initialize_inputs;
        wait_cycles(1);

        // ALU1
        assert_reset;
        check_result(ZERO);

        // ALU2
        opcode_temp = ADD;
        A_temp = MAXNEG; B_temp = MAXNEG;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXNEG; B_temp = ZERO;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXNEG; B_temp = MAXPOS;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = ZERO; B_temp = MAXNEG;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = ZERO; B_temp = ZERO;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = ZERO; B_temp = MAXPOS;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXPOS; B_temp = MAXNEG;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXPOS; B_temp = ZERO;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXPOS; B_temp = MAXPOS;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        // ALU3
        opcode_temp = SUB;
        A_temp = MAXNEG; B_temp = MAXNEG;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXNEG; B_temp = ZERO;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXNEG; B_temp = MAXPOS;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = ZERO; B_temp = MAXNEG;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = ZERO; B_temp = ZERO;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = ZERO; B_temp = MAXPOS;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXPOS; B_temp = MAXNEG;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXPOS; B_temp = ZERO;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));

        A_temp = MAXPOS; B_temp = MAXPOS;
        drive_input(opcode_temp, A_temp, B_temp);
        check_result(alu_function(opcode_temp, A_temp, B_temp));


        // ALU3
        opcode_temp = NOT_A;
        for (int i = 0; i < 15; i++) begin
            A_temp = i; B_temp = $random;
            drive_input(opcode_temp, A_temp, B_temp);
            check_result(alu_function(opcode_temp, A_temp, B_temp));
        end

        // ALU4
        opcode_temp = ReductionOR_B;
        for (int i = 0; i < 15; i++) begin
            A_temp = $random; B_temp = i;
            drive_input(opcode_temp, A_temp, B_temp);
            check_result(alu_function(opcode_temp, A_temp, B_temp));
        end

        // ALU5
        for (int i = 0; i < 20; i++) begin
            opcode_temp = $urandom_range(0, 3);
            A_temp = $random; 
            B_temp = $random;
            drive_input(opcode_temp, A_temp, B_temp);
            check_result(alu_function(opcode_temp, A_temp, B_temp));
        end

        $display("you got correct cases = %0d, and wrong cases = %0d", correct_count, error_count);
        $stop;
    end

    task initialize_inputs;
        clk = 0;
        reset = 0;
        opcode = 2'b00;
        A = 4'b1111;
        B = 4'b0000;
    endtask

endmodule