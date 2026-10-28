///|
test "scheme_serre_duality_bezout_and_motivic_p1" {
  assert_true(verify_serre_duality_and_riemann_roch_p1(4))
  assert_true(verify_serre_duality_p2(3))
  assert_true(verify_motivic_p1_categorification(5))
  let x0 = mpoly_var(3, 0)
  let x1 = mpoly_var(3, 1)
  let x2 = mpoly_var(3, 2)
  let conic = mpoly_sub(mpoly_add(mpoly_mul(x0, x0), mpoly_mul(x1, x1)), mpoly_mul(x2, x2))
  let line = mpoly_sub(x0, x1)
  assert_true(verify_bezout_theorem_p2(conic, line))
}

///|
test "scheme_weil_zeta_and_galois_frobenius_descent" {
  assert_true(verify_weil_zeta_and_galois_frobenius_descent())
}
