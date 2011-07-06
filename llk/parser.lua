-- grammar NestedNameList;
-- list : '[' elements ']' ; // match bracketed list
-- elements : element (',' element)* ; // match comma-separated list
-- element : NAME '=' NAME // match assignment such as a=b, this makes the grammar LL(2)
--           | NAME
--           | list
--           ;
-- NAME : ('a'..'z' |'A'..'Z' )+ ; // NAME is sequence of >=1 letter

local tokens = require 'tokens'
local nextToken = require "lexer"
local rb = require "ringbuffer"

local K = 2 -- amount of lookahead
local lookahead = rb.new(K)

function consume()
  lookahead:push(nextToken())
  print(lookahead(1))
end

function match(kind)
  if lookahead(1).kind == kind then
    consume()
  else
    error("expecting "..tokens[kind].." but found "..tostring(lookahead(1)))
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
  while lookahead(1).kind == tokens.COMMA do
    match(tokens.COMMA)
    element()
  end
end

-- element : NAME '=' NAME | NAME | list ; assignment, NAME or list
function element()
  if lookahead(1).kind == tokens.NAME and
     lookahead(2).kind == tokens.EQUALS then match(tokens.NAME); match(tokens.EQUALS); match(tokens.NAME)
  elseif lookahead(1).kind == tokens.NAME then match(tokens.NAME)
  elseif lookahead(1).kind == tokens.LBRACK then list()
  else error("expecting name or list; found "..tostring(lookahead(1)))
  end
end

for k = 1, K do consume() end
list() -- startup parser.
