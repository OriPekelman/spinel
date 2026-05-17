# `Fiber.current[:k]` and `Fiber.current[:k] = v` are aliases for
# `Fiber[:k]` and `Fiber[:k] = v` — both target the same storage Hash
# on the currently-running fiber.

Fiber.current[:via_current] = 100
puts Fiber[:via_current]                       # 100 — reads via Fiber[]

Fiber[:via_bare] = 200
puts Fiber.current[:via_bare]                  # 200 — reads via Fiber.current[]
