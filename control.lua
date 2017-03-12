if not akka then akka = {} end

function akka.add_player(player_index)
  if not akka.players then akka.players = {} end
  if not akka.players[player_index] then akka.players[player_index] = {} end
  if not akka.players[player_index].mouse1 then akka.players[player_index].mouse1 = false end
  if not akka.players[player_index].mouse2 then akka.players[player_index].mouse2 = false end
  if not akka.players[player_index].mouse3 then akka.players[player_index].mouse3 = false end
  if not akka.players[player_index].item then akka.players[player_index].item = nil end
  if not akka.players[player_index].rotation then akka.players[player_index].rotation = nil end
  if not akka.players[player_index].position then akka.players[player_index].position = {} end
end

local function add_all_players(players)
  for i, player in pairs(players) do
    akka.add_player(player.index)
  end
end

script.on_init(function() add_all_players(game.players) end)
script.on_configuration_changed(function(event) add_all_players(game.players) end)
script.on_event(defines.events.on_player_created, function(event) akka.add_player(event.player_index) end)
script.on_event(defines.events.on_player_joined_game, function(event) akka.add_player(event.player_index) end)
script.on_event(defines.events.on_tick, function(event)
  if game.tick % 20 == 0 then
    if akka and akka.players then
      for i, player in pairs(game.connected_players) do
        if not akka.players[player.index] then akka.add_player(player.index) end
      end
    else add_all_players(game.players) end
  end
end)
    


local function reset_player_state(player_index)
  akka.players[player_index].mouse1 = false
  akka.players[player_index].mouse2 = false
  akka.players[player_index].mouse3 = false
  akka.players[player_index].item = nil
  akka.players[player_index].position = {}
end

local function reset_player_item(player_index)
  akka.players[player_index].item = nil
  akka.players[player_index].position = {}
end

local function use_current_item(player_index)
  local player = game.players[player_index]
  if player.cursor_stack.valid_for_read then
    akka.players[player_index].item = player.cursor_stack.name
  end
end

script.on_event("akka-mouse-1", function(event)
  reset_player_state(event.player_index)
  akka.players[event.player_index].mouse1 = true
end)

script.on_event("akka-mouse-2", function(event)
  reset_player_state(event.player_index)
  akka.players[event.player_index].mouse2 = true
end)

script.on_event("akka-mouse-3", function(event)
  reset_player_state(event.player_index)
  akka.players[event.player_index].mouse3 = true
end)

--TODO test rotation
script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
  local player = game.players[event.player_index]
  if not player.cursor_stack.valid_for_read or
    akka.players[event.player_index].item ~= player.cursor_stack.name then
    reset_player_item(event.player_index)
  end
end)
script.on_event(defines.events.on_player_changed_surface, function(event)
  reset_player_item(event.player_index)
end)
--script.on_event(defines.events.on_player.on_player_rotated_entity, function(event) reset_player_state(event.player_index) end)

local function attempt_move_entity(player, entity, newPosition)
  local newEntity
  if entity.surface.can_place_entity{
    name=entity.name,
    position=newPosition, 
    direction=entity.direction, 
    force=entity.force} then
    newEntity = entity.surface.create_entity{
      name=entity.name,
      position=newPosition,
      direction=entity.direction,
      force=entity.force}
  end
  if not newEntity or not player.can_reach_entity(newEntity) then
    local cursor_stack = player.cursor_stack
    if cursor_stack.valid_for_read and cursor_stack.name == entity.name then
      cursor_stack.count = cursor_stack.count + 1
    else
      player.get_inventory(defines.inventory.player_main).insert({name = entity.name})
    end
  end
  entity.destroy()
  if newEntity and not player.can_reach_entity(newEntity) then newEntity.destroy() end
end

script.on_event(defines.events.on_built_entity, function(event)
  local player = game.players[event.player_index]
  local entity = event.created_entity
  local akkaPlayer = akka.players[event.player_index]
  if akkaPlayer.mouse1 or akkaPlayer.mouse2 or akkaPlayer.mouse3 then
    if akkaPlayer.item ~= entity.name then
      reset_player_item(event.player_index)
      akkaPlayer.item = entity.name
      akkaPlayer.position = event.created_entity.position
    end
    if akkaPlayer.mouse1 and
      entity.position.x ~= akkaPlayer.position.x then
      attempt_move_entity(player, entity, {x = akkaPlayer.position.x, y = entity.position.y})
    end
    if akkaPlayer.mouse2 and
      entity.position.y ~= akkaPlayer.position.y then
      attempt_move_entity(player, entity, {y = akkaPlayer.position.y, x = entity.position.x})
    end
    if akkaPlayer.mouse3 then
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
        attempt_move_entity(player, entity, {x = newX, y = newY})
      end
    end
  end
end)
