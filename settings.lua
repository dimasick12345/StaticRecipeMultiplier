data:extend({
  {
    type = "double-setting",
    name = "srm-multiplier",
    setting_type = "startup",
    default_value = 2.0,
    minimum_value = 1.0,
    maximum_value = 100.0,
    order = "a"
  },
  {
    type = "string-setting",
    name = "srm-ignore-items",
    setting_type = "startup",
    default_value = "steel-plate,cooked-fish",
    allow_blank = true,
    order = "b"
  }
})
