///|
test "semiring_bool_and_tropical_star_semiring_laws" {
  let mut idx = 0
  let bool_gen = fn() {
    idx = idx + 1
    BoolSr::of(idx % 2 == 0)
  }
  assert_true(check_star_idem("BoolSr", bool_gen, samples=32).ok())
  let mut tidx = 0
  let trop_gen = fn() {
    tidx = tidx + 1
    if tidx % 5 == 0 {
      Trop::zero()
    } else {
      Trop::new((tidx * 7) % 11)
    }
  }
  assert_true(check_star_idem("Trop", trop_gen, samples=32).ok())
}
