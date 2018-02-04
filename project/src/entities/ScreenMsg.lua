local Gamestate     = requireLibrary("hump.gamestate")
local Class         = requireLibrary("hump.class")
local lume          = requireLibrary("lume")
local anim8         = requireLibrary("anim8")

--------------------------------------------------------------------------------
-- Class Definitiond
--------------------------------------------------------------------------------

ScreenMsg = Class{
  -- initializes the inventory
	init = function(self)
    self.box_x = 70
    self.box_y = 103
    self.box_w = 184
    self.box_h = 60
    self.ui_texto_y = -600
    self.txt_x = 70 
    self.txt_y = 103 
    self.tcount = 0
    self.seen = false
    self.msg = nil
    self.msg_size = 1
    self.letter_typing_time = 0.025
    self.letter_typing_elapsed = 0
    self.currentCharIndex = 1
    self.bg_img = Image.ui_texto
    self.button_press_sprite = Image.button_pressing
    self.button_press_grid = anim8.newGrid(self.button_press_sprite:getWidth()/4, self.button_press_sprite:getHeight(),
                                   self.button_press_sprite:getWidth(), self.button_press_sprite:getHeight())
    self.button_animation =  anim8.newAnimation(self.button_press_grid('1-4',1), 0.2)
  end,

  setMsg = function(self,msg)
    if self.msg ~= msg then 
      self.tcount = 0
      self.currentCharIndex = 1
      if (self.msg ~= nil) then
        self.msg_size = #self.msg
      end
    end 

    self.msg = msg
  end,

  hasMsg = function(self)
    return self.msg ~= nil and string.len(self.msg)>1
  end,

  hasMsgFinished = function(self)
    if self.hasMsg(self) and self.currentCharIndex == #self.msg then
      return true
    else
      return false
    end
  end,

  skipMessage = function(self)
    if self:hasMsg() then
      if self.currentCharIndex < #self.msg then
        self.currentCharIndex = #self.msg
        return false
      else
        return true
      end
    end
  end,

  skipWithCallback = function(self, callback)
    self.skipMessage(self)
    callback()
  end,

  draw = function(self)
    -- the screen msg is only drawn if it exists!
    if self.hasMsg(self) then
      local t_limit = self.box_w-2
      local t_align = 'left'
      -- let's guarantee the background is drawn with proper alpha
      love.graphics.setColor( 255, 255, 255, 255 )

      -- we will tween it
      self.ui_texto_y  = lume.lerp(self.ui_texto_y , 0, .18)
      love.graphics.draw(self.bg_img  ,0,self.ui_texto_y )

      if self.tcount>0.7 then
        self.button_animation:draw(self.button_press_sprite,240,150)
      end

      -- now we draw the text on top of the dialog background
      love.graphics.setFont(font_Verdana2)
      love.graphics.setColor( 255, 255, 255, 255 )

      love.graphics.printf(string.sub(self.msg, 0, self.currentCharIndex),
        self.txt_x, self.txt_y+self.ui_texto_y,
        t_limit, t_align)
    else

      -- if we have no text, we just hide the dialog
      self.ui_texto_y  = lume.lerp(self.ui_texto_y , -600, .05)
      love.graphics.draw(self.bg_img,0,self.ui_texto_y )
    end
  end,
  update = function(self,dt)
    if self.hasMsg(self) then
      self.tcount = self.tcount + dt
      self.button_animation:update(dt)
      
      -- play each letter sound
      if #self.msg > 1 and self.currentCharIndex > 1 and self.currentCharIndex < #self.msg then
        local letter = string.upper(self.msg:sub(self.currentCharIndex,self.currentCharIndex))
        
        if string.match('0123456789ABCDEFGHIJKLMNOPQRSTUVXWYZ',letter) and letter ~= '' and letter ~= '.' then
          Sfx['GGJ18_beep_' .. letter]:play()

        end
      end

      -- typing effect
      -- TO DO on button press, show entire msg before moving on to the next
      -- TO DO play sfx
      -- Feature: make loger typing pauses on punctuation moments
      self.letter_typing_elapsed = self.letter_typing_elapsed + dt
      if self.letter_typing_elapsed > self.letter_typing_time then
        self.letter_typing_elapsed = 0
        self.currentCharIndex = lume.clamp(self.currentCharIndex + 1, 1, #self.msg)
      end
    end
  end 
}

return ScreenMsg