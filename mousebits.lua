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
  if not akkaPlayer.spacing then akkaPlayer.spacing = 0 end
  if not akkaPlayer.patternSlots then akkaPlayer.patternSlots = 0 end
  if not akkaPlayer.patternMax then akkaPlayer.patternMax = 8 end
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

function akka(player_index)
  return global.akka.players[player_index]
end

function gui_control(event)
  local player = game.players[event.player_index]
  local akkaPlayer = akka(event.player_index)
  local element = event.element
  if element.name == "akka-mouse-bits" then add_box(player, akkaPlayer)
  elseif element.name == "akka-mouse-bits-close" then add_button(player, akkaPlayer)
  elseif element.name == "akka-onlyX-radio" then toggle_onlyX(akkaPlayer)
  elseif element.name == "akka-onlyY-radio" then toggle_onlyY(akkaPlayer)
  elseif element.name == "akka-onlyD-radio" then toggle_onlyD(akkaPlayer)
  elseif element.name == "akka-reset-all" then general_reset(akkaPlayer)
  elseif string.sub(element.name, 1, -2) == "akka-pattern-check-" then
    update_pattern(akkaPlayer, tonumber(string.sub(element.name, -1)), element.state)
  elseif string.sub(element.name, 1, 13) == "akka-spinner-" then
    spinner_control(akkaPlayer, element.parent.parent, string.sub(element.name, 14))
  elseif element.name == "counter" then
    spinner_control(akkaPlayer, element.parent, "counter")
  end
end

function update_guis(akkaPlayer)
  update_axis_gui(akkaPlayer)
  update_pattern_gui(akkaPlayer)
end

function reset_base(akkaPlayer)
  akkaPlayer.item = nil
  akkaPlayer.direction = nil
  akkaPlayer.position = {}
end

function general_reset(akkaPlayer)
  reset_xyd(akkaPlayer)
  reset_pattern(akkaPlayer)
  update_guis(akkaPlayer)
end

local function set_base(akkaPlayer, entity)
  if akkaPlayer.item ~= entity.name or
    akkaPlayer.direction ~= entity.direction then
    reset_base(akkaPlayer)
    akkaPlayer.item = entity.name
    akkaPlayer.direction = entity.direction
    akkaPlayer.position = entity.position
  end
end

function on_cursor_change(event)
  local player = game.players[event.player_index]
  local akkaPlayer = akka(event.player_index)
  if not player.cursor_stack.valid_for_read or
    (akkaPlayer.item ~= nil and
    player.cursor_stack.name ~= akkaPlayer.item) then
    general_reset(akkaPlayer)
  end
end

function build_event_control(event)
  local player = game.players[event.player_index]
  local entity = event.created_entity
  local akkaPlayer = akka(event.player_index)
  if akkaPlayer.onlyX or
    akkaPlayer.onlyY or
    akkaPlayer.onlyD or
    akkaPlayer.spacing > 0 or
    akkaPlayer.patternSlots > 0 then
    if akkaPlayer.item ~= entity.name or
      akkaPlayer.direction ~= entity.direction then
      set_base(akkaPlayer, entity)
    end
    local axis_entity = axis_build(player, entity, akkaPlayer)
    if axis_entity and akkaPlayer.patternSlots > 0 or akkaPlayer.spacing > 0 then
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
