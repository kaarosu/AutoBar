
-- Separate tables for code and data. Splitting the code off from the data makes it easier to inspect data objects.
-- The names are verbose to reduce likelihood of conflict with another addon


local _
local AB = select(2, ...)

local code = {}	---@class ABCode
AB.code = code

local types = {}	---@class ABTypes
AB.types = types


local print, select, ipairs, tostring, pairs, tonumber, string, next = print, select, ipairs, tostring, pairs, tonumber, string, next

---@diagnostic disable-next-line: assign-type-mismatch
AB.LibKeyBound = LibStub("LibKeyBound-1.0")	---@type LibKeyBound

---@diagnostic disable-next-line: assign-type-mismatch
AB.LibMMStickyFrames = LibStub("LibMMStickyFrames-2.0") ---@type LibMMStickyFrames



AutoBar = {	---@class AutoBar
	warning_log = {},
	inWorld = false,
	inCombat = nil,		-- For item use restrictions
	inBG = false,		-- For battleground only items
	initialized = false,

-- List of Bars for the current user
	barList = {}, ---@type table<string, Bar>

-- List of barKey = barDB (the correct DB to use between char, class or account)
	barButtonsDBList = {},
	barLayoutDBList = {},
	barPositionDBList = {},

	-- List of Bar Names
	barValidateList = {},

-- List of buttonKey = buttonDB (the correct DB to use between char, class or account)
	buttonDBList = {},

-- List of buttonKey for Buttons not currently placed on a Bar
	unplacedButtonList = {},

-- List of buttonName = AutoBarButton
	buttonList = {},

-- List of buttonName = AutoBarButton for disabled buttons
	buttonListDisabled = {},

	visibility_driver_string = "[vehicleui] hide; [petbattle] hide; [possessbar] hide; show",
}

---@param p_table table
---@return boolean
function code.is_table_empty(p_table)
	return next(p_table) == nil
end

---@param p_list table
---@return table
function code.make_set(p_list)
	local set = {}
	for _, l in ipairs(p_list) do set[l] = true end
	return set
end


---@param p_class_name string
---@return boolean
function code.class_uses_mana(p_class_name)

	return AutoBarGlobalDataObject.set_mana_users[p_class_name]

end



-- All global data will be a child of this table
local ver_string, _, _, toc_version = GetBuildInfo()
local is_forever = (toc_version and tonumber(toc_version) >= 16000 and tonumber(toc_version) < 17000) or false

AutoBarGlobalDataObject = {
	TYPE_MACRO_TEXT = 1,
	TYPE_TOY = 2,
	TYPE_BATTLE_PET = 3,

	locale = {},

	timing = {},

	profile = {},

	is_forever_wow = is_forever,
	is_mainline_wow = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE),
	is_vanilla_wow = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC),
	is_bcc_wow = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC),
	is_wrath_wow = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC),
	is_cata_wow = (WOW_PROJECT_ID == (WOW_PROJECT_CATACLYSM_CLASSIC or 14)),
	is_mop_wow = (WOW_PROJECT_ID == (WOW_PROJECT_MISTS_OF_PANDARIA_CLASSIC or 19)),

	default_button_width = 36,
	default_button_height = 36,

}

local api_version_temp = {strsplit(".", ver_string)}
AutoBarGlobalDataObject.API_VERSION = tonumber(api_version_temp[1])
AutoBarGlobalDataObject.API_SUBVERSION = tonumber(api_version_temp[2])

AutoBarGlobalDataObject.MAX_BAG_SLOTS = (Constants and Constants.InventoryConstants and Constants.InventoryConstants.NumBagSlotsPlusReagentBagSlots) or NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4

if(AutoBarGlobalDataObject.API_VERSION >= 10) then	-- Dragonflight+
	AutoBarGlobalDataObject.default_button_width = 45
	AutoBarGlobalDataObject.default_button_height = 45
end


-- List of [spellName] = <GetSpellInfo Name>
AutoBarGlobalDataObject.spell_name_list = {}
-- List of [spellName] = <GetSpellInfo Icon>
AutoBarGlobalDataObject.spell_icon_list = {}
-- List of [spellName] = spell_id
AutoBarGlobalDataObject.spell_id_list = {}

