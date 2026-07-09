package FIFO_transaction_pkg;

    class FIFO_transaction; 
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;

        rand logic [FIFO_WIDTH-1:0] data_in;
        logic [FIFO_WIDTH-1:0] data_out;
        rand logic rst_n, wr_en, rd_en; 
        logic wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
        
        integer RD_EN_ON_DIST, WR_EN_ON_DIST;

        //FIFO_14
        function new(integer RD_EN_ON_DIST = 30, integer WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction

        constraint reset_con{
            rst_n dist{0 := 5, 1:= 95};
        }
        constraint write_con{
            wr_en dist{1 := WR_EN_ON_DIST, 0 := 100-WR_EN_ON_DIST};
        }
        constraint read_con{
            rd_en dist{1 := RD_EN_ON_DIST, 0 := 100-RD_EN_ON_DIST};
        }

    endclass
endpackage