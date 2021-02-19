module cropTop(
    input logic CLOCK_50, input logic [3:0] KEY, output logic done
);
    logic start_cropping, start_header = 0;
    logic doneValue = 0;
    logic done_cropping;
    logic done_header;

    // mem for 100x100 pictures
    logic [7:0] readMem [29999:0];
    logic [7:0] writeMem [29999:0];

    // instantiate boundingbox
    logic[31:0] readaddr;
    logic[15:0] readdata;
    logic[31:0] writeAddr;
    logic[15:0] wrdata;
    logic wrenCrop;    
    logic[10:0] xMin = 28;
    logic[10:0] yMin = 29;
    logic[10:0] xMax = 79;
    logic[10:0] yMax = 65;
    cropping cropping(.clk(CLOCK_50), .rst_n(KEY[3]), .start(start_cropping), .done(done_cropping),
                                .readAddr(readaddr), .readdata(readdata),
                                .writeAddr(writeAddr), .wrdata(wrdata), .wren(wrenCrop),
                                .xMin(xMin), .xMax(xMax), .yMin(yMin), .yMax(yMax));

    logic [23:0] headerAddr;
    logic wrenHeader;
    logic [15:0] wrdata_header;

    header header(.clk(CLOCK_50), .rst_n(KEY[3]),
                        .start(start_header), .done(done_header),
                        .addr(headerAddr), .wren(wrenHeader), .wrdata(wrdata_header),
                        .xMin(xMin), .xMax(xMax),
                        .yMin(yMin), .yMax(yMax));

    enum {init, process_header, process_cropping, finished} state = init;

    assign done = doneValue;

    always@(posedge CLOCK_50) begin
        if(~KEY[3]) begin
            state <= init;
            doneValue <= 0;
        end
        else begin
            doneValue <= 0;
            case(state)
                init: begin
                    start_header <= 1; // start processing header
                    start_cropping <= 0;
                    state <= process_header;
                end
                process_header: begin
                    start_header <= 0; // deassert start_header
                    if(wrenHeader)
                    begin
                        writeMem[headerAddr] <= wrdata_header;
                    end
                    if(done_header) begin
                        start_cropping <= 1;
                        state <= process_cropping;
                    end
                    else begin
                        state <= process_header;
                    end
                end
                process_cropping: 
                begin
                    start_cropping <= 0; // deassert start_cropping
                    readdata <= readMem[readaddr];
                    if(wrenCrop)
                    begin
                        writeMem[writeAddr] <= wrdata;
                    end
                    if(done_cropping) begin
                        state <= finished;
                    end
                    else begin
                        state <= process_cropping;
                    end
                end
                finished: begin
                    state <= finished;
                    doneValue <= 1;
                end
            endcase
        end
    end
endmodule