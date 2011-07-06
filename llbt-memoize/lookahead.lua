lookahead = {
  __call = function(la, i)
    la:sync(i)
    return la.buffer[la.p + (i - 1)]
  end,

  consume = function(la)
    la.p = la.p + 1

    -- have we hit end of buffer when not backtracking?
    if la.p > #la.buffer and not la:speculating() then
      -- if so, it's an opportunity to start filling at index 0 again
      la.p, la.buffer = 1, {}
    end

    la:sync(1) -- get another to replace consumed token
  end,

  -- Make sure we have i tokens from current position p
  sync = function(la, i)
    local n = la.p + (i - 1) - #la.buffer
    if n > 0 then -- out of tokens?
      local elem = la.nextelem()
      print("ELEM: ", elem)
      for i = 1, n do la.buffer[#la.buffer + 1] = elem end
    end
  end,

  mark = function(la)
    la.markers[#la.markers + 1] = la.p
    return p
  end,

  release = function(la)
    la.p = table.remove(la.markers)
  end,

  speculating = function(la)
    return #la.markers > 0
  end,

  -- support for rule memoization.
  memoizedRule = function(la, actions)
    local memo = {}
    return function()
      local idx = la.p -- get current token position
      print("At index "..idx)

      if la:speculating() then
        local res = memo[idx]; local kind = type(res)

        if kind == "nil" then
          -- Do nothing, we did not parse this rule yet.

        elseif kind == "table" then
          print("found ERROR memoized rule at "..idx)
          error(unpack(res))  -- Last result was an error.

        elseif kind == "number" then
          print("found SUCCESS memoized rule at "..idx..", will ff to "..res)
          la.p = res -- The rule was previously parsed, so fast forward and return.
          return
        end
      end

      -- must not have previously parsed list at tokenIndex; parse it
      local success, msg = pcall(actions)

      -- succeed or fail, must record result if backtracking
      if la:speculating() then
        if success then
          memo[idx] = la.p
        else
          memo[idx] = {false, msg}
        end
      end
    end
  end
}

lookahead.__index = lookahead

function lookahead.new(nextelem)
  local la = setmetatable({
    p = 1,        -- index of current lookahead token
    buffer = {},  -- dynamically-sized lookahead buffer
    markers = {}, -- stack of index markers into lookahead buffer
    nextelem = nextelem
  }, lookahead)

  la:sync(1) -- prime buffer with at least 1 token

  return la
end

return lookahead
