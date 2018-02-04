local MusicPlayer = {}

-- Set Library Folders
_LIBRARYPATH = "libs"
_LIBRARYPATH = _LIBRARYPATH .. "/"

requireLibrary = function(name)
	return require(_LIBRARYPATH..name)
end

-- the library for music and sounds
local ripple = requireLibrary("ripple/ripple")

function MusicPlayer.init()
  local musp = {}

  -- add music and sounds
  musp.tags = {
    sfx = ripple.newTag(),
    music = ripple.newTag(),
    master = ripple.newTag(),
  }
  
  musp.music = {
    theme = ripple.newSound('music/theme.ogg', {
      loop = true,
      tags = {musp.tags.music, musp.tags.master},
    })
  }

  musp.update = function(dt)
    for _, m in pairs(musp.music) do
      m:update(dt)
    end    
  end
  musp.mplay = function(mus)
    
    -- let's play the theme
    musp.music.theme:play()
  end

  return musp

end

return MusicPlayer