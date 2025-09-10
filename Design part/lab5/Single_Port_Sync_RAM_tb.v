`timescale 1ns / 1ps

module Single_Port_Sync_RAM_tb();

    // Parameters
    localparam MEM_WIDTH = 16;
    localparam MEM_DEPTH = 1024;
    localparam ADDR_SIZE = $clog2(MEM_DEPTH);

    // DUT signals
    reg                     clk;
    reg                     rst;
    reg                     wr_en;
    reg                     rd_en;
    reg                     blk_select;
    reg  [ADDR_SIZE-1:0]    addr;
    reg  [MEM_WIDTH-1:0]    din;
    reg                     addr_en;
    reg                     dout_en;
    wire [MEM_WIDTH-1:0]    dout;
    wire                    parity_out;

    // Instantiate DUT
    Single_Port_Sync_RAM #(
        .MEM_WIDTH(MEM_WIDTH),
        .MEM_DEPTH(MEM_DEPTH),
        .ADDR_SIZE(ADDR_SIZE),
        .ADDR_PIPELINE("TRUE"),
        .DOUT_PIPELINE("TRUE"),
        .PARITY_ENABLE(1)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .blk_select(blk_select),
        .addr(addr),
        .din(din),
        .addr_en(addr_en),
        .dout_en(dout_en),
        .dout(dout),
        .parity_out(parity_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Stimulus
    integer i;
    initial begin
        // Initialize
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        blk_select = 0;
        addr = 0;
        din = 0;
        addr_en = 0;
        dout_en = 0;

        // Release reset
        #20 rst = 0;

        // Perform 20 random write/read operations
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);

            blk_select = 1;
            addr_en    = 1;
            dout_en    = 1;

            // Randomize control signals
            wr_en = $random % 2;
            rd_en = $random % 2;

            // Randomize address and data
            addr = $random % MEM_DEPTH;
            din  = $random;

            // Ensure no simultaneous read & write (for clean demo)
            if (wr_en && rd_en)
                rd_en = 0;
        end

        // End simulation
        #50 $stop;
    end

    // Monitor outputs
    initial begin
        $display("Time\tblk_sel\twr_en\trd_en\taddr\tdin\tdout\tparity");
        $monitor("%0t\t%b\t%b\t%b\t%0d\t%h\t%h\t%b",
                 $time, blk_select, wr_en, rd_en, addr, din, dout, parity_out);
    end
    
endmodule

