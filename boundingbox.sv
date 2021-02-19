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
    input logic [15:0] rddata, output logic [31:0] addr,
    output logic[10:0] xMin, output logic[10:0] xMax,
    output logic[10:0] yMin, output logic[10:0] yMax
);
    
    logic doneValue;
    logic [10:0] xMinValue = WIDTH - 1;
    logic [10:0] xMaxValue = 0;
    logic [10:0] yMinValue = HEIGHT - 1;
    logic [10:0] yMaxValue = 0;

    assign done = doneValue;
    assign xMin = xMinValue;
    assign xMax = xMaxValue;
    assign yMin = yMinValue;
    assign yMax = yMaxValue;

    reg [10:0] xPos = 0;
    reg [10:0] yPos = 0;
    reg [1:0] rgb = 0;


    assign addr = yPos * WIDTH * 3 + xPos * 3 + rgb;

    enum {init, readMem, finished} state = init;

    //what is state
    always@(posedge clk)
    begin
        if (!rst_n)
        begin
            xMinValue <= WIDTH - 1;
            xMaxValue <= 0;
            yMinValue <= HEIGHT - 1;
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
                        state <= readMem;
                    end
                    else 
                    begin
                        state <= init;
                    end
                end

                readMem:
                begin
                    if(rddata < 250) 
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
                            yMinValue <= yPos;
                        end
                        if(yPos > yMaxValue)
                        begin
                            yMaxValue <= yPos;
                        end
                    end

                    if(rgb + 1 < 3)
                    begin
                        rgb <= rgb + 1;
                        state <= readMem;
                    end
                    
                    else
                    begin
                        rgb <= 0;
                        if(xPos + 1 < WIDTH)
                        begin
                            xPos <= xPos + 1;
                            state <= readMem;
                        end
                        else // 3 pixels * picture width + padding % 4?
                        begin
                            xPos <= 0;
                            if(yPos + 1 < HEIGHT)
                            begin
                                yPos <= yPos + 1;
                                state <= readMem;
                            end
                            else
                            begin
                                xPos <= 0;
                                yPos <= 0;
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
                        xMinValue <= WIDTH - 1;
                        xMaxValue <= 0;
                        yMinValue <= HEIGHT - 1;
                        yMaxValue <= 0;
                        xPos <= 0;
                        yPos <= 0;
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
    
    //output
    always @(*)
    begin
        doneValue <= 0;
        begin
            if(state != finished) 
            begin
                doneValue <= 0;
            end
            else 
            begin
                doneValue <= 1;
            end
        end
    end
endmodule