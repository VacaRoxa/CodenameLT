--
--  Game
--

local Gamestate     = requireLibrary("hump.gamestate")
local Timer         = requireLibrary("hump.timer")
local Vector        = requireLibrary("hump.vector")
local Tween         = Timer.tween
local map
local a
local b
local strength
local cnv

Cutscene = Gamestate.new()

local stuff = {}
local opacityTween
local ypos_c0_step
local cutscene_p0_ypos
local cutscene_p1_xpos
local cutscene_p2_xpos
local cutscene_p3_xpos
local opacity_step
local xpos_step
local change_scene_once
local cutscene_active 
local waiter_last

-- only say fire ONCE
local has_said_fire_once
function sayFire()
  if has_said_fire_once ~= true then
    Sfx.GGJ18_cutscene_sniper_fire:play()
  end
  has_said_fire_once = true
end

function Cutscene:enter()
  has_said_fire_once = false
  opacityTween = 0
  xpos_step = 48
  opacity_step = 48
  ypos_c0_step = 32
  change_scene_once = true
  waiter_last = 0
  cutscene_p0_ypos = 1*GAME_HEIGHT
  cutscene_p1_xpos = 2*GAME_WIDTH
  cutscene_p2_xpos = 2*GAME_WIDTH
  cutscene_p3_xpos = 2*GAME_WIDTH
end

function Cutscene:update(dt)
  if cutscene_p0_ypos <= 0 then
    cutscene_p0_ypos = 0
  else
    cutscene_p0_ypos = cutscene_p0_ypos - ypos_c0_step
  end

  if opacityTween<256-opacity_step then
    opacityTween = opacityTween + opacity_step
  else 
    if cutscene_p1_xpos <= GAME_WIDTH then
      sayFire()
    end

    if cutscene_p1_xpos > xpos_step-1 then 
      cutscene_p1_xpos = cutscene_p1_xpos - xpos_step
    else
      cutscene_p1_xpos = 0
      if cutscene_p2_xpos > xpos_step-1 then 
        cutscene_p2_xpos = cutscene_p2_xpos - xpos_step
      else
        cutscene_p2_xpos = 0
        if cutscene_p3_xpos > xpos_step-1 then 
          cutscene_p3_xpos = cutscene_p3_xpos - xpos_step
        else
          cutscene_p3_xpos = 0
          if waiter_last < 32 then
            waiter_last = waiter_last +1
          else
            goToGameState('Game')
            if change_scene_once then 
              change_scene_once = false
            end
          end

      
        end
        
      end

    end
  end

  return Cutscene




end


local function drawFn2()
    -- <Your drawing logic goes here.>
    -- love.graphics.draw(padLeft,a,2)
    love.graphics.setShader()
    cnv = love.graphics.newCanvas(GAME_WIDTH,GAME_HEIGHT)
    cnv:renderTo(function()
      love.graphics.setColor(255,255,255,255)
      drawLastStateScreenshot()
      love.graphics.setColor(255,255,255,opacityTween)
      love.graphics.draw(Image.cutscene_01,0,cutscene_p0_ypos)
      love.graphics.draw(Image.cutscene_01_p1,cutscene_p1_xpos)
      love.graphics.draw(Image.cutscene_01_p2,cutscene_p2_xpos)
      love.graphics.draw(Image.cutscene_01_p3,cutscene_p3_xpos)

    end)


    love.graphics.setShader(shader_screen)
    strength = math.sin(love.timer.getTime()*2)
    shader_screen:send("abberationVector", {strength*math.sin(love.timer.getTime()*7)/200, strength*math.cos(love.timer.getTime()*7)/200})

    love.graphics.draw(cnv,0,0)
    
end

function Cutscene:draw()
    screen:draw(drawFn2) -- Additional arguments will be passed to drawFn.


end