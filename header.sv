// #include <stdio.h>
// //3437096703
// int main() {
//     // int x = 1128 >> 4;
//     // printf("%d \n", x);
//     // printf("%d", 1128 - x*16);
    
//     long orig = 3437096703;
//     long divideBoi = orig >> 8;
//     long remainder = orig - divideBoi * 16 * 16;
//     printf("%ld %ld %ld\n", orig, divideBoi, remainder);
    
//     orig = divideBoi;
//     divideBoi = orig >> 8;
//     remainder = orig - divideBoi * 16 * 16;
//     printf("%ld %ld %ld\n", orig, divideBoi, remainder);
    
//     orig = divideBoi;
//     divideBoi = orig >> 8;
//     remainder = orig - divideBoi * 16 * 16;
//     printf("%ld %ld %ld\n", orig, divideBoi, remainder);
    
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
    output logic [23:0] addr, output logic wren, output logic [7:0] wrdata,
    input logic[10:0] xMin, input logic[10:0] xMax,
    input logic[10:0] yMin, input logic[10:0] yMax
);

    logic doneValue;
    logic [23:0] addrValue;
    logic wrenValue;
    logic [7:0] wrdataValue;

    assign done = doneValue;
    assign addr = addrValue;
    assign wren = wrenValue;
    assign wrdata = wrdataValue;

    enum {init, yIncr, xIncr, finished} state = init;
    



endmodule
