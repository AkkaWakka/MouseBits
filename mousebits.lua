require("gui")
require("xyd")
require("pattern")

if not global then global = {} end
if not global.akka then global.akka = {} end
if not global.akka.players then global.akka.players = {} end

function init_player(player_index)
  if not global.akka.players[player_index] then global.akka.players[player_index] = {} end
  local akkaPlayer = global.akka.players[player_index]
  if not akkaPlayer.item then akkaPlayer.item = nil end
  if not akkaPlayer.direction then akkaPlayer.direction = nil end
  if not akkaPlayer.position then akkaPlayer.position = nil end
  if not akkaPlayer.onlyX then akkaPlayer.onlyX = false end
  if not akkaPlayer.onlyY then akkaPlayer.onlyY = false end
  if not akkaPlayer.onlyD then akkaPlayer.onlyD = false end
  if not akkaPlayer.patternState then akkaPlayer.patternState = false end
  if not akkaPlayer.patternSlots then akkaPlayer.patternSlots = 4 end
  if not akkaPlayer.pattern then akkaPlayer.pattern = {} end
  for i = 1, akkaPlayer.patternSlots, 1 do
    if not akkaPlayer.pattern[i] then akkaPlayer.pattern[i] = true end
  end
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
  elseif element.name == "akka-patterns-state" then toggle_pattern(player.index)
  elseif string.sub(element.name, 1, -2) == "akka-pattern-check-" then
    update_pattern(akkaPlayer, tonumber(string.sub(element.name, -1)), element.state)
  end
end

function reset_base(player_index)
  local akkaPlayer = global.akka.players[player_index]
  akkaPlayer.item = nil
  akkaPlayer.direction = nil
  akkaPlayer.position = {}
end

local function set_base(player, akkaPlayer, entity)
  if akkaPlayer.item ~= entity.name or
    akkaPlayer.direction ~= entity.direction then
    reset_base(player.index)
    akkaPlayer.item = entity.name
    akkaPlayer.direction = entity.direction
    akkaPlayer.position = entity.position
  end
end

function build_event_control(event)
  local player = game.players[event.player_index]
  local entity = event.created_entity
  local akkaPlayer = global.akka.players[event.player_index]
  if akkaPlayer.onlyX or
    akkaPlayer.onlyY or
    akkaPlayer.onlyD or
    akkaPlayer.patternState then
    if akkaPlayer.item ~= entity.name or
      akkaPlayer.direction ~= entity.direction then
      set_base(player, akkaPlayer, entity)
    end
    local axis_entity = axis_build(player, entity, akkaPlayer)
    if axis_entity and akkaPlayer.patternState then
      pattern_build(player, axis_entity, akkaPlayer)
    end
  end
end

function give_back(player, entity)
  if entity.name ~= "entity-ghost" then
    local cursor_stack = player.cursor_stack
    if cursor_stack.valid_for_read and cursor_stack.name == entity.name then
      cursor_stack.count = cursor_stack.count + 1
    else
      player.get_inventory(defines.inventory.player_main).insert({name = entity.name})
    end
  end
end
