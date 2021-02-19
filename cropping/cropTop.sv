module cropTop(
    input logic CLOCK_50, input logic [3:0] KEY
);
    logic start;
    logic done;

    logic [7:0] readMem [29999:0];
    logic [7:0] writeMem [29999:0];

    // instantiate boundingbox
    logic[31:0] readaddr;
    logic[15:0] readdata;
    logic[31:0] writeAddr;
    logic[15:0] wrdata;
    logic wren;    
    logic[10:0] xMin = 10;
    logic[10:0] xMax = 20;
    logic[10:0] yMin = 60;
    logic[10:0] yMax = 70;
    cropping cropping(.clk(CLOCK_50), .rst_n(KEY[3]), .start(start), .done(done),
                                .readAddr(readaddr), .readdata(readdata),
                                .writeAddr(writeAddr), .wrdata(wrdata), .wren(wren),
                                .xMin(xMin), .xMax(xMax), .yMin(yMin), .yMax(yMax));

    enum {init, processing, finished} state = init;

    always@(posedge CLOCK_50) begin
        if(~KEY[3]) begin
            state <= init;
            start <= 1;
        end
        else begin
            case(state)
                init: begin
                    start <= 1; // start processing
                    state <= processing;
                end
                processing: begin
                    start <= 0; // deassert start
                    readdata <= readMem[readaddr]; // pass rddata to boundingBox
                    if(wren) 
                    begin
                    writeMem[writeAddr] <= wrdata;
                    end
                    if(done) begin
                        state <= finished;
                    end
                    else begin
                        state <= processing;
                    end
                end
                finished: begin
                    state <= finished;
                end
            endcase
        end
    end
endmodule