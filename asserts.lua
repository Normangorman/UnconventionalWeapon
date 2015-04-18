function assertint(...)
  for i, v in ipairs({select("#", ...)}) do
    assert(type(v) == "number")
  end
end