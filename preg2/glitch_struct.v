// glitch_struct.v
`timescale 1ns/1ps

module glitch_detector_struct (
  input  wire a,    // cambia en t₀ de 1→0
  input  wire b,
  input  wire c,
  input  wire d,
  output wire F     // resultado con glitch entre 7 ns y 9 ns
);
  // Wires internos
  wire a_n, b_n, c_n, d_n;
  wire or1, or2;
  wire and1, and2;

  // Inversores (retardo 1 ns)
  //   a_n sube en t₀+1 ns
  not #1 inv_a (a_n, a);
  not #1 inv_d (d_n, d);

  // OR2 = b' + c' (retardo 3 ns)
  //   or2 estable antes de t₀
  not #1 inv_b (b_n, b);
  not #1 inv_c (c_n, c);
  or  #3 or2_gate  (or2, b_n, c_n);

  // OR1 = a + b (retardo 3 ns)
  //   en t₀+3 ns or1 sigue la caída de 'a'
  or  #3 or1_gate  (or1, a, b);

  // AND1 = or1 · or2 (retardo 3 ns)
  //   en t₀+3+3 = 6 ns and1 cae a 0
  and #0 and1_gate (and1, or1, or2);

  // AND2 = a_n · d_n (retardo 3 ns)
  //   a_n sube en t₀+1 → and2 sube en t₀+1+3 = 4 ns
  and #3 and2_gate (and2, a_n, d_n);

  // F = and1 + and2 (retardo 3 ns)
  //   ruta backup llega en t₀+4+3 = 7 ns (F vuelve a 1)
  //   ruta main cae en   t₀+6+3 = 9 ns (F ya había caído en 9(ns))
  //   glitch en [7 ns .. 9 ns]
  or  #0 orF_gate  (F, and1, and2);
endmodule
