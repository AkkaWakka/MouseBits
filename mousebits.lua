require("gui")

if not global then global = {} end
if not global.akka then global.akka = {} end
akka = global.akka

function init_player(player_index)
  if not akka.players[player_index] then akka.players[player_index] = {} end
  local akkaPlayer = akka.players[player_index]
  if not akkaPlayer.mouse1 then akkaPlayer.mouse1 = false end
  if not akkaPlayer.mouse2 then akkaPlayer.mouse2 = false end
  if not akkaPlayer.mouse3 then akkaPlayer.mouse3 = false end
  if not akkaPlayer.item then akkaPlayer.item = nil end
  if not akkaPlayer.direction then akkaPlayer.direction = nil end
  if not akkaPlayer.position then akkaPlayer.position = nil end
  if akkaPlayer.gui then akkaPlayer.gui.destroy() end
  akkaPlayer.gui = nil
end

function add_player(player_index)
  if not akka.players then akka.players = {} end
  init_player(player_index)
  add_button(game.players[player_index], akka.players[player_index])
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
    if akka and akka.players then
      for i, player in pairs(game.connected_players) do
        if not akka.players[player.index] then add_player(player.index) end
      end
    else add_all_players(game.players) end
  end
end

function reset_item(player_index)
  akka.players[player_index].item = nil
  akka.players[player_index].direction = nil
  akka.players[player_index].position = {}
end

function reset_all(player_index)
  akka.players[player_index].mouse1 = false
  akka.players[player_index].mouse2 = false
  akka.players[player_index].mouse3 = false
  reset_item(player_index)
end

function gui_click_control(event)
  local player = game.players[event.player_index]
  local akkaPlayer = akka.players[event.player_index]
  local element = event.element
  if element.name == "akka-mouse-bits" then add_box(player, akkaPlayer)
  elseif element.name == "akka-mouse-bits-close" then add_button(player, akkaPlayer)
  elseif element.name == "akka-mouse1-radio" then update_box(akkaPlayer)
  elseif element.name == "akka-mouse2-radio" then update_box(akkaPlayer)
  elseif element.name == "akka-mouse3-radio" then update_box(akkaPlayer)
  elseif element.name == "akka-reset-all" then update_box(akkaPlayer)
  end
end

function toggle_mouse1(player_index)
  local toggle = akka.players[player_index].mouse1
  reset_all(player_index)
  akka.players[player_index].mouse1 = not toggle
end

function toggle_mouse2(player_index)
  local toggle = akka.players[player_index].mouse2
  reset_all(player_index)
  akka.players[player_index].mouse2 = not toggle
end

function toggle_mouse3(player_index)
  local toggle = akka.players[player_index].mouse3
  reset_all(player_index)
  akka.players[player_index].mouse3 = not toggle
end

function on_cursor_change(event)
  local player = game.players[event.player_index]
  if not player.cursor_stack.valid_for_read or
    akka.players[event.player_index].item ~= player.cursor_stack.name then
    reset_all(event.player_index)
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
  local akkaPlayer = akka.players[event.player_index]
  if akkaPlayer.mouse1 or akkaPlayer.mouse2 or akkaPlayer.mouse3 then
    if akkaPlayer.item ~= entity.name or
      akkaPlayer.direction ~= entity.direction then
      reset_item(event.player_index)
      akkaPlayer.item = entity.name
      akkaPlayer.direction = entity.direction
      akkaPlayer.position = entity.position
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
end
