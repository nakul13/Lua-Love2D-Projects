--[[
    4/11/2020
    Particle Simulator

    -- Particle Class --

    Author: Nakul Rao
]]

-- TODO - Add viscosity
-- TODO - Add pressure


Particle = Class{}

function Particle:init(window_height, window_width, particle_size)
    math.randomseed(os.time())

    self.mass = math.random(50, 255)

    self.radius = particle_size*self.mass/255
    self.x = math.random(0, window_width-2*self.radius)
    self.y = math.random(0, window_height-2*self.radius)

    self.dy = math.random(-150, 150)
    self.dx = math.random(-150, 150)
    self.red = math.random(100, 255)
    self.green = math.random(100, 255)
    self.blue =  math.random(100, 255)
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function Particle:collides(particle2)
    if math.sqrt((self.x-particle2.x)*(self.x-particle2.x) + (self.y-particle2.y)*(self.y-particle2.y)) > (self.radius+particle2.radius) then
      return false
    else
      return true
    end

end

function Particle:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Particle:render()
    love.graphics.setColor(self.red, self.green, self.blue, 255)
    love.graphics.circle('fill', self.x, self.y, self.radius)
end
