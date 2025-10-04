package fifo_shared_pkg;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
localparam max_fifo_addr = $clog2(FIFO_DEPTH); 

int NUM_TEST_CASES = 500;
int error_count;
int correct_count;

endpackage : fifo_shared_pkg