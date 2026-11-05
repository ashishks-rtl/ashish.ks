module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);

wire sum_intermediate;

assign sum_intermediate = a^b;

assign cout = (a&b) | (sum_intermediate&cin);
assign sum = sum_intermediate^cin; 


endmodule