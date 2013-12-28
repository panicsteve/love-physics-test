function love.load()
	love.graphics.setNewFont(12)
	
	local windowHeight = love.window.getHeight()
	local windowWidth = love.window.getWidth()

	-- Init physics
	
	love.physics.setMeter(100)
	world = love.physics.newWorld(0, 80 * 9.81, true)

	-- Add static physics bodies to all 4 screen edges
	
	local edgeThickness = 4
	
	-- Bottom screen edge

	local edgeBody = love.physics.newBody(world, 0, windowHeight, "static")
	local edgeShape = love.physics.newRectangleShape(windowWidth * 2, edgeThickness)
	local edgeFixture = love.physics.newFixture(edgeBody, edgeShape, 1)

	-- Left screen edge

	edgeBody = love.physics.newBody(world, 0, 0, "static")
	edgeShape = love.physics.newRectangleShape(edgeThickness, windowHeight * 2)
	edgeFixture = love.physics.newFixture(edgeBody, edgeShape, 1)

	-- Top screen edge

	edgeBody = love.physics.newBody(world, 0, 0, "static")
	edgeShape = love.physics.newRectangleShape(windowWidth * 2, edgeThickness)
	edgeFixture = love.physics.newFixture(edgeBody, edgeShape, 1)

	-- Right screen edge

	edgeBody = love.physics.newBody(world, windowWidth, 0, "static")
	edgeShape = love.physics.newRectangleShape(4, windowHeight * edgeThickness)
	edgeFixture = love.physics.newFixture(edgeBody, edgeShape, 1)

	-- Create balls

	balls = {}
	numBalls = 20

	for i = 1, numBalls do
		balls[i] = {}
		
		-- Create dynamic physics body placed somewhere in the middle of the screen
		
		balls[i].body = love.physics.newBody(world, love.math.random(100, windowWidth - 100), love.math.random(100, windowHeight - 100), "dynamic")
		
		-- Define a circular shape with a random radius
		
		balls[i].shape = love.physics.newCircleShape(love.math.random(8, 48))
		
		-- Attach the shape to the body
		
		balls[i].fixture = love.physics.newFixture(balls[i].body, balls[i].shape, 1)
		
		-- Make it bouncy
		
		balls[i].fixture:setRestitution(1)
	end
end


function love.update(dt)
	-- Update physics
	
	world:update(dt)
end


function love.mousepressed(x, y, button)
	-- On left mouse button, apply upward impulse to all balls
	
	if button == "l" then
		for i = 1, numBalls do
			balls[i].body:applyLinearImpulse(0, -500)
		end
	end
end


function love.draw()
	-- Print FPS counter
	
	love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 20)
	
	-- Draw balls
	
	for i = 1, numBalls do
		local a = balls[i].body:getAngle()
		local x = balls[i].body:getX()
		local y = balls[i].body:getY()
		local r = balls[i].shape:getRadius()
		local segments = 36
		
		love.graphics.circle("line", x, y, r, segments)

		-- Draw a line from circle's center to edge along its rotational angle
		
		love.graphics.line(x, y, x + (math.cos(a) * r), y + (math.sin(a) * r))
	end
end
