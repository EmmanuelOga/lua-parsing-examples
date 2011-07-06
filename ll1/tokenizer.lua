local tokens = require 'tokens'
local nextToken = require "lexer"

local t = nextToken()

while t.kind ~= tokens.EOF do
  print(t)
  t = nextToken()
end

print(t)
