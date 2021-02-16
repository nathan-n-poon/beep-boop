//rddata: the entire pixel or only one of RGB?
//addr: where in the hex file to read the above data (no writing here)
//xMin, xMax: the samllest and lagrest x coordinates for where the image is not the background colour. Returns the R position of the pixel
//yMin, yMax: the samllest and lagrest y coordinates for where the image is not the background colour. Returns the R position of the pixel
//start/done: on reset, done = 0. when start = 1, we drop done and start processing. AFter processing, done is raised. We restart when start is reasserted. done indicates valid data.
module boundingBox 
#(
    parameter WIDTH = 100, 					// Image width
	HEIGHT 	= 100 						    // Image height
)
(
    input logic clk, input logic rst_n,
    input logic start, output logic done,
    input logic [7:0] rddata, output logic [23:0] addr,
    output logic[10:0] xMin, output logic[10:0] xMax,
    output logic[10:0] yMin, output logic[10:0] yMax
);
    
    logic doneValue;
    logic [10:0] xMinValue = WIDTH - 1;
    logic [10:0] xMaxValue = 0;
    logic [10:0] yMinValue = HEIGHT * 3 - 1;
    logic [10:0] yMaxValue = 0;

    assign done = doneValue;
    assign xMin = xMinValue;
    assign xMax = xMaxValue;
    assign yMin = yMinValue;
    assign yMax = yMaxValue;

    reg [10:0] xPos = 0;
    reg [10:0] yPos = 0;


    assign addr = xPos * HEIGHT * 3 + yPos;

    enum {init, yIncr, xIncr, finished} state = init;

    //what is state
    always@(posedge clk)
    begin
        if (!rst_n)
        begin
            xMinValue <= WIDTH - 1;
            xMaxValue <= 0;
            yMinValue <= HEIGHT * 3 - 1;
            yMaxValue <= 0;
            xPos <= 0;
            yPos <= 0;
            state <= init;
        end

        else
        begin
            case (state)
                init:
                begin
                    if(start) // start the process when start is asserted
                    begin
                        state <= yIncr;
                    end
                    else 
                    begin
                        state <= init;
                    end
                end

                yIncr:
                begin
                    if(yPos < HEIGHT * 3 - 1)
                    begin
                        yPos <= yPos + 1;
                        state <= yIncr;
                    end
                    else if (yPos == HEIGHT * 3 - 1 && xPos < WIDTH - 1)
                    begin
                        xPos <= xPos + 1;
                        yPos <= 0;
                        state <= xIncr;
                    end
                    else //if(yPos == HEIGHT * 3 - 1 && xPos == WIDTH - 1)
                    begin
                        state <= finished;
                    end

                    if(rddata >= 5) 
                    begin
                        if(xPos < xMinValue) 
                        begin
                            xMinValue <= xPos;
                        end
                        if(xPos > xMaxValue)
                        begin
                            xMaxValue <= xPos;
                        end
                        if(yPos < yMinValue)
                        begin
                            if(yPos%3 == 1) begin
                                yMinValue <= yPos - 1;
                            end
                            else if(yPos%3 == 2) begin
                                yMinValue <= yPos - 2;
                            end
                            else begin
                                yMinValue <= yPos;
                            end
                        end
                        if(yPos > yMaxValue)
                        begin
                            if(yPos%3 == 1) begin
                                yMaxValue <= yPos - 1;
                            end
                            else if(yPos%3 == 2) begin
                                yMaxValue <= yPos - 2;
                            end
                            else begin
                                yMaxValue <= yPos;
                            end
                        end
                    end
                end

                xIncr:
                begin
                    yPos <= yPos + 1;
                    state <= yIncr;

                    if(rddata >= 5) 
                    begin
                        if(xPos < xMinValue) 
                        begin
                            xMinValue <= xPos;
                        end
                        if(xPos > xMaxValue)
                        begin
                            xMaxValue <= xPos;
                        end
                        if(yPos < yMinValue)
                        begin
                            if(yPos%3 == 1) begin
                                yMinValue <= yPos - 1;
                            end
                            else if(yPos%3 == 2) begin
                                yMinValue <= yPos - 2;
                            end
                            else begin
                                yMinValue <= yPos;
                            end
                        end
                        if(yPos > yMaxValue)
                        begin
                            if(yPos%3 == 1) begin
                                yMaxValue <= yPos - 1;
                            end
                            else if(yPos%3 == 2) begin
                                yMaxValue <= yPos - 2;
                            end
                            else begin
                                yMaxValue <= yPos;
                            end
                        end
                    end
                end

                finished:
                begin
                    if(start)
                    begin
                        xMinValue <= WIDTH - 1;
                        xMaxValue <= 0;
                        yMinValue <= HEIGHT * 3 - 1;
                        yMaxValue <= 0;
                        xPos <= 0;
                        yPos <= 0;
                        state <= yIncr;
                    end
                    else
                    begin
                        state <= finished;
                    end
                end
            endcase
        end
    end
    
    //output
    always @(*)
    begin
        doneValue = 0;
        begin
            if(state != finished) 
            begin
                doneValue = 0;
            end
            else 
            begin
                doneValue = 1;
            end
        end
    end
endmodule