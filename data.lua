local collision_mask_util = require('collision-mask-util')
local function demolisher_spritesheet(file_name, is_shadow, scale)
    is_shadow = is_shadow or false
    return util.sprite_load("__space-age__/graphics/entity/lavaslug/lavaslug-" .. file_name, {
        direction_count = 128,
        frame_count = 128,
        dice = 0, -- dicing is incompatible with sprite alpha masking, do not attempt
        draw_as_shadow = is_shadow,
        scale = scale,
        multiply_shift = scale * 2,
        surface = "vulcanus",
        usage = "enemy"
    })
end

-- Dummy entity for technology
data:extend({{
    type = "simple-entity",
    name = "demolisher-dummy",
    icon = "__base__/graphics/icons/signal/signal-skull.png",
    icon_size = 64
}, {
    type = "tool",
    name = "demolisher-dummy",
    icon = "__base__/graphics/icons/signal/signal-skull.png",
    icon_size = 64,
    stack_size = 1,
    durability = 1,
    send_to_orbit_mode = "not-sendable",
    weight = 1420000000
}})

-- Magic numbers
local scale = 0.5
local segd = 0.83
local jd = 0.1 -- was 0.5 -- Must be >= 0.1
local cd = segd - jd -- was 1

-- Spritesheets
local headlr = {demolisher_spritesheet("head", false, 0.5 * scale),
                demolisher_spritesheet("head-shadow", true, 0.5 * scale)}
local wagonlr = {demolisher_spritesheet("segment", false, 0.5 * scale),
                 demolisher_spritesheet("segment-shadow", true, 0.5 * scale)}

local taillr = {demolisher_spritesheet("tail", false, 0.5 * scale),
                demolisher_spritesheet("tail-shadow", true, 0.5 * scale)}

-- Head
local head = table.deepcopy(data.raw["locomotive"]["locomotive"])
head.name = "demolisher-locomotive-head"
head.minable.result = "demolisher-locomotive-head"
-- head.collision_box = {{-0.6, (-segd) - 0.2}, {0.6, (segd) + 0.2}}
head.collision_box = {{-0.6, -jd - 0.2}, {0.6, jd + 0.2}}
head.selection_box = {{-1, -segd}, {1, segd}}
head.connection_distance = cd -- 0.55
head.joint_distance = jd
head.pictures.rotated = {}
head.pictures.rotated.layers = headlr
head.wheels = nil
head.collision_mask = {
    layers = {
        ["train"] = true
        -- ["demolisher_train"] = true
    }
    -- not_colliding_with_itself = true
}
head.max_power = "3.14MW"
head.max_speed = 0.195

head.energy_source.fuel_categories = {"demolisher-food"}
local effect_multiplier = 0.5
head.energy_source.smoke = {{
    name = "demolisher-train-smoke-trail",
    frequency = 50,
    starting_frame = 7,
    starting_frame_deviation = 14,
    vertical_speed_slowdown = 0
}, {
    name = "demolisher-train-smoke-front",
    frequency = 5000,
    starting_frame_deviation = 0.5,
    position = {0, -1},
    deviation = {5 * effect_multiplier, 5 * effect_multiplier}
}}
head.icons = nil
head.icon = "__demolisher-trains__/graphics/icons/demolisher-train-head.png"
head.icon_size = 64

local headi = table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])
headi.name = "demolisher-locomotive-head"
headi.place_result = "demolisher-locomotive-head"
headi.icons = nil
headi.icon = "__demolisher-trains__/graphics/icons/demolisher-train-head.png"
headi.icon_size = 64
headi.order = "c[rolling-stock]-e1"

-- Segment
local seg = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"])
seg.name = "demolisher-wagon-segment"
seg.minable.result = "demolisher-wagon-segment"
-- seg.collision_box = {{-0.6, (-segd) - 0.2}, {0.6, (segd) + 0.2}}
seg.collision_box = {{-0.6, -jd - 0.2}, {0.6, jd + 0.2}}
seg.selection_box = {{-1, -segd}, {1, segd}}
seg.connection_distance = cd
seg.joint_distance = jd
seg.pictures.rotated = {}
seg.pictures.rotated.layers = wagonlr
seg.wheels = nil
seg.horizontal_doors = nil
seg.vertical_doors = nil
seg.collision_mask = {
    layers = {
        ["train"] = true
        -- ["demolisher_train"] = true
    }
    -- not_colliding_with_itself = true
}

seg.icons = nil
seg.icon = "__demolisher-trains__/graphics/icons/demolisher-train-segment.png"
seg.icon_size = 64

local segi = table.deepcopy(data.raw["item-with-entity-data"]["cargo-wagon"])
segi.name = "demolisher-wagon-segment"
segi.place_result = "demolisher-wagon-segment"
segi.icons = nil
segi.icon = "__demolisher-trains__/graphics/icons/demolisher-train-segment.png"
segi.icon_size = 64
segi.order = "c[rolling-stock]-e2"

-- Tail
local tail = table.deepcopy(data.raw["locomotive"]["locomotive"])
tail.name = "demolisher-locomotive-tail"
tail.minable.result = "demolisher-locomotive-tail"
-- tail.collision_box = {{-0.6, (-segd) - 0.2}, {0.6, (segd) + 0.2}}
tail.collision_box = {{-0.6, -jd - 0.2}, {0.6, jd + 0.2}}
tail.selection_box = {{-1, -segd}, {1, segd}}
tail.connection_distance = cd -- 0.7
tail.joint_distance = jd
tail.pictures.rotated = {}
tail.pictures.rotated.layers = taillr
tail.wheels = nil
tail.collision_mask = {
    layers = {
        ["train"] = true
        -- ["demolisher_train"] = true
    },
    not_colliding_with_itself = true
}
tail.max_power = "3.14MW"
tail.max_speed = 0.195
tail.energy_source = {
    type = "void",
    emissions_per_minute = nil,
    render_no_power_icon = false,
    render_no_network_icon = false
}

