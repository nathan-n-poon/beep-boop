// #include <stdio.h>
// //3437096703
// int main() {
//     // int x = 1128 >> 4;
//     // printf("%d \n", x);
//     // printf("%d", 1128 - x*16);
    
    //msb
//     long orig = 3437096703;
//     long divideBoi = orig >> 8;
//     long remainder = orig - divideBoi * 16 * 16;
//     printf("%ld %ld %ld\n", orig, divideBoi, remainder);
    
    //msb - 1
//     orig = divideBoi;
//     divideBoi = orig >> 8;
//     remainder = orig - divideBoi * 16 * 16;
//     printf("%ld %ld %ld\n", orig, divideBoi, remainder); 
    
    //msb - 2
//     orig = divideBoi;
//     divideBoi = orig >> 8;
//     remainder = orig - divideBoi * 16 * 16;
//     printf("%ld %ld %ld\n", orig, divideBoi, remainder);
    
    //lsb
//     orig = divideBoi;
//     divideBoi = orig >> 8;
//     remainder = orig - divideBoi * 16 * 16;
//     printf("%ld %ld %ld\n", orig, divideBoi, remainder);
//     return 0;
// }

module header 
(
    input logic clk, input logic rst_n,
    input logic start, output logic done,
    output logic [23:0] addr, output logic wren, output logic [15:0] wrdata,
    input logic[10:0] xMin, input logic[10:0] xMax,
    input logic[10:0] yMin, input logic[10:0] yMax
);

    logic doneValue = 0;
    logic [23:0] addrValue = 0;
    logic wrenValue = 0;
    logic [15:0] wrdataValue = 0;

    assign done = doneValue;
    assign addr = addrValue;
    assign wren = wrenValue;
    assign wrdata = wrdataValue;
    
    logic [31:0] size;
    logic [15:0] dividendFloor;
    logic [15:0] remainder;

    enum {init, msb, msb-1, msb-2, lsb, finished} state = init;

    always@(posedge clk)
    begin
        if (!rst_n)
        begin
            addrValue <= 0;
            wrenValue <= 0;
            wrdataValue <= 0;
            state <= init;
        end

        else
        begin
            case (state)
                init:
                begin
                    if(start) // start the process when start is asserted
                    begin
                        area <= (xMax - xMin) * (yMax - yMin);
                        state <= msb;
                    end
                    else 
                    begin
                        state <= init;
                    end
                end

                msb:
                begin
                    state <= msb-1;
                end

                msb-1:
                begin
                    state <= msb-2;
                end

                msb-2:
                begin
                    state <= lsb;
                end

                lsb:
                begin
                    state <= finished
                end

                finished:
                begin
                    if(start)
                    begin
                        area <= (xMax - xMin) * (yMax - yMin);
                        addrValue <= 0;
                        wrenValue <= 0;
                        wrdataValue <= 0;
                        state <= msb;
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
        done = 0;
        case(state) 
        begin
            init:
            begin
                addr = 0;
                wren = 0;
                wrdata = 0;
            end

            msb:
            begin
                addr = 0;
                wren = 1;
                dividendFloor = area >> 8;
                remainder = area - dividendFloor * 16 * 16;
                wrdata = remainder;
                area = dividendFloor;
            end

            msb-1:
            begin
                addr = 1; //this is really sus
                wren = 1;
                dividendFloor = area >> 8;
                remainder = area - dividendFloor * 16 * 16;
                wrdata = remainder;
                area = dividendFloor;
            end
            
            msb-2:
            begin
                addr = 2; //this is really sus
                wren = 1;
                dividendFloor = area >> 8;
                remainder = area - dividendFloor * 16 * 16;
                wrdata = remainder;
                area = dividendFloor;
            end

            lsb:
            begin
                addr = 3; //this is really sus
                wren = 1;
                dividendFloor = area >> 8;
                remainder = area - dividendFloor * 16 * 16;
                wrdata = remainder;
                area = dividendFloor;
            end

            finished:
            begin
                done = 1;
                wren = 0;
                wrdata = 0;
                addr = 0;
            end

        end
    end


endmodule
