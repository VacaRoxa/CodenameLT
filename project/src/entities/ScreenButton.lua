-- OnScreenButtons by Érico Vieira Porto 2018

local Gamestate     = requireLibrary("hump.gamestate")
local Class         = requireLibrary("hump.class")

ScreenButton = Class{
  -- initializes the inventory
  init = function(self)
    self.osString = love.system.getOS( )
    self.joy = {
      r = 32,
      x = 48,
      y = 132,
      ini_x = 48,
      ini_y = 132,
      deadzone = 7,
      color = {255,255,255,255},
    }

    self.buttonA = {
      r = 28,
      x = 266,
      y = 140,
      color = {255,255,255,255},
    }

    self.touchpos = {
      x=-1,
      y=-1,
    }
    self.scale = nil
    self.pressed = {}
    self.previouPressed = {}
    self.isTouching = false
    self.wasTouching = false
  end,
  
  update = function(self, dt)
    if self.osString ~= "Android" and self.osString ~= "iOS" then
      return
    end


    self.previouPressed.left = self.pressed.left
    self.previouPressed.right = self.pressed.right
    self.previouPressed.up = self.pressed.up
    self.previouPressed.down = self.pressed.down
    self.previouPressed.buttona = self.pressed.buttona

    local touches = love.touch.getTouches()
    local x, y, sx, sy
    self.scale = screen:getScale()
 
    for i, id in ipairs(touches) do
        x, y = love.touch.getPosition(id)
        sx =  x / self.scale 
        sy =  y / self.scale
    end

    -- used for edge/border detection (state as square wave)
    self.wasTouching = self.isTouching
    if x~=nil and y~=nil then 
      self.isTouching = true
    else
      sx = -1
      sy = -1
      self.isTouching = false
    end

    -- checks if touchdown or touchup
    if self.wasTouching == false and self.isTouching == true then
      -- finger starts touching
      self.joy.x = self.joy.ini_x
      self.joy.y = self.joy.ini_y

    elseif self.wasTouching == true and self.isTouching == false then
      -- finger leaves screen
      self.joy.x = self.joy.ini_x
      self.joy.y = self.joy.ini_y

    end
     
    -- resets everything first
    self.touchpos.x = self.joy.x
    self.touchpos.y = self.joy.y
    self.joy.color = {128,128,128,64}
    self.pressed.up = nil
    self.pressed.down = nil
    self.pressed.right = nil
    self.pressed.left = nil
    self.pressed.buttona = nil
    self.buttonA.color = {128,128,128,64}


    for i, id in ipairs(touches) do
      x, y = love.touch.getPosition(id)
      sx =  x / self.scale 
      sy =  y / self.scale

      if (self.joy.x-sx)^2 + (self.joy.y-sy)^2 < 3*(self.joy.r^2) then
        
        self.joy.color = {255,128,255,255}


        if(sx < self.joy.x-self.joy.deadzone ) then
          self.pressed.left = true
          self.pressed.right = nil
        elseif (sx > self.joy.x+self.joy.deadzone ) then
          self.pressed.right = true
          self.pressed.left = nil
        else 
          self.pressed.right = nil
          self.pressed.left = nil
        end


        if(sy > self.joy.y+self.joy.deadzone ) then
          self.pressed.down = true
          self.pressed.up = nil
        elseif (sy < self.joy.y-self.joy.deadzone ) then
          self.pressed.up = true
          self.pressed.down = nil
        else 
          self.pressed.up = nil
          self.pressed.down = nil
        end

        self.touchpos.x = sx
        self.touchpos.y = sy

        if (self.joy.x-sx)^2 + (self.joy.y-sy)^2 > 1.6*(self.joy.r^2) then

          local d_modulo = ((self.joy.x-sx)^2 + (self.joy.y-sy)^2 - 1.6*(self.joy.r^2))^0.5
          local d_dx = (sx-self.joy.x)/((self.joy.x-sx)^2 + (self.joy.y-sy)^2)
          local d_dy = (sy-self.joy.y)/((self.joy.x-sx)^2 + (self.joy.y-sy)^2)

          local d_new_x = d_dx*d_modulo
          local d_new_y = d_dy*d_modulo

          self.joy.x = self.joy.x + d_new_x
          self.joy.y = self.joy.y + d_new_y
        end
      end

      if (self.buttonA.x-sx)^2 + (self.buttonA.y-sy)^2 < 2*(self.buttonA.r^2) then
        self.pressed.buttona = true
        self.buttonA.color = {255,128,255,255}
      end

    end

    
  end,
  
  draw = function(self)
    if self.osString ~= "Android" and self.osString ~= "iOS" then
      return
    end


    love.graphics.setColor(self.joy.color)

    love.graphics.circle('fill',self.joy.x,self.joy.y,self.joy.r)


    love.graphics.setColor(self.buttonA.color)
    love.graphics.circle('fill',self.buttonA.x,self.buttonA.y,self.buttonA.r)

    love.graphics.setColor(244,244,255,64)
    love.graphics.circle('fill',self.touchpos.x,self.touchpos.y,self.joy.r/1.5)
  end
}

return ScreenButton