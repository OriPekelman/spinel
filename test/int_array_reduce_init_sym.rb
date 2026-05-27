# Enumerable#reduce(init, :op) — explicit init plus a symbol
# operator. Single-arg sym form was already wired; the 2-arg form
# (init + op-sym) fell through to unresolved-call.
puts [1,2,3,4].reduce(:+)
puts [1,2,3,4].reduce(:*)
puts [1,2,3,4].reduce(10, :+)
puts [1,2,3,4].reduce(100, :*)
puts [].reduce(7, :+)
