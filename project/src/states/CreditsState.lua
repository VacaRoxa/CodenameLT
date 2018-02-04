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

CreditsState = Gamestate.new()

local stuff = {}
local opacityTween
local cutscene_p1_xpos
local cutscene_p2_xpos
local cutscene_p3_xpos
local opacity_step
local xpos_step
local change_scene_once
local cutscene_active 

local only_once
local function doOnlyOnce(fn)
  if only_once ~= true then
    only_once = true
    fn()
  end
end

local is_accept_enable = false
local function f_isAcceptPressed()
  if  is_accept_enable and keys_pressed['buttona'] then 
    is_accept_enable = false

   -- print(keys_pressed['buttona'])
    -- prevents player from skipping all text by accident
    Timer.after(0.6, function()
      is_accept_enable = true
    end)
    return true
  else
    return false
  end
end


function CreditsState:enter()
  only_once = false
  is_accept_enable = false
  cutscene_active = true
  opacityTween = 0
  xpos_step = 8
  opacity_step = 2
  change_scene_once = true
end

function CreditsState:update(dt)
  Timer.update(dt)

  if f_isAcceptPressed() then 
    print('pressed')
    goToGameState('StartScreen')
  end


  if opacityTween<256-opacity_step then
    opacityTween = opacityTween + opacity_step
  else 
    doOnlyOnce(function()
      is_accept_enable = true
    end)
  end

end


local function drawFn2()
    -- <Your drawing logic goes here.>
    -- love.graphics.draw(padLeft,a,2)
    love.graphics.setShader()
    cnv = love.graphics.newCanvas(GAME_WIDTH*2,GAME_HEIGHT*2)
    cnv:renderTo(function()

    end)


    love.graphics.setShader(shader_screen)
    strength = math.sin(love.timer.getTime()*2)
    shader_screen:send("abberationVector", {strength*math.sin(love.timer.getTime()*7)/200, strength*math.cos(love.timer.getTime()*7)/200})

    
end

function CreditsState:draw()
    screen:draw(drawFn2) -- Additional arguments will be passed to drawFn.
    love.graphics.scale(love.graphics.getWidth() / 640)
    love.graphics.draw(cnv,0,0)
    love.graphics.setColor(255,255,255,opacityTween)
    love.graphics.draw(Image.credits)
end

return CreditsState