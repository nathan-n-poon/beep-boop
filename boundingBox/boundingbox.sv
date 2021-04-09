//Purpose:
//reads in image and returns min/max x and y values where pixel does not match background
//reads in hex representation of image, going over each rgb for each pixel.
//once it finds a pixel sufficiently different from the background, it may update the min/max
//if current pixel is less than min / greater than max.
//Although RGB are assessed individually, the x and y of the pixel as a whole is returned. 

//ARGS/RETURN:
//rddata: only one of RGB
//addr: where in the hex file to read the above data (no writing here)
//xMin, xMax: the samllest and lagrest x coordinates for where the image is not the background colour.
//yMin, yMax: the samllest and lagrest y coordinates for where the image is not the background colour.
//start/done: on reset, done = 0. when start = 1, we drop done and start processing. After processing, done is raised. We restart when start is reasserted. done indicates valid data.
//PARAMETERS: Hardware catures fixed dimensions bmp
module boundingBox 
#(
    parameter WIDTH = 100, 					// Image width
	HEIGHT 	= 100 						    // Image height
)
(
    input logic clk, input logic rst_n,
    input logic start, output logic done,
    input logic [15:0] rddata, output logic [31:0] addr,
    output logic[15:0] xMin, output logic[15:0] xMax,
    output logic[15:0] yMin, output logic[15:0] yMax
);
    
    logic doneValue = 0;
    //init min to max values and max to min values
    logic [15:0] xMinValue = WIDTH - 1;
    logic [15:0] xMaxValue = 0;
    logic [15:0] yMinValue = HEIGHT - 1;
    logic [15:0] yMaxValue = 0;

    assign done = doneValue;
    assign xMin = xMinValue;
    assign xMax = xMaxValue;
    assign yMin = yMinValue;
    assign yMax = yMaxValue;

    //counters analogous to:
    //x loop, y loop, and rgb loop nested within each other
    reg [15:0] xPos = 0;
    reg [15:0] yPos = 0;
    reg [1:0] rgb = 0;

    // xPos is not at its max, don't want to read onto the next pixel
    logic correction;
    assign correction = (rgb == 2 && xPos != (WIDTH-1))? 1 : 0;
    assign addr = (HEIGHT - yPos - 1) * WIDTH * 3 + xPos * 3 + rgb + correction;

    //states definition:
    //init: idle state before start is asserted. 
    //readMem: starts mem read request for next memory, and reads in previously requested value
    // updates min/max values if pixel colour detected
    //finished: states that processing is complete and min/max are correct. A new process can start if start is asserted
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
                    //255 is max possible value. If any of a pixel's rgb values are less than 250, we count it as
                    //not a background. 255,255,255 corresponds to white
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

                    //tries to increments rgb loop first
                    if(rgb + 1 < 3)
                    begin
                        rgb <= rgb + 1;
                        state <= readMem;
                    end
                    
                    // then tries to increment x loop
                    else
                    begin
                        rgb <= 0;
                        if(xPos + 1 < WIDTH)
                        begin
                            xPos <= xPos + 1;
                            state <= readMem;
                        end
                        // then tries to increment y loop
                        else 
                        begin
                            xPos <= 0;
                            if(yPos + 1 < HEIGHT)
                            begin
                                yPos <= yPos + 1;
                                state <= readMem;
                            end

                            //breaks loop
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
                    //restarts process when start asserted again
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