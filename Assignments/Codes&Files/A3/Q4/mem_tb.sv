module mem_tb;

    bit clk;
    logic write, read;
    logic [7:0]  data_in,data_out;
    logic [15:0] address;

    localparam TESTS = 100;

    logic [15:0] address_array[];
    logic [7:0]  data_to_write_array[];
    logic [7:0]  data_read_expect_assoc[int];
    logic [7:0]  data_read_queue[$];

    initial begin
        clk = 0;
        forever #2  clk = ~clk;
    end

    my_mem DUT (
        .clk(clk),
        .write(write),
        .read(read),
        .data_in(data_in),
        .address(address),
        .data_out(data_out)
    );

    integer error_count, correct_count;

    task stimulus_gen;
        address_array       = new[TESTS];  
        data_to_write_array = new[TESTS];
        for(int i = 0; i < TESTS; i++)begin
            address_array[i] = $urandom;
            data_to_write_array[i] = $random;
        end
    endtask

    task golden_model;
        for(int j = 0; j < TESTS; j++)begin
            data_read_expect_assoc[address_array[j]] = data_to_write_array[j];
        end
    endtask

    task check9Bits;

        @(negedge clk); 

        if (data_out === data_read_expect_assoc[address]) begin
            correct_count++;
        end else begin
            error_count++;
            $display("ERROR: Address = 0x%0h | Expected = %0d | Result = %0d",
                      address, data_read_expect_assoc[address], data_out);
        end
    endtask

    initial begin

        write         = 0;
        read          = 0;
        data_in       = 0;
        address       = 0;
        error_count   = 0;
        correct_count = 0;

        repeat(2)@(negedge clk);
        //MEM_1
        stimulus_gen();
        golden_model();

        //MEM_2
        write = 1;
        for(int k = 0; k < TESTS; k++)begin
            @(negedge clk);
            address = address_array[k];
            data_in = data_to_write_array [k];
        end

        repeat(2)@(negedge clk);

        //MEM3
        write         = 0;
        read          = 1;

        for(int l = 0; l < TESTS; l++)begin
            address = address_array[l];
            check9Bits();
            data_read_queue.push_back(data_out);
        end

        //MEM_4
        write         = 0;
        read          = 0;
        repeat(2)@(negedge clk);

        while (data_read_queue.size() > 0)
            $display("data = %0d", data_read_queue.pop_front());

        $display("%t: At end of test error count is %0d and correct count = %0d",
              $time, error_count, correct_count);
    $stop();    
    end

endmodule