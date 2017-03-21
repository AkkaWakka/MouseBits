local default = data.raw["gui-style"]["default"]

local function make_g_set(xpos, ypos, wwidth, hheight)
  return {
    type = "monolith",
    top_monolith_border = 0,
    right_monolith_border = 0,
    bottom_monolith_border = 0,
    left_monolith_border = 0,
    monolith_image = {
      filename = "__MouseBits__/graphics/gui.png",
      priority = "extra-high-no-scale",
      width = wwidth,
      height = hheight,
      x = xpos,
      y = ypos
    }
  }
end

default.akka_button = {
  type = "button_style",
  parent = "button_style",
  width = 24,
  height = 24,
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0
}

default.akka_pointer = {
  type = "button_style",
  parent = "button_style",
  width = 24,
  height = 24,
  top_padding = 8,
  right_padding = 8,
  bottom_padding = 8,
  left_padding = 8,
  default_graphical_set = make_g_set(0, 0, 24, 24),
  hovered_graphical_set = make_g_set(0, 25, 24, 24),
  clicked_graphical_set = make_g_set(0, 50, 24, 24)
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
  default_graphical_set = make_g_set(25, 0, 24, 24),
  hovered_graphical_set = make_g_set(25, 25, 24, 24),
  clicked_graphical_set = make_g_set(25, 50, 24, 24)
}

default.akka_spinner_up = {
  type = "button_style",
  parent = "button_style",
  width = 12,
  height = 9,
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  default_graphical_set = make_g_set(50, 0, 12, 9),
  hovered_graphical_set = make_g_set(50, 25, 12, 9),
  clicked_graphical_set = make_g_set(50, 50, 12, 9)
}

default.akka_spinner_down = {
  type = "button_style",
  parent = "button_style",
  width = 12,
  height = 9,
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  default_graphical_set = make_g_set(50, 10, 12, 9),
  hovered_graphical_set = make_g_set(50, 35, 12, 9),
  clicked_graphical_set = make_g_set(50, 60, 12, 9)
}

default.akka_table = {
  type = "table_style",
  cell_spacing = 8,
  horizontal_spacing = 8,
  vertical_spacing = 8
}
