require("gui")

if not global then global = {} end
if not global.akka then global.akka = {} end
if not global.akka.players then global.akka.players = {} end

function init_player(player_index)
  if not global.akka.players[player_index] then global.akka.players[player_index] = {} end
  local akkaPlayer = global.akka.players[player_index]
  if not akkaPlayer.onlyX then akkaPlayer.onlyX = false end
  if not akkaPlayer.onlyY then akkaPlayer.onlyY = false end
  if not akkaPlayer.onlyD then akkaPlayer.onlyD = false end
  if not akkaPlayer.item then akkaPlayer.item = nil end
  if not akkaPlayer.direction then akkaPlayer.direction = nil end
  if not akkaPlayer.position then akkaPlayer.position = nil end
  if akkaPlayer.gui then akkaPlayer.gui.destroy() end
  akkaPlayer.gui = nil
end

function add_player(player_index)
  init_player(player_index)
  add_button(game.players[player_index], global.akka.players[player_index])
end
function add_player_on_event(event) add_player(event.player_index) end

function add_all_players(players)
  for i, player in pairs(players) do
    add_player(player.index)
  end
end
function add_all_game_players() add_all_players(game.players) end

function add_on_tick(tick_event)
  if game.tick % 20 == 0 then
    if global.akka and global.akka.players then
      for i, player in pairs(game.connected_players) do
        if not global.akka.players[player.index] then add_player(player.index) end
      end
    else add_all_players(game.players) end
  end
end

function reset_item(player_index)
  global.akka.players[player_index].item = nil
  global.akka.players[player_index].direction = nil
  global.akka.players[player_index].position = {}
end

function reset_all(player_index)
  global.akka.players[player_index].onlyX = false
  global.akka.players[player_index].onlyY = false
  global.akka.players[player_index].onlyD = false
  reset_item(player_index)
end

function gui_click_control(event)
  local player = game.players[event.player_index]
  local akkaPlayer = global.akka.players[event.player_index]
  local element = event.element
  if element.name == "akka-mouse-bits" then add_box(player, akkaPlayer)
  elseif element.name == "akka-mouse-bits-close" then add_button(player, akkaPlayer)
  elseif element.name == "akka-onlyX-radio" then toggle_onlyX(player.index)
  elseif element.name == "akka-onlyY-radio" then toggle_onlyY(player.index)
  elseif element.name == "akka-onlyD-radio" then toggle_onlyD(player.index)
  elseif element.name == "akka-reset-all" then axis_reset(player.index)
  end
end

function toggle_onlyX(player_index)
  local akkaPlayer = global.akka.players[player_index]
  reset_all(player_index)
  akkaPlayer.onlyX = true
  update_box(akkaPlayer)
end

function toggle_onlyY(player_index)
  local akkaPlayer = global.akka.players[player_index]
  reset_all(player_index)
  akkaPlayer.onlyY = true
  update_box(akkaPlayer)
end

function toggle_onlyD(player_index)
  local akkaPlayer = global.akka.players[player_index]
  reset_all(player_index)
  akkaPlayer.onlyD = true
  update_box(akkaPlayer)
end

function axis_reset(player_index)
  local akkaPlayer = global.akka.players[player_index]
  reset_all(player_index)
  update_box(akkaPlayer)
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
  if entity.surface.can_place_entity({
    name = entity.name,
    position = newPosition, 
    direction = entity.direction, 
    force = entity.force
  }) then
    newEntity = entity.surface.create_entity({
      name = entity.name,
      position = newPosition,
      direction = entity.direction,
      force = entity.force
    })
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

function on_build(event)
  local player = game.players[event.player_index]
  local entity = event.created_entity
  local akkaPlayer = global.akka.players[event.player_index]
  if akkaPlayer.onlyX or akkaPlayer.onlyY or akkaPlayer.onlyD then
    if akkaPlayer.item ~= entity.name or
      akkaPlayer.direction ~= entity.direction then
      reset_item(event.player_index)
      akkaPlayer.item = entity.name
      akkaPlayer.direction = entity.direction
      akkaPlayer.position = entity.position
    end
    if akkaPlayer.onlyX and
      entity.position.y ~= akkaPlayer.position.y then
      attempt_move_entity(player, entity, {x = entity.position.x, y = akkaPlayer.position.y})
    end
    if akkaPlayer.onlyY and
      entity.position.x ~= akkaPlayer.position.x then
      attempt_move_entity(player, entity, {y = entity.position.y, x = akkaPlayer.position.x})
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
        attempt_move_entity(player, entity, {x = newX, y = newY})
      end
    end
  end
end
