///|
// Architecture boundary: the root package consumes the host-filesystem
// package only through this explicit import list.  The durability
// protocol is simulated in pure MoonBit so that it can be verified on
// every target; the actual native backend behind it is target gated and
// is never a dependency of the core.
using @hostfs {check_durable_write_protocol}
