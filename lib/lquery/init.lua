--получение переменной по ссылке и задание ей значения невозможны в луа, так что костыли
--TODO заюзать динамические функции!!
var_by_reference = function(var, value)
  if type(var) == 'table' then
    if #var == 1 then
      if value then _G[var[1]] = value else return _G[var[1]] end
    elseif #var == 2 then
      if value then _G[var[1]][var[2]] = value else return _G[var[1]][var[2]] end
    elseif #var == 3 then
      if value then _G[var[1]][var[2]][var[3]] = value else return _G[var[1]][var[2]][var[3]] end
    end
  else
    if value then _G[var] = value else return _G[var] end
  end
end

require("lib.lquery.entity")
require("lib.lquery.objects")

G = love.graphics --graphics
A = love.audio --audio
F = love.filesystem --files

getMouseXY = love.mouse.getPosition

lQuery.MousePressed = false

function love.run()
  if love.load then love.load(arg) end

  local dt = 0
  time = 0
  -- Main loop time.
  while true do
    if love.timer then
      love.timer.step()
      dt = love.timer.getDelta()
    end
    if love.update then
      love.update(dt)
    end
    -- Process events.
    if love.event then
      for e,a,b,c in love.event.poll() do
        if e == "q" then
          if not love.quit or not love.quit() then
            if love.audio then
              love.audio.stop()
            end
            return
          end
        end
        if e == "mp" then
          lQuery.MousePressed = true
          lQuery.MouseButton = c
        elseif e == "mr" then 
          lQuery.MousePressed = false
          lQuery.MouseButton = c
          --click handler
          local v = lQuery.MousePressedOwner
          if v and v._bound(v, mX, mY) then
            local v = lQuery.MousePressedOwner
            if v._mouserelease then 
              v._mouserelease(v, mX, mY, c)
            end
            if v._click then 
              v._click(v, mX, mY, c)
            end
          end
          lQuery.MousePressedOwner = nil
        elseif e == "kp" then
          lQuery.KeyPressed = true
          lQuery.KeyPressedKey = a
          lQuery.KeyPressedUni = b
          lQuery.KeyPressedCounter = 1
        elseif e == "kr" then
          lQuery.KeyPressed = false
        elseif e == "q" then
          if atexit then atexit() end
        end
        love.handlers[e](a,b,c)
      end
    end
    mX, mY = getMouseXY()
    if G then
      G.clear()
      time = love.timer.getTime()
      
      for _, v in pairs(lQuery.hooks) do
        v()
      end

      if screen then process_entities(screen) end

      if love.draw then love.draw() end
      G.present()
    end --if G
  end
end
