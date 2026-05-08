# Regression: `recv.attr = v` where `recv` is poly-typed (a
# function parameter widened to sp_RbVal because two classes
# share the call site) silently dropped the assignment. The
# poly-recv method-dispatch builder had a per-class arm for
# explicit methods and a fallback for cls_has_attr_reader, but
# nothing for cls_has_attr_writer, so attr_accessor / attr_writer
# setters on a poly receiver became no-ops.
#
# Three subcases:
#   1. boolean slot (the original tep symptom)
#   2. string slot, both classes agree
#   3. divergent slots: one class stores int, the other string
#      -- exercises the poly-result widening + per-arm unbox of
#      the rhs into the class's concrete ivar type
# Each subcase also captures the return value of the assignment
# expression to confirm Ruby `obj.x = v` semantics (yields v).

# ---- subcase 1: bool slot ----
class Box
  attr_accessor :flag
  def initialize; @flag = false; end
end
class Bag
  attr_accessor :flag
  def initialize; @flag = false; end
end
def trip(o);  ret = (o.flag = true);  ret; end
def clear(o); ret = (o.flag = false); ret; end

a = Box.new
b = Bag.new
ra = trip(a)
rb = trip(b)
puts a.flag ? "1" : "0"
puts b.flag ? "1" : "0"
# Setter expression should yield the assigned value (true).
puts ra ? "ret=1" : "ret=0"
puts rb ? "ret=1" : "ret=0"
clear(a)
clear(b)
puts a.flag ? "1" : "0"
puts b.flag ? "1" : "0"

# ---- subcase 2: string slot, both classes agree ----
class Pen
  attr_accessor :name
  def initialize; @name = ""; end
end
class Pin
  attr_accessor :name
  def initialize; @name = ""; end
end
def label(o, s); o.name = s; end

p1 = Pen.new
p2 = Pin.new
label(p1, "alpha")
label(p2, "beta")
puts p1.name
puts p2.name

# ---- subcase 3: divergent slot types ----
# IBox stores an int in @slot; SBox stores a string. The two
# share the call site `assign(o, v)`, so spinel widens both
# `o` and `v` to poly. The poly-attr_writer arm must (a) emit
# a per-class write that unboxes v from poly into the class's
# concrete slot type, and (b) box the result back to poly so
# the caller's poly result temp accepts it.
class IBox
  attr_accessor :slot
  def initialize; @slot = 0; end
end
class SBox
  attr_accessor :slot
  def initialize; @slot = ""; end
end
def assign(o, v); o.slot = v; end

ib = IBox.new
sb = SBox.new
assign(ib, 42)
assign(sb, "hello")
puts ib.slot.to_s
puts sb.slot
