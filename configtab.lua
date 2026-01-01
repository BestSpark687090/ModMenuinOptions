function mmio.create_menu()
    local nodes = {}
    local settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
    settings.nodes[#settings.nodes + 1] = {
        n = G.UIT.R,
        config = { colour = G.C.RED, minw = 10, r = 0, minh = 0.75, align = "cm" },
        nodes = {
            { n = G.UIT.T, config = { text = "MMiO Config", scale = 0.5, colour = G.C.WHITE, juice = true, align = "cm" } },
        }
    }
    local enabledMods = {}
    for k, modData in pairs(SMODS.mod_list) do
        -- check for a valid config menu
        if not modData.disabled then
            local mod = SMODS.find_mod(modData.id)[1]
            local config_tab_check = mod.config_tab ~= nil
            local extra_tabs_check = mod.extra_tabs ~= nil
            local config_check = config_tab_check or extra_tabs_check
            if config_check then
                enabledMods[#enabledMods + 1] = modData.id
            end
        end
    end
    local current_selected = ""
    local left_node = {}
    local cycle = create_option_cycle({
        label = "Enabled Mods",
        options = enabledMods,
        info = { "Select which mods to enable MMiO features for." },
        opt_callback = "mmio_select_mod",
        current_option = 1,
        info_scale = 0.35
    })
    mmio.cycle = cycle
    local cycle_node = cycle.nodes[2].nodes[1].nodes[1].config.ref_table
    left_node[#left_node + 1] = cycle


    local right_node = {}
    
    local enable_toggle = create_toggle({
        label = "Enable?",
        info = { "Enable or disable MMiO features for the mod." },
        info_scale = 0.35,
        id = "mmio_en_toggle",
        ref_table = mmio.config.mods_in_options,
        ref_value = cycle_node.current_option_val,
        callback = function(val)
            -- local cycle_node = mmio.cycle.nodes[2].nodes[1].nodes[1].config.ref_table
            -- if cycle.current_option == 1 then return end
            mmio.config.mods_in_options[cycle_node.current_option_val] = val
            mmio:save_config()
        end,
    })
    mmio.enable_toggle = enable_toggle
    local toggle_node = enable_toggle.nodes[1].nodes[2].nodes[1].nodes[1].config.ref_table
    right_node[#right_node + 1] = enable_toggle
    function G.FUNCS.mmio_select_mod(e)
       toggle_node.ref_value = cycle_node.current_option_val
    end
    for _, n in pairs(left_node) do
        n.config.align = "cr"
    end
    for _, n in pairs(right_node) do
        n.config.align = "cl"
    end
    local t = {
        n = G.UIT.R,
        config = { align = "cm", padding = 0.2, minw = 7 },
        nodes = {
            { n = G.UIT.C, config = { align = "cl", padding = 0.15 }, nodes = left_node },
            { n = G.UIT.C, config = { align = "cr", id="mmio_enable", padding = 0.15 }, nodes = right_node }
        }
    }
    settings.nodes[#settings.nodes + 1] = t
    local config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { settings } }
    nodes[#nodes + 1] = config
    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            minh = 6,
            r = 0.1,
            minw = 10,
            align = "cm",
            padding = 0.2,
            colour = G.C.BLACK,
        },
        nodes = nodes,
    }
end

return mmio.create_menu()
