local tokens = require 'tokens'
local nextToken = require 'lexer'

local token = nextToken()

while token.kind ~= tokens.EOF do
  print(token)
  token = nextToken()
end

print(token)
