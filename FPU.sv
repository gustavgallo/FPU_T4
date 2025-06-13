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
    
    PRE_SUM,

    SUM,

    AJUST

} state_t;

state_t EA;
logic [5:0] exp_A, exp_B, exp_diff;
logic signal [24:0] Mantissa_A, Mantissa_B;
logic signal_result; 
logic greater; // A = 0, B = 1
logic start = 1;
logic PRE_done = 0;






always_ff @(posedge clock, negedge reset)begin

    if(!reset)begin
    data_out <= 0;
    status_out<=0;
    start <= 1;
    PRE_done = 0;
    
    end else begin
        
        case(EA)

            PRE_SUM:begin
                if(start)begin
                    Mantissa_A <= {1, op_A_in[24:0]};
                    Mantissa_B <= {1, op_B_in[24:0]};
                    exp_A <= op_A_in[30:25];
                    exp_B <= op_B_in[30:25];
                    start <= 0;

                    if(op_A_in[30:25] >= op_B_in[30:25])begin
                        exp_diff <= (op_A_in[30:25] - op_B_in[30:25]);
                        signal_result <= op_A_in[31];
                        greater <= 0;
                
                    end else begin

                        exp_diff <= (op_B_in[30:25] - op_A_in[30:25]);
                        signal_result <= op_B_in[31];
                        greater <= 1;
                    end

                    end else begin
                        if(!PRE_done)begin
                            if(!greater)begin // if A is greater than
                                Mantissa_B <= Mantissa_B >> exp_diff;
                            end else begin // if B is greater

                                Mantissa_A <= Mantissa_A >> exp_diff;

                            end
                            PRE_done <= 1;
                        end    
                    end// end do else
            end

            AJUST:begin
                if(op_A_in[31])begin
                    Mantissa_A <= -Mantissa_A;
                end

                if(op_B_in[31])begin
                    Mantissa_B <= -Mantissa_B;
                end

            end

            SUM:begin

                



            end
            



        endcase

    end
end


// Here stands the state machine
always_ff @(posedge clock, negedge reset)begin

    if(!reset)begin
    EA <= PRE_SUM;
    
    end else begin
        
        case(EA)

            PRE_SUM:begin
                if(PRE_done) EA <= AJUST;
                else EA <= PRE_SUM;

            end

            AJUST:begin



            end

            SUM:begin


            end

            



        endcase

    end
end



endmodule