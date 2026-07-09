package my_pkg;
parameter HEIGHT = 10;
parameter WIDTH = 10; 
parameter PERCENT_WHITE = 50;
typedef enum {BLACK, WHITE} colors_t;

class screen;
    rand colors_t pixels [HEIGHT][WIDTH];
    constraint c {
        foreach(pixels[i,j]) 
            pixels[i][j] dist {WHITE := PERCENT_WHITE, BLACK := 100 - PERCENT_WHITE};
    }
    function void print_screen();
        foreach(pixels[i]) 
            $display("Pixels at Row %0d Colors are %0p: ",i, pixels[i]);
    endfunction
endclass
endpackage
