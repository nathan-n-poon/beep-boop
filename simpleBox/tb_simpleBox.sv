module tb_simpleBox();
    logic CLOCK_50;
    logic reset_n;
    logic rd_en;
    logic wr_en;
    logic [31:0] hex_value_index;
    logic [15:0] value;
    logic [31:0] out;

    integer i;
    parameter WIDTH = 100, HEIGHT = 100;
    parameter RESET = 99999;
    logic [7:0] tb_ram [29999:0];

    // instiate boundingBoxTop
    simpleBox dut(.CLOCK_50(CLOCK_50), .reset_n(reset_n),
                        .rd_en(rd_en), .wr_en(wr_en),
                        .hex_value_index(hex_value_index),
                        .out(out));

    // clock cycle
    initial begin
        CLOCK_50 = 1'b0; 
        forever begin #10 CLOCK_50 = ~CLOCK_50;  end
    end

    initial begin
        // load image into tb_ram
        #20;
        $readmemh("../MATLAB/triangle.hex", tb_ram);
        #20;

        // reset
        reset_n = 1'b0;
        #20;
        reset_n = 1'b1;
        #20;

        for(i = 0; i < WIDTH*HEIGHT*3; i = i + 1) begin
            wr_en = 1;
            hex_value_index[23:0] = 0;
            hex_value_index[31:24] = tb_ram[i];
            value = tb_ram[i];
            #20;
        end
        wr_en = 0;
        #20;

        assert(dut.xMin == 28 && dut.yMin == 34 && dut.xMax == 69 && dut.yMax == 78)
                else
        begin
            $display("expected values: 28 34 69 78 \n");
            $display("actual values: %d %d %d %d \n", dut.xMin, dut.yMin, dut.xMax, dut.yMax);
            // $stop;
        end

        // ------------------------------------------------------------------
        // load image into tb_ram
        #20;
        $readmemh("../MATLAB/shape.hex", tb_ram);
        #20;

        // reset
        hex_value_index[23:0] = RESET; // trigger start for boundingBox module
        #20;
        hex_value_index[23:0] = RESET + 1;
        #20;

        for(i = 0; i < WIDTH*HEIGHT*3; i = i + 1) begin
            wr_en = 1;
            hex_value_index[23:0] = 0;
            hex_value_index[31:24] = tb_ram[i];
            value = tb_ram[i];
            #20;
        end
        wr_en = 0;
        #20;

        assert(dut.xMin == 4 && dut.yMin == 16 && dut.xMax == 84 && dut.yMax == 77)
                else
        begin
            $display("expected values: 4 16 84 77 \n");
            $display("actual values: %d %d %d %d \n", dut.xMin, dut.yMin, dut.xMax, dut.yMax);
            // $stop;
        end
        $display("done!");
        $stop;
    end
endmodule





















