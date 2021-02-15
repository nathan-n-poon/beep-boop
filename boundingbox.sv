module boundingBox 
#(
    parameter WIDTH = 100, 					// Image width
	HEIGHT 	= 100, 						// Image height
	INFILE  = "kodim24.hex"
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

     //what is state
     always@(posedge clk, negedge rst_n)
     begin
          if (!rst_n)
          begin
               yPos <= 0;
               xPos <= 0;
               state <= init;
          end
          else
          begin
               yPos <= 0;
               xPos <= 0;
               state <= init;
               case (state)
                    init:
                    begin
                         if(en)
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