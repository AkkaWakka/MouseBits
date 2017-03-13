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

local function limit_info_item(identifier, container, akkaPlayer)
  container.add({
    type = "table",
    name = identifier,
    colspan = 2,
    style = "akka_table"
  })
  container[identifier].add({
    type = "label",
    name = identifier.."-label",
    caption = {"controls.akka-"..identifier}
  })
  container[identifier].add({
    type = "radiobutton",
    name = "akka-"..identifier.."-radio",
    state = akkaPlayer[identifier]
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
    type = "label",
    name = "title",
    caption = {"title.akka-mouse-bits"}
  })
  box.top.add({
    type = "button",
    name = "akka-mouse-bits-close",
    style = "akka_close"
  })
  limit_info_item("limitX", box, akkaPlayer)
  limit_info_item("limitY", box, akkaPlayer)
  limit_info_item("limitD", box, akkaPlayer)
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
    gui.limitX["akka-limitX-radio"].state = akkaPlayer.limitX
    gui.limitY["akka-limitY-radio"].state = akkaPlayer.limitY
    gui.limitD["akka-limitD-radio"].state = akkaPlayer.limitD
  end
end
