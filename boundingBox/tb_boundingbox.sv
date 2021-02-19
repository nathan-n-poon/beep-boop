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
        // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        $readmemh("C:/Users/natha/OneDrive/Documents/MATLAB/square.hex", dut.ram);
        #20;

        
        KEY[3] = 1'b0;
        #20;
        KEY[3] = 1'b1;
        #200;

        while(~dut.done)
        begin
            #10;
        end

        assert(dut.xMin == 28 && dut.yMin == 29 && dut.xMax == 79 && dut.yMax == 65)
        else
        begin
            $display("expected values: 28 29 79 65 \n");
            $display("actual values: %d %d %d %d \n", dut.xMin, dut.yMin, dut.xMax, dut.yMax);
            // $stop;
        end

        #20;
        // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        $readmemh("C:/Users/natha/OneDrive/Documents/MATLAB/triangle.hex", dut.ram);
        #20;

        
        KEY[3] = 1'b0;
        #20;
        KEY[3] = 1'b1;
        #200;

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

        #20;
        // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        $readmemh("C:/Users/natha/OneDrive/Documents/MATLAB/circle.hex", dut.ram);
        #20;

        
        KEY[3] = 1'b0;
        #20;
        KEY[3] = 1'b1;
        #200;

        while(~dut.done)
        begin
            #10;
        end

        assert(dut.xMin == 27 && dut.yMin == 27 && dut.xMax == 81 && dut.yMax == 78)
                else
        begin
            $display("expected values: 27 27 81 78 \n");
            $display("actual values: %d %d %d %d \n", dut.xMin, dut.yMin, dut.xMax, dut.yMax);
            // $stop;
        end

        #20;
        // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        $readmemh("C:/Users/natha/OneDrive/Documents/MATLAB/shape.hex", dut.ram);
        #20;

        
        KEY[3] = 1'b0;
        #20;
        KEY[3] = 1'b1;
        #200;

        while(~dut.done)
        begin
            #10;
        end

        assert(dut.xMin == 4 && dut.yMin == 16 && dut.xMax == 84 && dut.yMax == 77)
                else
        begin
            $display("expected values: 4 16 84 77 \n");
            $display("actual values: %d %d %d %d \n", dut.xMin, dut.yMin, dut.xMax, dut.yMax);
            // $stop;
        end

        #20;
        // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        $readmemh("C:/Users/natha/OneDrive/Documents/MATLAB/bottomRight.hex", dut.ram);
        #20;

        
        KEY[3] = 1'b0;
        #20;
        KEY[3] = 1'b1;
        #200;

        while(~dut.done)
        begin
            #10;
        end

        assert(dut.xMin == 99 && dut.yMin == 99 && dut.xMax == 99 && dut.yMax == 99)
                else
        begin
            $display("expected values: 99 99 99 99 \n");
            $display("actual values: %d %d %d %d \n", dut.xMin, dut.yMin, dut.xMax, dut.yMax);
            // $stop;
        end


                #20;
        // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        $readmemh("C:/Users/natha/OneDrive/Documents/MATLAB/topLeft.hex", dut.ram);
        #20;

        
        KEY[3] = 1'b0;
        #20;
        KEY[3] = 1'b1;
        #200;

        while(~dut.done)
        begin
            #10;
        end

        assert(dut.xMin == 0 && dut.yMin == 0 && dut.xMax == 0 && dut.yMax == 0)
                else
        begin
            $display("expected values: 0 0 0 0 \n");
            $display("actual values: %d %d %d %d \n", dut.xMin, dut.yMin, dut.xMax, dut.yMax);
            // $stop;
        end
        

        

        $display("done!");
        $stop;

        
    end
endmodule





















