--
-- AutoBarClassBar
-- Copyright 2007+ Toadkiller of Proudmoore.
-- A lot of code borrowed from Bartender3
--
-- Layout Bars for AutoBar
-- Layout Bars logically organize similar buttons and provide for layout options for the Bar and its Buttons
-- Sticky dragging is provided as well
-- http://muffinmangames.com
--

--GLOBALS: UIParent, CreateFrame, GameFontNormal, RegisterStateDriver, UnregisterStateDriver, InCombatLockdown, IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown
local _
local AB = select(2, ...)

local types = AB.types	---@class ABTypes
local code = AB.code	---@class ABCode

local AutoBar = AutoBar
local ABGData = AutoBarGlobalDataObject

local _G = _G
local L = AutoBarGlobalDataObject.locale
local Masque = LibStub("Masque", true)

local assert, ipairs, print, pairs, math = assert, ipairs, print, pairs, math


if (not AutoBar.Class) then
	AutoBar.Class = {}
end

--local function onReceiveDragFunc(bar)
--	local toObject = bar.class
----print("onReceiveDragFunc " .. tostring(toObject.barKey) .. " arg1 " .. tostring(arg1) .. " arg2 " .. tostring(arg2))
--	toObject:DropObject()
--end

local FADEOUT_UPDATE_TIME = 0.1
local function onUpdateFunc(button, elapsed)
	local self = button.class
--print("onUpdateFunc " .. tostring(self.barName) .. " elapsed " .. tostring(elapsed) .. " self.elapsed " .. tostring(self.elapsed))
	self.elapsed = self.elapsed + elapsed
	if (self.fadeOutDelay) then
		if (self.elapsed < self.fadeOutDelay) then
			return
		else
			self.elapsed = self.elapsed - self.fadeOutDelay
			self.fadeOutDelay = nil
		end
	end
	if (self.elapsed > FADEOUT_UPDATE_TIME) then
		self:UpdateFadeOut(self.elapsed)
		self.elapsed = 0
	end
end


-- Basic Bar that can do the classic AutoBar layout grid
-- Provides snapto when dragging bars
AB.bar = {}
local Bar = AB.bar ---@class Bar

-- Handle dragging of items, macros, spells to the button
-- Handle rearranging of buttons when buttonLock is off
function Bar:DropObject()
	local fromObject = AutoBar:GetDraggingObject()
--print("Bar:DropObject " .. tostring(fromObject and fromObject.buttonDB.buttonKey or "none") .. " --> " .. tostring(toObject.buttonDB.buttonKey))
	if (fromObject and AutoBar.moveButtonsMode) then
		local targetButton = # self.buttonList + 1
		AutoBar:ButtonMove(fromObject.parentBar.barKey, fromObject.order, self.barKey, targetButton)
		AutoBar:BarButtonChanged()
		fromObject:UpdateButton()
	end
	AutoBar:SetDraggingObject(nil)
end

---@param p_bar_key string
---@return Bar
function Bar:new(p_bar_key)

	local obj = CreateFromMixins(self)
	obj:init(p_bar_key)

	return obj
end

function Bar:init(p_bar_key)

	self.barKey = p_bar_key
	self:UpdateShared()
	if (not L[p_bar_key]) then
		L[p_bar_key] = self.sharedLayoutDB.name
	end
	self.barName = L[p_bar_key]
--	if self.statebar and self.id == 1 then self.mainbar = true end

	self:CreateBarFrame()
	self:CreateDragFrame()

	self.buttonList = {}		-- Button by index
	self.activeButtonList = {}	-- Button by index, non-empty & enabled ones only
	self.layoutDirty = true
	self:UpdateObjects()
end

--/script print(tostring(AutoBar.barList["AutoBarClassBarExtras"].frame:GetAttribute("state")))
--/script print(tostring(AutoBar.buttonList["AutoBarButtonFishing"].frame:GetAttribute("state")))


function Bar:SkinChanged(SkinID, Gloss, Backdrop, barKey, buttonKey, Colors)
	if (buttonKey) then
		local buttonDB = AutoBar.buttonDBList[buttonKey]
		buttonDB.SkinID = SkinID
		buttonDB.Gloss = Gloss
		buttonDB.Backdrop = Backdrop
		buttonDB.Colors = Colors
	elseif (barKey) then
		local barLayoutDB = AutoBar.barLayoutDBList[barKey]
		barLayoutDB.SkinID = SkinID
		barLayoutDB.Gloss = Gloss
		barLayoutDB.Backdrop = Backdrop
		barLayoutDB.Colors = Colors
	else
--print("Bar:SkinChanged SkinID " .. tostring(SkinID) .. " barKey " .. tostring(barKey) .. " buttonKey " .. tostring(buttonKey))
		AutoBarDB2.skin.SkinID = SkinID
		AutoBarDB2.skin.Gloss = Gloss
		AutoBarDB2.skin.Backdrop = Backdrop
		AutoBarDB2.skin.Colors = Colors
	end
end