AutoBarGlobalDataObject.set_mana_users = code.make_set{"DRUID", "EVOKER", "HUNTER", "MAGE", "MONK", "PRIEST", "PALADIN", "SHAMAN", "WARLOCK"}

AutoBarGlobalDataObject.TickScheduler =
{
	ResetSearch = 1,
	UpdateCategoriesID = 2,
	UpdateSpellsID = 3,
	UpdateObjectsID = 4,
	UpdateItemsID = 5,
	UpdateAttributesID = 6,
	UpdateActiveID = 7,
	UpdateButtonsID = 8,
	UpdateCompleteID = 9,

	BehaveTicker = 1,	-- Called by the ticker, so you may return the next step to be run rather than doing it immediately

	FullScanItemsFlag = true,

	ScheduledUpdate = nil,

	OtherStickyFrames = {
		"GridLayoutFrame",
		"Grid2LayoutFrame",
		"MicroMenu",
		"MainActionBar",
		"MultiBarBottomLeft",
		"StanceBar",
		"MultiBarBottomRight",
		"MultiBar5",
		"MultiBar6",
		"MultiBar7",
		"MultiBarLeft",
		"MultiBarRight",
	}
}




---@param o any
---@param p_max_depth number|nil
---@return string
function code.Dump(o, p_max_depth)
	local depth = p_max_depth or 5
	if type(o) == 'table' and (depth >= 1)  then
		depth = depth - 1
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then
				k = '"'..k..'"'
			end
			s = s .. '['..k..'] = ' .. code.Dump(v, depth) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end


---@param p_1 any
---@param p_2 any
---@return any
function code.NVL(p_1, p_2)
	if(p_1 ~= nil) then
		return p_1
	end

	return p_2
end

local function table_pack(...)
  return { n = select("#", ...), ... }
end

function code.log_warning(...)

	local message = "";
	local args = table_pack(...)
	for i=1,args.n do
		message = message .. tostring(args[i]) .. " "
	end
	table.insert(AutoBar.warning_log, message)

end

function code.get_warning_log_string()

	return table.concat(AutoBar.warning_log, "\n")

end


---@param p_toy_id number
---@return string
function code.ToyGUID(p_toy_id)

	local l = 7 - string.len(p_toy_id);
	local guid = "toy:" .. string.rep("0", l) .. p_toy_id;

	return guid;
end

local macro_text_guid_index = 0;
-- Generates a sequential GUID string for macro text entries.
-- The macro text itself is not hashed; IDs are assigned in registration order.
function code.MacroTextGUID(_p_macro_text)
	macro_text_guid_index = macro_text_guid_index + 1
	local guid = "macrotext:" .. macro_text_guid_index;
	return guid;
end



-- Called infrequently (on bag/toy updates); memoization not warranted.
function code.GetIconForToyID(p_toy_id)
	local item_id = tonumber(p_toy_id)	-- defensive: callers may pass strings

	if(not item_id) then
		return nil
	end

	local _, _, texture =  C_ToyBox.GetToyInfo(item_id)

	if(texture == nil) then
		texture = code.GetIconForItemID(item_id);
	end

	return texture;
end

-- Called infrequently (on bag/toy updates); memoization not warranted.
-- @param p_item_id number|string  item ID; string inputs are handled by the underlying API.
function code.GetIconForItemID(p_item_id)

	local getItemInfoInstant = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	local ii_texture = getItemInfoInstant and select(5, getItemInfoInstant(p_item_id))
	if ii_texture then
		return ii_texture
	end

	local i_texture = select(10, code.GetItemInfo(p_item_id))
	return i_texture
end

-- Strips dots, quotes, and spaces from a string to produce a valid WoW frame/key name.
function code.GetValidatedName(p_name)
	local name = p_name:gsub("%.", "")
	name = name:gsub("\"", "")
	name = name:gsub(" ", "")
	return name
end


-- IsUsableItem() from the WoW API is unreliable for our purposes; always treat items as usable.
function code.IsUsableItem(p_item_id)
	if(p_item_id == nil) then
		return nil;
	end
	return true;
