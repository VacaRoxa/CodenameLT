--
-- Map Class
--
-- 2016 Heachant, Tilmann Hars <headchant@headchant.com>
--
-- Made for tilemaps

--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------

local Gamestate     = requireLibrary("hump.gamestate")
local Class         = requireLibrary("hump.class")
local Vector        = requireLibrary("hump.vector")

--------------------------------------------------------------------------------
-- Class Definition
--------------------------------------------------------------------------------

Map = Class{
	init = function(self)
		self.data = {}
	end,
	set = function(self, i, j, what)
		self.data[i..","..j] = what
	end,
	get = function(self, i, j)
		return self.data[i..","..j]
	end,
	isBlocked = function(self, i, j)
		local t = self:get(i,j)
		return t and t.blocked
	end
}