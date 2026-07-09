module FIFO(FIFO_if.DUT fifo_if);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    localparam max_fifo_addr = $clog2(FIFO_DEPTH);

    logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

    logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
    logic [max_fifo_addr:0] count;

    // Write Port
    always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
        if (!fifo_if.rst_n) begin
            wr_ptr <= 0;
        end
        else if (fifo_if.wr_en && count < FIFO_DEPTH) begin
            mem[wr_ptr] <= fifo_if.data_in;
            fifo_if.wr_ack <= 1;
            wr_ptr <= wr_ptr + 1;
        end
        else begin 
            fifo_if.wr_ack <= 0; 
            if (fifo_if.full & fifo_if.wr_en)
                fifo_if.overflow <= 1;
            else
                fifo_if.overflow <= 0;
        end
    end

    // Read Port 
    always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
        if (!fifo_if.rst_n) begin
            rd_ptr <= 0;
        end
        else if (fifo_if.rd_en && count != 0) begin
            fifo_if.data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Counter
    always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
        if (!fifo_if.rst_n) begin
            count <= 0;
        end
        else begin
            if  ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
                count <= count + 1;
            else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
                count <= count - 1;
			//Missing Simultaneous Read/Write Counter Logic	
        end
    end

    assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
    assign fifo_if.empty = (count == 0)? 1 : 0;
    assign fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0; // Combinational Instead of Sequential
    assign fifo_if.almostfull = (count == FIFO_DEPTH-2)? 1 : 0; //Wrong Threshold 
    assign fifo_if.almostempty = (count == 1)? 1 : 0;

	`ifdef SIM
        //FIFO_1
		always @(negedge fifo_if.rst_n) begin
            #1; 
			A_RESET_COUNT: assert (count == 0)
			else $error("Async Reset Bug: internal count did not reset to 0");
			C_RESET_COUNT: cover (count == 0);

			A_RESET_WR_PTR: assert (wr_ptr == 0)
			else $error("Async Reset Bug: wr_ptr did not reset to 0");
			C_RESET_WR_PTR: cover (wr_ptr == 0);

			A_RESET_RD_PTR: assert (rd_ptr == 0)
			else $error("Async Reset Bug: rd_ptr did not reset to 0");
			C_RESET_RD_PTR: cover (rd_ptr == 0);

			A_RST_EMPTY: assert (fifo_if.empty == 1)
			else $error("Async Reset Bug: empty flag should be 1");
			C_RST_EMPTY: cover (fifo_if.empty == 1);

			A_RST_FULL: assert (fifo_if.full == 0)
			else $error("Async Reset Bug: full flag should be 0");
			C_RST_FULL: cover (fifo_if.full == 0);

			A_RST_ALMOSTFULL: assert (fifo_if.almostfull == 0)
			else $error("Async Reset Bug: almostfull flag should be 0");
			C_RST_ALMOSTFULL: cover (fifo_if.almostfull == 0);

			A_RST_ALMOSTEMPTY: assert (fifo_if.almostempty == 0)
			else $error("Async Reset Bug: almostempty flag should be 0");
			C_RST_ALMOSTEMPTY: cover (fifo_if.almostempty == 0);

			A_RST_OVERFLOW: assert (fifo_if.overflow == 0)
			else $error("Async Reset Bug: overflow should be 0");
			C_RST_OVERFLOW: cover (fifo_if.overflow == 0);

			A_RST_UNDERFLOW: assert (fifo_if.underflow == 0)
			else $error("Async Reset Bug: underflow should be 0");
			C_RST_UNDERFLOW: cover (fifo_if.underflow == 0);

			A_RST_WR_ACK: assert (fifo_if.wr_ack == 0)
			else $error("Async Reset Bug: wr_ack should be 0");
			C_RST_WR_ACK: cover (fifo_if.wr_ack == 0);
		end

        //FIFO_2
		property WR_ACK_P;
        	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
			(fifo_if.wr_en && !fifo_if.full) |=> fifo_if.wr_ack;
		endproperty

		A_WR_ACK: assert property (WR_ACK_P)
        else $error("wr_ack: write succeeded but wr_ack not asserted");
		C_WR_ACK: cover property (WR_ACK_P);

        //FIFO_3
		property OVERFLOW_P;
        	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
			(fifo_if.wr_en && fifo_if.full) |=> fifo_if.overflow;
		endproperty

		A_OVERFLOW: assert property (OVERFLOW_P) 
		else $error("overflow: write while full but overflow not asserted");
		C_OVERFLOW: cover property (OVERFLOW_P);

        //FIFO_4
		property UNDERFLOW_P;
        	@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
			(fifo_if.rd_en && fifo_if.empty) |=> fifo_if.underflow;
		endproperty

		A_UNDERFLOW: assert property (UNDERFLOW_P) 
		else $error("underflow: read while empty but underflow not asserted");
		C_UNDERFLOW: cover property (UNDERFLOW_P);

        //FIFO_5
		always_comb begin
			if (fifo_if.rst_n) begin
				A_EMPTY: assert (fifo_if.empty == (count == 0)) else $error("Empty flag failed");
				C_EMPTY: cover	(fifo_if.empty == (count == 0));
			end
		end	

        //FIFO_6
		always_comb begin
			if (fifo_if.rst_n) begin
				A_FULL: assert (fifo_if.full == (count == FIFO_DEPTH)) else $error("Full flag failed");
				C_FULL: cover  (fifo_if.full == (count == FIFO_DEPTH));
			end
		end	

        //FIFO_7
		always_comb begin
			if (fifo_if.rst_n) begin
				A_ALMOST_FULL: assert (fifo_if.almostfull == (count == FIFO_DEPTH-1)) else $error("Almost_Full flag failed");
				C_ALMOST_FULL: cover  (fifo_if.almostfull == (count == FIFO_DEPTH-1));
			end
		end		

        //FIFO_8
		always_comb begin
			if (fifo_if.rst_n) begin
				A_ALMOST_EMPTY: assert (fifo_if.almostempty == (count == 1)) else $error("Almost_Empty flag failed");
				C_ALMOST_EMPTY: cover  (fifo_if.almostempty == (count == 1));
			end
		end	

        //FIFO_9
		property WR_WRAP_P;
			@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
			(wr_ptr == FIFO_DEPTH - 1 && fifo_if.wr_en && !fifo_if.full) |=> (wr_ptr == 0);
		endproperty
		A_WR_WRAP: assert property(WR_WRAP_P) 
			else $error("Wrap around faild: Write pointer failed to wrap back to 0");
		C_WR_WRAP: cover property(WR_WRAP_P);
        
		//FIFO_10
		property RD_WRAP_P;
			@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n)
			(rd_ptr == FIFO_DEPTH - 1 && fifo_if.rd_en && !fifo_if.empty) |=> (rd_ptr == 0);
		endproperty
		A_RD_WRAP: assert property(RD_WRAP_P) 
			else $error("Wrap around faild: Read pointer failed to wrap back to 0");
		C_RD_WRAP: cover property(RD_WRAP_P);

        //FIFO_11
		always_comb begin
			if (fifo_if.rst_n) begin
			
			A_WR_PTR_THRESH: assert (wr_ptr < FIFO_DEPTH) 
				else $error("Threshold Bug: wr_ptr exceeded max index (FIFO_DEPTH-1)");
			C_WR_PTR_THRESH: cover  (wr_ptr < FIFO_DEPTH);

			A_RD_PTR_THRESH: assert (rd_ptr < FIFO_DEPTH) 
				else $error("Threshold Bug: rd_ptr exceeded max index (FIFO_DEPTH-1)");
			C_RD_PTR_THRESH: cover  (rd_ptr < FIFO_DEPTH);

			A_COUNT_THRESH:  assert (count <= FIFO_DEPTH) 
				else $error("Threshold Bug: internal count exceeded FIFO_DEPTH");
			C_COUNT_THRESH: cover   (count <= FIFO_DEPTH);

			end
		end
		
	`endif 
endmodule