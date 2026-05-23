# Issue #660: `hash[k] || rhs` on a typed-hash receiver must return
# rhs when the key is missing -- not the value-type zero (0 / "").
#
# Background: typed hash variants (sp_StrIntHash, sp_StrStrHash, ...)
# materialize the value type's zero as the missing-key default. Combined
# with the `||` truthy-lhs ternary lowering, the rhs arm was unreachable:
# 0 / "" are truthy in Ruby, so the always-present zero short-circuited
# the fallback.
#
# Fix: compile_or detects `hash[k]` on a typed-hash recv and rewrites
# to `has_key(h, k) ? get(h, k) : rhs`. Poly-hash variants already
# return sp_box_nil on miss, so they keep the legacy truthy lowering.

# Empty hash, no writes (inferred str_int_hash).
h1 = {}
puts (h1[:missing] || "fallback")

# String-valued hash via prior write.
h2 = {}
h2[:set_key] = "value"
puts (h2[:missing] || "fallback")

# Int-valued hash via prior write -- the missing-key 0 used to win.
h3 = {}
h3[:set] = 1
puts (h3[:missing] || -1)

# Present key returns the value, not the fallback.
h4 = {}
h4[:found] = "got it"
puts (h4[:found] || "fallback")
