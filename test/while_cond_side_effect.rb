# #500. `while (n = gets.to_i) > 0` looped forever because codegen
# emitted `_t1 = sp_gets(); SP_GC_ROOT(_t1);` BEFORE the while line,
# so every iteration re-read the same captured first line. Fix:
# compile the predicate into a scratch buffer and replay its
# emits inside `while (1) { ...; if (!cond) break; ... }` so any
# transient temp/root tied to the receiver call lives per-iter.
#
# Test uses an instance method returning a String — `.to_i` then
# routes through compile_expr_gc_rooted's hoist for the heap-
# allocated receiver. Stdin gets isn't reachable from the test
# harness, so we drive the same code path via an iterator class.

class Source
  def initialize
    @data = ["5", "4", "3", "0"]
    @idx = 0
  end

  def next_line
    s = @data[@idx]
    @idx += 1
    s
  end
end

src = Source.new
count = 0
while (n = src.next_line.to_i) > 0
  count += 1
end
puts count
