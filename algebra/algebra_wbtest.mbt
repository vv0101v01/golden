///|
test "algebra_hensel_factorization_and_certificates" {
  assert_true(check_qpoly_hensel_factor_and_certificates())
  assert_true(check_splitting_field())
}

///|
test "algebra_rank6_multiquad_and_real_algebraic_radicals" {
  assert_true(check_algebraic_radicals_and_rank6_multiquad())
}

///|
test "algebra_hermitian_block_deflated_jacobi_certificates" {
  assert_true(check_jacobi_block_deflation_and_multiplicity())
}
