// tb_serial.v
`timescale 1ns/1ps
module tb_serial;
  reg clk, rst;
  wire s, cout;

  serial_adder uut (
    .clk(clk),
    .rst(rst),
    .a(4'b0110),
    .b(4'b0011),
    .s(s),
    .cout(cout)
  );

  initial begin
    $dumpfile("serial.vcd");
    $dumpvars(0, tb_serial);
  end

  // Generador de reloj
  initial clk = 0;
  always #5 clk = ~clk;  // periodo 10 ns

  initial begin
    // Reset inicial
    rst = 1;
    #10;
    rst = 0;
    // Deja correr 5 ciclos para ver los 4 bits + uno extra
    #60;
    $finish;
  end

endmodule
