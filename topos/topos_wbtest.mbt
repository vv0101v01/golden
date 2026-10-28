///|
test "topos_nerve_homotopy_nonabelian_torsors_and_atomic_galois" {
  let s1_nerve = boundary_simplex_nerve(2)
  let s2_nerve = boundary_simplex_nerve(3)
  let ht_s1 = compute_nerve_homotopy_type(s1_nerve)
  let ht_s2 = compute_nerve_homotopy_type(s2_nerve)
  assert_eq(ht_s1.pi1_free_rank, 1)
  assert_eq(ht_s1.betti_numbers, [1, 1, 0, 0])
  assert_eq(ht_s2.betti_numbers, [1, 0, 1, 0])
  let s3_cat = @sym.cat_group(@sym.PermGroup::symmetric(3), 10)
  let (_, h1_s1) = classify_group_torsor_cohomology(s3_cat, s1_nerve)
  let (_, h1_s2) = classify_group_torsor_cohomology(s3_cat, s2_nerve)
  assert_eq(h1_s1, 3)
  assert_eq(h1_s2, 1)
}

///|
test "topos_open_closed_subtopos_complementarity" {
  let sierp = @sym.cat_arrow()
  let u_open = presheaf_representable(sierp, 0)
  let rep = verify_open_closed_subtopos_complementarity(u_open)
  assert_true(
    rep.meet_is_ambient &&
    rep.join_is_inconsistent &&
    !rep.internal_lem_holds &&
    rep.subtopos_boolean_complement_holds,
  )
}
