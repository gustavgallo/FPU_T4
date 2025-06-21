# 💡 FPU - Unidade Aritmética de Ponto Flutuante (T4)

> ⌨️ Projeto desenvolvido para a disciplina de **Sistemas Digitais** – PUCRS, 2025/1  
> 🧮 Implementa uma FPU em SystemVerilog capaz de realizar **operações de soma e subtração** em ponto flutuante.

---

## 👤 Autor

- **Nome:** [Gustavo Tibolla Gallo](https://github.com/gustavgallo)  
- **Curso:** Engenharia de Computação **PUCRS** 

---

## ✅ Objetivo

Implementar uma **FPU (Floating Point Unit)** funcional para simular operações com números em ponto flutuante, realizando:

- 🧩 Extração dos campos (sinal, expoente e mantissa)
- 🔄 Alinhamento dos operandos
- ➕ Operação de soma ou subtração
- 📏 Normalização e ajuste de expoente
- ⚠️ Geração de status (`EXACT`, `OVERFLOW`, `UNDERFLOW`, `INEXACT`)

---

## 📌 Cálculo de Parâmetros a partir da Matrícula

Conforme regra do enunciado:

- *X = 8 + (2+4+1+0+6+5+2+4+2) % 4*
- *X = 8 - 2*
- *X = 6 bits*

- *Y = 31 - 6*
- *Y = 25 bits*

### Resultado final:

| Parâmetro | Valor |
|-----------|--------|
| X (expoente) | 6 bits |
| Y (mantissa) | 25 bits |
| BIAS         | 31      |

---

## 📐 Formato do Número

| Campo     | Bits     | Descrição                    |
|-----------|----------|-------------------------------|
| Sinal     | [31]     | Bit de sinal (0 = +, 1 = -)   |
| Expoente  | [30:25]  | 6 bits (com BIAS 31)          |
| Mantissa  | [24:0]   | 25 bits       |

---
## 🎓 Espectro numérico

![representation](https://github.com/user-attachments/assets/1df3f9da-27c1-4a39-8720-4b149109f1c8)

---

## 📁 Estrutura do Projeto

| Arquivo         | Descrição                                      |
|-----------------|------------------------------------------------|
| `FPU.sv`        | Implementação da FPU com máquina de estados    |
| `tb_FPU.sv`     | Testbench com 10 casos de teste                |
| `sim.do`        | Script para uso no ModelSim/QuestaSim          |
| `fpu_range.png` | Gráfico com o espectro numérico representável |

---



## 🧪 Casos de Teste

Os casos de teste estão implementados no arquivo `tb_FPU.sv`, cobrindo desde operações simples até situações limite, incluindo:

- ✅ Soma entre números com mesmo expoente  
- ✅ Soma com o valor zero (`0.0`)  
- ✅ Subtração entre operandos com sinais opostos  
- ✅ Resultados que exigem **normalização via shift**  
- ✅ Situações de **underflow**, **overflow** e **inexact**

📂 Prints de **formas de onda simuladas (waveform)** estão disponíveis na pasta:

👉 [`📁 diretório de resultados`](https://github.com/gustavgallo/FPU_T4/tree/main/tests)

---

### 🔍 Exemplo de teste incluído

```verilog
// Teste_6: 1.5 + 2.25
op_A_in <= {1'b0, 6'b011111, 25'b1000000000000000000000000}; // 1.5
op_B_in <= {1'b0, 6'b100000, 25'b0010000000000000000000000}; // 2.25
// Esperado: 3.75 → data_out == 0x41C00000
