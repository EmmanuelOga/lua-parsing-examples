local rb = require 'ringbuffer'

b = rb.new(2)

print(b(1), b(2))

b:push("a"); print(b(1), b(2))
b:push("b"); print(b(1), b(2))
b:push("c"); print(b(1), b(2))
b:push("d"); print(b(1), b(2))
