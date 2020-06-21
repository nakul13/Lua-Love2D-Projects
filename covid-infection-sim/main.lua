--[[
  4/11/2020
  Particle Simulator

  -- Particle Class --

  Author: Nakul Rao
]]

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- Particle class
require 'Particle'

-- size of our actual window
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
PARTICLE_SIZE = 25


--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    -- love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Particle Simulator')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 12)
    largeFont = love.graphics.newFont('font.ttf', 28)
    love.graphics.setFont(smallFont)

    love.window.setMode( WINDOW_WIDTH, WINDOW_HEIGHT)

    particleArray = {}

    particleCount = 0
    begin_infection = 0
    infectedCount = 0
    uninfectedCount = 0
    immuneCount = 0
end

--[[
    Called every frame, passing in `dt` since the last frame. `dt`
    is short for `deltaTime` and is measured in seconds. Multiplying
    this by any changes we wish to make in our game will allow our
    game to perform consistently across all hardware; otherwise, any
    changes we make will be applied as fast as possible and will vary
    across system hardware.
]]
function love.update(dt)

  for i=1, particleCount do
    for j=i+1, particleCount do
      if particleArray[i]:collides(particleArray[j]) then
          newDeltaVi = (particleArray[i].mass - particleArray[j].mass)*particleArray[i].dx/(particleArray[i].mass + particleArray[j].mass) + 2*particleArray[j].mass*particleArray[j].dx/(particleArray[i].mass + particleArray[j].mass)
          newDeltaVj = 2*particleArray[i].mass*particleArray[i].dx/(particleArray[i].mass + particleArray[j].mass) + (particleArray[j].mass - particleArray[i].mass)*particleArray[j].dx/(particleArray[i].mass + particleArray[j].mass)
          particleArray[i].dx = newDeltaVi
          particleArray[j].dx = newDeltaVj
          newDeltaVi = (particleArray[i].mass - particleArray[j].mass)*particleArray[i].dy/(particleArray[i].mass + particleArray[j].mass) + 2*particleArray[j].mass*particleArray[j].dy/(particleArray[i].mass + particleArray[j].mass)
          newDeltaVj = 2*particleArray[i].mass*particleArray[i].dy/(particleArray[i].mass + particleArray[j].mass) + (particleArray[j].mass - particleArray[i].mass)*particleArray[j].dy/(particleArray[i].mass + particleArray[j].mass)
          particleArray[i].dy = newDeltaVi
          particleArray[j].dy = newDeltaVj

          overlap = (particleArray[i].radius + particleArray[j].radius) - math.sqrt((particleArray[i].x - particleArray[j].x)*(particleArray[i].x - particleArray[j].x) + (particleArray[i].y - particleArray[j].y)*(particleArray[i].y - particleArray[j].y));

          if(particleArray[i].mass > particleArray[j].mass) then
            sinTheta = particleArray[j].dy/(particleArray[j].dy*particleArray[j].dy + particleArray[j].dx*particleArray[j].dx)
            cosTheta = particleArray[j].dx/(particleArray[j].dy*particleArray[j].dy + particleArray[j].dx*particleArray[j].dx)
            if particleArray[j].x < particleArray[i].x then
              particleArray[j].x = particleArray[j].x - (overlap)*cosTheta - 1
            else
              particleArray[j].x = particleArray[j].x + (overlap)*cosTheta + 1
            end
            if particleArray[j].y < particleArray[i].y then
              particleArray[j].y = particleArray[j].y - (overlap)*sinTheta - 1
            else
              particleArray[j].y = particleArray[j].y + (overlap)*sinTheta + 1
            end
          else
            sinTheta = particleArray[i].dy/(particleArray[i].dy*particleArray[i].dy + particleArray[i].dx*particleArray[i].dx)
            cosTheta = particleArray[i].dx/(particleArray[i].dy*particleArray[i].dy + particleArray[i].dx*particleArray[i].dx)
            if particleArray[i].x < particleArray[j].x then
              particleArray[i].x = particleArray[i].x - (overlap)*cosTheta - 1
            else
              particleArray[i].x = particleArray[i].x - (overlap)*cosTheta + 1
            end
            if particleArray[i].y < particleArray[j].y then
              particleArray[i].y = particleArray[i].y - (overlap)*sinTheta - 1
            else
              particleArray[i].y = particleArray[i].y - (overlap)*sinTheta + 1
            end
          end --if

          --Spread the infection
          if begin_infection == 1 then
            if particleArray[i].type == 1 and particleArray[j].type == 2 then
              particleArray[j].type = 1
              particleArray[j].red = 255
              particleArray[j].green = 0
              particleArray[j].blue = 0
              infectedCount = infectedCount + 1
              uninfectedCount = uninfectedCount - 1
            end

            if particleArray[j].type == 1 and particleArray[i].type == 2 then
              particleArray[i].type = 1
              particleArray[i].red = 255
              particleArray[i].green = 0
              particleArray[i].blue = 0
              infectedCount = infectedCount + 1
              uninfectedCount = uninfectedCount - 1
            end
          end
      end --if
    end -- for
  end -- for

    for k in pairs (particleArray) do
        if particleArray[k].y <= 0 then
            particleArray[k].y = 0
            particleArray[k].dy = -particleArray[k].dy
        end

        if particleArray[k].x <= 0 then
            particleArray[k].x = 0
            particleArray[k].dx = -particleArray[k].dx
        end

        if particleArray[k].y >= WINDOW_HEIGHT - 2*particleArray[k].radius then
            particleArray[k].y = WINDOW_HEIGHT - 2*particleArray[k].radius
            particleArray[k].dy = -particleArray[k].dy
        end

        if particleArray[k].x >= WINDOW_WIDTH - 2*particleArray[k].radius then
            particleArray[k].x = WINDOW_WIDTH - 2*particleArray[k].radius
            particleArray[k].dx = -particleArray[k].dx
        end
    end


    for k in pairs (particleArray) do
      particleArray[k]:update(dt)
    end
