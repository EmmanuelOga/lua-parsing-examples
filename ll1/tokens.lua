local tokens = {
  "EOF",
  "NAME",
  "COMMA",
  "LBRACK",
  "RBRACK",
}

tokens.__tostring = function(tab)
  return tokens[tab.kind]..": "..tostring(tab.val)
end

tokens.new = function(kind, val)
  return setmetatable({ kind=kind, val=val }, tokens)
end

-- save each token as a numeric value.
for i, v in ipairs(tokens) do
  tokens[v] = i
end

return tokens