end

function code.ClearNormalTexture(p_frame)
	if (p_frame.ClearNormalTexture) then
		p_frame:ClearNormalTexture()
	else
		p_frame:SetNormalTexture(nil)
	end
end




---@param p_spell_id number
---@param p_spell_name string
function code.cache_spell_data(p_spell_id, p_spell_name)

	local name, _rank, icon = AB.GetSpellInfo(p_spell_id);

	if (p_spell_id == 120145) then	-- Ancient Dalaran Port TODO: Generalize this
		icon = 628678;
	end

	if (not AutoBarGlobalDataObject.spell_id_list) then
		AutoBarGlobalDataObject.spell_id_list = {}
	end
	if (p_spell_name and p_spell_id) then
		AutoBarGlobalDataObject.spell_id_list[p_spell_name] = p_spell_id
	end

	if (name) then
		AutoBarGlobalDataObject.spell_name_list[p_spell_name] = name;
		AutoBarGlobalDataObject.spell_icon_list[p_spell_name] = icon;
	else
		if (not AutoBarGlobalDataObject.spell_name_list[p_spell_name]) then
			AutoBarGlobalDataObject.spell_name_list[p_spell_name] = p_spell_name
		end
	end
end

function code.get_spell_name_by_name(p_spell_name)

	if (AutoBarGlobalDataObject.spell_name_list[p_spell_name]) then
		return AutoBarGlobalDataObject.spell_name_list[p_spell_name]
	end

	return p_spell_name
end

function code.get_spell_icon_by_name(p_spell_name)

	if (AutoBarGlobalDataObject.spell_icon_list[p_spell_name]) then
		return AutoBarGlobalDataObject.spell_icon_list[p_spell_name]
	end

	return nil
end

function code.get_spell_icon_by_name_fast(p_spell_name)

	return AutoBarGlobalDataObject.spell_icon_list[p_spell_name]

end

function code.add_profile_data(p_name, p_time)
	local prof = AutoBarGlobalDataObject.profile

	if(prof[p_name] == nil) then
		prof[p_name] = {}
		prof[p_name].calls = 0;
		prof[p_name].total_time = 0;
		prof[p_name].avg_time = 0;
		prof[p_name].min_time = 99999;
		prof[p_name].max_time = 0;
	end

	prof[p_name].calls = prof[p_name].calls + 1;
	prof[p_name].total_time = prof[p_name].total_time + p_time;
	if(prof[p_name].min_time > p_time) then
		prof[p_name].min_time = p_time;
	end;
	if(prof[p_name].max_time < p_time) then
		prof[p_name].max_time = p_time;
	end;
	prof[p_name].avg_time = prof[p_name].total_time / prof[p_name].calls

end

function code.GetItemCount(p_item_info, p_include_bank, p_include_uses, p_include_reagent_bank)

	local item_id = tonumber(p_item_info)
	if (not item_id) then
		return 0
	elseif (C_Item and C_Item.GetItemCount) then
		return C_Item.GetItemCount(item_id, p_include_bank, p_include_uses, p_include_reagent_bank) or 0
	else
		return GetItemCount(item_id, p_include_bank, p_include_uses, p_include_reagent_bank) or 0
	end

end


function code.GetLogIndexForQuestID(p_quest_id)

	if (C_QuestLog and C_QuestLog.GetLogIndexForQuestID) then
		return C_QuestLog.GetLogIndexForQuestID(p_quest_id)
	else
		return GetQuestLogIndexByID(p_quest_id)
	end
end

--C_QuestLog.GetLogIndexForQuestID
function AB.GetNumQuestLogEntries()

	if (C_QuestLog and C_QuestLog.GetNumQuestLogEntries) then
		return C_QuestLog.GetNumQuestLogEntries()
	else
		return GetNumQuestLogEntries()
	end
end

-- Return the interface display name
function AB.GetButtonDisplayName(p_button_db)
	local name

	if (p_button_db.name) then
		name = tostring(p_button_db.name)
	else
		local L = AutoBarGlobalDataObject.locale
		name = L[p_button_db.buttonKey] or L["Custom"]
	end
	return name
