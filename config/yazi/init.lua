---@ya pack -a yazi-rs/plugins:no-status
require("no-status"):setup()

---@ya pack -a yazi-rs/plugins:full-border
require("full-border"):setup()

---@ya pack -a dedukun/relative-motions
require("relative-motions"):setup({ show_numbers = "relative_absolute", show_motion = true })
