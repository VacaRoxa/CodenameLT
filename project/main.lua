--
--
--  Created by Tilmann Hars
--  Copyright (c) 2014 Headchant. All rights reserved.
--

-- Set Library Folders
_LIBRARYPATH = "libs"
_LIBRARYPATH = _LIBRARYPATH .. "/"

requireLibrary = function(name)
	return require(_LIBRARYPATH..name)
end

-- Get the libs manually
local strict    = requireLibrary("strict")
local slam      = requireLibrary("slam")
local Terebi    = requireLibrary("terebi")
local Gamestate = requireLibrary("hump/gamestate")

-- Game Version
GAME_VERSION = '1.0.0'

-- a variable for debug flags
debug_mode = false
restart = false

-- the library for Tiled map
sti = requireLibrary("sti")

-- adding Object to lua
Object = requireLibrary("classic")

-- Declare Global Variables
screen = nil
class_commons = nil
common = nil
no_game_code = nil 

game_locale = nil

-- fonts
font_16bfZX = nil
font_HelvetiPixel = nil
font_MicroStyle = nil
font_Minimal4 = nil
font_PixelMordred = nil
font_SullyVerge = nil
font_TimesNewPixel = nil
font_Verdana2 = nil

GAME_WIDTH = 320
GAME_HEIGHT = 180

-- shader screen
shader_screen = nil

-- the keyboard and joystick interface
keys = {}
keys_pressed = {}
keys_previousGamepad = {}

local p1joystick = nil

-- creating a global ternary if function
function ternary ( cond , T , F )
  if cond then return T else return F end
end

-- adding a function to remove keys from tables
function table.removekey(table, key)
	local element = table[key]
	table[key] = nil
	return element
end

