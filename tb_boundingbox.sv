module tb_boundingbox();
    logic clk, rst_n;

    logic start, done;
    logic [15:0] rddata;
    logic [23:0] addr;
    logic[10:0] xMin, xMax, yMin, yMax;

    // instiate top_boundingbox

    initial begin
        // please insert test here
    end
endmodule

module top_boundingbox();

// instantiate a RAM

// instantiate boundingbox
boundingbox boundingbox(.clk(clk), .rst_n(rst_n), .start(start), .done(done),
                            .rddata(rddata), .addr(addr),
                            .xMin(xMin), .xMax(xMax),
                            .yMin(yMin), .yMax(yMax));