# `Array.new(n)` (single arg, no fill value, no block) is CRuby
# shorthand for `Array.new(n, nil)`: an array of n nils, NOT an
# empty array. Pre-fix the single-arg lowering returned
# `sp_IntArray_new()` (length 0) and downstream `.length` /
# `.inspect` / `[i].nil?` saw the wrong shape. Issue #619 puzzle 4.
puts Array.new(3).length         # 3
puts Array.new(3).inspect        # [nil, nil, nil]
puts Array.new(3)[0].nil?        # true
puts Array.new(0).length         # 0
puts Array.new(5).length         # 5
