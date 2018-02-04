--
-- Inventory Class

--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------

local Gamestate     = requireLibrary("hump.gamestate")
local Class         = requireLibrary("hump.class")

--------------------------------------------------------------------------------
-- Class Definition
--------------------------------------------------------------------------------

Inventory = Class{
  -- initializes the inventory
	init = function(self)
    self.items = {}
    self._allitems = {}
  end,
  
  addItem = function(self, itemName)
    if self._allitems[itemName] == nil then
      self.defineEmptyItem(self,itemName)
    end

    if self.items[itemName] == nil then
      self.items[itemName] = {} 
      self.items[itemName].count = 1
    else 
      self.items[itemName].count = self.items[itemName].count + 1
    end
    self:addedItemCallback(itemName)
    return self.items[itemName]
  end,
  
  removeItem = function(self, itemName)
    if(self.items[itemName]==nil) then return end

    if self._allitems[itemName] == nil then
      self.defineEmptyItem(self,itemName)
    end

    if self.items[itemName].count > 1 then
      self.items[itemName].count = self.items[itemName].count - 1
    else 
      self.items[itemName] = nil
    end
    self:removedItemCallback(itemName)
    return self.items[itemName]
  end,

  removeAllItem = function(self, itemName)
    if(self.items[itemName]==nil) then return end

    if self._allitems[itemName] == nil then
      self.defineEmptyItem(self,itemName)
    end

    self.items[itemName] = nil

    self:removedItemCallback(itemName)
    return self.items[itemName]
  end,
  
  countItem = function(self, itemName)
    if self.items[itemName] ~= nil then
      return self.items[itemName].count
    else
      return 0
    end
  end,
  -- returns true if inventory has item
  hasItem = function(self, itemName)
    return self.countItem(self,itemName) > 0
  end,

  -- defines an items, dealing with drawing
  defineItem = function(self,itemName,drawFn,updateFn)
    self._allitems[itemName] = {}
    self._allitems[itemName].count = function()
      return self.countItem(self,itemName)
    end
    self._allitems[itemName].remove = function()
      return self.removeItem(self,itemName)
    end
    self._allitems[itemName].draw = function() end
    self._allitems[itemName].update = function() end
    if drawFn ~= nil then 
      self._allitems[itemName].draw = drawFn
    end
    if updateFn ~= nil then 
      self._allitems[itemName].update = updateFn
    end
  end,

  -- draw all items
  draw = function(self)
    for k,v in pairs(self._allitems) do
      if self.hasItem(self, k) then
        self._allitems[k]:draw()
      end
    end
  end,

  -- update items for animations
  update = function(self,dt)
    for k,v in pairs(self._allitems) do
      if self.hasItem(self, k) then
        self._allitems[k]:update(dt)
      end
    end
  end,

  -- define an empty item
  defineEmptyItem = function(self, itemName)
    self.defineItem(self,
      itemName,
      function() end,
      function() end)
  end,

  addedItemCallback = function()
    -- callback to be overwritten
  end,

  removedItemCallback = function()
    -- callback to be overwritten
  end
}

return Inventory