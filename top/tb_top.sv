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

        //-------------------------------------------------------------------------------------------------------------------

        #20;

        $readmemh("../MATLAB/square.hex", dut.readMem);
        
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

        fd = $fopen("squareOut.bmp", "wb+");
        for(i=0; i<5826; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------

        #20;

        $readmemh("../MATLAB/triangle.hex", dut.readMem);
        
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


        fd = $fopen("triangleOut.bmp", "wb+");
        for(i=0; i<5814; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------


        #20;
        $readmemh("../MATLAB/circle.hex", dut.readMem);
        
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


        fd = $fopen("circleOut.bmp", "wb+");
        for(i=0; i<8790; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------
        
        #20;

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

        fd = $fopen("windowsOut.bmp", "wb+");
        for(i=0; i<3726; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------

        #20;

        $readmemh("../MATLAB/windows2.hex", dut.readMem);
        
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


        fd = $fopen("window2sOut.bmp", "wb+");
        for(i=0; i<3726; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------

        #20;

        $readmemh("../MATLAB/windows3.hex", dut.readMem);
        
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


        fd = $fopen("window3sOut.bmp", "wb+");
        for(i=0; i<5562; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------

        #20;

        $readmemh("../MATLAB/windows4.hex", dut.readMem);
        
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


        fd = $fopen("window4sOut.bmp", "wb+");
        for(i=0; i<2910; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------

        #20;

        $readmemh("../MATLAB/shape.hex", dut.readMem);

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


        fd = $fopen("shapeOut.bmp", "wb+");
        for(i=0; i<15182; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------

        #20;

        $readmemh("../MATLAB/sushi.hex", dut.readMem);

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


        fd = $fopen("sushiOut.bmp", "wb+");
        for(i=0; i<18294; i=i+1) begin
            $fwrite(fd, "%c", dut.writeMem[i][7:0]); // write the header
        end

        //-------------------------------------------------------------------------------------------------------------------
        



        $display("done!");
        $stop;

        
    end
endmodule





















