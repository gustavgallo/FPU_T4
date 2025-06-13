module FPU(
input logic clock,
input logic reset,
input logic [31:0] op_A_in,
input logic [31:0] op_B_in,

output logic [31:0] data_out,
output logic [3:0] status_out


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
logic [5:0] exp_A, exp_B, exp_diff, exp_result;
logic signal [25:0] Valor_A, Valor_B; // 1 bit a mais
logic signal [25:0] Mantissa_A, Mantissa_B; // 1 bit a mais
logic signed [25:0] mantissa_sum; // 1 bit a mais
logic signal_result; 
logic greater; // A = 0, B = 1
logic start = 1;
logic PRE_done = 0;
logic SUM_done = 0;
logic ended = 0;

assign logic BIAS = 31;

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
                    Valor_A <= {1, op_A_in[24:0]};
                    Valor_B <= {1, op_B_in[24:0]};
                    exp_A <= op_A_in[30:25] - BIAS;
                    exp_B <= op_B_in[30:25] - BIAS;
                    start <= 0;

                    if(op_A_in[30:25] >= op_B_in[30:25])begin
                        exp_diff <= (op_A_in[30:25] - op_B_in[30:25]) - BIAS;
                        exp_result <= op_A_in[30:25] - BIAS;
                        signal_result <= op_A_in[31] - BIAS;
                        greater <= 0;
                
                    end else begin

                        exp_diff <= (op_B_in[30:25] - op_A_in[30:25]) - BIAS;
                        exp_result <= op_B_in[30:25] - BIAS;
                        signal_result <= op_B_in[31] - BIAS;
                        greater <= 1;
                    end

                    end else begin
                        if(!PRE_done)begin
                            if(!greater)begin // if A is greater than
                                Valor_B <= Valor_B >> exp_diff;
                            end else begin // if B is greater

                                Valor_A <= Valor_A >> exp_diff;

                            end
                            PRE_done <= 1;
                        end    
                    end// end do else
            end

            AJUST:begin
                Mantissa_A <= Valor_A[24:0];
                Mantissa_B <= Valor_B[24:0];


                /*if(op_A_in[31])begin
                    Mantissa_A <= -Mantissa_A;
                end

                if(op_B_in[31])begin
                    Mantissa_B <= -Mantissa_B;
                end*/
                PRE_done <= 0;
            end

            SUM:begin

                if (!SUM_done) begin
                    mantissa_sum <= Mantissa_A + Mantissa_B;
                    SUM_done <= 1;
                end 
                else begin
                    // Overflow: se bit 25 aceso, normaliza para direita
                    if (mantissa_sum[25]) begin
                        mantissa_sum <= mantissa_sum >> 1;
                        exp_result <= exp_result + 1;
                        
                    end
                    // Underflow: se bit 24 zerado, normaliza para esquerda
                    /*
                    else if (mantissa_sum[24] == 0 && mantissa_sum != 0 && exp_result > 0) begin
                        mantissa_sum <= mantissa_sum << 1;
                        exp_result <= exp_result - 1;
                        
                    end
                    */
                    else begin
                        // Mantissa normalizada
                        data_out[31]    <= signal_result;
                        data_out[30:25] <= exp_result;
                        data_out[24:0]  <= mantissa_sum[24:0];
                        ended <= 1;
                    end
                end

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

                EA <= SUM; 
                
            end

            SUM:begin

                if(ended) EA <= PRE_SUM;
                else EA <= SUM;
            end

        endcase

    end
end


endmodule