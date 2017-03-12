local default = data.raw["gui-style"]["default"]

local function make_g_set(xpos, ypos)
  return {
    type = "monolith",
    monolith_image = {
      filename = "__MouseBits__/graphics/gui.png",
      priority = "extra-high-no-scale",
      width = 24,
      height = 24,
      x = xpos,
      y = ypos
    }
  }
end

default.akka_pointer = {
  type = "button_style",
  parent = "button_style",
  width = 24,
  height = 24,
  top_padding = 8,
  right_padding = 8,
  bottom_padding = 8,
  left_padding = 8,
  default_graphical_set = make_g_set(0, 0),
  hovered_graphical_set = make_g_set(0, 25),
  clicked_graphical_set = make_g_set(0, 49)
}

default.akka_close = {
  type = "button_style",
  parent = "button_style",
  width = 24,
  height = 24,
  top_padding = 8,
  right_padding = 8,
  bottom_padding = 8,
  left_padding = 8,
  default_graphical_set = make_g_set(25, 0),
  hovered_graphical_set = make_g_set(25, 25),
  clicked_graphical_set = make_g_set(25, 49)
}

default.akka_table = {
  type = "table_style",
  cell_spacing = 8,
  horizontal_spacing = 8,
  vertical_spacing = 8
}