end


local logItems = {}	-- n = startTime
local logMemory = {}	-- n = startMemory
local event_name_colour = "|cFFFFFF7F"

function AB.LogEvent(p_event_name, p_arg1)
	local memory
	if (AutoBarDB2.settings.log_memory) then
		UpdateAddOnMemoryUsage()
		memory = GetAddOnMemoryUsage("AutoBar")
		print(p_event_name, "memory" , memory)
	end
	if (AutoBarDB2.settings.log_events) then
		if (p_arg1) then
			memory = memory or ""
			print(event_name_colour .. p_event_name .. "|r", "arg1" , p_arg1, "time:", GetTime(), memory)
		else
			print(event_name_colour .. p_event_name .. "|r", "time:", GetTime())
		end
	end
end


---@param p_event_name string
function AB.LogEventStart(p_event_name)
	local memory

	if (AutoBarDB2.settings.log_memory) then
		UpdateAddOnMemoryUsage()
		memory = GetAddOnMemoryUsage("AutoBar")
		logMemory[p_event_name] = memory
	end

	if (AutoBarDB2.settings.performance) then
		if (logItems[p_event_name]) then
			--print(p_event_name, "restarted before previous completion")
		else
			logItems[p_event_name] = debugprofilestop()
			--print(p_event_name, "started time:", logItems[p_event_name])
		end
	end

	if (AutoBarDB2.settings.log_events) then
			memory = memory or ""
			print(event_name_colour .. p_event_name .. "|r", "time:", debugprofilestop(), memory)
	end
end

function AB.LogEventEnd(p_event_name, ...)
	if (AutoBarDB2.settings.performance) then
		if (logItems[p_event_name]) then
			local elapsed = debugprofilestop() - logItems[p_event_name]
			-- if (p_event_name == "SPELLS_CHANGED") then
			-- 	print(p_event_name, p_arg1, elapsed, "=", debugprofilestop(), " - ", logItems[p_event_name])
			-- end
			if (elapsed > AutoBarDB2.settings.performance_threshold) then
				local args = {...}
				print(event_name_colour .. p_event_name .. "|r", (args or ""), "time:", elapsed)
			end
		--else
			--print(p_event_name, "restarted before previous completion")
			logItems[p_event_name] = nil
		end
	end
	if (AutoBarDB2.settings.log_memory) then
		UpdateAddOnMemoryUsage()
		local memory = GetAddOnMemoryUsage("AutoBar")
		local deltaMemory = memory - (logMemory[p_event_name] or 0)
		print(p_event_name, "memory" , deltaMemory)
		logMemory[p_event_name] = nil
	end
end

function AB.GetCategoryDB(p_category_key)
	return AutoBarDB2.custom_categories[p_category_key]
end

function AB.GetCategoryItemDB(p_category_key, p_item_index)
	return AutoBarDB2.custom_categories[p_category_key].items[p_item_index]
end

function code.SetDifference(p_set1, p_set2)
	if(p_set1 == nil) then return {} end;
	if(p_set2 == nil) then return p_set1 end;

	local s = {}
	for e in pairs(p_set1) do
		if not p_set2[e] then s[tostring(e)] = true end
	end
	return s
end


-- tcount: count table members even if they're not indexed by numbers
function code.tcount(p_table)

	if(p_table == nil) then return nil; end

	local n = #p_table
	if (n == 0) then
		for _k in pairs(p_table) do
			n = n + 1;
		end
	end
	return n
end




-- Support multiple API versions

AB.GetSpellInfo = function (p_identifier)
	local identifier = p_identifier
	if type(identifier) == "string" and AutoBarGlobalDataObject.spell_id_list and AutoBarGlobalDataObject.spell_id_list[identifier] then
		identifier = AutoBarGlobalDataObject.spell_id_list[identifier]
	end

	if C_Spell and C_Spell.GetSpellInfo then
		local si = C_Spell.GetSpellInfo(identifier)
		if (not si and identifier ~= p_identifier) then
			si = C_Spell.GetSpellInfo(p_identifier)
		end
		if(not si) then
			return nil
		end
		return si.name, nil, si.iconID, si.castTime, si.minRange, si.maxRange, si.spellID
	elseif GetSpellInfo then
		local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(identifier)
		if (not name and identifier ~= p_identifier) then
			name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(p_identifier)
		end
		return name, rank, icon, castTime, minRange, maxRange, spellID
	end
	return nil
