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

    AJUST,

    SUM,

    FINAL

} state_t;

state_t EA;


// Sinais internos
logic sign_a, sign_b;
logic signed [5:0] exp_a, exp_b; // expoente pode ser negativo
logic [24:0] mant_a, mant_b;
logic signed [5:0] exp_diff; // expoente pode ser negativo
logic [25:0] mant_a_aligned, mant_b_aligned;
logic signed [5:0] exp_common; // expoente pode ser negativo

localparam BIAS = 31;

//alinhamento das mantissas e expoentes
always_comb begin
    sign_a = op_A_in[31];
    exp_a  = op_A_in[30:25] - BIAS; // Ajusta o expoente subtraindo o bias
    mant_a = op_A_in[24:0];

    sign_b = op_B_in[31];
    exp_b  = op_B_in[30:25] - BIAS; // Ajusta o expoente subtraindo o bias
    mant_b = op_B_in[24:0];

    if (exp_a > exp_b) begin
        exp_diff = exp_a - exp_b;
        mant_a_aligned = {1'b1, mant_a}; // Adiciona o bit implícito 1 para números normalizados
        mant_b_aligned = {1'b1,mant_b} >> exp_diff; // Alinha mantissa b
        exp_common = exp_a;
    end else begin
        exp_diff = exp_b - exp_a;
        mant_a_aligned = {1'b1, mant_a} >> exp_diff;
        mant_b_aligned = {1'b1, mant_b};
        exp_common = exp_b;
    end

end


// lógica de soma e subtração
logic pre_done = 0;
logic [26:0] mant_res; // 27 bits
logic [25:0] mant_a_full, mant_b_full; // 26 bit
logic sign_res;
logic signed [5:0] exp_res;
logic ajusted = 0;
logic inexact = 0;
logic [5:0] exp_biased;
logic print_res = 0;
always_ff @(posedge clock, negedge reset)begin

    if(!reset) begin
        data_out <= 0;
        status_out <= 0;
        pre_done <= 0;
        mant_res <= 0;
        ajusted <= 0;
        mant_a_full <= 0;
        mant_b_full <= 0;
        sign_res <= 0;
        exp_res <= 0;
    end else begin
        
        case(EA)

            PRE_SUM:begin
                mant_a_full <= mant_a_aligned;
                mant_b_full <= mant_b_aligned;
                exp_res <= exp_common;
                pre_done <= 1;
                ajusted <= 0; // Reseta o sinal de ajuste
                mant_res <= 0; 


            end

            SUM: begin
                $display("sinal A %b", sign_a);
                $display("sinal B %b", sign_b);

                if (sign_a == sign_b) begin // sinais iguais soma
                    mant_res <= mant_a_full + mant_b_full;
                    sign_res <= sign_a;
                end else begin
                    if (mant_a_full > mant_b_full) begin // sinais diferentes subtração
                        mant_res <= mant_a_full - mant_b_full;
                        sign_res <= sign_a;
                    end else begin
                        mant_res <= mant_b_full - mant_a_full;
                        sign_res <= sign_b;
                    end
                end
            end

            AJUST: begin
                // adicionei verificação pra ve se é 0
                if (mant_res == 0) begin
                    ajusted <= 1;
                end else if (mant_res[26]) begin
                    mant_res <= mant_res >> 1;
                    exp_res <= exp_res + 1;
                    if(mant_res[0] == 1) inexact <= 1;
                end else if (!mant_res[25]) begin
                    mant_res <= mant_res << 1;
                    exp_res <= exp_res - 1;
                end else begin
                    ajusted <= 1;
                end
            end

            // Ajuste final do resultado
            FINAL: begin
                // Overflow
                if (exp_res > 33) begin
                    status_out <= 4'b0011;
                    
                end
                // Underflow
                else if (exp_res < -31) begin
                    status_out <= 4'b0111;
                    data_out   <= 0;
                end
                // Inexact
                else if (inexact) begin
                status_out <= 4'b1111;
                end
                // Exact
                else begin
                status_out <= 4'b0001;
                end
                exp_biased <= exp_res + BIAS;
                print_res <= 1;
                if(print_res)begin
                // verifica se é zero
                if (mant_res == 0) begin
                    // Zero: expoente e mantissa zerados, sinal tanto faz
                    data_out <= {sign_res, 6'b000000, 25'b0};
                end else begin
                    // Resultado normal: monta normalmente
                    data_out <= {sign_res, exp_biased[5:0], mant_res[24:0]};

                end
                print_res <= 0;
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
                if(pre_done) EA <= SUM;
                else EA <= PRE_SUM;

            end

            SUM:begin

                EA <= AJUST;

            end

            AJUST:begin
                if(ajusted) EA <= FINAL;
                else EA <= AJUST;
            end

            FINAL:begin
                if(print_res)begin
                    EA <= PRE_SUM; // Retorna ao estado inicial para nova operação
                end else begin
                    EA <= FINAL;
                end

            end
        endcase

    end
end


endmodule