`timescale 1ns/1ps
module tb_struct;
  reg  a, b, c, d;
  wire F;

  glitch_detector_struct uut (
    .a(a), .b(b), .c(c), .d(d),
    .F(F)
  );

  initial begin
    $dumpfile("glitch_struct.vcd");
    $dumpvars(0,tb_struct);
  end

  initial begin
    // --------- Caso 1: 1000 → 0000 ---------
    // t=0: a=1,b=0,c=0,d=0 ⇒ F=1
    a=1; b=0; c=0; d=0;
    #10;
    // t=10: solo a cambia → 0 ⇒ primer glitch
    a=0;
    #20;

    // --------- Caso 2: 1010 → 0010 ---------
    // t=30: a=1,b=0,c=1,d=0 ⇒ F=1
    a=1; b=0; c=1; d=0;
    #10;
    // t=40: solo a cambia → 0 ⇒ segundo glitch
    a=0;
    #20;

    $finish;
  end
endmodule
  