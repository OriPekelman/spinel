# defined? on globals and methods. Methods already returned
# "method"; globals were returning "expression". CRuby returns
# "global-variable" for $x whether set or not.
$g = 1
puts defined?($g)
puts defined?($unset_gvar)

def foo; end
puts defined?(foo)

# Locals already correct.
x = 1
puts defined?(x)
puts defined?(undefined_local).nil?
