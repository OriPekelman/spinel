# Bundled tests:
#   - int_overflow_raises
#   - integer_div

# === int_overflow_raises ===
def t_int_overflow_raises
  # Integer arithmetic that overflows mrb_int (int64) raises
  # RangeError rather than silently wrapping. spinel uses
  # `__builtin_add_overflow` / `_sub_overflow` / `_mul_overflow`
  # at the codegen-emit step for binary `+ - *` on int operands;
  # the helpers (defined as statement-expression macros in
  # sp_runtime.h) raise on overflow and otherwise reduce to the
  # bare arithmetic op. BIGINT.md option β.
  #
  # Non-overflowing arithmetic must still produce the expected
  # native-int result, and `rescue` must catch the raise so the
  # program can continue.
  
  # Sanity: non-overflowing arithmetic still works.
  puts 100 + 200
  puts 1000 - 500
  puts 6 * 7
  
  # Each of the three operators raises on overflow.
  [:plus, :minus, :mul].each do |op|
    begin
      huge = 9_223_372_036_854_775_000
      case op
      when :plus
        x = huge + 9_223_372_036_854_775_000
      when :minus
        x = -huge - 9_223_372_036_854_775_000
      when :mul
        x = huge * 1000
      end
      puts "no raise from #{op}: #{x}"
    rescue RangeError => e
      puts "#{op}: caught #{e.message}"
    end
  end
end
t_int_overflow_raises

# === integer_div ===
def t_integer_div
  # basic
  puts 7.div(2)
  puts 10.div(5)
  
  # exact
  puts 6.div(3)
  
  # negative — floor division rounds toward -infinity
  puts((-7).div(2))
  puts 7.div(-2)
  puts((-7).div(-2))
  
  # zero dividend
  puts 0.div(3)
  
  # one
  puts 1.div(1)
  puts((-1).div(1))
  
  # large
  puts 1000001.div(1000)
end
t_integer_div

