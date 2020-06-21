--[[
    4/11/2020
    Particle Simulator

    -- Particle Class --

    Author: Nakul Rao
]]



Particle = Class{}

function Particle:init(window_height, window_width, particle_size)
    math.randomseed(os.time())

    self.mass = 60--math.random(50, 255)

    self.radius = particle_size*self.mass/255
    self.x = math.random(0, window_width-2*self.radius)
    self.y = math.random(0, window_height-2*self.radius)

    self.dy = math.random(-150, 150)
    self.dx = math.random(-150, 150)
    self.red = 0
    self.green = 0
    self.blue =  0
    self.type = 0

    rand_num = math.random(1, 100)
    if(rand_num < 91) then
      self.type = 2
    elseif(rand_num < 99) then
      self.type = 3
    else
      self.type = 1
    end

    if self.type==1 then       --infected
      self.red = 255
    end

    if self.type==2 then       --uninfected
      self.blue = 255
    end

    if self.type==3 then       -- immune
      self.green = 255
    end

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
