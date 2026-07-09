package alsu_coverage_pkg;
import alsu_sequence_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class alsu_coverage extends uvm_component;
        `uvm_component_utils(alsu_coverage)
        alsu_seq_item cov_seq_item;
        uvm_analysis_export #(alsu_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(alsu_seq_item) cov_fifo;

        covergroup cvr_grp;

            A_cp: coverpoint cov_seq_item.A {
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_corner   = {ZERO, MAXPOS, MAXNEG};
                bins A_data_default = default;
                bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100} iff(cov_seq_item.red_op_A);
            }

            B_cp: coverpoint cov_seq_item.B {
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_corner   = {ZERO, MAXPOS, MAXNEG};
                bins B_data_default = default;
                bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100} iff(cov_seq_item.red_op_B && !cov_seq_item.red_op_A);
            }

            ALU_cp: coverpoint cov_seq_item.opcode {
                bins Bins_shift[] = {SHIFT, ROTATE};
                bins Bins_arith[] = {ADD, MULT};
                bins Bins_bitwise[] = {OR, XOR};
                illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
                bins Bins_trans = (OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE);        
            }

            cin_cp: coverpoint cov_seq_item.cin {
                bins cin_0 = {0};
                bins cin_1 = {1};
            }

            direction_cp: coverpoint cov_seq_item.direction {
                bins direction_0 = {0};
                bins direction_1 = {1};
            }

            serial_in_cp: coverpoint cov_seq_item.serial_in {
                bins serial_in_0 = {0};
                bins serial_in_1 = {1};
            }

            red_op_A_cp: coverpoint cov_seq_item.red_op_A {
                bins red_op_A_0 = {0};
                bins red_op_A_1 = {1};
            }

            red_op_B_cp: coverpoint cov_seq_item.red_op_B {
                bins red_op_B_0 = {0};
                bins red_op_B_1 = {1};
            }

            Cross_cov: cross A_cp, 
                             B_cp, 
                             ALU_cp, 
                             red_op_A_cp, 
                             red_op_B_cp, 
                             direction_cp,
                             serial_in_cp, 
                             cin_cp {
                option.cross_auto_bin_max = 0;

                bins ARITH_AMP_BMP = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_max) && binsof(B_cp.B_data_max);
                bins ARITH_AMP_BMN = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_max) && binsof(B_cp.B_data_min);
                bins ARITH_AMP_BZE = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_max) && binsof(B_cp.B_data_0);

                bins ARITH_AMN_BMP = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_min) && binsof(B_cp.B_data_max);
                bins ARITH_AMN_BMN = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_min) && binsof(B_cp.B_data_min);
                bins ARITH_AMN_BZE = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_min) && binsof(B_cp.B_data_0);

                bins ARITH_AZE_BMP = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_0) && binsof(B_cp.B_data_max);
                bins ARITH_AZE_BMN = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_0) && binsof(B_cp.B_data_min);
                bins ARITH_AZE_BZE = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_0) && binsof(B_cp.B_data_0);

                bins ADD_CARRY0    = binsof(ALU_cp) intersect {ADD} && binsof(cin_cp.cin_0); 
                bins ADD_CARRY1    = binsof(ALU_cp) intersect {ADD} && binsof(cin_cp.cin_1); 

                bins SHFT_ROR_DIR0 = binsof(ALU_cp.Bins_shift) && binsof(direction_cp.direction_0);
                bins SHFT_ROR_DIR1 = binsof(ALU_cp.Bins_shift) && binsof(direction_cp.direction_1);

                bins SHIFT_IN0     = binsof(ALU_cp) intersect {SHIFT} && binsof(serial_in_cp.serial_in_0);
                bins SHIFT_IN1     = binsof(ALU_cp) intersect {SHIFT} && binsof(serial_in_cp.serial_in_1);

                bins BITWISE_PAT_0 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_1) && 
                                    binsof(A_cp.A_data_walkingones[0]) && binsof(B_cp.B_data_0);
                bins BITWISE_PAT_1 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_1) && 
                                    binsof(A_cp.A_data_walkingones[1]) && binsof(B_cp.B_data_0);
                bins BITWISE_PAT_2 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_1) && 
                                    binsof(A_cp.A_data_walkingones[2]) && binsof(B_cp.B_data_0);
                
                bins BITWISE_PAT_3 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_1) && 
                                    binsof(B_cp.B_data_walkingones[0]) && binsof(A_cp.A_data_0);
                bins BITWISE_PAT_4 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_1) && 
                                    binsof(B_cp.B_data_walkingones[1]) && binsof(A_cp.A_data_0);
                bins BITWISE_PAT_5 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_1) && 
                                    binsof(B_cp.B_data_walkingones[2]) && binsof(A_cp.A_data_0);

                illegal_bins INVALID_RED_OP_A  = binsof(red_op_A_cp.red_op_A_1) && (binsof(ALU_cp.Bins_arith) ||
                                                                                    binsof(ALU_cp.Bins_shift));  
                illegal_bins INVALID_RED_OP_B  = binsof(red_op_B_cp.red_op_B_1) && (binsof(ALU_cp.Bins_arith) ||
                                                                                    binsof(ALU_cp.Bins_shift));                 
            }
        endgroup

        function new(string name = "alsu_coverage", uvm_component parent = null);
            super.new(name, parent);
            cvr_grp = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(cov_seq_item);
                cvr_grp.sample();
            end
        endtask
    endclass
endpackage