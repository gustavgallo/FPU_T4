# 💡 FPU - Unidade Aritmética de Ponto Flutuante (T4)

> ⌨️ Projeto desenvolvido para a disciplina de **Sistemas Digitais** – PUCRS, 2025/1  
> 🧮 Implementa uma FPU em SystemVerilog capaz de realizar **operações de soma e subtração** em ponto flutuante.

---

## 👤 Autor

- **Nome:** Gustavo Gallo  
- **Curso:** Engenharia da Computação  

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

Os casos teste estão apresentados no arquivo de testbench `tb_FPU.sv`, não foram anexados print de execução nesse `README` por conta da baixa qualidade da forma de onda ao capturar a tela do simulador.


