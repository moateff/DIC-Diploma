package my_pkg;
    
    parameter HEIGHT = 10;
    parameter WIDTH = 10;
    parameter PERCENT_WHITE = 20;
    typedef enum {BLACK, WHITE} colors_t;

    class screen;
        rand colors_t pixels [HEIGHT][WIDTH];

        constraint colors_c {
            foreach (pixels[i, j]) {
                pixels[i][j] dist {WHITE := PERCENT_WHITE, BLACK := 100 - PERCENT_WHITE};
            }
        }

        function void print_screen;
            /*
            for (int i = 0; i < HEIGHT; i++) begin
                for (int j = 0; j < WIDTH; j++) begin
                    $display("%p ", pixels[i][j]);
                end
            end
            */
            foreach (pixels[i]) $display("%p\n", pixels[i]);
        endfunction

    endclass

endpackage
