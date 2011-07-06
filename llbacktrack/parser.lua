--grammar NameListWithParallelAssign;
--options {backtrack=true;}
--// START: parser
--stat     : list EOF | assign EOF ;
--assign   : list '=' list ;
--list     : '[' elements ']' ;        // match bracketed list
--elements : element (',' element)* ;  // match comma-separated list
--element  : NAME '=' NAME | NAME | list ; //element is name, nested list
--// END: parser
--NAME     : LETTER+ ;                 // name is sequence of >=1 letter
--fragment
--LETTER   : 'a'..'z'|'A'..'Z';        // define what a letter is (\w)
--WS       : (' '|'\t'|'\n'|'\r')+ {skip();} ; // throw out whitespace

local tokens = require 'tokens'
local nextToken = require "lexer"
local la = require "lookahead"

local lookahead = la.new(nextToken)

function match(kind)
  if lookahead(1).kind == kind then
    lookahead:consume()
  else
    error("expecting "..tokens[kind].." but found "..tostring(lookahead(1)))
  end
end

-- basic backtracking mechanism
function matchorbacktrack(name, func)
  lookahead:mark() -- mark this spot in input so we can rewind
  local success, msg = pcall(func)
  lookahead:release() -- either way, rewind to where we were
  if success then
    func()  -- if the match succeeded then perform it.
  else
    print("Failed matching "..name.." with msg: "..msg..". Backtracked.")
  end
  return success
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

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

-- this is the statement needing backtrack
-- stat : list EOF | assign EOF
function stat()
  return matchorbacktrack("list",       function() list(); match(tokens.EOF) end) or
         matchorbacktrack("assignment", function() assign(); match(tokens.EOF) end) or
         error("expecting stat but found "..tostring(lookahead(1)))
end

-- assign : list '=' list ; // parallel assignment
function assign()
  list()
  match(tokens.EQUALS)
  list()
end

-- list : '[' elements ']' ; // match bracketed list
function list()
  match(tokens.LBRACK)
  elements()
  match(tokens.RBRACK)
end

-- elements : element (',' element)* ; // match comma-separated list
function elements()
  element()
  while (lookahead(1).kind == tokens.COMMA) do
    match(tokens.COMMA)
    element()
  end
end

-- element : name '=' NAME | NAME | list ; // assignment, name or list
function element()
  if lookahead(1).kind == tokens.NAME and lookahead(2).kind == tokens.EQUALS then
    match(tokens.NAME)
    match(tokens.EQUALS)
    match(tokens.NAME)
  elseif lookahead(1).kind == tokens.NAME then
    match(tokens.NAME)
  elseif lookahead(1).kind == tokens.LBRACK then
    list()
  else
    error("expecting element, but found "..tostring(lookahead(1)))
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

stat() -- startup parser.
