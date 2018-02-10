-- OnScreenButtons by Érico Vieira Porto 2018

local Gamestate     = requireLibrary("hump.gamestate")
local Class         = requireLibrary("hump.class")
local lume          = requireLibrary("lume")

local 

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

  pressedAmount = function (self, pressed, origin)
    -- clam uses value, min, max
    local valueToReturn = lume.clamp(math.abs(origin-pressed)/((1.6*(self.joy.r^2))^0.5),0,1 )

    local deadzone = self.joy.deadzone / ((1.6*(self.joy.r^2))^0.5) 
    if valueToReturn < deadzone then
      valueToReturn = 0
    end
  
    return valueToReturn
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

    -- when the player presses A, the directional must keep working
    -- so for multitouch, we need this for to see every place being touched
    for i, id in ipairs(touches) do
      x, y = love.touch.getPosition(id)
      sx =  x / self.scale 
      sy =  y / self.scale

      if (self.joy.x-sx)^2 + (self.joy.y-sy)^2 < 3*(self.joy.r^2) then
        
        self.joy.color = {255,128,255,255}


        if(sx < self.joy.x-self.joy.deadzone ) then
          self.pressed.left = true
          self.pressed.right = nil
          self.pressed.left_amount = self.pressedAmount(self,sx, self.joy.x)
          self.pressed.right_amount = nil
        elseif (sx > self.joy.x+self.joy.deadzone ) then
          self.pressed.right = true
          self.pressed.left = nil
          self.pressed.right_amount = self.pressedAmount(self, sx, self.joy.x)
          self.pressed.left_amount = nil
        else 
          self.pressed.right = nil
          self.pressed.left = nil
          self.pressed.right_amount = nil
          self.pressed.left_amount = nil
        end


        if(sy > self.joy.y+self.joy.deadzone ) then
          self.pressed.down = true
          self.pressed.up = nil
          self.pressed.down_amount = self.pressedAmount(self, sy, self.joy.y)
          self.pressed.up_amount = nil
        elseif (sy < self.joy.y-self.joy.deadzone ) then
          self.pressed.up = true
          self.pressed.down = nil
          self.pressed.up_amount = self.pressedAmount(self, sy, self.joy.y)
          self.pressed.down_amount = nil
        else 
          self.pressed.up = nil
          self.pressed.down = nil
          self.pressed.up_amount = nil
          self.pressed.down_amount = nil
        end

        self.touchpos.x = sx
        self.touchpos.y = sy

        -- evaluates if center of joystick must be moved
        if (self.joy.x-sx)^2 + (self.joy.y-sy)^2 > 1.6*(self.joy.r^2) then

          -- move the center by the difference dragged. eg:
          -- if player started draggin at 100,100 and 50 is limit,
          -- when finger goes to 160,100, center moves to 110,100.
          --
          -- we need to calculate the distance as a modulo and then set
          -- the direction vector separetely
          local d_modulo = ((self.joy.x-sx)^2 + (self.joy.y-sy)^2 - 1.6*(self.joy.r^2))^0.5
          local d_dx = (sx-self.joy.x)/((self.joy.x-sx)^2 + (self.joy.y-sy)^2)
          local d_dy = (sy-self.joy.y)/((self.joy.x-sx)^2 + (self.joy.y-sy)^2)

          local d_new_x = d_dx*d_modulo
          local d_new_y = d_dy*d_modulo

          self.joy.x = self.joy.x + d_new_x
          self.joy.y = self.joy.y + d_new_y
        end
      end

      -- the accept button is much simpler, we just check for fingers in it's area
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