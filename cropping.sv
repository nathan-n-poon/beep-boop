module cropping 
#(
    parameter WIDTH = 100, 					// Image width
	HEIGHT 	= 100 						    // Image height
)
(
    input logic clk, input logic rst_n,
    input logic start, output logic done,
    output logic [23:0] readAddr, input logic [15:0] readdata,
    output logic [23:0] writeAddr, output logic [15:0] wrdata, output logic wren,
    input logic[10:0] xMin, input logic[10:0] xMax,
    input logic[10:0] yMin, input logic[10:0] yMax
);

    logic doneValue = 0;
    logic [23:0] readAddrValue = 0;
    logic [23:0] writeAddrValue = 54;
    logic wrenValue = 0;
    logic [15:0] wrdataValue = 0;

    logic [15:0] readdataValue;

    assign readdataValue = readdata;

    assign done = doneValue;
    assign readAddr = readAddrValue;
    assign writeAddr = writeAddrValue;
    assign wren = wrenValue;
    assign wrdata = wrdataValue;

    reg [10:0] xPos = xMin;
    reg [10:0] yPos = yMin;
    reg [1:0] rgb = 0;

    enum {init, readMem, writeMem, finished} state = init;

    logic validPixel;

    assign validPixel = (xPos <= xMax || xPos >= xMin) && (yPos <= yMax || yPos >= yMin);
    assign readAddrValue = xPos * HEIGHT * 3 + yPos * 3 + rgb;

    always@(posedge clk)
    begin
        if (!rst_n)
        begin
            xPos <= xMin;
            yPos <= yMin;
            rgb <= 0;

            state <= init;
        end

        else
        begin
            case (state)
                init:
                begin
                    if(start) // start the process when start is asserted
                    begin
                        if(validPixel)
                        begin
                            state <= readMem;
                        end
                        else
                        begin
                            state <= finished;
                        end
                    end
                    else 
                    begin
                        state <= init;
                    end
                end

                readMem:
                begin
                    // readdataValue <= readdata;
                    writeAddrValue <= writeAddrValue + 1;
                    state <= writeMem;
                end

                writeMem:
                begin
                    // readdataValue = readdata;
                    if(rgb + 1 < 3)
                    begin
                        rgb <= rgb + 1;
                        state <= readMem;
                    end

                    else
                    begin
                        rgb <= 0;
                        if(yPos + 1 < yMax)
                        begin
                            yPos <= yPos + 1;
                            state <= readMem;
                        end
                        else
                        begin
                            yPos <= yMin;
                            if(xPos + 1 < xMax)
                            begin
                                xPos <= xPos + 1;
                                state <= readMem;
                            end
                            else
                            begin
                                xPos <= xMin;
                                yPos <= yMin;
                                rgb <= 0;
                                state <= finished;
                            end
                        end
                    end
                end

                finished:
                begin
                    if(start)
                    begin
                        xPos <= xMin;
                        yPos <= yMin;
                        rgb <= 0;
                        state <= readMem;
                    end
                    else
                    begin
                        state <= finished;
                    end
                end
            endcase
        end
    end

    always @(*)
    begin
        case (state)
        begin
            init:
            begin
                doneValue = 0;
                wrenValue = 0;
                wrdataValue = 0;
            end

            readMem:
            begin
                doneValue = 0;
                wrenValue = 0;
                wrdataValue = 0;
            end

            writeMem:
            begin
                doneValue = 0;
                wrenValue = 1;
                wrdataValue = readdataValue;
            end

            finished:
            begin
                doneValue = 1;
                wrenValue = 0;
                wrdataValue = 0;
            end
        end
        
    end

endmodule