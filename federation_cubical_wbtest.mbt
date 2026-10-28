///|
test "spec_registry_sound_and_phase15_count" {
  assert_true(spec_registry_sound())
  assert_eq(spec_count(), 121)
}

///|
test "cubical_core_univalence_glue_and_bdd_canonical" {
  assert_true(check_coe_definitional())
  assert_true(check_bdd_canonical())
  assert_true(check_glue_comp_all())
  assert_true(check_adjoint_equivalence_and_fibers())
}

///|
test "phase15_track_i_bdd_decomposed_lrat_and_dcube_yoneda" {
  assert_true(check_phase15_bdd_symmetry_orbit_and_decomposed_optimal())
  assert_true(check_phase15_cdcl_lrat_elaboration_and_binary_codec())
  assert_true(check_phase15_dcube_strength4_phf_and_yoneda_audit())
}

///|
test "phase15_track_ii_bidirectional_pi1_s1_adjunction_and_freudenthal" {
  assert_true(check_phase15_bidirectional_bijectivity_and_pi1_circle())
  assert_true(check_phase15_suspension_and_loop_suspension_adjunction())
  assert_true(check_phase15_freudenthal_suspension_and_wedge_connectivity())
}
