package alsu_scoreboard_pkg;
import alsu_sequence_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class alsu_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(alsu_scoreboard)
        uvm_analysis_export #(alsu_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(alsu_seq_item) sb_fifo;
        alsu_seq_item seq_item_sb;

        // Reference Model related Signals
        logic signed [5:0] alsu_out_ref;
        logic [15:0]       alsu_leds_ref;
        logic              red_op_A_reg, red_op_B_reg;
        logic              bypass_A_reg, bypass_B_reg;
        logic              direction_reg, serial_in_reg;
        logic signed [1:0] cin_reg;
        logic [2:0]        opcode_reg;
        logic signed [2:0] A_reg, B_reg;

        int error_count   = 0;
        int correct_count = 0;

        function new(string name = "alsu_scoreboard", uvm_component parent = null);
            super.new(name, parent);
            alsu_out_ref  = 0;
            alsu_leds_ref = 0;
            cin_reg       = 0;
            red_op_A_reg  = 0;
            red_op_B_reg  = 0;
            bypass_A_reg  = 0;
            bypass_B_reg  = 0;
            direction_reg = 0;
            serial_in_reg = 0;
            opcode_reg    = 0;
            A_reg         = 0;
            B_reg         = 0;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo   = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);

                if(seq_item_sb.out !== alsu_out_ref) begin
                    `uvm_error("run_phase",
                        $sformatf("Out Comparison Failed: out = %0d  out_exp = %0d | Transaction Received: %s",
                                  seq_item_sb.out, alsu_out_ref, seq_item_sb.convert2string()))
                    error_count++;
                end else begin
                    `uvm_info("run_phase",
                        $sformatf("Correct: out = %0d | %s",
                                  seq_item_sb.out, seq_item_sb.convert2string()), UVM_HIGH)
                    correct_count++;
                end

                if(seq_item_sb.leds !== alsu_leds_ref) begin
                    `uvm_error("run_phase",
                        $sformatf("LEDS Comparison Failed: leds = %0b leds_exp = %0b",
                                  seq_item_sb.leds, alsu_leds_ref))
                    error_count++;
                end
            end
        endtask

        task ref_model(alsu_seq_item seq_item_chk);
            logic invalid_red_op, invalid_opcode, invalid;


            invalid_red_op = (red_op_A_reg | red_op_B_reg) &
                             (opcode_reg[1] | opcode_reg[2]);
            invalid_opcode = opcode_reg[1] & opcode_reg[2];
            invalid        = invalid_red_op | invalid_opcode;

            if(seq_item_chk.rst) begin

                alsu_leds_ref = 0;
                alsu_out_ref  = 0;
            end
            else begin

                if(invalid)
                    alsu_leds_ref = ~alsu_leds_ref;
                else
                    alsu_leds_ref = 0;

                if(bypass_A_reg && bypass_B_reg)
                    alsu_out_ref = (INPUT_PRIORITY == "A") ? A_reg : B_reg;
                else if(bypass_A_reg)
                    alsu_out_ref = A_reg;
                else if(bypass_B_reg)
                    alsu_out_ref = B_reg;
                else if(invalid)
                    alsu_out_ref = 0;
                else begin
                    case(opcode_reg)
                        3'h0: begin 
                            if(red_op_A_reg && red_op_B_reg)
                                alsu_out_ref = (INPUT_PRIORITY == "A") ? |A_reg : |B_reg;
                            else if(red_op_A_reg)
                                alsu_out_ref = |A_reg;
                            else if(red_op_B_reg)
                                alsu_out_ref = |B_reg;
                            else
                                alsu_out_ref = A_reg | B_reg;
                        end
                        3'h1: begin 
                            if(red_op_A_reg && red_op_B_reg)
                                alsu_out_ref = (INPUT_PRIORITY == "A") ? ^A_reg : ^B_reg;
                            else if(red_op_A_reg)
                                alsu_out_ref = ^A_reg;
                            else if(red_op_B_reg)
                                alsu_out_ref = ^B_reg;
                            else
                                alsu_out_ref = A_reg ^ B_reg;
                        end
                        3'h2: alsu_out_ref = A_reg + B_reg + cin_reg; 
                        3'h3: alsu_out_ref = A_reg * B_reg;           
                        3'h4: begin 
                            if(direction_reg)
                                alsu_out_ref = {alsu_out_ref[4:0], serial_in_reg};
                            else
                                alsu_out_ref = {serial_in_reg, alsu_out_ref[5:1]};
                        end
                        3'h5: begin 
                            if(direction_reg)
                                alsu_out_ref = {alsu_out_ref[4:0], alsu_out_ref[5]};
                            else
                                alsu_out_ref = {alsu_out_ref[0], alsu_out_ref[5:1]};
                        end
                        default: alsu_out_ref = 0;
                    endcase
                end
            end

            if(seq_item_chk.rst) begin
                cin_reg       = 0;
                red_op_A_reg  = 0;
                red_op_B_reg  = 0;
                bypass_A_reg  = 0;
                bypass_B_reg  = 0;
                direction_reg = 0;
                serial_in_reg = 0;
                opcode_reg    = 0;
                A_reg         = 0;
                B_reg         = 0;
            end else begin
                cin_reg       = seq_item_chk.cin;
                red_op_A_reg  = seq_item_chk.red_op_A;
                red_op_B_reg  = seq_item_chk.red_op_B;
                bypass_A_reg  = seq_item_chk.bypass_A;
                bypass_B_reg  = seq_item_chk.bypass_B;
                direction_reg = seq_item_chk.direction;
                serial_in_reg = seq_item_chk.serial_in;
                opcode_reg    = seq_item_chk.opcode;
                A_reg         = seq_item_chk.A;
                B_reg         = seq_item_chk.B;
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("Report Phase",
                $sformatf("Total Successful Transactions = %0d", correct_count), UVM_MEDIUM);
            `uvm_info("Report Phase",
                $sformatf("Total Failed Transactions = %0d", error_count), UVM_MEDIUM);
        endfunction
    endclass
endpackage
