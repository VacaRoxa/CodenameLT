local Item = {}
local Character     = require 'src.entities.Character'
local anim8         = requireLibrary("anim8")

function Item.init(type,image,x,y)
    local item
    item = Character.init('item_' .. type,type,image,x,y,nil, 0.25)

    return item
end

return Item