end

local function GetSpellCooldown_hack(p_identifier)
	if C_Spell and C_Spell.GetSpellCooldown then
		local sc = C_Spell.GetSpellCooldown(p_identifier)
		if(not sc) then
			return nil
		end
		return sc.startTime, sc.duration, sc.isEnabled, sc.modRate
	elseif GetSpellCooldown then
		return GetSpellCooldown(p_identifier)
	end
	return nil
end
AB.GetSpellCooldown = (C_Spell and C_Spell.GetSpellCooldown and GetSpellCooldown_hack) or GetSpellCooldown	---@diagnostic disable-line: deprecated

AB.GetItemCooldown = (C_Container and C_Container.GetItemCooldown) or GetItemCooldown	---@diagnostic disable-line: deprecated

AB.GetSpellCastCount = function(spellIdentifier)
	if C_Spell and C_Spell.GetSpellCastCount then
		return C_Spell.GetSpellCastCount(spellIdentifier) or 0
	elseif GetSpellCount then
		return GetSpellCount(spellIdentifier) or 0
	end
	return 0
end

AB.IsSpellUsable = function(spellIdentifier)
	if C_Spell and C_Spell.IsSpellUsable then
		return C_Spell.IsSpellUsable(spellIdentifier)
	elseif IsUsableSpell then
		return IsUsableSpell(spellIdentifier)
	end
	return true, false
end

code.GetSpellTexture = (C_Spell and C_Spell.GetSpellTexture) or GetSpellTexture	---@diagnostic disable-line: deprecated

AB.SetCooldown = function(cooldownFrame, spellIdentifier, fallbackStart, fallbackDuration, fallbackEnabled)
	if C_Spell and C_Spell.GetSpellCooldownDuration and cooldownFrame.SetCooldownFromDurationObject then
		local durationObj = C_Spell.GetSpellCooldownDuration(spellIdentifier)
		if durationObj then
			cooldownFrame:SetCooldownFromDurationObject(durationObj)
			return
		end
	end
	CooldownFrame_Set(cooldownFrame, fallbackStart or 0, fallbackDuration or 0, fallbackEnabled or 0)
end

AB.GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
AB.GetContainerItemID = (C_Container and C_Container.GetContainerItemID) or GetContainerItemID
AB.GetContainerItemLink = (C_Container and C_Container.GetContainerItemLink) or GetContainerItemLink

AB.GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata

AB.GetItemSpell = (C_Item and C_Item.GetItemSpell) or GetItemSpell	---@diagnostic disable-line: deprecated

AB.ItemHasRange = (C_Item and C_Item.ItemHasRange) or ItemHasRange
AB.SpellHasRange = (C_Spell and C_Spell.SpellHasRange) or SpellHasRange
AB.IsItemInRange = (C_Item and C_Item.IsItemInRange) or IsItemInRange
AB.IsSpellInRange = (C_Spell and C_Spell.IsSpellInRange) or IsSpellInRange

AB.GetSpellTabInfo = function(index)
	if C_SpellBook and C_SpellBook.GetSpellBookSkillLineInfo then
		local info = C_SpellBook.GetSpellBookSkillLineInfo(index)
		if info then
			return info.name, info.iconID, info.itemIndexOffset, info.numSpellBookItems, info.isGuild, info.offSpecID
		end
		return nil
	end
	return GetSpellTabInfo(index)
end

AB.GetSpellBookItemName = function(index, bookType)
	if C_SpellBook and C_SpellBook.GetSpellBookItemName then
		if type(bookType) == "string" then
			bookType = bookType == "spell" and Enum.SpellBookSpellBank.Player or Enum.SpellBookSpellBank.Pet
		end
		return C_SpellBook.GetSpellBookItemName(index, bookType)
	end
	return GetSpellBookItemName(index, bookType)
end

