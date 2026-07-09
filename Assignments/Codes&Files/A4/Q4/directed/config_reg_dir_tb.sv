module config_reg_dir_tb ();

    bit clk, reset;
    bit write;
    logic [15:0] data_in, data_out;
    logic [2:0] address;

    typedef enum logic [2:0]{adc0_reg, adc1_reg, temp_sensor0_reg, temp_sensor1_reg, 
                            analog_test, digital_test, amp_gain, digital_config} reg_address;
    
    reg_address test_reg;
    
    logic [15:0] reset_assoc [string];
    logic [15:0] expected_assoc [string];
    
    parameter MAXPOS = 16'hFFFF;
    parameter MAXNEG = 16'h8000;
    parameter ZERO   = 16'h0000;

    initial begin
        clk = 0;
        forever 
            #1 clk = ~clk;
    end

    config_reg DUT(.*);

    integer correct_count, error_count;

    initial begin
        reset_assoc["adc0_reg"]         = 16'hFFFF;
        reset_assoc["adc1_reg"]         = 16'h0;
        reset_assoc["temp_sensor0_reg"] = 16'h0;
        reset_assoc["temp_sensor1_reg"] = 16'h0;
        reset_assoc["analog_test"]      = 16'hABCD;
        reset_assoc["digital_test"]     = 16'h0;
        reset_assoc["amp_gain"]         = 16'h0;
        reset_assoc["digital_config"]   = 16'h1;
        expected_assoc = reset_assoc;  

        correct_count = 0;
        error_count   = 0;
        write         = 0;
        address       = 0;
        data_in       = 0;

        assert_reset();
        
        // BUG 1
        assert_reset();

        // BUG 2
        test_reg = temp_sensor1_reg;
        address  = temp_sensor1_reg;
        data_in  = MAXPOS;
        write    = 1;
        check_result();
        assert_reset();

        // BUG 3
        test_reg = temp_sensor0_reg;
        address  = temp_sensor0_reg;
        data_in  = 16'h0001;
        write    = 1;
        check_result();

        // BUG 4
        test_reg = digital_test;
        address  = digital_test;
        data_in  = MAXPOS;
        write    = 1;
        check_result();
        write    = 0;
        check_result();

        // BUG 5
        test_reg = digital_config;
        address  = digital_config;
        data_in  = 16'h8000;
        write    = 1;
        check_result();
        write    = 0;
        check_result();

        // BUG 6
        test_reg = adc0_reg;
        address  = adc0_reg;
        data_in  = 16'hFFFF;
        write    = 1;
        check_result();
        data_in  = 16'h7FFF;
        write    = 1;
        check_result();
        write    = 0;
        check_result();

        // BUG 7
        test_reg = adc1_reg;
        address  = adc1_reg;
        data_in  = 16'h8000;
        write    = 1;
        check_result();
        write    = 0;
        check_result();
        data_in  = 16'h0080;
        write    = 1;
        check_result();
        write    = 0;
        check_result();

        // BUG 8
        test_reg = amp_gain;
        address  = amp_gain;
        data_in  = 16'hBEEF;
        write    = 1;
        check_result();
        repeat(8) @(posedge clk);
        write    = 0;
        check_result();
        $display("Simulation done: Correct = %0d | Errors = %0d", correct_count, error_count);
        $stop;
    end

    task check_result;

        reg_address current_reg;          
        current_reg = reg_address'(address);  

        if(reset == 1'b1) begin
            test_reg = test_reg.first();
            for(int i = 0; i < reset_assoc.size(); i++) begin
                address = test_reg;
                @(negedge clk);
                if(reset_assoc[test_reg.name()] != data_out) begin
                    error_count++;
                    $display("%t: Error in Reset: address = 0x%0h | data_out = 0x%0h | data_exp = 0x%0h", 
                                $time,address , data_out, reset_assoc[test_reg.name()]);
                end
                else
                    correct_count++;
                test_reg = test_reg.next();    
            end
        end
        
        else if(write == 1'b1) begin
            @(negedge clk);
            if(data_out != data_in) begin
                error_count++;
                $display("%t: Error in Write: address = 0x%0h | data_out = 0x%0h | data_in = 0x%0h",
                            $time, address, data_out, data_in);
            end
            else begin
                correct_count++;
                expected_assoc[current_reg.name()] = data_in;  
            end
        end

        else begin
            @(negedge clk);
            if(data_out != expected_assoc[current_reg.name()]) begin
                error_count++;
                $display("%t: Error in Read : address = 0x%0h | data_out = 0x%0h | expected = 0x%0h",
                            $time, address, data_out, expected_assoc[current_reg.name()]);
            end
        else
                correct_count++;
        end 
    endtask

    task assert_reset;
        reset = 1; 
        check_result();
        expected_assoc = reset_assoc;
        reset = 0;
    endtask 
endmodule