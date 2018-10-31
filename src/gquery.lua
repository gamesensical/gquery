local inspect = require "inspect"

local function replace_objects(element, ...)
	local objects = {...}
	for i=1, #objects do
		if type(objects[i]) == "table" and objects[i][element] ~= nil then
			objects[i] = objects[i][element]
		end
	end
	return unpack(objects)
end

local function replace_objects_function(fn, element)
	if fn == nil then return nil end
	return function(...)
		--client.log(inspect({replace_objects(element, ...)}))
		return fn(replace_objects(element, ...))
	end
end

local client = setmetatable({}, {__index = function(self, key) return replace_objects_function(client[key], "__value") end})
local entity = setmetatable({}, {__index = function(self, key) return replace_objects_function(entity[key], "__value") end})
local globals = setmetatable({}, {__index = function(self, key) return replace_objects_function(globals[key], "__value") end})
local ui = setmetatable({}, {__index = function(self, key) return replace_objects_function(ui[key], "__value") end})
local renderer = setmetatable({}, {__index = function(self, key) return replace_objects_function(renderer[key], "__value") end})
local cvar = setmetatable({}, {__index = function(self, key) return replace_objects_function(renderer[key], "__value") end})

--local variables for API. Automatically generated by https://github.com/simpleavaster/gslua/blob/master/authors/sapphyrus/generate_api.lua 
local client_latency, client_set_clan_tag, client_log, client_draw_rectangle, client_draw_indicator, client_draw_circle_outline, client_timestamp, client_world_to_screen, client_userid_to_entindex = client.latency, client.set_clan_tag, client.log, client.draw_rectangle, client.draw_indicator, client.draw_circle_outline, client.timestamp, client.world_to_screen, client.userid_to_entindex 
local client_draw_circle, client_draw_gradient, client_set_event_callback, client_screen_size, client_trace_line, client_draw_text, client_color_log = client.draw_circle, client.draw_gradient, client.set_event_callback, client.screen_size, client.trace_line, client.draw_text, client.color_log 
local client_system_time, client_delay_call, client_visible, client_exec, client_open_panorama_context, client_set_cvar, client_eye_position = client.system_time, client.delay_call, client.visible, client.exec, client.open_panorama_context, client.set_cvar, client.eye_position 
local client_draw_hitboxes, client_get_cvar, client_draw_line, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.draw_hitboxes, client.get_cvar, client.draw_line, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float 
local entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all = entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all 
local entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname 
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval 
local globals_framecount, globals_frametime, globals_maxplayers = globals.framecount, globals.frametime, globals.maxplayers 
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set 
local ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get 
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos 
local math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad 
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert 
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub 
local renderer_line, renderer_indicator, renderer_world_to_screen, renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text = renderer.line, renderer.indicator, renderer.world_to_screen, renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text 
--end of local variables 

local random = client.random_int
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string_gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string_format('%x', v)
    end)
end

local function table_contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then 
			return true
		end
	end
	return false
end

