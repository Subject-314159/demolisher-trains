-- Mod settings
data:extend({{
    type = "bool-setting",
    name = "dt-render-overlay",
    setting_type = "runtime-global",
    default_value = true
}, {
    type = "int-setting",
    name = "dt-animation-updates-per-tick",
    setting_type = "runtime-global",
    default_value = 100,
    minimum_value = 1,
    maximum_value = 1000000
}})
