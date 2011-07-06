local ringbuffer = {
  __call = function(tab, key)
    assert(key > 0, "element 0 is not defined")
    assert(key <= tab.size, "the buffer only holds "..tab.size.." elements, but element "..key.." was requested.")
    return tab[((tab.idx + key) % tab.size) + 1]
  end,

  push = function(tab, val)
    tab[tab.idx] = val
    tab.idx = (tab.idx % tab.size) + 1
    return val
  end
}

ringbuffer.__index = ringbuffer

ringbuffer.new = function(size)
  return setmetatable({size=size, idx=1}, ringbuffer)
end

return ringbuffer
