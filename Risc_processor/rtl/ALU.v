module ALU(
 input  [15:0] a,  //src1
 input  [15:0] b,  //src2
 input  [2:0] alu_control, //function sel
 
 output reg [15:0] result,  //result 
 output zero
    );

always @(*) begin 
 case(alu_control)
 3'b000: result = a + b; // add
 3'b001: result = a - b; // sub
 3'b010: result = ~a;    // 1's complement (INV)
 3'b011: result = a << b; // Logical Shift Left (LSL)
 3'b100: result = a >> b; // Logical Shift Right (LSR)
 3'b101: result = a & b; // Bitwise AND
 3'b110: result = a | b; // Bitwise OR
 3'b111: begin // Set on Less Than (SLT)
    if (a < b) 
        result = 16'd1;
    else 
        result = 16'd0;
    end
 default:result = a + b; // Default to add
 endcase
end

// Zero flag assignment: set to 1 if result is 0, otherwise 0
assign zero = (result == 16'd0) ? 1'b1 : 1'b0;

endmodule