`timescale 1ns/1ps
module garage_controller (
    input  wire clk,        // reloj único
    input  wire remote,     // botón remoto
    input  wire open,       // sensor abierta
    input  wire closed,     // sensor cerrada
    input  wire timer,      // timeout 30 s
    output reg  power,      // 1 = motor on
    output reg  direction   // 0 = abre, 1 = cierra
);

  // estados
  localparam S0 = 3'b000;  // cerrada
  localparam S1 = 3'b001;  // abriendo
  localparam S2 = 3'b010;  // abierta
  localparam S3 = 3'b011;  // pausa apertura
  localparam S4 = 3'b100;  // cerrando
  localparam S5 = 3'b101;  // pausa cierre

  reg [2:0] state = S0;    // arranca en cerrada
  reg [2:0] next_state;

  // avance de estado
  always @(posedge clk) begin
    state <= next_state;
  end

  // calcula siguiente estado
  always @(*) begin
    next_state = state;
    case (state)
      S0: next_state = remote ? S1 : S0;                  // remote → abrir
      S1: next_state = remote ? S3 : (open ? S2 : S1);    // pausa o llega a abierta
      S3: next_state = remote ? S1 : S3;                  // reanuda apertura
      S2: next_state = (remote|timer) ? S4 : S2;          // remote/timer → cerrar
      S4: next_state = remote ? S5 : (closed ? S0 : S4);  // pausa o llega a cerrada
      S5: next_state = remote ? S4 : S5;                  // reanuda cierre
      default: next_state = S0;                           // fallback
    endcase
  end

  // salidas Moore
  always @(*) begin
    case (state)
      S1: begin power = 1; direction = 0; end            // abriendo
      S4: begin power = 1; direction = 1; end            // cerrando
      default: begin power = 0; direction = 0; end       // detenido
    endcase
  end

endmodule
