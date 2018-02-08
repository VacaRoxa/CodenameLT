local Gamestate     = requireLibrary("hump.gamestate")
local Class         = requireLibrary("hump.class")

ScreenButton = Class{
  -- initializes the inventory
  init = function(self)
    self.osString = love.system.getOS( )
    self.joy = {
      r = 24,
      x = 48,
      y = 132,
      deadzone = 6,
      color = {255,255,255,255},
    }

    self.buttonA = {
      r = 18,
      x = 262,
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
    end

    if x~=nil and y~=nil then 
      sx =  x / self.scale 
      sy =  y / self.scale
    else
      sx = -1
      sy = -1
    end

    if (self.joy.x-sx)^2 + (self.joy.y-sy)^2 < 4*(self.joy.r^2) then
      
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

      self.touchpos.x = x
      self.touchpos.y = y

    else

      self.touchpos.x = self.joy.x
      self.touchpos.y = self.joy.y
      self.joy.color = {128,128,128,64}
      self.pressed.up = nil
      self.pressed.down = nil
      self.pressed.right = nil
      self.pressed.left = nil

    end

    if (self.buttonA.x-sx)^2 + (self.buttonA.y-sy)^2 < 4*(self.buttonA.r^2) then
      self.pressed.buttona = true
      self.buttonA.color = {255,128,255,255}
    else
      self.pressed.buttona = nil
      self.buttonA.color = {128,128,128,64}
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

    love.graphics.setColor(244,244,255,40)
    love.graphics.circle('fill',self.touchpos.x,self.touchpos.y,self.joy.r/4)
  end
}

return ScreenButton