function Bar:CreateBarFrame()
	local name = self.barKey .. "Driver"
	local driver_template = "SecureHandlerStateTemplate"
	if (BackdropTemplateMixin) then
		driver_template = "SecureHandlerStateTemplate, BackdropTemplate"
	end
	---@type Button
	local driver = CreateFrame("Button", name, UIParent, driver_template)  ---@diagnostic disable-line: assign-type-mismatch
	driver.class = self
	driver:SetClampedToScreen(AutoBarDB2.settings.clamp_bars_to_screen)
	driver:EnableMouse(false)
	driver:SetMovable(true)
	driver:RegisterForDrag("LeftButton")
	driver:RegisterForClicks("RightButtonDown", "LeftButtonUp")
	driver:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},})
	driver:SetBackdropColor(0, 1, 1, 0)
	driver:ClearAllPoints()
	driver:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	driver.text = driver:CreateFontString(nil, "ARTWORK")
	driver.text:SetFontObject(GameFontNormal)
	driver.text:SetText()
	driver.text:Show()
	driver.text:ClearAllPoints()
	driver.text:SetPoint("CENTER", driver, "CENTER", 0, 0)
	if (self.sharedLayoutDB.hide) then
		driver:Hide()
	else
		driver:Show()
	end
	self.frame = driver

	AB.LibMMStickyFrames:RegisterFrame(self.frame)

	self.elapsed = 0
	self.frame:SetAlpha(self.sharedLayoutDB.alpha or 1)
	if (self:IsFadeOut()) then
		self:CreateFadeFrame()
	end

	if (Masque) then
		local group = Masque:Group("AutoBar", self.barKey) ---@class MasqueGroup
		driver.MasqueGroup = group
		group.SkinID = self.sharedLayoutDB.SkinID or "Blizzard"
		group.Backdrop = self.sharedLayoutDB.Backdrop
		group.Gloss = self.sharedLayoutDB.Gloss
		group.Colors = self.sharedLayoutDB.Colors or {}
	end
end
-- /dump LibStub("Masque",true):ListSkins()
-- /dump LibStub("Masque",true):ListAddons()
-- /dump LibStub("Masque",true):ListGroups("AutoBar")
-- /dump LibStub("Masque",true):ListButtons("AutoBar", "AutoBarClassBarBasic")

-- Refresh the Bar
-- New buttons are added, unused ones removed
function Bar:UpdateShared()
	self.sharedLayoutDB = AutoBar.barLayoutDBList[self.barKey]
	self.sharedButtonDB = AutoBar.barButtonsDBList[self.barKey]
	self.sharedPositionDB = AutoBar.barPositionDBList[self.barKey]
	assert(self.sharedLayoutDB, "nil sharedLayoutDB " .. self.barKey)
	assert(self.sharedButtonDB, "nil sharedButtonDB " .. self.barKey)
	assert(self.sharedPositionDB, "nil sharedPositionDB " .. self.barKey)
end

-- Apply the new skin
function Bar:UpdateSkin(SkinID)
	if (Masque) then
		local group = self.frame.MasqueGroup
		group.SkinID = SkinID
		group:Skin(group.SkinID, group.Backdrop, group.Gloss, group.Colors)
--print("Bar:UpdateSkin SkinID " .. tostring(group.SkinID))
	end
end

-- Refresh the Bar
-- New buttons are added, unused ones removed
function Bar:UpdateObjects()
	local buttonList = self.buttonList
	local buttonKeyList = self.sharedButtonDB.buttonKeys
	local buttonDB

	assert(buttonList)
	assert(buttonKeyList)

	-- Create or Refresh the Bar's Buttons
	for buttonKeyIndex, buttonKey in ipairs(buttonKeyList) do

		local debug = false --(buttonKey == "AutoBarButtonMount")
		buttonDB = AutoBar.buttonDBList[buttonKey]
		if (not buttonDB) then
			buttonKeyList[buttonKeyIndex] = nil
		elseif (buttonDB.enabled) then
			-- Recover from disabled cache
			assert(buttonDB.buttonKey == buttonKey, "Bar:UpdateObjects mismatched keys")
			if (AutoBar.buttonListDisabled[buttonKey]) then
				AutoBar.buttonList[buttonKey] = AutoBar.buttonListDisabled[buttonKey]
				AutoBar.buttonListDisabled[buttonKey] = nil
				buttonDB.is_dirty = true
				ABGData.TickScheduler.FullScanItemsFlag = true
				if(debug) then code.log_warning("Bar:UpdateObjects Thaw " .. tostring(buttonKey) .. " <-- buttonListDisabled") end
			end

			if (AutoBar.buttonList[buttonKey]) then
				buttonList[buttonKeyIndex] = AutoBar.buttonList[buttonKey]
				buttonList[buttonKeyIndex]:Refresh(self, buttonDB)
				if(debug) then code.log_warning("Bar:UpdateObjects existing buttonKeyIndex " .. tostring(buttonKeyIndex) .. " buttonKey " .. tostring(buttonKey)) end
			else
				assert(buttonKeyIndex)
				assert(buttonDB)
				assert(buttonDB.buttonClass)
				if (AutoBar.Class[buttonDB.buttonClass]) then
					buttonList[buttonKeyIndex] = AutoBar.Class[buttonDB.buttonClass]:new(self, buttonDB)
					AutoBar.buttonList[buttonKey] = buttonList[buttonKeyIndex]
					if(debug) then code.log_warning("Bar:UpdateObjects new buttonKeyIndex " .. tostring(buttonKeyIndex) .. " buttonKey " .. tostring(buttonKey)) end
				else
					code.log_warning("AutoBar.Class[" .. tostring(buttonDB.buttonClass) .. "] not found for buttonKey " .. tostring(buttonKey))
				end
			end
			if (buttonList[buttonKeyIndex]) then
				buttonList[buttonKeyIndex].order = buttonKeyIndex
			end
		else
			if(debug) then code.log_warning("Bar:UpdateObjects Disabled " .. tostring(buttonKey) .. " --> buttonListDisabled ?") end
			-- Move to disabled cache
			if (AutoBar.buttonList[buttonKey]) then
				buttonList[buttonKeyIndex] = AutoBar.buttonList[buttonKey]
				buttonList[buttonKeyIndex]:Refresh(self, buttonDB)
				AutoBar.buttonListDisabled[buttonKey] = AutoBar.buttonList[buttonKey]
				AutoBar.buttonList[buttonKey] = nil
				if(debug) then code.log_warning("Bar:UpdateObjects Freeze " .. tostring(buttonKey) .. " --> buttonListDisabled") end
			elseif (AutoBar.buttonListDisabled[buttonKey]) then
				buttonList[buttonKeyIndex] = AutoBar.buttonListDisabled[buttonKey]
			else
				if (AutoBar.Class[buttonDB.buttonClass]) then
					buttonList[buttonKeyIndex] = AutoBar.Class[buttonDB.buttonClass]:new(self, buttonDB)
					AutoBar.buttonListDisabled[buttonKey] = buttonList[buttonKeyIndex]
				else
					code.log_warning("AutoBar.Class[" .. tostring(buttonDB.buttonClass) .. "] not found for disabled buttonKey " .. tostring(buttonKey))
				end
			end
		end
	end

	-- Trim Excess
	for buttonIndex = # buttonList, # buttonKeyList + 1, -1 do
		buttonList[buttonIndex] = nil
	end

