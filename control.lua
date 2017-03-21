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
script.on_event("akka-onlyX", function(event) toggle_onlyX(event.player_index) end)
script.on_event("akka-onlyY", function(event) toggle_onlyY(event.player_index) end)
script.on_event("akka-onlyD", function(event) toggle_onlyD(event.player_index) end)
script.on_event("akka-reset", function(event) axis_reset(event.player_index) end)
script.on_event("akka-base-reset", function(event) reset_base(event.player_index) end)
script.on_event("akka-pattern-toggle", function(event) toggle_pattern(event.player_index) end)

-- Important Player State Changes
script.on_event(defines.events.on_player_cursor_stack_changed, on_cursor_change)
script.on_event(defines.events.on_player_changed_surface, function(event) reset_base(event.player_index) end)

-- Axis Restriction & Pattern Placement Trigger
script.on_event(defines.events.on_built_entity, build_event_control)
