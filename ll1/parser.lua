-- grammar NestedNameList;
-- list : '[' elements ']' ; // match bracketed list
-- elements : element (',' element)* ; // match comma-separated list
-- element : NAME | list ; // element is name or nested list
-- NAME : ('a'..'z' |'A'..'Z' )+ ; // NAME is sequence of >=1 letter

local tokens = require 'tokens'
local nextToken = require "lexer"

local lookahead

function consume()
  lookahead = nextToken()
  print(lookahead)
end

function match(kind)
  if lookahead.kind == kind then
    consume()
  else
    error("expecting "..tokens[kind].." but found "..tostring(lookahead))
  end
end

-- list : '[' elements ']' ; // match bracketed list
function list()
  match(tokens.LBRACK)
  elements()
  match(tokens.RBRACK);
end

-- elements : element (',' element)* ;
function elements()
  element()
  while lookahead.kind == tokens.COMMA do
    match(tokens.COMMA)
    element()
  end
end

-- element : name | list ; // element is name or nested list
function element()
  if lookahead.kind == tokens.NAME then match(tokens.NAME)
  elseif lookahead.kind == tokens.LBRACK then list()
  else error("expecting name or list; found "..tostring(lookahead))
  end
end

consume()
list() -- startup parser.
