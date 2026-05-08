# Regression: `recv.attr = v` where `recv` is poly-typed (a
# function parameter widened to sp_RbVal because two classes
# share the call site) silently dropped the assignment. The
# poly-recv method-dispatch builder had a per-class arm for
# explicit methods and a fallback for cls_has_attr_reader, but
# nothing for cls_has_attr_writer, so attr_accessor / attr_writer
# setters on a poly receiver became no-ops.

class Box
  attr_accessor :flag
  def initialize
    @flag = false
  end
end

class Bag
  attr_accessor :flag
  def initialize
    @flag = false
  end
end

# Two classes with the same accessor force `flag=` onto the poly
# dispatch path; a single-class call site would get monomorphised
# and emit a direct ivar write instead.
def trip(o);  o.flag = true;  end
def clear(o); o.flag = false; end

a = Box.new
b = Bag.new

trip(a)
trip(b)
puts a.flag ? "1" : "0"
puts b.flag ? "1" : "0"

clear(a)
clear(b)
puts a.flag ? "1" : "0"
puts b.flag ? "1" : "0"