tail.icons = nil
tail.icon = "__demolisher-trains__/graphics/icons/demolisher-train-tail.png"
tail.icon_size = 64

local taili = table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])
taili.name = "demolisher-locomotive-tail"
taili.place_result = "demolisher-locomotive-tail"
taili.icons = nil
taili.icon = "__demolisher-trains__/graphics/icons/demolisher-train-tail.png"
taili.icon_size = 64
taili.order = "c[rolling-stock]-e3"

-- Animation
local headani = {
    type = "animation",
    name = "demolisher-locomotive-head",
    layers = table.deepcopy(headlr)
}
local wagonani = {
    type = "animation",
    name = "demolisher-wagon-segment",
    layers = table.deepcopy(wagonlr)
}
local tailani = {
    type = "animation",
    name = "demolisher-locomotive-tail",
    layers = table.deepcopy(taillr)
}

-- FOR DEBUGGING
-- Make animation alpha layer and red
-- for _, a in pairs({headani, wagonani, tailani}) do
--     for _, l in pairs(a.layers) do
--         l.tint = {1, 0, 0, 0.5}
--     end
-- end
-- /FOR DEBUGGING

data:extend({head, headi, seg, segi, tail, taili, headani, wagonani, tailani})

-- Collision layer
data:extend({{
    type = "collision-layer",
    name = "demolisher_train"
}})

-- Smoke
local smokes = {"demolisher-mining-smoke-front", "demolisher-mining-smoke-small-top",
                "demolisher-mining-smoke-small-bottom", "demolisher-mining-smoke-big"}
for _, s in pairs(smokes) do
    local smoke = table.deepcopy(data.raw["trivial-smoke"][s])
    smoke.name = string.gsub(s, "mining", "train")
    smoke.render_layer = "lower-object-above-shadow"
    data:extend({smoke})
end
local scale = 0.5
data:extend({{
    type = "trivial-smoke",
    name = "demolisher-train-smoke-trail",
    animation = {
        filename = "__space-age__/graphics/entity/demolisher/trail-lower/demolisher-trail-lower.png",
        frame_count = 14,
        line_length = 4,
        width = 512,
        height = 512,
        scale = 2 * scale,
        animation_speed = 0.0000000000001,
        max_advance = 0
    },
    glow_animation = {
        filename = "__space-age__/graphics/entity/demolisher/trail-upper/demolisher-trail-upper.png",
        frame_count = 14,
        line_length = 4,
        width = 512,
        height = 512,
        scale = 1.5 * scale,
        animation_speed = 0.0000000000001,
        max_advance = 0
    },
    duration = 255,
    start_scale = 0.1,
    end_scale = 1,
    fade_away_duration = 60,
    affected_by_wind = false,
    movement_slow_down_factor = 0,
    render_layer = "ground-patch-higher2" -- Could be building-smoke = over resource under rail stone path
}})

-- Recipes
data:extend({{
    type = "recipe",
    name = "demolisher-locomotive-head",
    icon = "__demolisher-trains__/graphics/icons/demolisher-train-head.png",
    icon_size = 64,
    ingredients = {{
        type = "item",
        name = "locomotive",
        amount = 1
    }, {
        type = "item",
        name = "tungsten-plate",
        amount = 10
    }},
    results = {{
        type = "item",
        name = "demolisher-locomotive-head",
        amount = 1
    }}
}, {
    type = "recipe",
    name = "demolisher-wagon-segment",
    icon = "__demolisher-trains__/graphics/icons/demolisher-train-segment.png",
    icon_size = 64,
    ingredients = {{
        type = "item",
        name = "cargo-wagon",
        amount = 1
    }, {
        type = "item",
        name = "tungsten-carbide",
        amount = 5
    }},
    results = {{
        type = "item",
        name = "demolisher-wagon-segment",
        amount = 1
    }}
}, {
    type = "recipe",
    name = "demolisher-locomotive-tail",
    icon = "__demolisher-trains__/graphics/icons/demolisher-train-tail.png",
    icon_size = 64,
    ingredients = {{
        type = "item",
        name = "locomotive",
        amount = 1
    }, {
        type = "item",
        name = "tungsten-plate",
        amount = 1
    }, {
        type = "item",
        name = "tungsten-carbide",
        amount = 1
    }},
    results = {{
        type = "item",
        name = "demolisher-locomotive-tail",
        amount = 1
    }}
}})

-- Technology
data:extend({{
    type = "technology",
    name = "demolisher-trains",
    icon = "__demolisher-trains__/graphics/technology/demolisher-trains.png",
    icon_size = 528,
    prerequisites = {"planet-discovery-vulcanus", "railway"},
    research_trigger = {
        type = "mine-entity",
        entity = "demolisher-dummy"
    },
    effects = {{
        type = "unlock-recipe",
        recipe = "demolisher-locomotive-head"
    }, {
        type = "unlock-recipe",
        recipe = "demolisher-wagon-segment"
    }, {
        type = "unlock-recipe",
        recipe = "demolisher-locomotive-tail"
    }}
}})

-- Fuel
data:extend({{
    type = "fuel-category",
    name = "demolisher-food"
}})

local tu = data.raw["item"]["tungsten-ore"]
tu.fuel_category = "demolisher-food"
tu.fuel_value = "3.14MJ"
