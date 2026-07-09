module FIFO_top();

    bit clk;
    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    FIFO_if fifoif (clk);
    FIFO DUT (fifoif);
    FIFO_tb TEST (fifoif);
    FIFO_monitor MONITOR(fifoif);
	
    
    `ifdef SIM
        always @(negedge fifoif.rst_n) begin
            #1;
            //FIFO_12
            A_TOP_RST_EMPTY: assert (fifoif.empty == 1)
                else $error("Top Async Reset Bug: empty flag should be 1");
            C_TOP_RST_EMPTY: cover  (fifoif.empty == 1);
            
            A_TOP_RST_FULL: assert (fifoif.full == 0)
                else $error("Top Async Reset Bug: full flag should be 0");
            C_TOP_RST_FULL: cover  (fifoif.full == 0);

            A_TOP_RST_ALMOSTFULL: assert (fifoif.almostfull == 0)
                else $error("Top Async Reset Bug: almostfull flag should be 0");
            C_TOP_RST_ALMOSTFULL: cover  (fifoif.almostfull == 0);

            A_TOP_RST_ALMOSTEMPTY: assert (fifoif.almostempty == 0)
                else $error("Top Async Reset Bug: almostempty flag should be 0");
            C_TOP_RST_ALMOSTEMPTY: cover  (fifoif.almostempty == 0);

            A_TOP_RST_OVERFLOW: assert (fifoif.overflow == 0)
                else $error("Top Async Reset Bug: overflow should be 0");
            C_TOP_RST_OVERFLOW: cover  (fifoif.overflow == 0);

            A_TOP_RST_UNDERFLOW: assert (fifoif.underflow == 0)
                else $error("Top Async Reset Bug: underflow should be 0");
            C_TOP_RST_UNDERFLOW: cover  (fifoif.underflow == 0);

            A_TOP_RST_WR_ACK: assert (fifoif.wr_ack == 0)
                else $error("Top Async Reset Bug: wr_ack should be 0");
            C_TOP_RST_WR_ACK: cover  (fifoif.wr_ack == 0);
        end
	`endif 

endmodule