module FPU(
input logic clock;
input logic reset;
logic input [31:0] op_A_in;
logic input [31:0] op_B_in;

logic output [31:0] data_out;
logic output [3:0] status_out;


);

// 24106524-2
// X = 8 + (2+4+1+0+6+5+2+4+2) % 4
// X = 8 - 2
// X = 6

// Y = 31 - 6
// Y = 25

// [31] = Signal
// [30:25] = Exponent
// [24: 0] = Mantissa

// BIAS = 2⁽⁵⁾- 1
// BIAS = 31

typedef enum logic [1:0]{  
    
    DECODE,

    CALC

} state_t;

state_t EA;
logic [31:0] decoded_A, decoded_B;
logic [5:0] exp_A, exp_B;

always_ff @(posedge clock, negedge reset)begin

    if(!reset)begin
    data_out <= 0;
    status_out<=0;
    
    end else begin
        
        case(EA)

            DECODE:begin
                if(!op_A_in)begin
                decoded_A <=
                end else begin
                decoded_A <=

                end

                if(!op_B_in)begin
                decoded_B <=
                end else begin
                decoded_B <=

                end

            end

            CALC:begin


            end



        endcase

    end
end


// Here stands the state machine
always_ff @(posedge clock, negedge reset)begin

    if(!reset)begin
    EA <= DECODE;
    
    end else begin
        
        case(EA)

            DECODE:begin


            end

            CALC:begin


            end



        endcase

    end
end



endmodule