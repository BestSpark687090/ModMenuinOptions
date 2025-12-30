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
        if modData.disabled then goto continue end
        local mod = SMODS.find_mod(modData.id)[1]
        local config_tab_check = mod.config_tab ~= nil
        local extra_tabs_check = mod.extra_tabs ~= nil
        local config_check = config_tab_check or extra_tabs_check
        if not modData.disabled and config_check then
            enabledMods[#enabledMods + 1] = modData.id
        end
        ::continue::
    end
    local current_selected = ""
    local left_node = {}
    left_node[#left_node + 1] = create_option_cycle({
        label = "Enabled Mods",
        options = enabledMods,
        info = { "Select which mods to enable MMiO features for." },
        opt_callback = "mmio_select_mod",
        info_scale = 0.35
    })
    function G.FUNCS.mmio_select_mod(e)
        local current_selected = e.to_val
        if current_selected == "" then return end
        local toggle = G.OVERLAY_MENU:get_UIE_by_ID("mmio_enable")
        local im_getting_there = toggle.children[1].children[1].children[2].children[1].children[1].children[1]
        -- im_getting_there.config.button_UIE.config.ref_value = true -- I guess??
        
        local uie = im_getting_there.config.button_UIE
        mmio.uie = uie
        uie.config.ref_table.ref_value = current_selected
        -- Okay let me explain this
        -- how do i do multiline comments again? 
        --[[
        test
        i see
        so basically im_getting_there is the actual ui element for the button. i get its config
        then its actual button ui element then ITS config because it has the ref table
        dont know why it does it twice but check the code
        functions/button_callbacks.lua line 464. it's just there. 
        ]]
        uie.config.ref_table.ref_table[uie.config.ref_table.ref_value] = mmio.config.mods_in_options[current_selected] or false
        -- heck yeah
        -- ill finish this up tomorrow
        -- i did!
    end

    local right_node = {}
    right_node[#right_node + 1] = create_toggle({
        label = "Enable?",
        info = { "Enable or disable MMiO features for the mod." },
        info_scale = 0.35,
        id = "mmio_en_toggle",
        ref_table = mmio.config.mods_in_options,
        ref_value = mmio.config.mods_in_options[current_selected] or false,
        callback = function(val)
            if current_selected == "" then return end
            mmio.config.mods_in_options[current_selected] = val
            mmio:save_config()
        end,
    })
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
            { n = G.UIT.C, config = { align = "cl", padding = 0.15 },                   nodes = left_node },
            { n = G.UIT.C, config = { align = "cr", id = "mmio_enable", padding = 0.15 }, nodes = right_node }
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
            id = "mmio_root"
        },
        nodes = nodes,
    }
end

return mmio.create_menu()
