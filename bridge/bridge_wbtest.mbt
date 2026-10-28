///|
test "bridge_five_federation_grand_unification_and_39_certificates" {
  assert_true(check_certificate_bridge())
  let unif = run_grand_unification_system()
  assert_true(unif.all_ok)
  assert_eq(unif.federations_verified_count, 5)
  assert_eq(unif.k5_bridges_verified_count, 10)
  assert_eq(unif.atlas_verified_count, 18)
  assert_eq(unif.total_certificates_passed, 39)
  assert_eq(unif.total_certificates_count, 39)
}
