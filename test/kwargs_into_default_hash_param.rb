# When a method's only positional has a default hash literal
# (`attrs = {}`), call sites that pass kwargs whose names DON'T
# match the param name should bundle the kwargs into that hash
# slot. CRuby auto-folds trailing unmatched kwargs into a hash
# positional; spinel previously dropped them silently because:
#  - The analyzer fixpoint left the param typed `str_int_hash`
#    (from the literal `{}` default) and never widened despite
#    the call site carrying mixed-type values.
#  - The codegen `compile_typed_call_args` / class-method dispatch
#    arm filled the unmatched slot with the literal default
#    (`sp_StrIntHash_new()` / `sp_StrPolyHash_new()`), so the
#    callee saw an empty hash and constructed all-default values.
#
# Surfaced by Sam Ruby's roundhouse `comment_test.rb`
# `test_belongs_to_article_association` (issue #572 follow-up):
# `Comment.create(article_id: article.id, ...)` against
# `def self.create(attrs = {})` had the kwargs dropped, so the
# created Comment's article_id stayed 0 and the assertion
# `article.id != comment.article_id` raised.

class Bag
  def self.create(attrs = {})
    new(attrs)
  end
  def initialize(attrs = {})
    @id = attrs[:id] || 0
    @name = attrs[:name] || "(none)"
    @count = attrs.length
  end
  attr_reader :id, :name, :count
end

# Class method form: `.create(kw: val, ...)`.
b1 = Bag.create(id: 7, name: "alpha")
puts b1.id     # 7
puts b1.name   # alpha
puts b1.count  # 2

# Instance constructor form: `.new(kw: val, ...)` with default
# hash param. Without the analyzer widening, sp_Bag_new(0)
# segfaulted on the NULL hash. Issue #530 sibling.
b2 = Bag.new(id: 42, name: "beta")
puts b2.id     # 42
puts b2.name   # beta
puts b2.count  # 2

# Empty call: defaults still kick in.
b3 = Bag.create
puts b3.id     # 0
puts b3.name   # (none)
puts b3.count  # 0

# Mixed kwarg types -- string + int -- exercise the str_poly_hash
# poly value path.
b4 = Bag.create(id: 99, name: "gamma")
puts b4.id     # 99
puts b4.name   # gamma
