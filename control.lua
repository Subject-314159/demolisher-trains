local allowed_names = {"demolisher-locomotive-head", "demolisher-wagon-segment", "demolisher-locomotive-tail"}

-- local event_filter = {{
--     filter = "name",
--     name = "demolisher-locomotive-head"
-- }, {
--     filter = "name",
--     name = "demolisher-locomotive-head"
-- }, {
--     filter = "name",
--     name = "demolisher-locomotive-head"
-- }}
local event_filter = {}
for _, n in pairs(allowed_names) do
    local prop = {
        filter = "name",
        name = n
    }
    table.insert(event_filter, prop)
end

local array_has_value = function(array, value)
    for k, v in pairs(array) do
        if v == value then
            return true
        end
    end
    return false
end

local init_storage = function()
    if not storage then
        storage = {}
    end
    if not storage.trains then
        storage.trains = {}
    end
    if not storage.state then
        storage.state = {}
    end
    if not storage.demolishers then
        storage.demolishers = {}
    end
    if not storage.forces then
        storage.forces = {}
    end
end

local init = function()
    init_storage()
end

local load = function()

    commands.add_command("make", "Generate array of trains", function(command)
        local dir = {"north", "northnortheast", "northeast", "eastnortheast", "east", "eastsoutheast", "southeast",
                     "southsoutheast", "south", "southsouthwest", "southwest", "westsouthwest", "west", "westnorthwest",
                     "northwest", "northnorthwest"}
        local d = 1
        local s = game.get_player(command.player_index).surface
        for x = 1, 100, 1 do
            for y = 1, 100, 1 do
                local pos = {4 * x, 4 * y}
                s.create_entity({
                    name = "straight-rail",
                    position = pos,
                    force = "player",
                    direction = defines.direction[dir[d]]
                })
                s.create_entity({
                    name = "demolisher-locomotive-head",
                    position = pos,
                    force = "player",
                    direction = defines.direction[dir[d]]
                })
            end
            if d < 16 then
                d = d + 1
            else
                d = 1
            end
        end
    end)
end

