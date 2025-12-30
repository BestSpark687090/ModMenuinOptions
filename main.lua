---@diagnostic disable: undefined-global
-- if not mmio then
--     mmio = {} -- me when config
-- end
-- i just realized mmio is easier but im using moim
-- nvm i changed it
mmio = SMODS.current_mod
mmio.save_config = function(self)
    SMODS.save_mod_config(self)
end
mmio:save_config()
local mod_path = "" .. SMODS.current_mod.path
mmio.config_tab = SMODS.load_file("configtab.lua")
assert(SMODS.load_file("functions.lua"))() -- me when load file
-- okay after creating the config menu... time to actually do the implementing i guess
-- my idea is that if there's only one mod enabled it just
-- shows that mod's menus directly
-- here we are
-- code taken from handy, which was taken from ankh by MathIsFun
-- they misspelled it in their code lol
local create_uibox_options_ref = create_UIBox_options
function create_UIBox_options()
	local contents = create_uibox_options_ref()
	table.insert(contents.nodes[1].nodes[1].nodes[1].nodes, UIBox_button({ label = { "MMiO" }, button = "mmio_generate_mod_select_menu", minw = 5, colour = HEX("FF0000") }))
	return contents
end
function G.FUNCS.mmio_test_press(e)
    print(e)
end
--[[
NOTES:
SMODS.mod_list[find mod number].config_tab() - check if function but should be?
SMODS.mod_list[find mod number].extra_tabs() - this is gonna be a function but its gonna be hard to implement...
it's a list of tables with a label and a tab_definition_function
wait i can just use SMODS.find_mod(mod id) then use next(mod_find) to check if it's somehow nil (uninstalled mod?)

]]
--[[
function G.UIDEF.handy_options(from_smods)
	local tabs = Handy.UI.get_options_tabs()
	tabs[Handy.UI.config_tab_index or 1].chosen = true
	local t = create_UIBox_generic_options({
		back_func = from_smods and "mods_button" or "handy_exit_options",
		contents = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0 },
				nodes = {
					create_tabs({
						tabs = tabs,
						snap_to_nav = true,
						no_shoulders = true,
						colour = G.C.BOOSTER,
					}),
				},
			},
		},
	})
	return t
end
function G.FUNCS.handy_open_options(e) -- opens the actual options
	G.SETTINGS.paused = true
	Handy.UI.reset_config_variables()
	Handy.UI.config_opened = true
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.handy_options(),
	})
	Handy.utils.cleanup_dead_elements(G, "MOVEABLES")
end
function G.FUNCS.handy_exit_options(e)
	Handy.UI.reset_config_variables()
	if e then -- if we were in the options go back to the options
		return G.FUNCS.options(e)
	end
	Handy.utils.cleanup_dead_elements(G, "MOVEABLES")
end
local exit_overlay_ref = G.FUNCS.exit_overlay_menu
function G.FUNCS.exit_overlay_menu(...)
	Handy.UI.reset_config_variables()
	local result = exit_overlay_ref(...)
	Handy.utils.cleanup_dead_elements(G, "MOVEABLES")
	return result
end
]]