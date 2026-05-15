# #507. `s.split` (no arg) used to emit `sp_str_split(s, 0)` and
# segfault at strlen(NULL) — the no-arg fallback compiled
# compile_arg0 to literal `0` (NULL) and the runtime helper
# called strlen on it. Fix: new `sp_str_split_ws` runtime helper
# matches Ruby's whitespace-mode split (no arg / nil arg form),
# splitting on runs of ASCII whitespace and skipping leading
# whitespace. Codegen routes the no-arg and explicit-nil forms
# to it.

p "1 2 3".split
p "  leading  trailing  ".split
p "a\tb\nc".split          # mixed whitespace
p "".split                  # empty
p "abc".split(nil)          # explicit nil arg -> same as no-arg
p "a,b,c".split(",")        # non-whitespace sep (regression guard)
