
local WaitForButton = {}

function WaitForButton:update(dt)
  if WaitForButton.updater ~= nil then
    WaitForButton.updater()
    return
  end
end


function WaitForButton:init(checkbtnfunction,callback)
  WaitForButton = {

    checkf = checkbtnfunction,
    callback = callback,
    updater = function (dt)
        if WaitForButton.checkf ~= nil and WaitForButton.callback ~= nil then
          if WaitForButton.checkf() then
            
            -- by removing the callback, we guarantee it will be called only once
            local call_once = WaitForButton.callback
            WaitForButton.callback = nil
            call_once()
          end
        end
    end,
  }
  
end

return WaitForButton