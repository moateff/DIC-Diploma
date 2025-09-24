module counter_sva (counter_if.DUT c_if);
    always_comb begin
        if(~c_if.rst_n) begin
            assert_reset: assert final(c_if.count_out == 0);
        end
    end

    property load_p;
        @(posedge c_if.clk) disable iff (~c_if.rst_n) (~c_if.load_n) |=> (c_if.count_out == $past(c_if.data_load));
    endproperty

    property count_stable_p;
        @(posedge c_if.clk) disable iff (~c_if.rst_n) (c_if.load_n && ~c_if.ce) |=> (c_if.count_out == $past(c_if.count_out));
    endproperty

    property inc_count_p;
        @(posedge c_if.clk) disable iff (~c_if.rst_n) (c_if.load_n && c_if.ce && c_if.up_down) |=> (c_if.count_out == ($past(c_if.count_out) + 1'b1));
    endproperty

    property dec_count_p;
        @(posedge c_if.clk) disable iff (~c_if.rst_n) (c_if.load_n && c_if.ce && ~c_if.up_down) |=> (c_if.count_out == ($past(c_if.count_out) - 1'b1));
    endproperty

    property zero_p;
        @(posedge c_if.clk) disable iff (~c_if.rst_n) (c_if.count_out == {c_if.WIDTH{1'b0}}) |-> (c_if.zero == 1'b1);
    endproperty

    property max_p;
        @(posedge c_if.clk) disable iff (~c_if.rst_n) (c_if.count_out == {c_if.WIDTH{1'b1}}) |-> (c_if.max_count == 1'b1)
    endproperty

    assert_load_p: assert property(load_p);
    assert_count_stable_p: assert property(count_stable_p);
    assert_inc_count_p: assert property(inc_count_p);
    assert_dec_count_p: assert property(dec_count_p);
    assert_zero_p: assert property(zero_p);
    assert_max_p: assert property(max_p);

    cover_load_p: assert property(load_p);
    cover_count_stable_p: assert property(count_stable_p);
    cover_inc_count_p: assert property(inc_count_p);
    cover_dec_count_p: assert property(dec_count_p);
    cover_zero_p: assert property(zero_p);
    cover_max_p: assert property(max_p);    
endmodule