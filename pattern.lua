function toggle_pattern(player_index)
  local player = game.players[player_index]
  local akkaPlayer = global.akka.players[player_index]
  akkaPlayer.patternState = not akkaPlayer.patternState
  reset_base(player_index)
  update_pattern_gui(akkaPlayer)
end

function update_pattern(akkaPlayer, index, state)
  akkaPlayer.pattern[index] = state
end

function update_pattern_gui(akkaPlayer)
  if akkaPlayer and
    akkaPlayer.gui and
    akkaPlayer.gui.valid and
    akkaPlayer.gui.name == "akka_box" then
    local gui = akkaPlayer.gui
    local pattern = gui.pattern
    if akkaPlayer.patternState then
      gui.patternHeader["akka-patterns-state"].caption = {"gui.akka-on"}
      if pattern then
        for i = 1, akkaPlayer.patternSlots, 1 do
          pattern["akka-pattern-check-"..i].state = not not akkaPlayer.pattern[i]
        end
      else
        pattern_visual(gui, akkaPlayer)
      end
    else
      gui.patternHeader["akka-patterns-state"].caption = {"gui.akka-off"}
      if pattern then pattern.destroy() end
    end
  end
end

-- Assumes the base has been apropriatly set
function pattern_build(player, entity, akkaPlayer)
  local diffX = entity.position.x - akkaPlayer.position.x
  local diffY = entity.position.y - akkaPlayer.position.y
  local absX = math.abs(diffX)
  local absY = math.abs(diffY)
  local tl = entity.prototype.selection_box.left_top
  local br = entity.prototype.selection_box.right_bottom
  local sizeX = math.floor(math.abs(tl.x - br.x) + 0.5)
  local sizeY = math.floor(math.abs(tl.y - br.y) + 0.5)
  local countX = math.floor(absX / sizeX)
  local countY = math.floor(absY / sizeY)
  local count = math.max(countX, countY)
  local mod = count % akkaPlayer.patternSlots
  if not akkaPlayer.pattern[mod + 1] then
    give_back(player, entity)
    entity.destroy()
  end
end
