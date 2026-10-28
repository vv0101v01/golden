///|
fn main {
  println(
    "Golden Grand Unification — Five-Federation Architecture & Synthesis",
  )
  println("===================================================================")
  println("-- Five Autonomous Mathematical Federations --")
  for fed in @bridge.five_federation_descriptors() {
    let st = if fed.live_health_ok { "PASS" } else { "FAIL" }
    println("[\{st}] federation \{fed.slug}: \{fed.summary}")
  }
  println("-- Complete K_5 Cross-Federation Pairwise Bridges (10/10) --")
  for edge in @bridge.verify_k5_federation_bridges() {
    let st = if edge.holds { "PASS" } else { "FAIL" }
    println("[\{st}] \{edge.id}: \{edge.bridge_theorem}")
    println("        \{edge.quantitative_witness}")
  }
  println("-- Unified Certificate Ledger --")
  let certificates = @bridge.bridge_certificates()
  for cert in certificates {
    let status = if cert.ok { "PASS" } else { "FAIL" }
    println("[\{status}] \{cert.source}: \{cert.name}")
    if cert.detail != "" {
      println("        \{cert.detail}")
    }
  }
  println(@bridge.certificate_summary(certificates))
  let unif = @bridge.run_grand_unification_system()
  println(
    "five-federation unification: federations=\{unif.federations_verified_count}/5, K5_bridges=\{unif.k5_bridges_verified_count}/10, pentagon=\{unif.five_federation_pentagon_ok}, six_pillar=\{unif.six_pillar_circle_sphere_ok}, atlas=\{unif.atlas_verified_count}/18, all_ok=\{unif.all_ok}",
  )
  let cycle = @sgraph.Graph::build(4, [0, 1, 2, 3], [1, 2, 3, 0], [1, 1, 1, 1])
  let report = @bridge.weighted_graph_report(cycle, 32)
  println(
    "directed weighted C4: weighted symmetries=\{report.weighted_symmetry_count}, reachable pairs=\{report.reachable_pairs}, finite-distance sum=\{report.finite_distance_sum}",
  )
  println(
    "symmetry-average projector: projector=\{@cub.is_projector(report.symmetry_projector)}, trace=\{@cub.mat_trace_re(report.symmetry_projector)}",
  )
  let rotation = @sym.Perm::from_img([1, 2, 3, 0])
  let wiring_ok = match
    @bridge.perm_of_wiring(@bridge.perm_equiv(rotation).wiring) {
    Some(back) => back.equal(rotation)
    None => false
  }
  println("Perm → cubical Equiv → Perm round trip: \{wiring_ok}")
  guard @bridge.certificates_all_ok(certificates) && wiring_ok && unif.all_ok else {
    abort("showcase failed")
  }
}
