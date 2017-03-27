function update_pattern(akkaPlayer, index, state)
  akkaPlayer.pattern[index] = state
  reset_base(akkaPlayer)
end

function update_pattern_gui(akkaPlayer)
  if akkaPlayer and
    akkaPlayer.gui and
    akkaPlayer.gui.valid and
    akkaPlayer.gui.name == "akka_box" then
    local gui = akkaPlayer.gui
    local pattern = gui.pattern
    pattern["spacing-spinner"].counter.text = tostring(akkaPlayer.spacing)
    pattern["patternSlots-spinner"].counter.text = tostring(akkaPlayer.patternSlots)
    local pattern_slots = pattern.pattern_slots
    if #pattern_slots.children_names ~= akkaPlayer.patternSlots then
      pattern_slots.destroy()
      pattern_slots = mk_pattern_slots(pattern, akkaPlayer)
    end
    for i = 1, akkaPlayer.patternSlots, 1 do
      pattern.pattern_slots["akka-pattern-check-"..i].state = not not akkaPlayer.pattern[i]
    end
  end
end

function spinner_control(akkaPlayer, spinner, actionID)
  local property = string.sub(spinner.name, 1, -9)
  local newValue
  if string.find(actionID, "up") ~= nil then
    newValue = math.min(akkaPlayer[property] + 1, akkaPlayer.patternMax)
  elseif string.find(actionID, "down") ~= nil then
    newValue = math.max(akkaPlayer[property] - 1, 0)
  elseif string.find(actionID, "counter") ~= nil then
    newValue = tonumber(spinner.counter.text) or akkaPlayer[property]
    newValue = math.max(newValue, 0)
    newValue = math.min(newValue, akkaPlayer.patternMax)
  end
  akkaPlayer[property] = newValue
  reset_base(akkaPlayer)
  update_pattern_gui(akkaPlayer)
end

function reset_pattern(akkaPlayer)
  akkaPlayer.spacing = 0
  akkaPlayer.patternSlots = 0
  reset_base(akkaPlayer)
end

-- Assumes the base has been apropriatly set
function pattern_build(player, entity, akkaPlayer)
  local diffX = entity.position.x - akkaPlayer.position.x
  local diffY = entity.position.y - akkaPlayer.position.y
  local absX = math.abs(diffX)
  local absY = math.abs(diffY)
  local tl = entity.prototype.selection_box.left_top
  local br = entity.prototype.selection_box.right_bottom
  local sizeX = math.floor(math.abs(tl.x - br.x) + 0.5) + akkaPlayer.spacing
  local sizeY = math.floor(math.abs(tl.y - br.y) + 0.5) + akkaPlayer.spacing
  local countX = absX / sizeX
  local countY = absY / sizeY
  local count = math.max(countX, countY)
  local mod = math.floor(count) % akkaPlayer.patternSlots
  if count - math.floor(count) ~= 0 or akkaPlayer.patternSlots > 0 and not akkaPlayer.pattern[mod + 1] then
    give_back(player, entity)
    entity.destroy()
  end
end
