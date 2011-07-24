local pi = math.pi
local cos = math.cos
return 
{
  linear = function(t, b, c, d)
    return c * t / d + b
  end,
  swing = function(t, b, c, d)
    return ((-cos(pi * t / d) / 2) + 0.5) * c + b
  end
}
