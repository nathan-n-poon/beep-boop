
module boundingBox 
#(
    parameter WIDTH = 100, 					// Image width
	HEIGHT 	= 100, 						// Image height
	INFILE  = "kodim24.hex"
)
(
    input logic clk, input logic rst_n,
    input logic en, output logic rdy,
    input logic [7:0] rddata, output logic [7:0] addr,
    output logic[10:0] xMin, output logic[10:0] xMax,
    output logic[10:0] yMin, output logic[10:0] yMax
);
    
    logic rdyValue;
    logic [10:0] xMinValue = WIDTH;
    logic [10:0] xMaxValue = 0;
    logic [10:0] yMinValue = HEIGHT;
    logic [10:0] yMaxValue = 0;

    assign rdy = rdyValue;
    assign xMin = xMinValue;
    assign xMax = xMaxValue;
    assign yMin = yMinValue;
    assign yMax = yMaxValue;

     reg [10:0] xPos = 0;
     reg [10:0] yPos = 0;


    assign addr = xPos * HEIGHT + yPos;

    enum {idle, init, yIncr, xIncr} state = idle;


     //what is state
     always@(posedge clk)
     begin
          if (!rst_n)
          begin
               yPos <= 0;
               xPos <= 0;
               state <= idle;
          end
          else
          begin
               yPos <= 0;
               xPos <= 0;
               state <= init;
               case (state)
                    idle:
                    begin
                         if(en)
                         begin
                              state <= init;
                         end

                         else 
                         begin
                              state <= idle;
                         end
                    end

                    init:
                    begin
                         state <= yIncr;

                         if(rddata >= 5) 
                         begin
                              if(xPos < xMinValue) 
                              begin
                                   xMinValue = xPos;
                              end
                              if(xPos > xMaxValue)
                              begin
                                   xMaxValue = xPos;
                              end
                              if(yPos < yMinValue)
                              begin
                                   yMinValue = yPos;
                              end
                              if(yPos > yMaxValue)
                              begin
                                   yMaxValue = yPos;
                              end
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
                              state <= idle;
                         end

                         if(rddata >= 5) 
                         begin
                              if(xPos < xMinValue) 
                              begin
                                   xMinValue = xPos;
                              end
                              if(xPos > xMaxValue)
                              begin
                                   xMaxValue = xPos;
                              end
                              if(yPos < yMinValue)
                              begin
                                   yMinValue = yPos;
                              end
                              if(yPos > yMaxValue)
                              begin
                                   yMaxValue = yPos;
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
                                   xMinValue = xPos;
                              end
                              if(xPos > xMaxValue)
                              begin
                                   xMaxValue = xPos;
                              end
                              if(yPos < yMinValue)
                              begin
                                   yMinValue = yPos;
                              end
                              if(yPos > yMaxValue)
                              begin
                                   yMaxValue = yPos;
                              end
                         end
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

     //output
     always @(*)
     begin

          rdyValue = 0;
          
          begin
               if(state != idle) 
               begin
                    rdyValue = 0;
               end
               else 
               begin
                    rdyValue = 1;
               end
          end
     end

     

endmodule