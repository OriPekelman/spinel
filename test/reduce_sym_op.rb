# #506. `[1,2,3,4].reduce(:*)` previously fell through unresolved
# on int_array, emitted 0 for the call, and printed `:` (analyzer
# typed the return as `symbol` so `p` inspected it as `:<name>`).
#
# Codegen now folds the symbol-arg form inline for binary
# arithmetic / bitwise ops on int_array; analyze types the return
# as `int` (the array's element type) so `p` formats it as a
# number.

p [1, 2, 3, 4].reduce(:*)    # 24
p [1, 2, 3, 4].reduce(:+)    # 10
p [10, 1, 2].reduce(:-)      # 7
p [5, 3].inject(:%)          # 2
p [12, 10].inject(:&)        # 8
p [5, 3].inject(:|)          # 7
p [5, 3].inject(:^)          # 6
p [42].reduce(:+)            # 42 (single-element)
p [].reduce(:+)              # 0 (empty array; CRuby returns nil — int_array can't)
