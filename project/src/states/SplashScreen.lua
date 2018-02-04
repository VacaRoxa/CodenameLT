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

SplashScreen = Gamestate.new()

local stuff = {}
local opacityTween
local opacity_step
local opacity_step_out
local opacityTweenFadout
local change_scene_once
local cutscene_active 
local delay

local only_once
local function doOnlyOnce(fn)
  if only_once ~= true then
    only_once = true
    fn()
  end
end


local only_once2
local function doOnlyOnce2(fn)
  if only_once2 ~= true then
    only_once2 = true
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


function SplashScreen:enter()
  only_once = false
  only_once2 = false
  is_accept_enable = false
  cutscene_active = true
  opacityTween = 0
  opacity_step = 2
  opacity_step_out = 8
  change_scene_once = true
  opacityTweenFadout = 255
  delay = 0
  --Sfx.Vaca_Load:play()
end

function SplashScreen:update(dt)
  Timer.update(dt)

  if f_isAcceptPressed() then 
    print('pressed')
    goToGameState('StartScreen')
  end

  delay= delay+ 1

  if delay < 24 then
    return
  end


  doOnlyOnce2(function()
    Sfx.Vaca_Load:play()
  end)

  if opacityTween<256-opacity_step then
    if opacityTween > 32 and opacityTween < 32 + 1+opacity_step then
      opacityTween = opacityTween + 24
    end

    if opacityTween > 64 and opacityTween < 64 + 1+opacity_step then
      opacityTween = opacityTween + 24
    end


    if opacityTween > 128 and opacityTween < 128 + 1+opacity_step then
      opacityTween = opacityTween + 24
    end

    opacityTween = opacityTween + opacity_step
  else 
    doOnlyOnce(function()
      is_accept_enable = true
    end)

    if opacityTweenFadout>0+opacity_step_out then
      if opacityTweenFadout < 120 then
        opacity_step_out = 3
      end
      if opacityTweenFadout < 32 then
        opacity_step_out = 2
      end
      if opacityTweenFadout < 18 then
        opacity_step_out = 1
      end
      opacityTweenFadout = opacityTweenFadout - opacity_step_out
    else 
      goToGameState('StartScreen')
    end
    
  end

end


local function drawFn2()
    -- <Your drawing logic goes here.>
    -- love.graphics.draw(padLeft,a,2)
    love.graphics.setShader()
    cnv = love.graphics.newCanvas(GAME_WIDTH,GAME_HEIGHT)
    cnv:renderTo(function()
      if opacityTween < 256-opacity_step then
        love.graphics.setColor(255,255,255,opacityTween)
      else
        love.graphics.setColor(255,255,255,opacityTweenFadout)
      end

      love.graphics.draw(Image.vaca_splash)
    end)


    love.graphics.setShader(shader_screen)
    love.graphics.draw(cnv,0,0)
    strength = 2*math.sin(love.timer.getTime()*3)
    shader_screen:send("abberationVector", {strength*math.sin(love.timer.getTime()*7)/150, strength*math.cos(love.timer.getTime()*7)/200})

    
end

function SplashScreen:draw()
    screen:draw(drawFn2) -- Additional arguments will be passed to drawFn
end

return SplashScreen