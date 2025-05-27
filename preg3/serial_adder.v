`timescale 1ns/1ps

module serial_adder_mealy (
  input  wire       clk,
  input  wire       rst,      
  input  wire [3:0] a,        
  input  wire [3:0] b,        
  input  wire       cin,      
  output wire       s,        
  output wire       cout      
);

  // Registro que guarda el carry actual
  reg C;
  // Próximo carry
  wire C_next;

  // Índice de bit (0..3)
  reg [1:0] bit_idx;

  // Cálculo de un bit de suma completo
  wire x1 = a[bit_idx] ^ b[bit_idx];      
  wire sum_bit = x1 ^ C;                 // s = a_i ⊕ b_i ⊕ C
  wire ab    = a[bit_idx] & b[bit_idx];  // término para el carry
  wire xC    = x1 & C;                   // segundo término
  assign C_next = ab | xC;               // carry de siguiente

  // Conexiones de salida
  assign s    = sum_bit;
  assign cout = C;

  // FSM Mealy: en cada flanco avanzamos bit y carry
  always @(posedge clk) begin
    if (rst) begin
      C       <= cin;      // cargamos el carry in inicial
      bit_idx <= 2'd0;     // empezamos en el bit 0 (LSB)
    end else begin
      C       <= C_next;               // actualizamos el carry
      bit_idx <= bit_idx + 1'b1;       // avanzamos al siguiente bit
    end
  end

endmodule
