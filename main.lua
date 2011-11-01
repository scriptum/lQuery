require('lib.lquery')

balls = Entity:new(screen)

function rand_pos()
  return {x=math.random(50,800-50), y=math.random(50, 600-50)}
end

for i=1, 500 do
  --point and circle have same rendering spedd but point looks more smooth
  Entity:new(balls):point(10) --new circle of radius 10
        :move(400,300) --move to the center of the screen
        :color(math.random(125,255),math.random(125,255),math.random(125,255)) --random color
        :animate(rand_pos, {speed= 1, loop=true, queue='loop'}) --animate to random position
        :delay({speed=2, loop=true, queue='loop'}) --delay between animations
        :mouseover(function(self)
            self:stop('main'):animate({R=30,a=200})  --increase size when mouse is over
        end)
        :mouseout(function(self) 
            self:stop('main'):animate({R=10,a=255}, 0.5)  --restore size when mouse is out
        end)
        :click(function(self, x, y)
          table.foreach(balls._child, function(key, value) --loop throw all balls
            value :stop('click')
                  :delay({speed=key/1000, queue='click'})
                  :animate({x=x,y=y}, {queue='click'}) 
          end) --move all balls to the click point
        end)
end

text = Entity:new(screen):draw(function(s)
  G.print('FPS: '..love.timer.getFPS() .. '\nMemory: ' .. gcinfo(),s.x,s.y)
  G.printf('Try to click on the circle',s.x,s.y, 800, 'center')
end)

--mouse = Entity:new(screen):draw(function(s)love.mouse.setPosition(s.x, s.y)end):animate({x=500, y=100}):animate({y=200}, {speed=1,callback=function(s)s:delete()end})

