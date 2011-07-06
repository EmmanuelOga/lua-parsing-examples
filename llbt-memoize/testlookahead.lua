local la = require 'lookahead'

local numbers = function()
  local n = 0; return function()
    n = n + 1; if n < 99 then return n end
  end
end

local lookahead = la.new(numbers())

local function test(n)
  print("Looking ahead "..n..": "..lookahead(n), "buffer: ", unpack(lookahead.buffer))
end

print("without consuming:")
test(1)
test(3)
test(2)
test(4)
test(1)

print("\nconsuming each step:\n")
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) print("____")
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) print("____")
io.write("consuming 3 "); for i = 1, 3 do lookahead:consume() end; test(1) test(3) print("____")
io.write("consuming 2 "); for i = 1, 2 do lookahead:consume() end; test(1) test(2) print("____")
io.write("consuming 4 "); for i = 1, 4 do lookahead:consume() end; test(1) test(4) print("____")
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) test(1) print("____")

print("\nmarking/releasing:\n")
print("lookahead 1 before mark:", lookahead(1))
lookahead:mark()
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) print("____")
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) print("____")
io.write("consuming 3 "); for i = 1, 3 do lookahead:consume() end; test(1) test(3) print("____")
io.write("consuming 2 "); for i = 1, 2 do lookahead:consume() end; test(1) test(2) print("____")
io.write("consuming 4 "); for i = 1, 4 do lookahead:consume() end; test(1) test(4) print("____")
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) test(1) print("____")
lookahead:release()
print("lookahead 1 after release:", lookahead(1))

print("\nnested marking/releasing:\n")
print("lookahead 1 before mark:", lookahead(1))
lookahead:mark()
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) print("____")
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) print("____")
io.write("consuming 3 "); for i = 1, 3 do lookahead:consume() end; test(1) test(3) print("____")
print("  lookahead 1 before mark:", lookahead(1))
lookahead:mark()
io.write("consuming 2 "); for i = 1, 2 do lookahead:consume() end; test(1) test(2) print("____")
io.write("consuming 4 "); for i = 1, 4 do lookahead:consume() end; test(1) test(4) print("____")
lookahead:release()
print("  lookahead 1 after release:", lookahead(1))
io.write("consuming 1 "); for i = 1, 1 do lookahead:consume() end; test(1) test(1) print("____")
lookahead:release()
print("lookahead 1 after release:", lookahead(1))
