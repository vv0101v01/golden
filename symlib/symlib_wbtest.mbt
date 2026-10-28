///|
test "symlib_schreier_sims_and_c4_automorphisms" {
  let s4 = PermGroup::symmetric(4)
  assert_eq(s4.order(), 24L)
  let c4 = Graph::from_edges(4, [(0, 1), (1, 2), (2, 3), (3, 0)])
  assert_eq(aut_order(c4), 8L)
  assert_true(all_hold(prove_graph(c4, Perm::from_img([1, 2, 3, 0]), 32)))
}

///|
test "symlib_prove_all_certificate_battery" {
  assert_true(all_hold(prove_all(200)))
}
