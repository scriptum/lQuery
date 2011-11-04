--получение переменной по ссылке и задание ей значения невозможны в луа, так что костыли
var_by_ref = function(var, value)
	if value then loadstring(var .. '='..value)()
	else return loadstring('return '..var)()end
end

require("lib.lquery.entity")

if love then
	require("lib.lquery.objects_love")
	G = love.graphics --graphics
	A = love.audio --audio
	F = love.filesystem --files
	getMouseXY = love.mouse.getPosition
	lQuery.draw = function(ent)
		G.setColor(ent.r or 255, ent.g or 255, ent.b or 255, ent.a or 255)
		if ent.blendMode then G.setBlendMode(ent.blendMode) end
		if type(ent._draw) == 'function' then
			ent._draw(ent)
		else
			for _, v in ipairs(ent._draw) do v(ent) end
		end
		if ent.blendMode then G.setBlendMode('alpha') end
	end
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
			--get mouse position
			mX, mY = getMouseXY()
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
					lQuery.event(e,a,b,c)
					love.handlers[e](a,b,c)
				end
			end
			
			if G then
				G.clear()
				time = love.timer.getTime()
				
				lQuery.process()
				
				if love.draw then love.draw() end
				G.present()
			end --if G
	  end
	end
else
	require("lib.lquery.objects")
	S = scrupp
	getMouseXY = S.getMousePos
	lQuery.draw = function(ent)
		S.setColor(ent.r or 255, ent.g or 255, ent.b or 255, ent.a or 255)
		if ent.blendMode then S.setBlendMode(ent.blendMode) end
		if type(ent._draw) == 'function' then
			ent._draw(ent)
		else
			for _, v in ipairs(ent._draw) do v(ent) end
		end
		if ent.blendMode then S.setBlendMode('alpha') end
	end

	main ={
		render = function()
		mX, mY = getMouseXY()
		time = scrupp.getTicks() / 1000
		--events
		local e, a, b, c = scrupp.poll()
		if e then
		  lQuery.event (e,a,b,c)
		end
		lQuery.process()
	  end
	}
end
lQuery.MousePressed = false
