module boundingBox 
#(
    parameter WIDTH = 100, 					// Image width
	HEIGHT 	= 100, 						    // Image height
	INFILE1  = "background.hex"             // background
    INFILE2  = "backgroundobject.hex"       // background + object
)
(
    input logic clk, input logic rst_n,
    input logic en, output logic rdy,
    output logic [7:0] addr, output logic [7:0] wrdata, output logic wren,
    output logic[10:0] xMin, output logic[10:0] xMax,
    output logic[10:0] yMin, output logic[10:0] yMax
);
    
    logic rdyValue;
    logic [7:0] addrValue;
    logic [7:0] wrdataValue;
    logic wrenValue;
    logic [10:0] xMinValue;
    logic [10:0] xMaxValue;
    logic [10:0] yMinValue;
    logic [10:0] yMaxValue;

    assign rdy = rdyValue;
    assign addr = addrValue;
    assign wrdata = wrdataValue;
    assign wren = wrenValue;
    assign xMin = xMinValue;
    assign xMax = xMaxValue;
    assign yMin = yMinValue;
    assign yMax = yMaxValue;

    enum {idle, init, yIncr, xIncr, finished} state = idle;

    reg [7:0] xPos = 0;
    reg [6:0] yPos = 0;

    enum { init, yIncr, xIncr, finished} state = init;

    reg [7:0] xPos = 0;
    reg [6:0] yPos = 0;

    // ------------- READING from 2 images --------------
    reg doneRGB = 0;
    parameter sizeOfLengthReal = 30000; 		            // image data : 1179648 bytes: 512 * 768 *3 
    reg [7:0] mem_background [0:sizeOfLengthReal-1];	    // memory to store  8-bit data image of background
    reg [7:0] mem_object [0:sizeOfLengthReal-1]             // memory to store 8-bit data image of object

    // temporary memory for background : size will be WIDTH*HEIGHT*3
    integer background_BMP   [0 : WIDTH*HEIGHT*3 - 1];			
    integer background_R  [0 : WIDTH*HEIGHT - 1]; 	// temporary storage for R component
    integer background_G  [0 : WIDTH*HEIGHT - 1];	// temporary storage for G component
    integer background_B  [0 : WIDTH*HEIGHT - 1];	// temporary storage for B component

    // temporary memory for object : size will be WIDTH*HEIGHT*3
    integer object_BMP   [0 : WIDTH*HEIGHT*3 - 1];			
    integer object_R  [0 : WIDTH*HEIGHT - 1]; 	// temporary storage for R component
    integer object_G  [0 : WIDTH*HEIGHT - 1];	// temporary storage for G component
    integer object_B  [0 : WIDTH*HEIGHT - 1];	// temporary storage for B component

    initial begin
    $readmemh(INFILE1,mem_background,0,sizeOfLengthReal-1);   // read file from INFILE1
    end

    initial begin
    $readmemh(INFILE2,mem_object,0,sizeOfLengthReal-1);   // read file from INFILE2
    end

    // use 3 intermediate signals RGB to save image data
    // always@(start) begin
    //     if(start == 1'b1) begin
    //         for(i=0; i<WIDTH*HEIGHT*3 ; i=i+1) begin
    //             background_BMP[i] = mem_background[i+0][7:0];
    //             object_BMP[i] = mem_object[i+0][7:0];
    //         end
            
    //         for(i=0; i<HEIGHT; i=i+1) begin
    //             for(j=0; j<WIDTH; j=j+1) begin
    //                 background_R[WIDTH*i+j] = background_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+0];   // save Red component
    //                 background_G[WIDTH*i+j] = background_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+1];   // save Green component
    //                 background_B[WIDTH*i+j] = background_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+2];   // save Blue component

    //                 object_R[WIDTH*i+j] = object_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+0];   // save Red component
    //                 object_G[WIDTH*i+j] = object_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+1];   // save Green component
    //                 object_B[WIDTH*i+j] = object_BMP[WIDTH*3*(HEIGHT-i-1)+3*j+2];   // save Blue component
    //             end
    //         end
    //         doneRGB = 1; // finish copying RGB
    //     end
    // end

    // ----------- State Machine for finding coordinates -------------
    // should be done after extracting R,G,B
    always@(posedge clk, negedge rst_n)
    begin
        if (!rst_n)
        begin
            xMinValue <= WIDTH - 1;
            xMaxValue <= 0;
            yMinValue <= HEIGHT - 1;
            yMaxValue <= 0;

            yPos <= 0;
            xPos <= 0;
            state <= init;
        end
        else
        begin
            xMinValue <= WIDTH - 1;
            xMaxValue <= 0;
            yMinValue <= HEIGHT - 1;
            yMaxValue <= 0;

            yPos <= 0;
            xPos <= 0;
            state <= init;
            case (state)
                init:
                begin
                    if(en && doneRGB == 1) // when en and finished copying RGB
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
                    // update min, max for x & y
                    if(background_R != object_R || background_G != object_G || background_B != object_B)
                    begin
                        if(xPos < xMinValue) begin
                            xMinValue <= xPos;
                        end
                        if(yPos < yMinValue) begin
                            yMinValue <= yPos;
                        end
                        if(xPos > xMaxValue) begin
                            xMaxValue <= xPos;
                        end
                        if(yPos > yMaxValue) begin
                            yMaxValue <= yPos;
                        end
                    end

                    // handle states and incrementing
                    if(yPos < HEIGHT)
                    begin
                        yPos <= yPos + 1;
                        state <= yIncr;
                    end
                    else if (yPos == HEIGHT && xPos < WIDTH)
                    begin
                        xPos <= xPos + 1;
                        yPos <= 0;
                        state <= xIncr;
                    end
                    else //if(yPos == HEIGHT && xPos == WIDTH)
                    begin
                        state <= finished;
                    end
                end

                xIncr:
                begin
                    // update min, max for x & y
                    if(background_R != object_R || background_G != object_G || background_B != object_B)
                    begin
                        if(xPos < xMinValue) begin
                            xMinValue <= xPos;
                        end
                        if(yPos < yMinValue) begin
                            yMinValue <= yPos;
                        end
                        if(xPos > xMaxValue) begin
                            xMaxValue <= xPos;
                        end
                        if(yPos > yMaxValue) begin
                            yMaxValue <= yPos;
                        end
                    end

                    yPos <= yPos + 1;
                    state <= yIncr;
                end

                finished:
                begin
                    //  if(start)
                    //  begin
                    //       state <= finished;   
                    //  end

                    //  else
                    //  begin
                    //       yPos <= 0;
                    //       xPos <= 0;
                    //       state <= init;
                    //  end
                end
            endcase
        end
    end

endmodule