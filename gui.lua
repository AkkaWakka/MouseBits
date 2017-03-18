function destroy_gui(akkaPlayer)
  if akkaPlayer and
    akkaPlayer.gui and
    akkaPlayer.gui.valid then
    akkaPlayer.gui.destroy()
  end
end

function add_button(player, akkaPlayer)
  destroy_gui(akkaPlayer)
  akkaPlayer.gui = player.gui.left.add({
    type="button",
    name="akka-mouse-bits",
    style="akka_pointer"
  })
end

local function axis_info_item(identifier, container, akkaPlayer)
  container.add({
    type = "table",
    name = identifier,
    colspan = 2,
    style = "akka_table"
  })
  container[identifier].add({
    type = "radiobutton",
    name = "akka-"..identifier.."-radio",
    state = akkaPlayer[identifier]
  })
  container[identifier].add({
    type = "label",
    name = identifier.."-label",
    caption = {"controls.akka-"..identifier}
  })
end

function add_box(player, akkaPlayer)
  destroy_gui(akkaPlayer)
  akkaPlayer.gui = player.gui.left.add({
    type = "frame",
    name = "akka_box",
    direction = "vertical"
  })
  local box = akkaPlayer.gui
  box.add({
    type = "table",
    name = "top",
    colspan = 2,
    style = "akka_table"
  })
  box.top.add({
    type = "button",
    name = "akka-mouse-bits-close",
    style = "akka_close"
  })
  box.top.add({
    type = "label",
    name = "title",
    caption = {"title.akka-mouse-bits"}
  })
  axis_info_item("onlyX", box, akkaPlayer)
  axis_info_item("onlyY", box, akkaPlayer)
  axis_info_item("onlyD", box, akkaPlayer)
  box.add({
    type = "button",
    name = "akka-reset-all",
    style = "button_style",
    caption = {"controls.akka-reset"}
  })
end

function update_box(akkaPlayer)
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
