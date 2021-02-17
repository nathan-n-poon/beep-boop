module dividebythree
(
    input logic clk, output logic [7:0] out
);

    logic [7:0] value = 6;

    always@(posedge clk) begin
        out <= value/3;
    end
endmodule