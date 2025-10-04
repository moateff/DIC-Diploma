package fifo_coverage_pkg;
import fifo_transaction_pkg::*;

class fifo_coverage;
    fifo_transaction F_cvg_txn =  new();

    covergroup cvr_grp;
        wr_en_cp: coverpoint F_cvg_txn.wr_en{
            bins wr_en_0 = {0};
            bins wr_en_1 = {1};
            option.weight = 0;
        }

        rd_en_cp: coverpoint F_cvg_txn.rd_en{
            bins rd_en_0 = {0};
            bins rd_en_1 = {1};
            option.weight = 0;
        }

        wr_ack_cp: coverpoint F_cvg_txn.wr_ack{
            bins wr_ack_0 = {0};
            bins wr_ack_1 = {1};
            option.weight = 0;
        }

        overflow_cp: coverpoint F_cvg_txn.overflow{
            bins overflow_0 = {0};
            bins overflow_1 = {1};
            option.weight = 0;
        }

        full_cp: coverpoint F_cvg_txn.full{
            bins full_0 = {0};
            bins full_1 = {1};
            option.weight = 0;
        }    

        empty_cp: coverpoint F_cvg_txn.empty{
            bins empty_0 = {0};
            bins empty_1 = {1};
            option.weight = 0;
        }

        almostfull_cp: coverpoint F_cvg_txn.almostfull{
            bins almostfull_0 = {0};
            bins almostfull_1 = {1};
            option.weight = 0;
        }

        almostempty_cp: coverpoint F_cvg_txn.almostempty{
            bins almostempty_0 = {0};
            bins almostempty_1 = {1};
            option.weight = 0;
        } 

        underflow_cp: coverpoint F_cvg_txn.underflow{
            bins underflow_0 = {0};
            bins underflow_1 = {1};
            option.weight = 0;
        }       

        wr_ack_cross: cross wr_en_cp, rd_en_cp, wr_ack_cp{
            illegal_bins wr_en_0 = binsof(wr_ack_cp) intersect {1} && binsof(wr_en_cp) intersect {0};
        }

        full_cross: cross wr_en_cp, rd_en_cp, full_cp{
            illegal_bins rd_en = binsof(full_cp) intersect {1} && binsof(rd_en_cp) intersect {1} ;
        }

        almostfull_cross: cross wr_en_cp, rd_en_cp, almostfull_cp;

        overflow_cross: cross wr_en_cp, rd_en_cp, overflow_cp{
            illegal_bins wr_en_0 = binsof(overflow_cp) intersect {1} && binsof(wr_en_cp) intersect {0};
        }

        empty_cross: cross wr_en_cp, rd_en_cp, empty_cp;

        almostempty_cross: cross wr_en_cp, rd_en_cp, almostempty_cp;

        underflow_cross: cross wr_en_cp, rd_en_cp, underflow_cp{
            illegal_bins rd_en_1 =binsof(underflow_cp) intersect {1} && binsof(rd_en_cp) intersect {0};
        }
    endgroup

    function new();
        cvr_grp = new();
    endfunction

    function void sample_data(fifo_transaction F_txn);
        F_cvg_txn = F_txn;
        cvr_grp.sample();
    endfunction
endclass : fifo_coverage

endpackage : fifo_coverage_pkg