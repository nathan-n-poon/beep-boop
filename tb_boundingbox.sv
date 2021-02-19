module tb_boundingBox();
    logic CLOCK_50;
    logic [3:0] KEY;

    // instiate boundingBoxTop
    boundingBoxTop dut(.CLOCK_50(CLOCK_50), .KEY(KEY));

    // clock cycle
    initial begin
        CLOCK_50 = 1'b0; 
        forever begin #10 CLOCK_50 = ~CLOCK_50;  end
    end

    initial begin
        // reset
        #20;
        $readmemh("C:/Users/natha/OneDrive/Documents/MATLAB/test.hex", dut.ram);
        #20;

        
        KEY[3] = 1'b0;
        #10;
        KEY[3] = 1'b1;
        #200;

        while(~dut.done)
        begin
            #10;
        end

        $display("done!");
        $stop;

        
    end
endmodule





















