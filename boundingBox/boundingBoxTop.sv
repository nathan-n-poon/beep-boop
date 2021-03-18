module boundingBoxTop(
    input logic CLOCK_50, input logic reset_n,
    output logic[15:0] xMaxOut, output logic[15:0] xMinOut,
    output logic[15:0] yMaxOut, output logic[15:0] yMinOut
);
    logic start;
    logic done;
    
    // instantiate a RAM, store max of 4 bytes, total of 
    // ffffffff = 4294967295
    // ram[index] = 
    // read, rddata <= ram[index]
    // write, ram[index] <= wrdata
    // logic [7:0] ram [783125:0];
    logic [7:0] ram [29999:0];
    
    // instantiate boundingbox
    logic[15:0] rddata;
    logic[31:0] addr;
    logic[15:0] xMin;
    logic[15:0] xMax;
    logic[15:0] yMin;
    logic[15:0] yMax;
    boundingBox boundingBox(.clk(CLOCK_50), .rst_n(reset_n), .start(start), .done(done),
                                .rddata(rddata), .addr(addr),
                                .xMin(xMin), .xMax(xMax),
                                .yMin(yMin), .yMax(yMax));

    enum {init, processing, finished} state = init;
    
    always@(posedge CLOCK_50) begin
        if(~reset_n) begin
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
    assign xMinOut = xMin;
    assign xMaxOut = xMax;
    assign yMinOut = yMin;
    assign yMaxOut = yMax;
endmodule