module tb_cropping();
    logic CLOCK_50;
    logic [3:0] KEY;
    logic done;
    integer i;
    integer fd;

    // instiate boundingBoxTop
    top dut(.CLOCK_50(CLOCK_50), .KEY(KEY), .done(done));

    // clock cycle
    initial begin
        CLOCK_50 = 1'b0; 
        forever begin #10 CLOCK_50 = ~CLOCK_50;  end
    end

    initial begin
        // reset
        // #20;
        // // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        // $readmemh("../MATLAB/square.hex", dut.readMem);
        
        // #20;

        // KEY[3] = 1'b1;
        // #10;
        // KEY[3] = 1'b0;
        // #10;
        // KEY[3] = 1'b1;
        // #200;

        // while(~dut.done)
        // begin
        //     #10;
        // end

        // // $fwrite(fd, "%c", BMP_header[i][7:0]);
        // // $writememh("../MATLAB/output.hex", dut.writeMem);
        // fd = $fopen("squareOut.bmp", "wb+");
        // for(i=0; i<5826; i=i+1) begin
        //     $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        // end



        // #20;
        // // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        // $readmemh("../MATLAB/triangle.hex", dut.readMem);
        
        // #20;

        // KEY[3] = 1'b1;
        // #10;
        // KEY[3] = 1'b0;
        // #10;
        // KEY[3] = 1'b1;
        // #200;

        // while(~dut.done)
        // begin
        //     #10;
        // end

        // // $fwrite(fd, "%c", BMP_header[i][7:0]);
        // // $writememh("../MATLAB/output.hex", dut.writeMem);
        // fd = $fopen("triangleOut.bmp", "wb+");
        // for(i=0; i<5814; i=i+1) begin
        //     $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        // end


        // #20;
        // // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        // $readmemh("../MATLAB/circle.hex", dut.readMem);
        
        // #20;

        // KEY[3] = 1'b1;
        // #10;
        // KEY[3] = 1'b0;
        // #10;
        // KEY[3] = 1'b1;
        // #200;

        // while(~dut.done)
        // begin
        //     #10;
        // end

        // // $fwrite(fd, "%c", BMP_header[i][7:0]);
        // // $writememh("../MATLAB/output.hex", dut.writeMem);
        // fd = $fopen("circleOut.bmp", "wb+");
        // for(i=0; i<8790; i=i+1) begin
        //     $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        // end

        #20;
        // D:/main/2020fall/poo/beep-boop/kodim24.hex
        // $readmemh("D:/main/2020fall/poo/beep-boop/kodim24.hex", dut.ram);
        $readmemh("../MATLAB/windows.hex", dut.readMem);
        
        #20;

        KEY[3] = 1'b1;
        #10;
        KEY[3] = 1'b0;
        #10;
        KEY[3] = 1'b1;
        #200;

        while(~dut.done)
        begin
            #10;
        end

        // $fwrite(fd, "%c", BMP_header[i][7:0]);
        // $writememh("../MATLAB/output.hex", dut.writeMem);
        fd = $fopen("windowsOut.bmp", "wb+");
        for(i=0; i<8790; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        


        $display("done!");
        $stop;

        
    end
endmodule





















