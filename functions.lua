-- most of this code stolen from handy (with good intents)
-- ts is too far gone to be saying its stolen. but i did copy some of it
-- Okay... i don't know what I did... but it works now????????
-- its been weird all of the time. now it's... normal?
-- nvm it doesnt work what the flip
function G.FUNCS.mmio_options(e)
    local mod_id = e.config.id
    if next(SMODS.find_mod(mod_id)) == nil then
        return nil -- nope.
    end
    local mod = SMODS.find_mod(mod_id)[1]
    local main_was_nil = false
    local config_tab_content = type(mod.config_tab) == "function" and mod.config_tab() or {}
    local tabs = type(mod.extra_tabs) == "function" and mod.extra_tabs() or {}
    -- Double function check (Handy, as far as I know)
    if type(config_tab_content) == "function" then
        config_tab_content = config_tab_content()
    end
    -- again on tabs just in case
    if type(tabs) == "function" then
        tabs = tabs()
    end
    -- print(config_tab_content)
    local main_tab = {}
    if next(config_tab_content) == nil then
        -- config_tab_content = tabs
        main_was_nil = true
        main_tab = tabs
    else
        main_tab = {
            [1] = {
                label = "Config",
                chosen = true,
                button = "mmio_change_tab",
                colour = G.C.BOOSTER,
                tab_definition_function = function()
                    return config_tab_content
                end,
            }
        }
    end
    if not main_was_nil then
        for k, v in ipairs(tabs) do
            v["button"] = "mmio_change_tab"
            local v_t = v
            -- if v_t.colour == nil then
            --     v_t.colour = G.C.BOOSTER
            -- end
            table.insert(main_tab, v_t)
        end
    end

    main_tab[1].chosen = true
    mmio.main_tab = main_tab
    local t = create_UIBox_generic_options({
        back_func = "mmio_generate_mod_select_menu",
        contents = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    create_tabs({
                        tabs = main_tab,
                        colour = G.C.BOOSTER,
                        change_func = "mmio_change_tab"
                    }),
                },
            },
        },
    })
    -- Make t's config buttons the change_tab function. Hope that works.
    G.FUNCS.overlay_menu({
        definition = t,
    })
    -- im just gonna do it
    return t
end
function G.FUNCS.mmio_change_tab(e)
    if not e then return end
    local tab_contents = e.UIBox:get_UIE_by_ID('tab_contents')
    if not tab_contents then return end
    tab_contents.children = {}
    local new_def = e.config.ref_table.tab_definition_function(e.config.ref_table.tab_definition_function_args)
    tab_contents.config.object = UIBox {
        definition = new_def,
        config = { offset = { x = 0, y = 0 }, parent = tab_contents, type = 'cm' }
    }
    tab_contents.UIBox:recalculate()
end
function G.FUNCS.mmio_do_it()
    if G.OVERLAY_MENU:get_UIE_by_ID("spl_uhhhh") then
        local not_gonna_sugarcoat_it = mmio.tab.UIRoot.children[1].children[1].children[1].children[1].children[1]
        .children[2].children[1].config.object.UIRoot.children[1].children[1].children[3]--.children[1]--.children[1]
        --.children[2].children[1].children[1].children[1]
        not_gonna_sugarcoat_it:mmio_set_wh()
        -- not_gonna_sugarcoat_it.T.w=0.56
        -- not_gonna_sugarcoat_it.T.h=0.56
    end
end

function UIElement:mmio_set_wh()
    -- print(self.T.h)
    self.T.w = 0.56
    self.T.h = 0.56
    for k, v in pairs(self.children) do
        v:mmio_set_wh()
    end
end

function G.FUNCS.mmio_back_to_select(e)
    if e then -- if we were in the options go back to the options
        return G.FUNCS.options(e)
    end
end

-- TODO: make multi-mod menu...
-- okay so that wasnt as bad as i thought it would have been :)
function G.FUNCS.mmio_generate_mod_select_menu()
    local mod_options = {}
    for k, v in pairs(mmio.config.mods_in_options) do
        if not v == false then
            -- make buttons for each mod
            mod_options[#mod_options + 1] = UIBox_button({
                label = { k },
                button = "mmio_options",
                -- func = G.FUNCS.mmio_options({id="SparkLatro"}),
                minw = 5,
                colour = G.C.RED,
                id = k,
            })
        end
    end
    local ui = {
        n = G.UIT.R,
        config = { align = "cm", padding = 0 },
        nodes = {
            -- here we go i guess.
            {
                n = G.UIT.R,
                config = { colour = G.C.RED, minw = 10, r = 0, minh = 0.75, align = "cm" },
                nodes = {
                    { n = G.UIT.T, config = { text = "Select a Mod:", scale = 0.5, colour = G.C.WHITE, juice = true, align = "cm" } },
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.15 },
                nodes = mod_options
            },
        }
    }
    local t = create_UIBox_generic_options({
        back_func = "mmio_back_to_select",
        contents = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    ui
                },
            },
        },
    })
    G.FUNCS.overlay_menu({
        definition = t,
    })
    -- return ui
end