-- Global Functions inspired by picolove https://github.com/gamax92/picolove/blob/master/api.lua
function all(a)
	if a==nil or #a==0 then
		return function() end
	end
	local i, li=1
	return function()
		if (a[i] == li) then 
			i = i + 1 
		end
		while(a[i] == nil and i<=#a) do
			i = i + 1 
		end
		li = a[i]
		return a[i]
	end
end

function add(a, v)
	if a == nil then
		return
	end
	a[#a+1] = v
end

function del(a, dv)
	if a == nil then
		return
	end
	for i=1, #a do
		if a[i] == dv then
			table.remove(a, i)
			return
		end
	end
end

function rnd()
	return math.random()
end

local screenShotFromLastState

local function saveScreenShotFromLastState()
  local scrn = love.graphics.newScreenshot()
	local canvas = love.graphics.newCanvas(GAME_WIDTH,GAME_HEIGHT) -- make a canvas that is the proper dimensions
	canvas:renderTo(function()
		love.graphics.setColor(255,255,255,255) -- set colour to white, i.e. draw normally
		love.graphics.draw(love.graphics.newImage(scrn),0,0, -- draw the screenshot at 0,0
		0, -- 0 rotation
		canvas:getWidth() / love.graphics.getWidth(), -- x scale
		canvas:getHeight() / love.graphics.getHeight() -- y scale
		)
  end)
  -- this resizes the canvas get's it's data and put's in an image
  screenShotFromLastState = love.graphics.newImage(canvas:newImageData())
end

function drawLastStateScreenshot()
  love.graphics.draw(screenShotFromLastState)
end

function goToGameState(stateString)
  saveScreenShotFromLastState()
  if stateString=='Game' then
    Gamestate.switch(Game)
  elseif stateString=='Cutscene' then
    Gamestate.switch(Cutscene)
  elseif stateString=='StartScreen' then
    Gamestate.switch(StartScreen)
  elseif stateString=='CreditsState' then
    Gamestate.switch(CreditsState)
  elseif stateString=='SplashScreen' then
    Gamestate.switch(SplashScreen)
  end

end

--[[
require("tests.tests")
--]]

-- Creates a proxy via rawset.
-- Credit goes to vrld: https://github.com/vrld/Princess/blob/master/main.lua
-- easier, faster access and caching of resources like images and sound
-- or on demand resource loading
local function Proxy(f)
	return setmetatable({}, {__index = function(self, k)
		local v = f(k)
		rawset(self, k, v)
		return v
	end})
end

-- Standard proxies
Image   = Proxy(function(k) return love.graphics.newImage('img/' .. k .. '.png') end)
Sfx     = Proxy(function(k) return love.audio.newSource('sfx/' .. k .. '.ogg', 'static') end)
Music   = Proxy(function(k) return love.audio.newSource('music/' .. k .. '.ogg', 'stream') end)

--[[ examples:
    love.graphics.draw(Image.background)
-- or    
    Sfx.explosion:play()
--]]


local lastPlayingMusic
function playMusic(musicName)
  if musicName ~= lastPlayingMusic then
    if lastPlayingMusic ~= nil then
      Music[lastPlayingMusic]:stop()
    end
    Music[musicName]:play()
  end

  lastPlayingMusic = musicName
end
    
-- Require all files in a folder and its subfolders, this way we do not have to require every new file
local function recursiveRequire(folder, tree)
  local tree = tree or {}
  for i,file in ipairs(love.filesystem.getDirectoryItems(folder)) do
      local filename = folder.."/"..file
      if love.filesystem.isDirectory(filename) then
          recursiveRequire(filename)
      elseif file ~= ".DS_Store" then
          require(filename:gsub(".lua",""))
      end
  end
  return tree
end



local function extractFileName(str)
	return string.match(str, "(.-)([^\\/]-%.?([^%.\\/]*))$")
end

-- Initialization
function love.load(arg)
	for k, v in ipairs(arg) do
		-- mute music
		if (v == '-nomusic') then
			Music.ggj18_ambient:setVolume(0)
    		Music.ggj18_theme:setVolume(0)
		end
		print(k .. ' ' .. v)
	end
	math.randomseed(os.time())
	love.graphics.setDefaultFilter("nearest", "nearest")
	-- love.mouse.setVisible(false)
    -- print "Require Sources:"
	recursiveRequire("src")
	Gamestate.registerEvents()
  Gamestate.switch(SplashScreen)
  
  -- set locale
  game_locale = 'en'

  -- Set nearest-neighbour scaling. Calling this is optional.
  Terebi.initializeLoveDefaults()

  -- Parameters: game width, game height, starting scale factor
  screen = Terebi.newScreen(GAME_WIDTH,GAME_HEIGHT, 1)
    -- This color will used for fullscreen letterboxing when content doesn't fit exactly. (Optional)
    :setBackgroundColor(64, 64, 64)

  if GAME_WIDTH == 320 then
    screen:increaseScale()
  end

  -- add all font as objects
	font_Verdana2 = love.graphics.newFont("fonts/Verdana2.ttf", 16)

	-- adding a general map of keys
	keys = {
		up = false,
		down = false,
		right = false,
		left = false,
		buttona = false,
		buttonb = false,
		buttonx = false,
		buttony = false
	}

	--shader test from rxi
	shader_screen = love.graphics.newShader[[
		extern vec2 abberationVector;

		vec4 effect(vec4 color, Image currentTexture, vec2 texCoords, vec2 screenCoords){
			vec4 finalColor = vec4(1);
			finalColor.r = Texel(currentTexture, texCoords.xy + abberationVector).r;
			finalColor.g = Texel(currentTexture, texCoords.xy).g;
			finalColor.b = Texel(currentTexture, texCoords.xy - abberationVector).b;
			return finalColor;
		}
  ]]


end

-- Logic
function love.update( dt )
  -- things for joystick
	if p1joystick ~= nil then
		-- getGamepadAxis returns a value between -1 and 1.
		-- It returns 0 when it is at rest

		if     p1joystick:getGamepadAxis("leftx")<-0.2 then
			if keys_previousGamepad['left']~=true then
				keys_pressed['left'] = true
				keys_previousGamepad['left'] = true
			end
		else
			if keys_previousGamepad['left']==true then
				keys_pressed['left'] = nil
				keys_previousGamepad['left'] = false
			end
		end


		if     p1joystick:getGamepadAxis("leftx")>0.2 then
			if keys_previousGamepad['right']~=true then
				keys_pressed['right'] = true
				keys_previousGamepad['right'] = true
			end
		else
			if keys_previousGamepad['right']==true then
				keys_pressed['right'] = nil
				keys_previousGamepad['right'] = false
			end
		end


		if     p1joystick:getGamepadAxis("lefty")>0.2 then
			if keys_previousGamepad['down']~=true then
				keys_pressed['down'] = true
				keys_previousGamepad['down'] = true
			end
		else
			if keys_previousGamepad['down']==true then
				keys_pressed['down'] = nil
				keys_previousGamepad['down'] = false
			end
		end


		if     p1joystick:getGamepadAxis("lefty")<-0.2 then
			if keys_previousGamepad['up']~=true then
				keys_pressed['up'] = true
				keys_previousGamepad['up'] = true
			end
		else
			if keys_previousGamepad['up']==true then
				keys_pressed['up'] = nil
				keys_previousGamepad['up'] = false
			end
		end

	end
end




-- Rendering
function love.draw()
end

-- Input
local alt_is_pressed

function love.keypressed(key)

  if key == 'lalt' or key == 'ralt' then
    alt_is_pressed = true
    return
  end

  if     key == 'f1' then
    debug_mode = debug_mode == false
  elseif key == 'f5' then
    restart = true
  end

  if     key == '=' or key == '+' then
    screen:increaseScale()
  elseif key == '-' then
    screen:decreaseScale()
  elseif key == 'f11' or (alt_is_pressed and (key == 'return' or key == 'kpenter')) then
    screen:toggleFullscreen()
  elseif key == 'escape' then
    goToGameState('StartScreen')
	end	
	
	if     key == 'up' or key == 'w' then
		keys_pressed['up'] = true
	elseif key == 'down' or key == 's' then
		keys_pressed['down'] = true
	elseif key == 'left' or key == 'a' then
		keys_pressed['left'] = true
	elseif key == 'right' or key == 'd' then
		keys_pressed['right'] = true
	end

	if     key == 'i' then
		keys_pressed['buttonx'] = true
	elseif key == 'k' or key == 'space' then
		keys_pressed['buttona'] = true
	elseif key == 'j' then
		keys_pressed['buttony'] = true
	elseif key == 'l' then
		keys_pressed['buttonb'] = true
	end


end

function love.keyreleased(key)
  if key == 'lalt' or key == 'ralt' then
    alt_is_pressed = false
    return
  end

	if     key == 'up' or key == 'w' then
		keys_pressed['up'] = nil
	elseif key == 'down' or key == 's' then
		keys_pressed['down'] = nil
	elseif key == 'left' or key == 'a' then
		keys_pressed['left'] = nil
	elseif key == 'right' or key == 'd' then
		keys_pressed['right'] = nil
	end	

	if     key == 'i' then
		keys_pressed['buttonx'] = nil
	elseif key == 'k' then
		keys_pressed['buttona'] = nil
	elseif key == 'j' then
		keys_pressed['buttony'] = nil
	elseif key == 'l' then
		keys_pressed['buttonb'] = nil
	end

end

function love.mousepressed()
	
end

function love.mousereleased()
	
end

function love.joystickadded(joystick)
	p1joystick = joystick
end

function love.joystickpressed(joystick, btn)

  if debug_mode then 
    print(btn)	
  end
  

	if     tonumber(btn) == 3 then
		keys_pressed['buttonx'] = true
	elseif tonumber(btn) == 1 then
		keys_pressed['buttona'] = true
	elseif tonumber(btn) == 4 then
		keys_pressed['buttony'] = true
	elseif tonumber(btn) == 2 then
		keys_pressed['buttonb'] = true
	end
end

function love.joystickreleased(joystick, btn)
	if     tonumber(btn) == 3 then
		keys_pressed['buttonx'] = nil
	elseif tonumber(btn) == 1 then
		keys_pressed['buttona'] = nil
	elseif tonumber(btn) == 4 then
		keys_pressed['buttony'] = nil
	elseif tonumber(btn) == 2 then
		keys_pressed['buttonb'] = nil
	end
	
end

-- Get console output working with sublime text
io.stdout:setvbuf("no")
