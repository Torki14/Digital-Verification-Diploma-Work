import shared_pkg::*;
module FIFO_sva(
                input logic                    clk,
                input logic                    rst_n,
                input logic                    wr_en,
                input logic                    rd_en,
                input logic [FIFO_WIDTH-1:0]   data_in,
                input logic                    wr_ack,
                input logic                    overflow,
                input logic                    underflow,
                input logic                    full,
                input logic                    empty,
                input logic                    almostfull,
                input logic                    almostempty,

                input logic [$clog2(FIFO_DEPTH):0]   count,
                input logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr,
                input logic [$clog2(FIFO_DEPTH)-1:0] rd_ptr
                );

    //FIFO_5
    always @(negedge rst_n) begin
        #1;
        A_RESET_COUNT   : assert (count    == 0) else $error("Reset Bug: count did not reset to 0");
        C_RESET_COUNT   : cover  (count    == 0);

        A_RESET_WR_PTR  : assert (wr_ptr   == 0) else $error("Reset Bug: wr_ptr did not reset to 0");
        C_RESET_WR_PTR  : cover  (wr_ptr   == 0);

        A_RESET_RD_PTR  : assert (rd_ptr   == 0) else $error("Reset Bug: rd_ptr did not reset to 0");
        C_RESET_RD_PTR  : cover  (rd_ptr   == 0);

        A_RST_EMPTY     : assert (empty        == 1) else $error("Reset Bug: empty should be 1");
        C_RST_EMPTY     : cover  (empty        == 1);

        A_RST_FULL      : assert (full         == 0) else $error("Reset Bug: full should be 0");
        C_RST_FULL      : cover  (full         == 0);

        A_RST_ALMOSTFULL: assert (almostfull   == 0) else $error("Reset Bug: almostfull should be 0");
        C_RST_ALMOSTFULL: cover  (almostfull   == 0);

        A_RST_ALMOSTEMPTY: assert (almostempty == 0) else $error("Reset Bug: almostempty should be 0");
        C_RST_ALMOSTEMPTY: cover  (almostempty == 0);

        A_RST_OVERFLOW  : assert (overflow     == 0) else $error("Reset Bug: overflow should be 0");
        C_RST_OVERFLOW  : cover  (overflow     == 0);

        A_RST_UNDERFLOW : assert (underflow    == 0) else $error("Reset Bug: underflow should be 0");
        C_RST_UNDERFLOW : cover  (underflow    == 0);

        A_RST_WR_ACK    : assert (wr_ack       == 0) else $error("Reset Bug: wr_ack should be 0");
        C_RST_WR_ACK    : cover  (wr_ack       == 0);
    end

    //FIFO_6
    always_comb begin
        if (rst_n) begin
            A_EMPTY      : assert (empty       == (count == 0))            else $error("Empty flag failed");
            C_EMPTY      : cover  (empty       == (count == 0));

            A_FULL       : assert (full        == (count == FIFO_DEPTH))   else $error("Full flag failed");
            C_FULL       : cover  (full        == (count == FIFO_DEPTH));

            A_ALMOST_FULL: assert (almostfull  == (count == FIFO_DEPTH-1)) else $error("AlmostFull flag failed");
            C_ALMOST_FULL: cover  (almostfull  == (count == FIFO_DEPTH-1));

            A_ALMOST_EMPTY: assert (almostempty == (count == 1))           else $error("AlmostEmpty flag failed");
            C_ALMOST_EMPTY: cover  (almostempty == (count == 1));
        end
    end
    
    //FIFO_7
    always_comb begin
        if (rst_n) begin
            A_WR_PTR_THRESH: assert (wr_ptr < FIFO_DEPTH)  else $error("Threshold Bug: wr_ptr exceeded FIFO_DEPTH-1");
            C_WR_PTR_THRESH: cover  (wr_ptr < FIFO_DEPTH);

            A_RD_PTR_THRESH: assert (rd_ptr < FIFO_DEPTH)  else $error("Threshold Bug: rd_ptr exceeded FIFO_DEPTH-1");
            C_RD_PTR_THRESH: cover  (rd_ptr < FIFO_DEPTH);

            A_COUNT_THRESH : assert (count  <= FIFO_DEPTH)  else $error("Threshold Bug: count exceeded FIFO_DEPTH");
            C_COUNT_THRESH : cover  (count  <= FIFO_DEPTH);
        end
    end

    //FIFO_8
    property WR_ACK_P;
        @(posedge clk) disable iff (!rst_n)
        (wr_en && !full) |=> wr_ack;
    endproperty

    //FIFO_9
    property OVERFLOW_P;
        @(posedge clk) disable iff (!rst_n)
        (wr_en && full) |=> overflow;
    endproperty

    //FIFO_10
    property UNDERFLOW_P;
        @(posedge clk) disable iff (!rst_n)
        (rd_en && empty) |=> underflow;
    endproperty

    //FIFO_11
    property WR_WRAP_P;
        @(posedge clk) disable iff (!rst_n)
        (wr_ptr == FIFO_DEPTH - 1 && wr_en && !full) |=> (wr_ptr == 0);
    endproperty

    //FIFO_12
    property RD_WRAP_P;
        @(posedge clk) disable iff (!rst_n)
        (rd_ptr == FIFO_DEPTH - 1 && rd_en && !empty) |=> (rd_ptr == 0);
    endproperty

    //FIFO_13
    property FULL_NO_WR_ACK_P;
        @(posedge clk) disable iff (!rst_n)
        full |=> !wr_ack;
    endproperty

    A_WR_ACK_ASSERT      : assert property (WR_ACK_P)       else $error("wr_ack not asserted after valid write");
    A_WR_ACK_COVER       : cover  property (WR_ACK_P);

    A_OVERFLOW_ASSERT    : assert property (OVERFLOW_P)     else $error("overflow not asserted on write-while-full");
    A_OVERFLOW_COVER     : cover  property (OVERFLOW_P);

    A_UNDERFLOW_ASSERT   : assert property (UNDERFLOW_P)    else $error("underflow not asserted on read-while-empty");
    A_UNDERFLOW_COVER    : cover  property (UNDERFLOW_P);

    A_WR_WRAP_ASSERT     : assert property (WR_WRAP_P)      else $error("Write pointer failed to wrap to 0");
    A_WR_WRAP_COVER      : cover  property (WR_WRAP_P);

    A_RD_WRAP_ASSERT     : assert property (RD_WRAP_P)      else $error("Read pointer failed to wrap to 0");
    A_RD_WRAP_COVER      : cover  property (RD_WRAP_P);

    A_FULL_NO_WR_ACK_ASSERT : assert property (FULL_NO_WR_ACK_P) else $error("wr_ack asserted while FIFO is full");
    A_FULL_NO_WR_ACK_COVER  : cover  property (FULL_NO_WR_ACK_P);

endmodule