end
--/dump AutoBar.buttonList["AutoBarCustomButtonCustoXyXz"]
--/dump AutoBar.buttonList["AutoBarButtonBandages"]
--/dump AutoBar.buttonList["CustomButton28"]:IsActive()
--/dump AutoBar.buttonListDisabled["CustomButton30"]:IsActive()
--/script AutoBar.buttonListDisabled["CustomButton30"].frame:Show()
--/dump AutoBar.barList["AutoBarClassBarExtras"].buttonList[2].buttonDB.buttonKey
--/dump AutoBar.barList["AutoBarClassBarExtras"].buttonList[2]:IsActive()
--/dump # AutoBar.barList["AutoBarClassBarExtras"].activeButtonList
--/dump AutoBar.barList["AutoBarClassBarDruid"].buttonList
--/script AutoBar.barList["AutoBarClassBarBasic"]:UpdateActive()
--/dump (# AutoBar.barList["AutoBarClassBarBasic"].activeButtonList)
--/dump (# AutoBar.barList["AutoBarClassBarBasic"].buttonList)
--/dump (# AutoBar.buttonList)
--/dump (# AutoBar.buttonListDisabled)


-- Based on the current Scan results, update the Button and Popup Attributes
-- Create Popup Buttons as needed
function Bar:UpdateAttributes()
	local buttonList = self.buttonList

	-- Create or Refresh the Bar's Buttons
	for _, button in ipairs(buttonList) do
		button:SetupButton()
	end
end


-- The activeButtonList contains only active buttons.  Make it so.
function Bar:UpdateActive()
	local activeButtonList = self.activeButtonList
	local maxButtons = # self.buttonList
	local activeIndex = 1
	local maxActiveButtons = self.sharedLayoutDB.rows * self.sharedLayoutDB.columns
	local changed = false

	--print("Bar:UpdateActive maxButtons " .. tostring(maxButtons))
	for index = 1, maxButtons, 1 do
		local button = self.buttonList[index]
		if (button and button:IsActive()) then
			--if (button.buttonName == "AutoBarButtonCharge") then print("AB.Class.Bar.proto:UpdateActive Active ", activeIndex, button.buttonName, button:IsActive()) end;
			if (activeButtonList[activeIndex] ~= button) then
				changed = true
			end
			activeButtonList[activeIndex] = button
			activeIndex = activeIndex + 1
			if (button.SecureStateDriverRegistered == false) then
				RegisterStateDriver(button.frame, "visibility", AutoBar.visibility_driver_string)
				button.SecureStateDriverRegistered = true
			end

			if (not button.frame:IsShown()) then
				button.frame:Show()
			end
		elseif (button) then
			--if (button.buttonName == "AutoBarButtonCharge") then print("Bar:UpdateActive Inactive " .. tostring(index) .. " " .. tostring(button.buttonName)) end
			if (button.SecureStateDriverRegistered ~= false) then
				UnregisterStateDriver(button.frame, "visibility")
				button.SecureStateDriverRegistered = false
			end

			if (button.frame:IsShown()) then
				button.frame:Hide()
			end
		end
	end

	-- Ditch buttons in excess of rows * columns
	if ((activeIndex - 1) > maxActiveButtons and not AutoBar.moveButtonsMode) then
		--print("Bar:UpdateActive activeIndex " .. tostring(activeIndex - 1) .. " maxActiveButtons " .. tostring(maxActiveButtons) .. " = rows " .. tostring(self.sharedLayoutDB.rows) .. " columns " .. tostring(self.sharedLayoutDB.columns))
		activeIndex = maxActiveButtons + 1
	end

	-- Trim Excess
	if (#activeButtonList >= activeIndex) then
		changed = true
	end
	for i = activeIndex, # activeButtonList, 1 do
		local button = activeButtonList[i]
		button:Disable()
		activeButtonList[i] = nil
	end

	return changed
end
-- /dump AutoBar.buttonListDisabled
-- /dump (# AutoBar.buttonList)
-- /dump (# AutoBar.barList["AutoBarClassBarBasic"].buttonList)
-- /dump AutoBar.barList["AutoBarClassBarBasic"].buttonList[6]
-- /dump AutoBar.barList["AutoBarClassBarBasic"].activeButtonList[2].frame.popupHeader:GetAttribute("state")
-- /script AutoBar.barList["AutoBarClassBarBasic"].activeButtonList[4].frame:SetChecked(1)


function Bar:IsFadeOut()
	return not not (self.sharedLayoutDB.fadeOut or (AutoBarDB2 and AutoBarDB2.settings and AutoBarDB2.settings.fade_out))
end

-- Returns true if the mouse cursor is currently over any visible button in this bar.
-- The bar's driver frame has EnableMouse(false), so frame:IsMouseOver() is always false;
-- we must check the individual mouse-enabled button frames instead.
local function isMouseOverBar(self)
	if (self.frame and self.frame:IsShown() and self.frame:IsMouseOver()) then
		return true
	end
	for _, button in pairs(self.activeButtonList) do
		if (button.frame and button.frame:IsShown() and button.frame:IsMouseOver()) then
			return true
		end
	end
	return false
end

function Bar:UpdateFadeOut()
	if (self:IsFadeOut()) then
		local cancelInCombat = (self.sharedLayoutDB.fadeOutCancelInCombat ~= nil) and self.sharedLayoutDB.fadeOutCancelInCombat or (AutoBarDB2 and AutoBarDB2.settings and AutoBarDB2.settings.fadeOutCancelInCombat)
		local cancelOnShift = (self.sharedLayoutDB.fadeOutCancelOnShift ~= nil) and self.sharedLayoutDB.fadeOutCancelOnShift or (AutoBarDB2 and AutoBarDB2.settings and AutoBarDB2.settings.fadeOutCancelOnShift)
		local cancelOnCtrl = (self.sharedLayoutDB.fadeOutCancelOnCtrl ~= nil) and self.sharedLayoutDB.fadeOutCancelOnCtrl or (AutoBarDB2 and AutoBarDB2.settings and AutoBarDB2.settings.fadeOutCancelOnCtrl)
		local cancelOnAlt = (self.sharedLayoutDB.fadeOutCancelOnAlt ~= nil) and self.sharedLayoutDB.fadeOutCancelOnAlt or (AutoBarDB2 and AutoBarDB2.settings and AutoBarDB2.settings.fadeOutCancelOnAlt)
		local fadeOutAlpha = self.sharedLayoutDB.fadeOutAlpha or (AutoBarDB2 and AutoBarDB2.settings and AutoBarDB2.settings.fadeOutAlpha) or 0
		local fadeOutTime = self.sharedLayoutDB.fadeOutTime or (AutoBarDB2 and AutoBarDB2.settings and AutoBarDB2.settings.fadeOutTime) or 10
		local fadeOutDelay = self.sharedLayoutDB.fadeOutDelay or (AutoBarDB2 and AutoBarDB2.settings and AutoBarDB2.settings.fadeOutDelay) or 0

		local cancelFade = (InCombatLockdown() and cancelInCombat)
			or isMouseOverBar(self)
			or (IsShiftKeyDown() and cancelOnShift)
			or (IsControlKeyDown() and cancelOnCtrl)
			or (IsAltKeyDown() and cancelOnAlt)
		for _, button in pairs(self.activeButtonList) do
			-- A popup being open counts as hovering
			if (button.frame and button.frame.popupHeader and button.frame.popupHeader:IsVisible()) then
				cancelFade = true
				break
			end
		end
		if (cancelFade) then
			self.frame:SetAlpha(self.sharedLayoutDB.alpha or 1)
			self.faded = nil
			self.fadeOutDelay = fadeOutDelay
		elseif (not self.faded) then
			local startAlpha = self.sharedLayoutDB.alpha or 1
			local fadeOutChunks = fadeOutTime / FADEOUT_UPDATE_TIME
			local decrement = (startAlpha - fadeOutAlpha) / fadeOutChunks
			local alpha = self.frame:GetAlpha() - decrement
			if (alpha < fadeOutAlpha) then
				alpha = fadeOutAlpha
			end
			if (AutoBar.stickyMode or AutoBar.moveButtonsMode) then
				self.frame:SetAlpha(startAlpha)
				self.faded = nil
			elseif (alpha > fadeOutAlpha) then
				self.frame:SetAlpha(alpha)
			else
				self.frame:SetAlpha(fadeOutAlpha)
				self.faded = true
			end
		end
	end
end

function Bar:SetFadeOut(fadeOut)
	self.sharedLayoutDB.fadeOut = fadeOut
	self.faded = nil
	if (self:IsFadeOut()) then
		self:CreateFadeFrame()
	else
		self.frame:SetAlpha(self.sharedLayoutDB.alpha or 1)
		if (self.fadeFrame) then
			self.fadeFrame:SetScript("OnUpdate", nil)
			self.fadeFrame:Hide()
		end
	end
end

function Bar:StickTo(frame, point, stickToFrame, stickToPoint, stickToX, stickToY)
	AB.LibMMStickyFrames:SetFramePoints(frame, point, stickToFrame, stickToPoint, stickToX, stickToY)
	self.sharedLayoutDB.stickPoint = point
	self.sharedLayoutDB.stickToFrameName = stickToFrame and stickToFrame:GetName() or nil
	self.sharedLayoutDB.stickToPoint = stickToPoint
	self.sharedLayoutDB.stickToX = stickToX
	self.sharedLayoutDB.stickToY = stickToY
end

local colorMoveButtons = {r = 1, b = 1, g = 0, a = 0.5}
function Bar:ColorBars()
	local frame = self.frame
	if (AutoBar.keyBoundMode or AutoBar.moveButtonsMode) then
		-- Adjust Frame Strata
		frame:SetFrameStrata("DIALOG")
		self:SetButtonFrameStrata("LOW")

		-- Cancel Fade
		if self:IsFadeOut() then
			frame:SetAlpha(self.sharedLayoutDB.alpha or 1)
			self.faded = nil
		end

		-- Set Color
		if (AutoBar.keyBoundMode) then
			frame:SetBackdropColor(AB.LibKeyBound:GetColorKeyBoundMode())
		elseif (AutoBar.moveButtonsMode) then
			if (self.sharedLayoutDB.hide) then
				frame:SetBackdropColor(AB.LibMMStickyFrames:GetColorHidden())
			else
				frame:SetBackdropColor(colorMoveButtons.r, colorMoveButtons.g, colorMoveButtons.b, colorMoveButtons.a)
			end
		end
		frame.text:SetText(self.barName)
		frame:Show()
	elseif (AutoBar.stickyMode) then
		frame:SetFrameStrata(self.sharedLayoutDB.frameStrata)
		self:SetButtonFrameStrata(self.sharedLayoutDB.frameStrata)
		frame.text:SetText(self.barName)
	else
		if (self.sharedLayoutDB.hide) then
			self.frame:Hide()
		else
			self.frame:Show()
		end
		frame:SetFrameStrata(self.sharedLayoutDB.frameStrata)
		self:SetButtonFrameStrata(self.sharedLayoutDB.frameStrata)
		frame.text:SetText("")
		frame:SetBackdropColor(0, 0, 0, 0)
		frame:SetBackdropBorderColor(0, 0, 0, 0)
	end
end


function Bar:SetButtonFrameStrata(frameStrata)
	for _, button in pairs(self.buttonList) do
		button.frame:SetFrameStrata(frameStrata)
		if (button.frame.popupHeader) then
			button.frame.popupHeader:SetFrameStrata("DIALOG")
		end
	end
end

--local oldOnReceiveDragFunc

function Bar:MoveButtonsModeOn()
	local frame = self.frame
	frame:EnableMouse(# self.buttonList == 0)
	--oldOnReceiveDragFunc = frame:GetScript("OnReceiveDrag")
---	frame:SetScript("OnReceiveDrag", onReceiveDragFunc)
	self:ColorBars()
	for _, button in pairs(self.buttonList) do
		button:MoveButtonsModeOn()
	end
	self.dragFrame:Show()
end

function Bar:MoveButtonsModeOff()
	local frame = self.frame
	frame:EnableMouse(AutoBar.stickyMode)
---	frame:SetScript("OnReceiveDrag", oldOnReceiveDragFunc)
	frame:SetFrameStrata(self.sharedLayoutDB.frameStrata)
	self:SetButtonFrameStrata(self.sharedLayoutDB.frameStrata)
	self:ColorBars()
	for _, button in pairs(self.buttonList) do
		button:MoveButtonsModeOff()
	end
	self.dragFrame:Hide()
end


function Bar:CreateDragFrame()
	if (not self.dragFrame) then
		local name = self.barKey .. "DragFrame"
		local frame = CreateFrame("Button", name, self.frame, "SecureHandlerDragTemplate")
		if (frame.GetNormalTexture and frame:GetNormalTexture()) then
			frame:GetNormalTexture():Hide()
		end
		code.ClearNormalTexture(frame)
		self.dragFrame = frame
	--print(tostring(self.parentBar.frame) .. " ->  " .. tostring(frame) .. " button " .. tostring(name))

		frame.class = self
		frame:EnableMouse(true)
		if (frame.SetMouseClickEnabled) then frame:SetMouseClickEnabled(true) end
		if (frame.SetMouseMotionEnabled) then frame:SetMouseMotionEnabled(true) end
		frame:RegisterForClicks("AnyUp", "AnyDown")
		frame:RegisterForDrag("LeftButton", "RightButton")
---		frame:SetScript("OnReceiveDrag", onReceiveDragFunc)
	end
end


function Bar:CreateFadeFrame()
	if (not self.fadeFrame) then
		local name = self.barKey .. "FadeFrame"
		local frame = CreateFrame("Frame", name, self.frame)
		frame.class = self

		self.fadeFrame = frame
	end
	self.fadeFrame:Show()
	self.fadeFrame:SetScript("OnUpdate", onUpdateFunc)
end


function Bar:ToggleVisibilty()
	-- Disable during combat or Move Buttons
	if (InCombatLockdown() or AutoBar.moveButtonsMode) then
		return
	end

	if (self.sharedLayoutDB.hide) then
		self.sharedLayoutDB.hide = nil
	else
		self.sharedLayoutDB.hide = true
	end
	AutoBar:BarsChanged()
	if (not AutoBar.stickyMode) then
		if (self.sharedLayoutDB.hide) then
--			self.frame:Hide()
		else
--			self.frame:Show()
		end
	end
end

function Bar:RefreshLayout()
	-- Disable during combat
	if (InCombatLockdown()) then
		return
	end

	self:RefreshScale()
	self:RefreshButtonLayout()
	self:RefreshAlpha()

	--If it's in stickyMode or movebuttonsMode, show it regardless of whether it's hidden or not
	if ((AutoBar.stickyMode or AutoBar.moveButtonsMode)) then
		self.frame:Show()
	elseif (self.sharedLayoutDB.hide or not self.sharedLayoutDB.enabled) then
		self.frame:Hide()
	else
		self.frame:Show()
	end
end

function Bar:PositionLoad()
	local sharedPositionDB = self.sharedPositionDB
	local sharedLayoutDB = self.sharedLayoutDB
	local debug = false --self.barKey == "AutoBarClassBarBasic"

	if(debug) then code.log_warning("PositionLoad", self.barKey); end
	if(debug) then code.log_warning(code.Dump(sharedPositionDB, 1)); end
	if (sharedPositionDB.stickToFrameName and _G[sharedPositionDB.stickToFrameName]) then
		local stickToFrame = _G[sharedPositionDB.stickToFrameName]
		AB.LibMMStickyFrames:SetFramePoints(self.frame, sharedPositionDB.stickPoint, stickToFrame, sharedPositionDB.stickToPoint, sharedPositionDB.stickToX, sharedPositionDB.stickToY)
--print("Bar:PositionLoad " .. tostring(barDB.stickToFrameName))
	else
		if (not sharedLayoutDB.alignButtons) then
			sharedLayoutDB.alignButtons = "3"
		end
		if (not sharedPositionDB.posX) then
			sharedPositionDB.posX = 300
			sharedPositionDB.posY = 360
		end
--		local alignPoint = Bar:GetAlignPoints(sharedLayoutDB.alignButtons)
		local x, y, s = sharedPositionDB.posX, sharedPositionDB.posY, self.frame:GetEffectiveScale()
		x, y = x/s, y/s
		self.frame:ClearAllPoints()
		self.frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
	end
end

function Bar:PositionSave()
	local debug = false --self.barKey == "AutoBarClassBarBasic"
	local frame = self.frame
	local x, y = frame:GetLeft(), frame:GetBottom()
	local s = frame:GetEffectiveScale()
	x, y = x * s, y * s
	self.sharedPositionDB.posX = x
	self.sharedPositionDB.posY = y
	if(debug) then code.log_warning("|nPositionSave", self.barKey); end
	if(debug) then code.log_warning(code.Dump(self.sharedPositionDB, 1)); end

end


-- Translate the alignButtons setting
function Bar:GetAlignPoints(alignButtons)
	local alignPoint, columnRelativePoint, rowRelativePoint, signX, signY

	if (alignButtons == "3") then
		alignPoint = "BOTTOMLEFT"
		rowRelativePoint = "BOTTOMRIGHT"
		columnRelativePoint = "TOPLEFT"
		signX, signY = 1, 1
	elseif (alignButtons == "6") then
		alignPoint = "BOTTOMLEFT"
		rowRelativePoint = "BOTTOMRIGHT"
		columnRelativePoint = "TOPLEFT"
		signX, signY = 1, 1
	elseif (alignButtons == "9") then
		alignPoint = "BOTTOMRIGHT"
		rowRelativePoint = "BOTTOMLEFT"
		columnRelativePoint = "TOPRIGHT"
		signX, signY = -1, 1
	elseif (alignButtons == "8") then
		alignPoint = "BOTTOMRIGHT"
		rowRelativePoint = "BOTTOMLEFT"
		columnRelativePoint = "TOPRIGHT"
		signX, signY = -1, 1
	elseif (alignButtons == "5") then
		alignPoint = "BOTTOMLEFT"
		rowRelativePoint = "BOTTOMRIGHT"
		columnRelativePoint = "TOPLEFT"
		signX, signY = 1, 1
	elseif (alignButtons == "2") then
		alignPoint = "BOTTOMLEFT"
		rowRelativePoint = "BOTTOMRIGHT"
		columnRelativePoint = "TOPLEFT"
		signX, signY = 1, 1
	elseif (alignButtons == "7") then
		alignPoint = "TOPRIGHT"
		rowRelativePoint = "TOPLEFT"
		columnRelativePoint = "BOTTOMRIGHT"
		signX, signY = -1, -1
	elseif (alignButtons == "4") then
		alignPoint = "TOPLEFT"
		rowRelativePoint = "TOPRIGHT"
		columnRelativePoint = "BOTTOMLEFT"
		signX, signY = 1, -1
	elseif (alignButtons == "1") then
		alignPoint = "TOPLEFT"
		rowRelativePoint = "TOPRIGHT"
		columnRelativePoint = "BOTTOMLEFT"
		signX, signY = 1, -1
	end
	return alignPoint, rowRelativePoint, columnRelativePoint, signX, signY
end

--	["1"] = L["TOPLEFT"],
--	["2"] = L["LEFT"],
--	["3"] = L["BOTTOMLEFT"],
--	["4"] = L["TOP"],
--	["5"] = L["CENTER"],
--	["6"] = L["BOTTOM"],
--	["7"] = L["TOPRIGHT"],
--	["8"] = L["RIGHT"],
--	["9"] = L["BOTTOMRIGHT"],

-- Get offsets for any of the centered options of alignButtons
local function getCenterShift(alignButtons, signX, signY, rows, columns, displayedRows, displayedColumns, padding)
	local centerShiftX = 0
	local centerShiftY = 0

	local padded_width = ABGData.default_button_width + padding
	local padded_height = ABGData.default_button_height + padding

	if (alignButtons == "6") then
		centerShiftX = signX * (columns - displayedColumns) * (padded_width) / 2
	elseif (alignButtons == "8") then
		centerShiftY = signY * (rows - displayedRows) * (padded_height) / 2
	elseif (alignButtons == "5") then
		centerShiftX = signX * (columns - displayedColumns) * (padded_width) / 2
		centerShiftY = signY * (rows - displayedRows) * (padded_height) / 2
	elseif (alignButtons == "2") then
		centerShiftY = signY * (rows - displayedRows) * (padded_height) / 2
	elseif (alignButtons == "4") then
		centerShiftX = signX * (columns - displayedColumns) * (padded_width) / 2
	end
	return centerShiftX, centerShiftY
end


-- Lay out the buttons in the rows, columns grid specified
-- Collapse holes if collapseButtons is true
-- Obey the alignment options in alignButtons
function Bar:RefreshButtonLayout()
	local rows = self.sharedLayoutDB.rows or 1
	local columns = self.sharedLayoutDB.columns or 24
	local padding = self.sharedLayoutDB.padding
	local alignButtons = self.sharedLayoutDB.alignButtons or "3"
	local alignPoint, _, _, signX, signY = Bar:GetAlignPoints(alignButtons)
	local framePadding = math.max(0, padding)

	self.frame:SetWidth(ABGData.default_button_width * columns + ((columns + 1) * framePadding))
	self.frame:SetHeight(ABGData.default_button_height * rows + ((rows + 1) * framePadding))

	local anchorFrame = self.frame

	local activeButtonList = self.activeButtonList

	local displayedRows = math.floor((# activeButtonList - 1) / columns) + 1
	local displayedColumns = math.min(# activeButtonList, columns)
	local centerShiftX, centerShiftY = getCenterShift(alignButtons, signX, signY, rows, columns, displayedRows, displayedColumns, padding)

	local pad_btn_width = ABGData.default_button_width + padding
	local pad_btn_height = ABGData.default_button_height + padding

	local nButtons = # activeButtonList
	local frame
	for i = 1, nButtons do
		frame = activeButtonList[i].frame
		local targetX = ((i - 1) % columns) * signX * pad_btn_width + signX * padding + centerShiftX
		local targetY = (math.floor((i - 1) / columns)) * signY * (ABGData.default_button_height + padding) + signY * padding + centerShiftY
		if (frame:GetNumPoints() == 1) then
			local point, relTo, relPoint, x, y = frame:GetPoint(1)
			if (point ~= alignPoint or relTo ~= anchorFrame or relPoint ~= alignPoint or math.abs((x or 0) - targetX) > 0.05 or math.abs((y or 0) - targetY) > 0.05) then
				frame:ClearAllPoints()
				frame:SetPoint(alignPoint, anchorFrame, alignPoint, targetX, targetY)
			end
		else
			frame:ClearAllPoints()
			frame:SetPoint(alignPoint, anchorFrame, alignPoint, targetX, targetY)
		end
		if (frame:GetHeight() ~= ABGData.default_button_height) then
			frame:SetHeight(ABGData.default_button_height)
		end
		if (frame:GetWidth() ~= ABGData.default_button_width) then
			frame:SetWidth(ABGData.default_button_width)
		end
		if (frame:GetScale() ~= 1) then
			frame:SetScale(1)
		end
	end

	-- Dummy drag button for empty bar and end of bar drags
	if (AutoBar.moveButtonsMode) then
		local i = nButtons + 1
		frame = self.dragFrame
		frame:ClearAllPoints()
		local emptyColumns = columns - ((i - 1) % columns)
--print("Bar:RefreshButtonLayout columns  " .. tostring(columns) .. " i  " .. tostring(i) .. " emptyColumns  " .. tostring(emptyColumns))
		frame:SetWidth(pad_btn_width * emptyColumns)
		frame:SetPoint(alignPoint, anchorFrame, alignPoint,
						((i - 1) % columns) * signX * pad_btn_width + signX * padding + centerShiftX,
						(math.floor((i - 1) / columns)) * signY * pad_btn_height + signY * padding + centerShiftY)
	end
end


function Bar:RefreshScale()
	local targetScale = self.sharedLayoutDB.scale or 1
	if (self.frame:GetScale() ~= targetScale or not self.positionLoaded) then
		self.frame:SetScale(targetScale)
		self:PositionLoad()
		self.positionLoaded = true
	end
end


function Bar:RefreshAlpha()
	local targetAlpha = self.sharedLayoutDB.alpha or 1
	for _, button in pairs(self.buttonList) do
		button.frame:SetAlpha(targetAlpha)
	end
	if (not self:IsFadeOut() or not self.faded) then
		self.frame:SetAlpha(targetAlpha)
	end
end


-- Remove a button from the Bar
function Bar:ButtonRemove(buttonDB)
	for i, button in pairs(self.buttonList) do
		if (button.buttonDB == buttonDB) then
			button.frame:SetAttribute("category", nil)
			button.frame:SetAttribute("itemId", nil)
			button.frame:Hide()

			if (AutoBar.buttonListDisabled[buttonDB.buttonKey]) then
				AutoBar.buttonListDisabled[buttonDB.buttonKey] = nil
			end
			if (AutoBar.buttonList[buttonDB.buttonKey]) then
				AutoBar.buttonList[buttonDB.buttonKey] = nil
			end

			for j = i, # self.buttonList, 1 do
				if (self.buttonList[j + 1]) then
					self.buttonList[j] = self.buttonList[j + 1]
					self.buttonList[j + 1] = nil
				end
			end
			break
		end
	end
end


-- Return a unique key to use
function Bar:GetCustomKey(customBarName)
	local barKey = "AutoBarCustomBar" .. customBarName
	return barKey
end


-- Change name if possible.  return current name
function Bar:ChangeName(newName)
	L[self.barKey] = newName
	self.barName = newName
	self.barKey = Bar:GetCustomKey(newName)
end


function Bar:NameExists(newName)
	local newKey = Bar:GetCustomKey(newName)

	if (AutoBarDB2.account.barList[newKey]) then
		return true
	end
	for _, classDB in pairs (AutoBarDB2.classes) do
		if (classDB.barList[newKey]) then
			return true
		end
	end
	for _, charDB in pairs (AutoBarDB2.chars) do
		if (charDB.barList[newKey]) then
			return true
		end
	end

	return nil
end

-- Return a unique barName and barKey to use
function Bar:GetNewName(baseName)
	local newName, newKey
	local key_seed = 0
	while true do
		newName = baseName .. key_seed
		newKey = Bar:GetCustomKey(newName)

		key_seed = key_seed + 1
		if (not Bar:NameExists(newName)) then
			break
		end
	end
	return newName, newKey
end



function Bar:DeleteButtonKey(barDBList, oldKey)
	for _, barDB in pairs(barDBList) do
		local buttonKeys = barDB.buttonKeys
		for _, buttonKey in ipairs(buttonKeys) do
			if (buttonKey == oldKey) then
				for index = buttonKey, # buttonKeys - 1, 1 do
					buttonKeys[index] = buttonKeys[index + 1]
				end
			end
		end
	end
end

function Bar:RenameButtonKey(barDBList, oldKey, newKey)
	for _, barDB in pairs(barDBList) do
		local buttonKeys = barDB.buttonKeys
		for buttonIndex, buttonKey in pairs(buttonKeys) do
			if (buttonKey == oldKey) then
				buttonKeys[buttonIndex] = newKey
			end
		end
	end
end

function Bar:RenameKey(barDBList, oldKey, newKey, newName)
	local barDB = barDBList[oldKey]
	if (barDB) then
		barDBList[newKey] = barDB
		barDBList[oldKey] = nil
		barDB.barKey = newKey
		if (barDB.name) then
			barDB.name = newName
		end
	end
end

function Bar:Rename(oldKey, newName)
	local newKey = Bar:GetCustomKey(newName)

	-- Rename Bar for all classes and characters
	Bar:RenameKey(AutoBarDB2.account.barList, oldKey, newKey, newName)
	for _, classDB in pairs (AutoBarDB2.classes) do
		Bar:RenameKey(classDB.barList, oldKey, newKey, newName)
	end
	for _, charDB in pairs (AutoBarDB2.chars) do
		Bar:RenameKey(charDB.barList, oldKey, newKey, newName)
	end

	-- Rename instantiated Bar
	local bar = AutoBar.barList[oldKey]
	if (bar) then
		AutoBar.barList[newKey] = bar
		AutoBar.barList[oldKey] = nil
	end
end


function Bar:OptionsInitialize()
	if (not AutoBarDB2.account.barList) then
		AutoBarDB2.account.barList = {}
	end
	if (not AutoBar.class.barList) then
		AutoBar.class.barList = {}
	end
	if (not AutoBar.char.barList) then
		AutoBar.char.barList = {}
	end
	if Masque then
		Masque:Group("AutoBar");
	end
end



function Bar:OptionsReset()
	AutoBarDB2.account.barList = {}
end

function Bar:OptionsUpgrade()
--print("Bar:OptionsUpgrade start")
--	if (not AutoBarDB2.account.barListVersion) then
--		AutoBarDB2.account.barListVersion = barListVersion
--	elseif (AutoBarDB2.account.barListVersion < barListVersion) then
--print("Bar:OptionsUpgrade AutoBarDB2.account.barListVersion " .. tostring(AutoBarDB2.account.barListVersion))
--		AutoBarDB2.account.barListVersion = barListVersion
--	end
end

--[[
/dump AutoBar.barList
/script AutoBarClassBarBasicFrame:Show()
/dump AutoBar.barList["AutoBarClassBar"]
--]]


