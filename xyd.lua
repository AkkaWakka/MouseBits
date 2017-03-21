function reset_xyd(player_index)
  global.akka.players[player_index].onlyX = false
  global.akka.players[player_index].onlyY = false
  global.akka.players[player_index].onlyD = false
  reset_base(player_index)
end

function toggle_onlyX(player_index)
  local akkaPlayer = global.akka.players[player_index]
  reset_xyd(player_index)
  akkaPlayer.onlyX = true
  update_axis_gui(akkaPlayer)
end

function toggle_onlyY(player_index)
  local akkaPlayer = global.akka.players[player_index]
  reset_xyd(player_index)
  akkaPlayer.onlyY = true
  update_axis_gui(akkaPlayer)
end

function toggle_onlyD(player_index)
  local akkaPlayer = global.akka.players[player_index]
  reset_xyd(player_index)
  akkaPlayer.onlyD = true
  update_axis_gui(akkaPlayer)
end

function axis_reset(player_index)
  local akkaPlayer = global.akka.players[player_index]
  reset_xyd(player_index)
  update_axis_gui(akkaPlayer)
end

function update_axis_gui(akkaPlayer)
  if akkaPlayer and
    akkaPlayer.gui and
    akkaPlayer.gui.valid and
    akkaPlayer.gui.name == "akka_box" then
    local gui = akkaPlayer.gui
    gui.onlyX["akka-onlyX-radio"].state = akkaPlayer.onlyX
    gui.onlyY["akka-onlyY-radio"].state = akkaPlayer.onlyY
    gui.onlyD["akka-onlyD-radio"].state = akkaPlayer.onlyD
  end
end

function on_cursor_change(event)
  local player = game.players[event.player_index]
  local akkaPlayer = global.akka.players[event.player_index]
  if not player.cursor_stack.valid_for_read or
    (akkaPlayer.item ~= nil and
    player.cursor_stack.name ~= akkaPlayer.item) then
    axis_reset(event.player_index)
  end
end

function attempt_move_entity(player, entity, newPosition)
  local newEntity
  local entity_table = {
    name = entity.name,
    position = newPosition, 
    direction = entity.direction, 
    force = entity.force
  }
  if entity.name == "entity-ghost" then
    entity_table["inner_name"] = entity.ghost_name
  end
  if entity.surface.can_place_entity(entity_table) then
    newEntity = entity.surface.create_entity(entity_table)
  end
  if not newEntity or not player.can_reach_entity(newEntity) then
    give_back(player, entity)
  end
  entity.destroy()
  if newEntity and not player.can_reach_entity(newEntity) then
    newEntity.destroy()
    return nil
  else
    return newEntity
  end
end

-- Assumes the base has been apropriatly set
function axis_build(player, entity, akkaPlayer)
  local axis_entity = entity
  if akkaPlayer.onlyX and
    entity.position.y ~= akkaPlayer.position.y then
    axis_entity = attempt_move_entity(player, entity, {x = entity.position.x, y = akkaPlayer.position.y})
  end
  if akkaPlayer.onlyY and
    entity.position.x ~= akkaPlayer.position.x then
    axis_entity = attempt_move_entity(player, entity, {y = entity.position.y, x = akkaPlayer.position.x})
  end
  if akkaPlayer.onlyD then
    local diffX = entity.position.x - akkaPlayer.position.x
    local diffY = entity.position.y - akkaPlayer.position.y
    local absX = math.abs(diffX)
    local absY = math.abs(diffY)
    if absX ~= absY then
      local change = math.floor((absX + absY) / 2)
      local signX = diffX / absX
      local signY = diffY / absY
      local newX = akkaPlayer.position.x + (signX * change)
      local newY = akkaPlayer.position.y + (signY * change)
      axis_entity = attempt_move_entity(player, entity, {x = newX, y = newY})
    end
  end
  return axis_entity
end
