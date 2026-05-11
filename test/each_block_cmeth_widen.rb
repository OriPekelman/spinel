# Issue #424. `Json.escape(k)` inside `h.each |k, v|` couldn't
# pick up k's narrowed string type from the hash variant -- the
# cmeth param `s` stayed at the int default and the C compile
# of the call site failed with `passing 'const char *' to
# parameter of type 'mrb_int'`. Fix runs a targeted pre-scan
# (widen_cmeths_via_hash_each_blocks) that walks hash-typed
# params for `<p>.each |k, v|` blocks and widens any nested
# `<Class>.<cmeth>(k|v)` call's param types from the hash's
# key/value variant.
#
# Coverage:
#   - str_str_hash: k and v both string; escape's param s
#     widens to string via both call sites.
#   - str_int_hash variant: k string, v int. Mixed types
#     force the cmeth widening to handle each arg independently.

class Json
  def self.escape(s)
    out = ""
    i = 0
    n = s.length
    while i < n
      out = out + s[i]
      i += 1
    end
    out
  end

  def self.from_str_hash(h)
    out = "{"
    h.each do |k, v|
      out = out + "\"" + Json.escape(k) + "\":\"" + Json.escape(v) + "\""
    end
    out + "}"
  end
end

puts Json.from_str_hash({"a" => "b"})
puts Json.from_str_hash({"x" => "y"})
