function destroy_gui(akkaPlayer)
  if akkaPlayer and
    akkaPlayer.gui and
    akkaPlayer.gui.valid then
    akkaPlayer.gui.destroy()
  end
end

function add_button(player, akkaPlayer)
  destroy_gui(akkaPlayer)
  akkaPlayer.gui = player.gui.top.add({
    type="button",
    name="akka-mouse-bits",
    style="akka_pointer"
  })
end

local function akka_frame(frame_name, frame_direction)
  return {
    type = "frame",
    name = frame_name,
    direction = frame_direction
  }
end
local function akka_table(table_name, cols)
  return {
    type = "table",
    name = table_name,
    colspan = cols,
    style = "akka_table"
  }
end
local function akka_button(button_name, button_style, button_caption)
  return {
    type = "button",
    name = button_name,
    style = button_style,
    caption = button_caption
  }
end
local function akka_label(label_name, label_caption)
  return {
    type = "label",
    name = label_name,
    caption = label_caption
  }
end
local function akka_radio(radio_name, radio_state)
  return {
    type = "radiobutton",
    name = radio_name,
    state = radio_state
  }
end
local function akka_check(check_name, check_state)
  return {
    type = "checkbox",
    name = check_name,
    state = check_state
  }
end
local function akka_text(text_name, text_text)
  return {
    type = "textfield",
    name = text_name,
    style = "number_textfield_style",
    text = text_text
  }
end

local function gui_header(gui_box)
  gui_box.add(akka_table("header", 2))
  gui_box.header.add(akka_button("akka-mouse-bits-close", "akka_close"))
  gui_box.header.add(akka_label("title", {"title.akka-mouse-bits"}))
end

local function axis_info_item(identifier, container, akkaPlayer)
  container.add(akka_table(identifier, 2))
  container[identifier].add(akka_radio("akka-"..identifier.."-radio", akkaPlayer[identifier]))
  container[identifier].add(akka_label(identifier.."-label", {"controls.akka-"..identifier}))
end

local function spinner(gui_box, name, value)
  gui_box.add(akka_table(name.."-spinner", 3))
  gui_box[name.."-spinner"].add(akka_text("counter", tostring(value)))
  gui_box[name.."-spinner"].add(akka_table("buttons", 1))
  gui_box[name.."-spinner"].buttons.add(akka_button("akka-spinner-"..name.."-up", "akka_spinner_up"))
  gui_box[name.."-spinner"].buttons.add(akka_button("akka-spinner-"..name.."-down", "akka_spinner_down"))
  gui_box[name.."-spinner"].add(akka_label("label", {"gui.akka-"..name.."-spinner"}))
end

function mk_pattern_slots(gui_box, akkaPlayer)
  local pattern_slots = gui_box.add(akka_table("pattern_slots", akkaPlayer.patternSlots))
  for i = 1, akkaPlayer.patternSlots, 1 do
    pattern_slots.add(akka_check("akka-pattern-check-"..i, not not akkaPlayer.pattern[i]))
  end
  return pattern_slots
end

function add_box(player, akkaPlayer)
  destroy_gui(akkaPlayer)
  akkaPlayer.gui = player.gui.top.add(akka_frame("akka_box", "vertical"))
  local box = akkaPlayer.gui
  gui_header(box)
  box.add(akka_button("akka-reset-all", "button_style", {"controls.akka-reset"}))
  local axis = box.add(akka_frame("axis", "vertical"))
  axis_info_item("onlyX", axis, akkaPlayer)
  axis_info_item("onlyY", axis, akkaPlayer)
  axis_info_item("onlyD", axis, akkaPlayer)
  local pattern = box.add(akka_frame("pattern", "vertical"))
  spinner(pattern, "spacing", 0)
  spinner(pattern, "patternSlots", akkaPlayer.patternSlots)
  mk_pattern_slots(pattern, akkaPlayer)
end
