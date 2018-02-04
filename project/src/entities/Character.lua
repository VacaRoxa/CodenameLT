local Character = {}
local anim8         = requireLibrary("anim8")

function Character.init(name,type,image,x,y, physicWorld ,animTime)
    local chara = {}
    chara.type = type
    chara.pos = { x = x, y = y }
    chara.active = true
    chara.pxw = 24
    chara.pxh = 24
    if physicWorld ~= nil then
      chara.body = love.physics.newBody(physicWorld, chara.pos.x, chara.pos.y, "dynamic")
      chara.body:setLinearDamping(10)
      chara.body:setFixedRotation(true)
      chara.shape   = love.physics.newCircleShape(chara.pxw/2, chara.pxh/2, 6)
      chara.fixture = love.physics.newFixture(chara.body, chara.shape)
      chara.fixture:setUserData(name) 
    end


    chara.animTime = animTime and animTime or 0.1
    chara.color = {255, 255, 255, 255}
    chara.sprite = love.graphics.newImage(image)
    chara.anim_grid = anim8.newGrid(24, 24, chara.sprite:getWidth(), chara.sprite:getHeight())
    chara.current_direction = 'down'
    chara.animations= { 
      walk = {
        down = anim8.newAnimation(chara.anim_grid('1-4',1), chara.animTime),
        down_right = anim8.newAnimation(chara.anim_grid('1-4',2), chara.animTime),
        right = anim8.newAnimation(chara.anim_grid('1-4',3), chara.animTime),
        up_right = anim8.newAnimation(chara.anim_grid('1-4',4), chara.animTime),
        up = anim8.newAnimation(chara.anim_grid('1-4',5), chara.animTime),
        up_left = anim8.newAnimation(chara.anim_grid('1-4',6), chara.animTime),
        left = anim8.newAnimation(chara.anim_grid('1-4',7), chara.animTime),
        down_left = anim8.newAnimation(chara.anim_grid('1-4',8),chara.animTime)
      },
      idle = {
        down = anim8.newAnimation(chara.anim_grid(2,1), chara.animTime),
        down_right = anim8.newAnimation(chara.anim_grid(2,2), chara.animTime),
        right = anim8.newAnimation(chara.anim_grid(2,3), chara.animTime),
        up_right = anim8.newAnimation(chara.anim_grid(2,4), chara.animTime),
        up = anim8.newAnimation(chara.anim_grid(2,5), chara.animTime),
        up_left = anim8.newAnimation(chara.anim_grid(2,6), chara.animTime),
        left = anim8.newAnimation(chara.anim_grid(2,7), chara.animTime),
        down_left = anim8.newAnimation(chara.anim_grid(2,8), chara.animTime)
      }
    }
    chara.current_animation = chara.animations.walk
    chara.draw = function()
      if chara.body ~= nil then
        local vx, vy = chara.body:getLinearVelocity()
        local limit_v = 0.1 -- below value will be considered stopped for animation
      
        if (vx<-limit_v or vx>limit_v) or (vy<-limit_v or vy>limit_v) then
          chara.current_animation = chara.animations.walk
        else
          chara.current_animation = chara.animations.idle
        end
      end

      love.graphics.setColor(chara.color)
      chara.current_animation[chara.current_direction]:draw(chara.sprite,chara.pos.x-chara.pxw/2,chara.pos.y-chara.pxh/1.1)
    end
    return chara
end

return Character