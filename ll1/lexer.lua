-- grammar NestedNameList;
-- list : '[' elements ']' ; // match bracketed list
-- elements : element (',' element)* ; // match comma-separated list
-- element : NAME | list ; // element is name or nested list
-- NAME : ('a'..'z' |'A'..'Z' )+ ; // NAME is sequence of >=1 letter

local t = require("tokens")

local c = io.read(1)

local function isletter()
  return c and c:match("%a")
end

local function consume()
  c = io.read(1)
end

local function NAME()
  local val = {}
  while isletter() do
    val[#val+1] = c
    consume()
  end
  return t.new(t.NAME, table.concat(val))
end

local function WS()
  while c == ' ' or c == "\t" or c == "\n" or c == "\r" do consume() end
end

local function nextToken()
  while c do
    if c == ' ' or c == '\t' or c == '\n' or c == '\r' then WS()
    elseif c == ',' then consume(); return t.new(t.COMMA, ",")
    elseif c == '[' then consume(); return t.new(t.LBRACK, "[")
    elseif c == ']' then consume(); return t.new(t.RBRACK, "]")
    elseif (isletter()) then return NAME();
    else
      error("invalid character: "..c)
    end
  end
  return t.new(t.EOF, "<EOF>");
end

return nextToken