----------------------------------------------------------------------------------------------------
-- DATA STRUCTURE
----------------------------------------------------------------------------------------------------
-- storage = {
--      trains = {
--          [id] = { -- The Train ID as per the LuaTrain
--              train = LuaTrain
--              carriages = {
--                  [id] = { -- The Carriage ID within this train
--                      entity = LuaEntity -- Reference to the locomotive/wagon
--                      animation = int -- The ID of the animation related to this entity
--                      orientation = double -- The orientation of the entity at the point the animation was last updated
--                  },
--                  [id] = {...},
--                  ...
--              },
--              carriage_render_order = {[i] = #carriages - i} -- Inverse order of carriages, for tracking current_carriage while rendering
--          },
--          [id] = {...},
--          ...
--      },
--      state = {
--          current_train = int -- Train ID currently being checked
--          current_carriage = int -- Carriage ID in the train currently being checked
--      }
-- }

-- local get_storage_entries = function()
--     init_storage()
--     return storage.entities
-- end

script.on_configuration_changed(function()
    init()
end)

script.on_init(function()
    init()
    load()
end)

script.on_load(function()
    load()
end)

-- local check_trains = function()
--     -- Get some variables to work with
--     local chk = storage.state.check
--     local st = storage.trains

--     -- Get the train currently being checked
--     local icurt, icurc
--     if chk.current_train == nil then
--         -- If there is no current train being checked then we need to retrieve all trains from the train manager
--         storage.trainmgr = game.train_manager.get_trains({})

--         -- Early exit if there are no trains in the game
--         -- This means that the next tick we end up here again, until at least one train is built, which is fine
--         if not storage.trainmgr or next(storage.trainmgr) == nil then
--             return
--         end

--         -- Get the first next train from the mgr and store it in state
--         icurt = next(storage.trainmgr)
--         chk.current_train = icurt
--     else
--         -- Get the current train ID from storage
--         icurt = chk.current_train
--     end

--     -- Get the carriage of the train currently being checked
--     if chk.current_carriage == nil then
--         -- If there is no current carriage then we need to retrieve it from the trainmgr
--         icurc = next(storage.trainmgr[icurt].carriages)

--         -- Early exit if there is no carriage in this train
--         -- This should not happen but we have to build a safety check anyways
--         if not icurc then
--             return
--         end

--         -- Store the carriage as current
--         chk.current_carriage = icurc
--     else
--         -- Get the current carriage ID within this train from the storage
--         icurc = chk.current_carriage
--     end

--     -- Check trains and add animations for as long as we are allowed
--     local i = 1
--     -- local icur = icurt
--     while i <= settings.global["dt-animation-updates-per-tick"].value do
--         -- Get the related train from storage
--         if not storage.trains[icurt] then
--             -- We do not have this train in our storage, so we need to create it
--             -- Include a reference to the LuaTrain
--             storage.trains[icurt] = {
--                 train = storage.trainmgr[icurt]
--             }

--             -- Also create the carriage order array
--             storage.trains[icurt].carriage_render_order = {}
--             local ro = storage.trains[icurt].carriage_render_order
--             local a = 1
--             for b = #storage.trains[icurt].carriages, 1, -1 do
--                 ro[a] = b
--                 a = a + 1
--             end
--         end
--         local chkt = storage.trains[icurt]

--         -- Get the related carriage from storage if this is a demolisher carriage
--         -- TODO: I think we need to add all carriages to our array or handle it in a different way during animation update?
--         if not chkt.carriages[icurc] and array_has_value(chkt.name, allowed_names) then
--             -- We do not have this carriage in our storage, so we need to create it
--             local c = chkt.train.carriages[icurc]

--             -- Create new animation for this entity
--             local ofs = c.orientation * 128
--             local prop = {
--                 animation = c.name,
--                 target = c,
--                 surface = c.surface,
--                 animation_speed = 0,
--                 animation_offset = ofs,
--                 render_layer = "higher-object-under"
--             }
--             local id = rendering.draw_animation(prop)
--             chkt.carriages[icurc] = {
--                 entity = c,
--                 animation = id,
--                 orientation = c.orientation
--             }

--             -- Increase the counter
--             i = i + 1
--         end

--         -- TODO next: get the next carriage, if no next carriage get next train and fist carriage in that train, if  no next train then break

--     end
-- end

-- local make_animations = function()
--     local se = get_storage_entries()
--     for _, t in pairs(game.train_manager.get_trains({})) do
--         for i = #t.carriages, 1, -1 do
--             local c = t.carriages[i]
--             if not se[c.unit_number] then
--                 -- Create new animation for this entity
--                 local ofs = c.orientation * 128
--                 local prop = {
--                     animation = c.name,
--                     target = c,
--                     surface = c.surface,
--                     animation_speed = 0,
--                     animation_offset = ofs,
--                     render_layer = "higher-object-under"
--                 }
--                 local id = rendering.draw_animation(prop)
--                 se[c.unit_number] = {
--                     entity = c,
--                     animation = id,
--                     orientation = c.orientation
--                 }
--             end
--         end
--     end
-- end

local get_current_train = function()
    local train_id = storage.current_train
    local st = storage.trains
    local current_train
    -- Get the train and carriage we are working with
    if st[train_id] then
        -- This train ID entry exists so reference it
        current_train = st[train_id]
    else
        -- The train entry does not exist, so remove that entry and grab the first entry from the array and store that ID
        local id
        id, current_train = next(st)
        if not current_train then
            -- There are no train entries so we can return home
            storage.current_train = nil
            return
        end
        storage.current_train = id
    end
    return current_train
end

local get_next_train = function()
    -- Get the next train from storage based on the current ID
    local st = storage.trains
    local cur_id = storage.current_train
    local id, next_train = next(st, cur_id)

    -- If we did not receive a train we reached the end of the line, so get the first train from the array
    if not next_train then
        id, next_train = next(st)
    end

    -- Store the new ID
    storage.current_train = id
    return next_train
end

local get_current_carriage = function()
    -- Get the train
    local current_train = get_current_train()
    if not current_train then
        -- This should not be necessary but add a failsafe anyways
        return false
    end

    -- Get the carriage id
    local id = storage.current_carriage or 1
    -- Check if the carriage id exceeds the render order array
    if id > #current_train.carriage_render_order then
        -- We reached the end of the train, loop around and return nil so we can get the next train
        return false
    end

    -- Get the carriage entry
    local unit_nr = current_train.carriage_render_order[id]
    if current_train.carriages[unit_nr] then
        local carriage = current_train.carriages[unit_nr]
        return carriage
    end
end

local get_next_train_carriage = function()
    -- Get the current train
    local train = get_current_train()
    if not train then
        return
    end

    -- First try to get the next carriage in the current train
    -- And check if the next ID is bigger than the array length
    local carriage, unit_nr
    local next_id = (storage.current_carriage or 1) + 1
    if next_id > #train.carriage_render_order then
        train = get_next_train()
        next_id = 1
    end

    -- Get the carriage
    unit_nr = train.carriage_render_order[1]
    carriage = train.carriages[unit_nr]

    -- Store the new carriage ID
    storage.current_carriage = next_id

    -- Return the new train and carriage references
    return train, carriage
end

local mark_remove = function(to_remove)
    local train_id, carriage_id = storage.current_train, storage.current_carriage
    if not train_id then
        return
    end

    local current_train = storage.trains[train_id]
    if not to_remove[train_id] then
        to_remove[train_id] = {}
    end
    if current_train and current_train.carriage_render_order[carriage_id] then
        table.insert(to_remove[train_id], current_train.carriage_render_order[carriage_id])
    end
end

local remove_animation = function(current_carriage, to_remove)
    mark_remove(to_remove)
    if current_carriage and current_carriage.animation then
        current_carriage.animation.destroy()
        return true
    end
end

local update_animation = function(current_carriage)
    local updated = false
    local c = current_carriage.entity
    local cor = -(1 / 256)
    -- local cor = 0
    if c.orientation == 0 or c.orientation == 0.25 or c.orientation == 0.5 or c.orientation == 0.75 then
        cor = 0
    end
    -- local ofs = math.floor(((c.orientation - cor) * 128))
    local ofs = (c.orientation - cor) * 128
    if current_carriage.animation then
        -- We have an existing animation, so update the orientation only
        if c.orientation ~= current_carriage.orientation then
            current_carriage.animation.animation_offset = ofs
            updated = true
        end
    else
        -- There is no animation yet (because we just registered it), so create it
        local prop = {
            animation = c.name,
            target = {
                entity = c,
                offset = {
                    x = 0,
                    y = 0
                }
            },
            surface = c.surface,
            -- time_to_live = 1,
            animation_speed = 0,
            animation_offset = ofs,
            render_layer = "higher-object-under"
        }
        local id = rendering.draw_animation(prop)

        -- Store the animation in the carriage array
        current_carriage.animation = id

        -- Mark updated
        updated = true
    end

    if updated then
        -- Update the XY offset
        local pi = 3.141592
        local shift_x, shift_y
        if c.name == "demolisher-locomotive-head" then
            shift_x, shift_y = -0.3, 0.26
        elseif c.name == "demolisher-wagon-segment" then
            shift_x, shift_y = -0.55, 0.40
        else
            shift_x, shift_y = -0.1, 0.26
        end
        local x_off = (math.sin((c.orientation or 0) * 4 * pi) * shift_x)
        local y_off = (math.cos((c.orientation or 0) * 4 * pi) * shift_y) + shift_y

        -- x_off = 0
        -- y_off = 0
        current_carriage.animation.target = {
            entity = c,
            offset = {
                x = x_off,
                y = y_off
            }
        }
        -- Store the orientation of the carriage as per the updated animation
        current_carriage.orientation = c.orientation
        return true
    end
end

local update_animations = function()
    -- Get the first train and carriage IDs we start updating in this tick
    -- local ifirstt = storage.current_train or next(st)
    -- local ifirstc = storage.current_carriage or 1

    local curt = get_current_train()
    if not curt then
        return
    end

    local curc
    local ifirstt = storage.current_train
    local ifirstc = storage.current_carriage or 1

    -- Get some variables to work with
    local to_remove = {}

    -- Update animations as far as mod settings allow
    local i, j = 1, 1
    local icurt, icurc = ifirstt, ifirstc
    while i <= settings.global["dt-animation-updates-per-tick"].value do
        -- Get the current train based on the ID
        curt = get_current_train()
        if not curt then
            break
        end

        -- Get the current carriage based on the ID
        curc = get_current_carriage()

        -- Check if the train is valid
        if curt.train and curt.train.valid then
            -- The train is valid, so get the carriage based on the ID
            if not curc then
                -- Either we reached the end or we encountered a carriage entry that no longer exists
                if curc == nil then
                    -- The entry does not exist, so we mark it for clean up
                    if remove_animation(curc, to_remove) then
                        i = i + 1
                    end
                end
            elseif curc.entity and curc.entity.valid then
                -- The entity is still there, so update the animation
                if update_animation(curc) then
                    i = i + 1
                end
            else
                -- The entity no longer exists, so we need to remove the animation and mark it for clean up
                if remove_animation(curc, to_remove) then
                    i = i + 1
                end
            end
        else
            -- The train is no longer valid, so remove all carriages
            if remove_animation(curc, to_remove) then
                i = i + 1
            end
        end

        -- Prepare for the next carriage
        curt, curc = get_next_train_carriage()
        if not curt or not curc then
            -- We did not get a new train/carriage so we should return
            break
        end

        -- Break if we are back at where we started
        if ifirstt == storage.current_train and ifirstc == storage.current_carriage then
            break
        end

        -- Update the total loop count
        j = j + 1

        if j > 1000000 then
            game.print("Whoa there pardner, we looped 1 million times in one tick.. Sumtin wong!")
            game.print("You better report a bug on the mod portal and include your save")
            return
        end
    end

    -- Remove obsolete entries in storage
    local st = storage.trains
    for tid, carriages in pairs(to_remove) do
        local tr = st[tid]
        -- Remove all obsolete carriages
        for _, cen in pairs(carriages) do
            tr.carriages[cen] = nil
            -- Remove the entry from the render order
            for k, v in ipairs(tr.carriage_render_order) do
                if v == cen then
                    table.remove(tr.carriage_render_order, k)
                    break
                end
            end
        end

        local has_carriages = false
        for _, c in pairs(st[tid].carriages) do
            has_carriages = true
            break
        end

        -- Remove the train if there are no more carriages
        if not has_carriages then
            st[tid] = nil
        end
    end
end

script.on_event(defines.events.on_tick, function(e)
    -- Early exit if we are disabled or not yet initialized
    if not settings.global["dt-render-overlay"].value or not storage or not storage.trains then
        return
    end

    -- Do our magic
    update_animations()

end)

local register_trains = function(trains)
    -- We need to register the complete train because we don't know the position of the carriage that was created or removed

    -- Normalize trains
    if trains == nil then
        -- No trains were passed, get all trains from the train manager
        trains = game.train_manager.get_trains({})
    elseif type(trains) ~= "array" then
        -- The passed trains is not an array, convert to array
        trains = {trains}
    end

    -- Register all trains and carriages
    for _, t in pairs(trains) do
        -- Register the train
        if not storage.trains[t.id] then
            storage.trains[t.id] = {
                train = t,
                carriages = {}
            }
        end
        local curt = storage.trains[t.id]

        -- Determine the render order from last carriage to first carriage
        local order = {}
        for i = #t.carriages, 1, -1 do
            local c = t.carriages[i]
            -- Only register demolisher train segments
            if array_has_value(allowed_names, c.name) then
                -- Register the carriage
                if not curt.carriages[c.unit_number] then
                    curt.carriages[c.unit_number] = {
                        entity = c
                        -- Animation and orientation are to be created on_tick
                    }
                end

                -- Add the carriage unit number to the order array
                table.insert(order, c.unit_number)
            end
        end

        -- Overwrite the render order
        curt.carriage_render_order = order
    end
end

-- Event handlers
script.on_event(defines.events.on_runtime_mod_setting_changed, function(e)
    -- Only for our setting and storage.entities exists
    if e.setting == "dt-render-overlay" then
        if settings.global["dt-render-overlay"].value then
            register_trains()
        else
            -- Early exit if we are not inited yet
            if not storage or not storage.trains then
                return
            end

            -- Remove/disable animations
            for _, curt in pairs(storage.trains) do
                curt.animation.destroy()
            end

            -- Reset the array
            storage.trains = {}
        end
    end
end)
local on_built_event = function(e)
    -- Early exit if the entity (or parent train) this event was triggered on is not valid
    if not e.entity or not e.entity.valid or not e.entity.train or not e.entity.train.valid then
        return
    end

    -- Register the train
    register_trains(e.entity.train)
end
script.on_event(defines.events.on_built_entity, function(e)
    on_built_event(e)
end, event_filter)
script.on_event(defines.events.on_robot_built_entity, function(e)
    on_built_event(e)
end, event_filter)
script.on_event(defines.events.script_raised_built, function(e)
    on_built_event(e)
end, event_filter)

-- Demolisher killed setter/getter
local set_demolisher_killed = function(force)
    if not storage.forces then
        storage.forces = {}
    end
    storage.forces(force.index).killed_demolisher = true
end
local get_demolisher_killed = function(force)
    if not storage.forces then
        storage.forces = {}
    end
    return storage.forces(force.index).killed_demolisher
end

-- Research handling
local unlock_demolisher_tech = function(force)
    -- Early exit if already researched
    local tt = force.technologies["demolisher-trains"]
    if tt.researched then
        return
    end

    -- Early exit if not all prerequisites are researched
    for _, p in pairs(tt.prerequisites) do
        if not p.researched then
            return
        end
    end

    -- Research our demolisher tech
    if get_demolisher_killed(force) then
        force.research_recursive(tt.name)
    end
end
script.on_event(defines.events.on_research_finished, function(e)
    -- Unlock the demolisher tech if available
    unlock_demolisher_tech(e.research.force)
end)

-- Track demolisher destroying events
script.on_event(defines.events.on_chunk_generated, function(e)
    -- Only for vulcanus
    if e.surface.name == "vulcanus" then
        -- Search for demolishers in the generated chunk
        local prop = {
            area = e.area,
            name = {"small-demolisher", "medium-demolisher", "big-demolisher"}
        }
        local demolishers = e.surface.find_entities_filtered(prop)

        -- Register all demolishers for on_killed
        for _, d in pairs(demolishers) do
            local id = script.register_on_object_destroyed(d)
            if not storage.demolishers then
                storage.demolishers = {}
            end
            storage.demolishers[id] = true
        end

    end
end)
script.on_event(defines.events.on_object_destroyed, function(e)
    -- If it is one of our registered demolishers
    if storage.demolishers[e.registration_number] then
        -- Set the flag for that force and unlock if available
        for _, f in pairs(game.forces) do
            set_demolisher_killed(f)
            unlock_demolisher_tech(f)
        end
    end
end)