end


--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    -- `key` will be whatever key this callback detected as pressed
    if key == 'escape' then
        -- the function LÖVE2D uses to quit the application
        love.event.quit()
    -- if we press enter during either the start or serve phase, it should
    -- transition to the next appropriate state
    elseif key == 'enter' or key == 'return' then
      for k in pairs (particleArray) do
        particleArray [k] = nil
      end
      particleCount = 0
      begin_infection = 0
      infectedCount = 0
      uninfectedCount = 0
      immuneCount = 0
    elseif key == 'space' then
      table.insert(particleArray, Particle(WINDOW_HEIGHT, WINDOW_WIDTH, PARTICLE_SIZE))
      particleCount = particleCount + 1
      if particleArray[particleCount].type == 1 then
        infectedCount = infectedCount + 1
      elseif particleArray[particleCount].type == 2 then
        uninfectedCount = uninfectedCount + 1
      else
        immuneCount = immuneCount + 1
      end
    elseif key == 'q' then
      begin_infection = 1
    end
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    love.graphics.clear(0, 0, 0, 255)

    if(particleCount > 0) then
      --Draw all the Particles
      for k in pairs (particleArray) do
        particleArray[k]:render()
      end
    else
      displayInit()
    end

    displayParticleCount()
end


--[[
    Renders the instructions
]]
function displayInit()
  love.graphics.setFont(largeFont)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print('Hit SpaceBar to create a new participant', WINDOW_WIDTH/2 - 280, WINDOW_HEIGHT/2 - 40)
  love.graphics.print('Hit ENTER to destroy all participants', WINDOW_WIDTH/2 - 260, WINDOW_HEIGHT/2 + 40)
  love.graphics.setColor(0, 0, 0, 255)
end


--[[
    Renders the current numbers of Particles
]]
function displayParticleCount()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 20, 20)
    love.graphics.print('Infected  : ' .. tostring(infectedCount), 20, 40)
    love.graphics.print('UnInfected: ' .. tostring(uninfectedCount), 20, 60)
    love.graphics.print('Immune    : ' .. tostring(immuneCount), 20, 80)
    love.graphics.print('Total     : ' .. tostring(particleCount), 20, 100)
    love.graphics.setColor(0, 0, 0, 255)
end
