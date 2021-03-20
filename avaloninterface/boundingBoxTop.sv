// consists of 2 phases:
// phase 1: load image into the RAM
// phase 2: perform boundingBox module
module boundingBoxTop(
    input logic CLOCK_50, input logic reset_n,
    input logic rd_en, input logic wr_en,

    // input logic [7:0] hex_value, // hex value to be stored into RAM
    // input logic [16:0] hex_index, // index of the RAM where hex_value would be stored
    input logic [31:0] hex_value_index, // hex_value [31:24], hex_index [23:0]
    output logic [31:0] coordinates // xMin stored in [31:24], xMax[23:16], yMin[15:8], yMax[7:0]
);
    parameter BBRESET = 99999;   // any arbitrary big num
    logic start;
    logic done;
    logic [7:0] ram [29999:0];
    
    // instantiate boundingbox
    logic[15:0] rddata;
    logic[31:0] addr;
    logic[7:0] xMin, xMax, yMin, yMax; // small picture of 100x100 => 8 bits enough for x,y
    boundingBox boundingBox(.clk(CLOCK_50), .rst_n(reset_n), .start(start), .done(done),
                                .rddata(rddata), .addr(addr),
                                .xMin(xMin), .xMax(xMax),
                                .yMin(yMin), .yMax(yMax));

    // phase 1 store data into RAM
    always@(posedge CLOCK_50) begin
        if(~reset_n) begin  // default value is 0
            start <= 0;
        end
        else if (wr_en == 1) begin
            ram[hex_value_index[23:0]] <= hex_value_index[31:24];
        end
    end

    // phase 2 performing boudingBox
    enum {init, processing, finished} state = finished;
    always@(posedge CLOCK_50) begin
        if(hex_value_index[23:0] == BBRESET) begin
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

    assign coordinates = {xMin, xMax, yMin, yMax}; // assign output
endmodule