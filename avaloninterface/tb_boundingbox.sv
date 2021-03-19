module tb_boundingBox();
    logic CLOCK_50;
    logic reset_n;
    logic rd_en;
    logic wr_en;
    logic [31:0] hex_value_index;
    logic [31:0] coordinates;

    integer i;
    parameter WIDTH = 100, HEIGHT = 100;
    parameter BBRESET = 99999;
    logic [7:0] tb_ram [29999:0];

    // instiate boundingBoxTop
    boundingBoxTop dut(.CLOCK_50(CLOCK_50), .reset_n(reset_n),
                        .rd_en(rd_en), .wr_en(wr_en),
                        .hex_value_index(hex_value_index),
                        .coordinates(coordinates));

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

        // phase 1
        for(i = 0; i < WIDTH*HEIGHT*3; i = i + 1) begin
            hex_value_index[23:0] = i;
            hex_value_index[31:24] = tb_ram[i];
            #20;
        end

        // phase 2
        hex_value_index[23:0] = BBRESET; // trigger start for boundingBox module
        #20

        while(~dut.done)
        begin
            #10;
        end

        assert(dut.xMin == 28 && dut.yMin == 34 && dut.xMax == 69 && dut.yMax == 78)
                else
        begin
            $display("expected values: 28 34 69 78 \n");
            $display("actual values: %d %d %d %d \n", dut.xMin, dut.yMin, dut.xMax, dut.yMax);
            // $stop;
        end
        $display("done!");
        $stop;
    end
endmodule





