local function string_starts_with(str, start)
   return str:sub(1, #start) == start
end

local function string_ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

local function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math_floor(num * mult + 0.5) / mult
end

local function between(number, min, max, include_equal)
	if min > max then
		min, max = max, min
	end
	return include_equal and (number >= min and number <= max) or (number > min and number < max)
end

local function lerp(a, b, fraction)
	return a + (b - a) * fraction
end

local function apply_metatable(metatable, ...)
	local elements = {...}
	for i=1, #elements do
		local element = elements[i]
		if type(element) ~= "table" then
			elements[i] = {
				["__value"] = element
			}
		end
		elements[i] = setmetatable(elements[i], metatable)
	end
	return unpack(elements)
end

local function apply_metatable_function(metatable, fn)
	return function(...)
		return apply_metatable(metatable, fn(...))
	end
end

local function hook_multiple_function(fn, hook_fns)
	return function(...)
		local parameters = {...}
		local results = {fn(unpack(parameters))}
		for i=1, #hook_fns do
			hook_fns[i](results, parameters)
		end
		return unpack(results)
	end
end

local function get_reference_type(reference, i)
	local values = {ui_get(reference)}
	if type(value[1]) == "boolean" then return (i ~= nil and i > 1) and "hotkey" or "checkbox" end
	if type(value[1]) == "number" then
		if type(value[2]) == "number" and type(value[3]) == "number" and type(value[4]) == "number" then
			return "color_picker"
		else
			return "slider"
		end
	end
	if type(value[1]) == "table" then return "multiselect" end
	if type(value[1]) == "string" then return "combobox" end
end

local FL_ONGROUND = 1
local M = {}

M.common = {}
M.common.table_contains = table_contains
M.common.round = round
M.common.between = between
M.common.lerp = lerp

local scheudled_tasks = {}
local function run_tasks()
	for key, value in pairs(scheudled_tasks) do
		value(key)
	end
end

--initialize our custom api tables and set metatable to pass trough everything we dont know
M.client = setmetatable({}, {__index = function(self, key) return client[key] end})
M.entity = setmetatable({}, {__index = function(self, key) return entity[key] end})
M.globals = setmetatable({}, {__index = function(self, key) return globals[key] end})
M.ui = setmetatable({}, {__index = function(self, key) return ui[key] end})
M.renderer = setmetatable({}, {__index = function(self, key) return renderer[key] end})

--ui reference api
local reference_callbacks = {}
local reference_parameters = {}
local reference_types = {}
local reference_visibility_conditions = {}
local function reference_hook(results, parameters)
	for i=1, #results do
		local reference = results[i]
		reference_parameters[reference] = parameters
	end
end
local function new_element_hook(results, parameters)
	for i=1, #results do
		local reference = results[i]
		--create callbacks table for that reference and a function that executes all callbacks
		reference_callbacks[reference] = {}
		local function callback_function(self)
			local callbacks = reference_callbacks[reference]
			for i=1, #callbacks do
				callbacks[i](self)
			end
		end
		
		ui_set_callback(reference, callback_function)
	end
end
local function type_hook(reference_type)
	return function(results, parameters)
		for i=1, #results do
			local reference = results[i]
			if reference_type ~= nil then
				reference_types[reference] = reference_type
			else
				reference_types[reference] = get_reference_type(reference)
			end
		end
	end
end

local reference_class = {}
function reference_class:get() return ui_get(self) end
function reference_class:set(...) return ui_set(self, ...) end

function reference_class:set_visible(value) return ui_set_visible(self, value) end
function reference_class:is_created()
	return reference_callbacks[self] ~= nil
end
function reference_class:add_callback(callback)
	assert(self:is_created(), "callbacks can only be added to newly created UI elements")
	
	table_insert(reference_callbacks[self], callback)
	return #reference_callbacks[self]
end
function reference_class:clear_callbacks()
	assert(self:is_created(), "callbacks can only be removed from newly created UI elements")
	
	reference_callbacks[self] = {}
end
function reference_class:set_callback(callback)
	assert(self:is_created(), "callbacks can only be added to newly created UI elements")
	
	self:clear_callbacks()
	return self:add_callback(callback)
end
function reference_class:should_be_visible()
	local visible = true
	for i=1, #reference_visibility_conditions[self] do
		local reference, condition_function = unpack(reference_visibility_conditions[self][i])
		if not condition_function(reference:get()) then
			visible = false
		end
	end
	return visible
end
function reference_class:add_visibility_dependency(reference, condition)
	local condition_function = function() return true end
	if condition == nil then
		local reference_type = reference:get_type() or get_reference_type(reference)
		if reference_type == "checkbox" then
			condition_function = function(value)
				return value
			end
		elseif reference_type == "combobox" then
			condition_function = function(value)
				return not (value == "Disabled" or value == "Off" or value == "-")
			end
		elseif reference_type == "multiselect" then
			condition_function = function(value)
				return #value > 0
			end
		end
	elseif type(condition) == "function" then
		condition_function = condition
	elseif type(condition) == table then
		condition_function = function(value)
			return table_contains(condition, value)
		end
	else
		condition_function = function(value)
			return value == condition
		end
	end
	
	if reference_visibility_conditions[self] == nil then
		reference_visibility_conditions[self] = {}
	end
	
	table_insert(reference_visibility_conditions[self], {reference, condition_function})
	
	local function update_visibility()
		self:set_visible(self:should_be_visible())
	end
	
	if reference:is_custom() then
		reference:add_callback(update_visibility)
	else
		if scheudled_tasks["visibility_" .. self] == nil then
			scheudled_tasks["visibility_" .. self] = update_visibility
		end
	end
end
function reference_class:clear_visibility_dependencies()
	reference_visibility_conditions[self] = {}
end
function reference_class:set_visibility_dependency(reference, condition)
	self:clear_visibility_dependencies()
	return self:add_visibility_dependency(reference, condition)
end

function reference_class:get_type()
	return reference_types[self]
end
function reference_class:get_tab()
	assert(reference_parameters[self] ~= nil, "invalid reference")
	
	return reference_parameters[self][1]
end
function reference_class:get_container()
	assert(reference_parameters[self] ~= nil, "invalid reference")
	
	return reference_parameters[self][2]
end
function reference_class:get_name()
	assert(reference_parameters[self] ~= nil, "invalid reference")
	
	return reference_parameters[self][3]
end

M.ui.reference = apply_metatable_function(reference_class, hook_multiple_function(ui_reference, {reference_hook, type_hook}))
M.ui.new_checkbox = apply_metatable_function(reference_class, hook_multiple_function(ui_new_checkbox, {reference_hook, new_element_hook, type_hook("checkbox")}))
M.ui.new_slider = apply_metatable_function(reference_class, hook_multiple_function(ui_new_slider, {reference_hook, new_element_hook, type_hook("slider")}))
M.ui.new_combobox = apply_metatable_function(reference_class, hook_multiple_function(ui_new_combobox, {reference_hook, new_element_hook, type_hook("combobx")}))
M.ui.new_multiselect = apply_metatable_function(reference_class, hook_multiple_function(ui_new_multiselect, {reference_hook, new_element_hook, type_hook("multiselect")}))
M.ui.new_hotkey = apply_metatable_function(reference_class, hook_multiple_function(ui_new_hotkey, {reference_hook, new_element_hook, type_hook("hotkey")}))
M.ui.new_color_picker = apply_metatable_function(reference_class, hook_multiple_function(ui_new_color_picker, {reference_hook, new_element_hook, type_hook("color_picker")}))
M.ui.new_button = apply_metatable_function(reference_class, hook_multiple_function(function(...)
	ui_new_button(...)
	return ui_reference(...)
end, {reference_hook, new_element_hook, type_hook("button")}))

--team metatable
local team_class = {}
local team_mt = {["__index"] = function(self, index) return team_class[index] end}
function team_mt:get_name()
	return "CT"
end
function team_mt:get_full_name()
	return "Counter-Terrorist"
end

local comparisons_mt = {}
comparisons_mt["__call"] = function(self) return self["__value"] end
comparisons_mt["__tostring"] = function(self) return tostring(self()) end
comparisons_mt["__unm"] = function(self) return -self() end
comparisons_mt["__add"] = function(self, second) return self() + replace_objects("__value", second) end
comparisons_mt["__sub"] = function(self, second) return self() - replace_objects("__value", second) end
comparisons_mt["__mul"] = function(self, second) return self() * replace_objects("__value", second) end
comparisons_mt["__div"] = function(self, second) return self() / replace_objects("__value", second) end
comparisons_mt["__mod"] = function(self, second) return self() % replace_objects("__value", second) end
comparisons_mt["__pow"] = function(self, second) return self() ^ replace_objects("__value", second) end
comparisons_mt["__concat"] = function(self, second) return self() .. replace_objects("__value", second) end
comparisons_mt["__eq"] = function(self, second) return self() == replace_objects("__value", second) end
comparisons_mt["__lt"] = function(self, second) return self() < replace_objects("__value", second) end
comparisons_mt["__le"] = function(self, second) return self() <= replace_objects("__value", second) end


--entity metatable
local entity_class = {}
local entity_mt = {["__index"] = function(self, index) return entity_class[index] end}

entity_class["__call"] = function(self) return self["__value"] end
entity_class["__tostring"] = function(self) return tostring(self()) end
entity_class["__unm"] = function(self) return -self() end
entity_class["__add"] = function(self, second) return self() + replace_objects("__value", second) end
entity_class["__sub"] = function(self, second) return self() - replace_objects("__value", second) end
entity_class["__mul"] = function(self, second) return self() * replace_objects("__value", second) end
entity_class["__div"] = function(self, second) return self() / replace_objects("__value", second) end
entity_class["__mod"] = function(self, second) return self() % replace_objects("__value", second) end
entity_class["__pow"] = function(self, second) return self() ^ replace_objects("__value", second) end
entity_class["__concat"] = function(self, second) return self() .. replace_objects("__value", second) end

entity_class["__eq"] = function(self, second) return self() == replace_objects("__value", second) end
entity_class["__lt"] = function(self, second) return self() < replace_objects("__value", second) end
entity_class["__le"] = function(self, second) return self() <= replace_objects("__value", second) end

function entity_class:get_prop(propname, array_index) return entity_get_prop(self, propname, array_index) end
function entity_class:set_prop(propname, value, array_index) return entity_set_prop(self, propname, value, array_index) end
function entity_class:get_classname() return entity_get_classname(self) end
function entity_class:is_player() return self:get_classname() == "CCSPlayer" end
function entity_class:is_alive() return entity_is_alive(self) end
function entity_class:is_enemy() return entity_is_enemy(self) end
function entity_class:get_weapon() return entity_get_player_weapon(self) end
function entity_class:get_steam64() return entity_get_steam64(self) end
function entity_class:get_bounding_box(ctx) return entity_get_bounding_box(ctx, self) end
function entity_class:get_health() return self:get_prop("m_iHealth") end
function entity_class:get_team() return setmetatable(self:get_prop("m_iTeamNum"), team_mt) end
function entity_class:is_teammate() return self:get_team() == entity_get_prop(entity_get_local_player(), "m_iTeamNum") end
function entity_class:get_velocity() return self:get_prop("m_vecVelocity") end
function entity_class:get_flags() return self:get_prop("m_fFlags") end
function entity_class:get_buttons() return self:get_prop("m_nButtons") end
function entity_class:is_flagged(flag) return bit_band(self:get_flags(), flag) == flag end
function entity_class:is_on_ground() return self:is_flagged(FL_ONGROUND) end
function entity_class:is_ducked() return self:get_prop("m_bDucked") == 1 end
function entity_class:is_scoped() return self:get_prop("m_bIsScoped") == 1 end
function entity_class:get_resource_prop(propname) return entity_get_prop(entity_get_all("CCSPlayerResource")[1], propname, self) end
function entity_class:dormant_is_alive() return self:get_resource_prop("m_bAlive") == 1 end
function entity_class:dormant_get_team() return setmetatable(self:get_resource_prop("m_iTeam"), team_mt) end
function entity_class:dormant_is_enemy() return self:dormant_get_team() ~= entity_get_prop(entity_get_local_player(), "m_iTeamNum") end
function entity_class:dormant_is_teammate() return self:dormant_get_team() == entity_get_prop(entity_get_local_player(), "m_iTeamNum") end
function entity_class:is_connected() return self:get_resource_prop("m_bConnected") == 1 end
function entity_class:get_kills() return self:get_resource_prop("m_iKills") end
function entity_class:get_assists() return self:get_resource_prop("m_iAssists") end
function entity_class:get_deaths() return self:get_resource_prop("m_iDeaths") end
function entity_class:get_ping() return self:get_resource_prop("m_iPing") end
function entity_class:hitbox_position(hitbox) return entity_hitbox_position(self, hitbox) end
function entity_class:is_dormant() return entity_is_dormant(self) end
function entity_class:is_local_player() return self == entity_get_local_player() end
function entity_class:has_bomb() return self == entity_get_prop(entity_get_all("CCSPlayerResource")[1], "m_iPlayerC4") end
function entity_class:get_name(sanitize_player_name)
	if self == 0 then
		return "World"
	end
	if self:is_player() then
		local name = entity_get_player_name(self)
		if sanitize_player_name ~= nil and sanitize_player_name then
			--todo
		end
		return name
	end
	
	local iName = self:get_prop("m_iName")
	if iName ~= nil then return iName end
	
	local team_name = self:get_prop("m_szTeamname")
	if team_name ~= nil then return team_name end
	
	return "unknown"
end
function entity_class:get_origin()
	local x, y, z = self:get_prop("m_vecAbsOrigin")
	if x == nil then
		x, y, z = self:get_prop("m_vecOrigin")
	end
	return x, y, z
end
function entity_class:get_view_offset()
	if self:is_local_player() then
		return self:get_prop("m_vecViewOffset")
	elseif self:is_player() then
		--m_vecViewOffset is not always networked for other players, rebuild it based on m_flDuckAmount
		local duck_amount = self:get_prop("m_flDuckAmount")
		return 0, 0, 46 + (1 - duck_amount) * 18
	end
	return 0, 0, 0
end
function entity_class:get_eye_position()
	if self:is_local_player() then
		return client_eye_position()
	else
		local x, y, z = self:get_origin()
		local vo_x, vo_y, vo_z = self:get_view_offset()
		return x + vo_x, y + vo_y, z + vo_z
	end
end
function entity_class:get_weapons()
	local weapons = {}
	for i=0, 64 do
		local weapon = self:get_prop("m_hMyWeapons", i)
		if weapon ~= nil then
			table_insert(weapons, weapon)
		end
	end
	return weapons
end
function entity_class:can_attack()
	local next_attack = math_max(0, self:weapon():get_prop("m_flNextPrimaryAttack") or 0, self:get_prop("m_flNextAttack") or 0)
	return next_attack - globals_curtime() > 0
end

--entity: replace default functions with ones that return entity objects
M.entity.from_entindex = function(entindex) return apply_metatable(entity_mt, entindex) end
M.entity.from_userid = function(userid) return apply_metatable(entity_mt, client_userid_to_entindex(userid)) end
M.entity.get_local_player = apply_metatable_function(entity_mt, entity_get_local_player)
M.entity.get_player_resource = apply_metatable_function(entity_mt, function() return entity_get_all("CCSPlayerResource")[1] end)
M.entity.get_all = apply_metatable_function(entity_mt, entity_get_all)
M.entity.get_players = apply_metatable_function(entity_mt, entity_get_players)
M.entity.get_prop = apply_metatable_function(entity_mt, entity_get_prop)

local entity_from_entindex = M.entity.from_entindex
M.entity.get_dormant_players = function(enemy_only, alive_only)
	local enemy_only = enemy_only ~= nil and enemy_only or false
	local alive_only = alive_only ~= nil and alive_only or true
	local result = {}

	local player_resource = entity_get_all("CCSPlayerResource")[1]
	
	for entindex=1, globals_maxplayers() do
		local player = entity_from_entindex(entindex)
		if player:is_connected() then
			local include = true
			if enemy_only and not player:dormant_is_enemy() then include = false end
			if alive_only and not player:dormant_is_alive() then include = false end
			if include then
				table_insert(result, player)
			end
		end
	end

	return result
end

local entity_get_dormant_players = M.entity.get_dormant_players

M.entity_get_esp_players = function(non_dormant_only, enemy_only)
	local non_dormant_only = non_dormant_only ~= nil and non_dormant_only or true
	local enemy_only = enemy_only ~= nil and enemy_only or true
	
	local players = non_dormant_only and entity_get_players(enemy_only) or entity_get_dormant_players(enemy_only)
	local result = {}
	
	for i=1, #players do
		local player = entity_from_entindex(players[i])
		local include = true
		
		if enemy_only then
			local is_enemy = non_dormant_only and player:is_enemy() or player:dormant_is_enemy()
			if not is_enemy then include = false end
		end
		
		if include then
			table_insert(result, player)
		end
	end
	
	return result
end

--globals
function M.globals.tickrate()
	return 1 / globals_tickinterval()
end
function M.globals.framerate()
end

--client
function M.client.screen_center()
	local w, h = client_screen_size()
	return w/2, h/2
end

---renderer
function M.renderer.indicator_circle(x, y, r, g, b, a, percentage, outline)
  local outline = outline == nil and true or outline
  local radius = 9
  local start_degrees = 0

  -- draw outline
  if outline then
    renderer_circle_outline(ctx, x, y, 0, 0, 0, 200, radius, start_degrees, 1.0, 5)
  end
  -- draw inner circle
  renderer_circle_outline(ctx, x, y, r, g, b, a, radius-1, start_degrees, percentage, 3)
end

--paint event stuff
local paint_metatable = {["__index"] = function(self, index)
	local fn = M.renderer[index] or M.renderer[index:sub(6)]
	if fn == nil then return nil end
	return function(ctx, ...)
		return fn(...)
	end
end}

function M.renderer.bar(x, y, w, h, r, g, b, a, lrt, rev, outline)
	local ltr = ltr ~= nil and ltr or true
	local rev = rev ~= nil and rev or false
	local outline = outline ~= nil and outline or true
	
	if not (outline and (w > 2 and h > 2) or (w > 0 or h > 0)) then
		error("Invalid arguments. Width and/or height too small")
	end
	
	local outline_r, outline_b, outline_g = 16, 16, 16
	local outline_a = 200
	if outline then
		--draw outline using rectangles to prevent weird bug with draw_line
		renderer_rectangle(ctx, x, y, w, 1, outline_r, outline_b, outline_g, outline_a)
		renderer_rectangle(ctx, x, y, 1, h, outline_r, outline_b, outline_g, outline_a)
		
		renderer_rectangle(ctx, x+w, y+1, 1, h-1, outline_r, outline_b, outline_g, outline_a)
		renderer_rectangle(ctx, x+1, y+h, w-1, 1, outline_r, outline_b, outline_g, outline_a)
	end
	
	--todo
end

--aim event stuff
local aim_registered = false
local aim_metatable = {}
local aim_temp = {}

function aim_metatable:get_fire_event()
	return aim_temp[self.id]
end

--general event stuff
local event_userid_elements = {
	"userid",
	"attacker",
	"assister"
}

local m_entity_from_userid = M.entity.from_userid
local m_entity_get_local_player = M.entity.get_local_player

local custom_events = {
	"gq_config_changed",
	"gq_reset",
	"gq_weapon_switched"
}

local event_callbacks = {}
local event_callbacks_event_name = {}

local function run_event_callbacks(event_name, e)
	local callbacks = event_callbacks[event_name]
	if callbacks == nil or callbacks == {} then return end
	
	for key, value in pairs(callbacks) do
		value(e, event_name)
	end
end

M.client.set_event_callback = function(event_name, callback)
	local id = uuid()
	if event_callbacks[event_name] == nil then
		event_callbacks[event_name] = {}
		
		--custom aim event stuff
		local is_aim_event = event_name == "aim_hit" or event_name == "aim_miss"
		if not aim_registered and is_aim_event then
			M.client.set_event_callback("aim_fire", function(e)
				aim_temp[e.id] = e
			end)
			aim_registered = true
		end
		
		if not table_contains(custom_events, event_name) then
			local run_callbacks = function(e)
				local callbacks = event_callbacks[event_name]
				local metatable = {}
				
				if event_name == "paint" then
					metatable = paint_metatable
				elseif is_aim_event then
					metatable = aim_metatable
				elseif event_name == "run_command" then
					if e.send_packet == nil then
						e.send_packet = e.choked_ticks == 0
					end
				else
					--generic event
					if next(e) ~= nil then
						for i=1, #event_userid_elements do
							local key = event_userid_elements[i]
							local value = e[key]
							if value ~= nil then
								local player = m_entity_from_userid(value)
								if player ~= nil then
									metatable[key .. "_player"] = function()
										return player
									end
								end
							end
						end
					end
				end

				if type(e) ~= "table" then
					e = {
						["__value"] = e
					}
				end
				
				setmetatable(e, metatable)
				run_event_callbacks(event_name, e)
			end
			client_set_event_callback(event_name, run_callbacks)
		end
	else
		client_log("[gamesense] Added event handler for ", event_name)
	end
	
	event_callbacks[event_name][id] = callback
	event_callbacks_event_name[id] = event_name
	return setmetatable({["__value"]=id}, {["remove"] = function(self)  end})
end
M.client.remove_event_callback = function(id)
	local event_name = event_callbacks_event_name[id]
	if event_name == nil then return false end
	
	event_callbacks[event_name][id] = nil
	event_callbacks_event_name[id] = nil
	
	client_log("[gamesense] Removed event handler for ", event_name)
	
	return true
end

local forbidden_cvars = {
	"sv_cheats",
	"mat_wireframe",
	"r_drawothermodels",
	"enable_skeleton_draw",
	"r_drawbeams",
	"r_drawbrushmodels",
	"r_drawdetailprops",
	"r_drawstaticprops",
	"r_modelwireframedecal",
	"r_shadowwireframe",
	"r_slowpathwireframe",
	"r_visocclusion",
	"vcollide_wireframe",
	"mp_radar_showall",
	"radarvisdistance",
	"mat_proxy",
	"mat_drawflat",
	"mat_norendering",
	"mat_drawgray",
	"mat_showmiplevels",
	"mat_showlowresimage",
	"mat_measurefillrate",
	"mat_fillrate",
	"mat_reversedepth",
	"fog_override",
	"r_drawentities",
	"r_drawdisp",
	"r_drawfuncdetail",
	"r_drawworld",
	"r_drawmodelstatsoverlay",
	"r_drawopaqueworld",
	"r_drawtranslucentworld",
	"r_drawopaquerenderables",
	"r_drawtranslucentrenderables",
	"mat_normals",
	"sv_allow_thirdperson",
	"sv_pure",
	"cl_pitchup",
	"cl_pitchdown"
}
M.client.set_cvar = function(cvar, value)
	if table_contains(forbidden_cvars, cvar) then
        client.log("A script tried to set forbidden cvar ", cvar, ". self has been prevented.")
        return false
    end
    return previous_client_set_cvar(cvar, value)
end
M.client.get_cvar = function(cvar)
	local result = client_get_cvar(cvar)
	if tonumber(result) ~= nil then return tonumber(result) end
	return result
end
local m_client_set_cvar = M.client.set_cvar
local m_client_get_cvar = M.client.get_cvar

--cvar api
local cvar_class = {}
function cvar_class:get()
	return m_client_get_cvar(self)
end
function cvar_class:set(value)
	return m_client_set_cvar(self, value)
end
function cvar_class:is_safe()
	return not table_contains(forbidden_cvars, cvar)
end
M.client.cvar = function(cvar)
	if client_get_cvar(cvar) == nil then return end
	return setmetatable(cvar, cvar_class)
end

local function escape_chat_message(message, ...)
	local message = message .. table_concat({...})
	message = string_gsub(message, ";", ";") --replace semicolons with greek question mark, prevents command injection while still looking okay-ish in chat.
	return message
end
M.client.escape_chat_message = escape_chat_message

M.client.say = function(message, ...)
	message = escape_chat_message(message, ...)
	client_exec("say ", message)
end
M.client.say_team = function(message, ...)
	message = escape_chat_message(message, ...)
	client_exec("say_team ", message)
end

--some more magic to make everything work

local function task_delay_call()
	run_tasks()
	client_delay_call(0.5, task_delay_call)
end
task_delay_call()

local weapon_prev
local function on_run_command(e)
	run_tasks()
	
	local local_player = m_entity_get_local_player()

	local weapon = local_player:get_weapon()
	if weapon_prev ~= nil and weapon ~= nil and weapon ~= weapon_prev then
		client.log(weapon)
		run_event_callbacks("gq_weapon_switched", {["weapon"]=weapon, ["weapon_prev"]=weapon_prev})
	end
	weapon_prev = weapon
end
client_set_event_callback("run_command", on_run_command)

--end of module
return M
