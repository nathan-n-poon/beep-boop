module boundingBoxTop(
    input logic CLOCK_50, input logic [3:0] KEY
);
    logic start;
    logic done;
    
    // instantiate a RAM, store max of 4 bytes, total of 
    // ffffffff = 4294967295
    // ram[index] = 
    // read, rddata <= ram[index]
    // write, ram[index] <= wrdata
    logic [7:0] ram [30000:0];

    // instantiate boundingbox
    logic[15:0] rddata;
    logic[31:0] addr;
    logic[10:0] xMin;
    logic[10:0] xMax;
    logic[10:0] yMin;
    logic[10:0] yMax;
    boundingBox boundingBox(.clk(CLOCK_50), .rst_n(KEY[3]), .start(start), .done(done),
                                .rddata(rddata), .addr(addr),
                                .xMin(xMin), .xMax(xMax),
                                .yMin(yMin), .yMax(yMax));

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
                    rddata <= ram[addr]; // pass rddata to boundingBox
                    if(~done) begin
                        state <= processing;
                    end
                    else begin
                        state <= finished;
                    end
                end
                finished: begin
                    state <= finished;
                end
            endcase
        end
    end
endmodule