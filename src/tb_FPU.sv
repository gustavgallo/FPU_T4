`timescale 1us/1ns

module tb_FPU;

    // Declarar sinais internos e instanciar o DUT aqui
    // Sinais internos
    logic clock_100KHZ = 0;
    logic reset = 1;
    logic[31:0] op_A_in;
    logic[31:0] op_B_in;

    logic[31:0] data_out;
    logic[3:0] status_out;

    // Instanciação do DUT
    FPU dut (
        .clock(clock_100KHZ),
        .reset(reset),
        .op_A_in(op_A_in),
        .op_B_in(op_B_in),
        .data_out(data_out),
        .status_out(status_out)
    );

    always begin
        #5 clock_100KHZ = ~clock_100KHZ;
    end

    initial begin
        #5; reset = 0;
        #5; reset = 1;

        // Teste 1: -1.0 + -1.0 = - 2.0
        op_A_in <= {1'b1, 6'b011111, 25'b0};
        op_B_in <= {1'b1, 6'b011111, 25'b0};
        #80;

        reset = 0;
        #5; reset = 1;

        // Teste 2: 2.0 - 4.0 = - 2.0
        op_A_in <= {1'b0, 6'b100000, 25'b0};
        op_B_in <= {1'b1, 6'b100001, 25'b0};
        #80;

        reset = 0;
        #5; reset = 1;
        
        // Teste 3: 1.0 + (-1.0) = 0
        op_A_in <= {1'b0, 6'b011111, 25'b0};
        op_B_in <= {1'b1, 6'b011111, 25'b0};
        #80;

        reset = 0;
        #5; reset = 1;

        // Teste 4: 1.5 + 0.5 = 2.0
        op_A_in <= {1'b0, 6'b011111, 25'b1000000000000000000000000};
        op_B_in <= {1'b0, 6'b011110, 25'b0};
        #80;

        reset = 0;
        #5; reset = 1;

        // Teste 5: 1.0 + 0.0 = 1.0
        op_A_in <= {1'b0, 6'b011111, 25'b0};
        op_B_in <= {1'b0, 6'b000000, 25'b0};
        #80;

        reset = 0;
        #5; reset = 1;

        // Teste 6: 1.5 + 2.25 = 3.75
        op_A_in <= {1'b0, 6'b011111, 25'b1000000000000000000000000}; // 1.5
        op_B_in <= {1'b0, 6'b100000, 25'b0010000000000000000000000}; // 2.25
        #80;

        reset = 0;
        #5; reset = 1;

        // Teste 7: OVERFLOW -> expMAX + 1 = + infinito (Overflow)
        op_A_in <= {1'b0, 6'b111111, 25'b1000000000000000000000000}; // MAX
        op_B_in <= {1'b0, 6'b111111, 25'b1000000000000000000000000}; // MAX 
        #80;

        reset = 0;
        #5; reset = 1;

        // Teste 8: UNDERFLOW -> Num pequeno não representável = arredondamento
        op_A_in <= {1'b0, 6'b000000, 25'b0000000000000000000000010}; 
        op_B_in <= {1'b1, 6'b000000, 25'b0000000000000000000000000}; 
        #80;

        reset = 0;
        #5; reset = 1;

        // Teste 9: INEXACT -> Último bit se perde 
        op_A_in <= {1'b0, 6'b100000, 25'b0000000000000000000000001}; 
        op_B_in <= {1'b0, 6'b100000, 25'b0000000000000000000000000}; 
        #80;

        reset = 0;
        #5; reset = 1;
        // Teste 10: 10 + 10 = 20
        op_A_in <= {1'b0, 6'b100010, 25'b0100000000000000000000000}; 
        op_B_in <= {1'b0, 6'b100010, 25'b0100000000000000000000000};
        #80;



        $finish;
    end

endmodule