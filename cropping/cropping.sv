module cropping 
#(
    parameter WIDTH = 100, 					// Image width
	HEIGHT 	= 100 						    // Image height
)
(
    input logic clk, input logic rst_n,
    input logic start, output logic done,
    output logic [31:0] readAddr, input logic [15:0] readdata,
    output logic [31:0] writeAddr, output logic [15:0] wrdata, output logic wren,
    input logic[10:0] xMin, input logic[10:0] xMax,
    input logic[10:0] yMin, input logic[10:0] yMax
);

    logic doneValue = 0;
    logic [31:0] readAddrValue;
    logic [31:0] writeAddrValue = 54;
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
    reg [10:0] yPos = yMax;
    reg [1:0] rgb = 0;
    reg [1:0] paddingCounter = 0;

    enum {init, readMem, writeMem, padding, finished} state = init;

    logic validPixel;

    assign validPixel = (xPos <= xMax && xPos >= xMin) && (yPos <= yMax && yPos >= yMin);
    assign readAddrValue = yPos * WIDTH * 3 + xPos * 3 + rgb;

    always@(posedge clk)
    begin
        if (!rst_n)
        begin
            xPos <= xMin;
            yPos <= yMax;
            rgb <= 0;
            paddingCounter <= 0;

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
                    // writeAddrValue <= writeAddrValue + 1;
                    state <= writeMem;
                end

                writeMem:
                begin
                    // readdataValue = readdata;
                    writeAddrValue <= writeAddrValue + 1;
                    if(rgb + 1 < 3)
                    begin
                        rgb <= rgb + 1;
                        state <= readMem;
                    end

                    else
                    begin
                        rgb <= 0;
                        if(xPos + 1 < xMax)
                        begin
                            xPos <= xPos + 1;
                            state <= readMem;
                        end
                        else // 3 pixels * picture width + padding % 4?
                        begin
                            if(((3*(xPos - xMin + 1) + paddingCounter) & 3) != 0)
                            begin
                                state <= padding;
                            end
                            else
                            begin
                                xPos <= xMin;
                                if(yPos - 1 >= 0)
                                begin
                                    yPos <= yPos - 1;
                                    state <= readMem;
                                end
                                else
                                begin
                                    xPos <= xMin;
                                    yPos <= yMax;
                                    rgb <= 0;
                                    paddingCounter <= 0; //finish padding, reset counter
                                    state <= finished;
                                end
                            end
                        end
                    end
                end

                padding:
                begin
                    writeAddrValue <= writeAddrValue + 1;

                    // check multiple of 4
                    if(((3*(xPos - xMin + 1) + paddingCounter) & 3) != 0)
                    begin
                        state <= padding;
                        paddingCounter <= paddingCounter + 1; // add 1 byte of padding at a time
                    end
                    else
                    begin
                        xPos <= xMin;
                        if(yPos - 1 >= 0)
                        begin
                            yPos <= yPos - 1;
                            state <= readMem;
                        end
                        else
                        begin
                            xPos <= xMin;
                            yPos <= yMax;
                            rgb <= 0;
                            paddingCounter <= 0; //finish padding, reset counter
                            state <= finished;
                        end
                    end

                end

                finished:
                begin
                    if(start)
                    begin
                        xPos <= xMin;
                        yPos <= yMax;
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

            padding:
            begin
                doneValue = 0;
                wrenValue = 1;
                wrdataValue = 0;
            end

            finished:
            begin
                doneValue = 1;
                wrenValue = 0;
                wrdataValue = 0;
            end
        endcase
        
    end

endmodule