AB.GetContainerItemInfo = function(bag, slot)
	if C_Container and C_Container.GetContainerItemInfo then
		local info = C_Container.GetContainerItemInfo(bag, slot)
		if info then
			return info.iconFileID, info.itemCount, info.isLocked, info.quality, info.isReadable, info.hasLoot, info.hyperlink, info.isFiltered, info.hasNoValue, info.itemID, info.isBound
		end
		return nil
	end
	if GetContainerItemInfo then
		return GetContainerItemInfo(bag, slot)
	end
	return nil
end

AB.PickupContainerItem = (C_Container and C_Container.PickupContainerItem) or PickupContainerItem

AB.PickupSpellBookItem = function(spellNameOrId)
	if C_SpellBook and C_SpellBook.PickupSpellBookItem then
		local name, _, _, _, _, _, spellID = AB.GetSpellInfo(spellNameOrId)
		if spellID then
			PickupSpell(spellID)
		end
	else
		PickupSpellBookItem(spellNameOrId)
	end
end

if (AutoBarGlobalDataObject.is_mainline_wow) then
-------------------------------------------------------------------
--
-- WoW Retail
--
-------------------------------------------------------------------

	AutoBarGlobalDataObject.is_toy_usable_cache = {}
	AutoBarGlobalDataObject.mount_data_cache_by_id = {}

	function AB.EraseMountInfoCache()
		wipe(AutoBarGlobalDataObject.mount_data_cache_by_id)
	end

	function AB.GetMountInfoByID(p_id)
		local mdc = AutoBarGlobalDataObject.mount_data_cache_by_id
		if (mdc[p_id] == nil or mdc[p_id].is_usable == nil) then
			local name, spell_id, icon, _active, is_usable, _src, is_favourite, _faction_specific, faction_id, _is_hidden, is_collected, _mount_id =
						 C_MountJournal.GetMountInfoByID(p_id)
			local data = mdc[p_id] or {}
			data.name = name
			data.spell_id = spell_id
			data.icon = icon
			data.is_favourite = is_favourite
			data.is_collected = is_collected
			data.faction_id = faction_id
			data.is_usable = is_usable

			mdc[p_id] = data;
		end
		return mdc[p_id]
	end

	--This should query a global guid registry and then the specific ones if not found.
	function AB.InfoFromGUID(p_guid)	---@diagnostic disable-line: duplicate-set-field
		return AutoBarSearch.registered_macro_text[p_guid] or AutoBarSearch.registered_toys[p_guid];
	end

	do
		local cache   = AutoBarGlobalDataObject.is_toy_usable_cache
		local IsUsable = C_ToyBox and C_ToyBox.IsToyUsable

		--Once we get a non-nil result, that's what we'll use for the rest of the session
		function AB.IsToyUsable(p_item_id)

			local cached = cache[p_item_id]
			if(cached ~= nil) then
				return cached
			end

			local usable = IsUsable(p_item_id)
			if usable == nil then
				return nil
			end

			cache[p_item_id] = usable

			return usable
		end

	end --do


-------------------------------------------------------------------
--
-- WoW Classic
--
-------------------------------------------------------------------

else

	function AB.InfoFromGUID(p_guid)	---@diagnostic disable-line: duplicate-set-field
		return AutoBarSearch.registered_macro_text[p_guid];
	end

end

--#region PlayerHasToy deprecation/wrapper

local function PlayerHasToy_wrapper(p_item_id)
	local phtc = AutoBarDB2.player_has_toy_cache
	if(phtc[p_item_id] == true) then
		return true
	end
	phtc[p_item_id] = PlayerHasToy(p_item_id) or nil;	--Don't store a bunch of falses
	return phtc[p_item_id]
end

if PlayerHasToy then
	AB.PlayerHasToy = PlayerHasToy_wrapper
else
	AB.PlayerHasToy = function (_p_item) return false; end
end
--#endregion PlayerHasToy deprecation/wrapper


code.GetSpellLink = (C_Spell and C_Spell.GetSpellLink) or GetSpellLink



--#region GetItemInfo deprecation
code.GetItemInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
--#endregion GetItemInfo deprecation