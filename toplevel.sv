module toplevel
(
    input logic clk, input logic rst_n,
);

// inferred RAM
logic [31:0] ram [127:0]