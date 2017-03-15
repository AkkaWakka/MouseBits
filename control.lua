require("mousebits")

-- Initialise all the bits and bobs here.
script.on_init(add_all_game_players)
script.on_configuration_changed(add_all_game_players)
script.on_event(defines.events.on_player_created, add_player_on_event)
script.on_event(defines.events.on_player_joined_game, add_player_on_event)
script.on_event(defines.events.on_tick, add_on_tick)

-- GUI events
script.on_event(defines.events.on_gui_click, gui_click_control)

-- Key Events
script.on_event("akka-limitX", function(event) toggle_limitX(event.player_index) end)
script.on_event("akka-limitY", function(event) toggle_limitY(event.player_index) end)
script.on_event("akka-limitD", function(event) toggle_limitD(event.player_index) end)
script.on_event("akka-reset", function(event) limit_reset(event.player_index) end)

-- Important Player State Changes
script.on_event(defines.events.on_player_cursor_stack_changed, on_cursor_change)
script.on_event(defines.events.on_player_changed_surface, function(event) reset_player_item(event.player_index) end)

-- Main Placement Restriction Trigger
script.on_event(defines.events.on_built_entity, on_build)
