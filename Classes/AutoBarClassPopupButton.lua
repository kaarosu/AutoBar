--
-- AutoBarClassPopupButton
-- Copyright 2007+ Toadkiller of Proudmoore.
--
-- Popup Buttons for AutoBar
-- Popup Buttons are contained by AutoBar.Class.Button
-- http://muffinmangames.com
--

--GLOBALS: InCombatLockdown, GameTooltip, CreateFrame, SecureHandlerWrapScript

local AutoBar = AutoBar
local ABGData = AutoBarGlobalDataObject

local Class = AutoBar.Class.new_class
local L = AutoBarGlobalDataObject.locale
local Masque = LibStub("Masque", true)
local _G = _G
local _


-- Basic Button with textures, highlighting, keybindText, tooltips etc.
-- Bound to the underlying AutoBarButton which provides its state information, icon etc.
AutoBar.Class.PopupButton = Class(AutoBar.Class.BasicButton)

function AutoBar.Class.PopupButton:GetPopupButton(parentButton, popupButtonIndex, popupHeader, popupKeyHandler)
	local popupButtonList = popupHeader.popupButtonList
	if (popupButtonList[popupButtonIndex]) then
		popupButtonList[popupButtonIndex]:Refresh(parentButton, popupButtonIndex, popupHeader)
	else
		popupButtonList[popupButtonIndex] = AutoBar.Class.PopupButton:new(parentButton, popupButtonIndex, popupHeader, popupKeyHandler)
	end

	return popupButtonList[popupButtonIndex]
end



function AutoBar.Class.PopupButton:init(parentButton, popupButtonIndex, popupHeader, popupKeyHandler)
	AutoBar.Class.PopupButton.super.init(self)

	self.parentBar = parentButton.parentBar
	self.parentButton = parentButton
	self.buttonDB = parentButton.buttonDB
	self.buttonName = self.buttonDB.buttonKey
	self.popupButtonIndex = popupButtonIndex
	self.popupHeader = popupHeader
	self.popupKeyHandler = popupKeyHandler
	self:CreateButtonFrame()
	self:Refresh(parentButton, popupButtonIndex, popupHeader)
end


function AutoBar.Class.PopupButton:Refresh(parentButton, popupButtonIndex, popupHeader)
end


local function funcOnEnter(self)
	local noTooltip = not (AutoBarDB2.settings.show_tooltip and self.needsTooltip or AutoBar.moveButtonsMode)
	noTooltip = noTooltip or (InCombatLockdown() and not AutoBarDB2.settings.show_tooltip_in_combat)
	if (noTooltip) then
		self.UpdateTooltip = nil
		GameTooltip:Hide()
	else
		AutoBar.Class.BasicButton.TooltipShow(self)
	end
--	self.popupHeader:Show()
end

local function funcOnLeave(self)
	GameTooltip:Hide()
end

-- Return the name of the global frame for the button.  Keybinds are made to it.
function AutoBar.Class.PopupButton:GetButtonFrameName(popupButtonIndex)
	return self.parentButton:GetButtonFrameName() .. "Popup" .. popupButtonIndex
end

function AutoBar.Class.PopupButton:CreateButtonFrame()
	local popupButtonIndex = self.popupButtonIndex
	local popupHeader = self.popupHeader
	local popupKeyHandler = self.popupKeyHandler
	local popupButtonName = self:GetButtonFrameName(popupButtonIndex)
	local frame = CreateFrame("Button", popupButtonName, popupKeyHandler or popupHeader, "ActionButtonTemplate, SecureActionButtonTemplate, SecureHandlerBaseTemplate, SecureHandlerEnterLeaveTemplate")
	self.frame = frame
	frame.class = self
	frame:EnableMouse(true)
	if (frame.SetMouseClickEnabled) then frame:SetMouseClickEnabled(true) end
	if (frame.SetMouseMotionEnabled) then frame:SetMouseMotionEnabled(true) end
	frame:RegisterForClicks("AnyUp", "AnyDown")
	frame:SetFrameRef("popupHeader", popupHeader)
	frame.popupHeader = popupHeader
	frame:HookScript("OnEnter", funcOnEnter)
	frame:HookScript("OnLeave", funcOnLeave)

	frame:ClearAllPoints()
	frame:SetWidth(ABGData.default_button_width)
	frame:SetHeight(ABGData.default_button_height)

---	frame:SetScript("PostClick", self.PostClick)

	frame.icon = _G[("%sIcon"):format(popupButtonName)]
	frame.cooldown = _G[("%sCooldown"):format(popupButtonName)]
	frame.macroName = _G[("%sName"):format(popupButtonName)]
	frame.hotKey = _G[("%sHotKey"):format(popupButtonName)]
	frame.normalTexture = frame:GetNormalTexture()

	if frame.normalTexture then
		frame.normalTexture:ClearAllPoints()
		frame.normalTexture:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
		frame.normalTexture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)
	end
	if frame.icon then
		frame.icon:ClearAllPoints()
		frame.icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
		frame.icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
	end
	frame.border = _G[("%sBorder"):format(popupButtonName)]
	if frame.border then
		frame.border:ClearAllPoints()
		frame.border:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
		frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)
		frame.border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		frame.border:SetBlendMode("ADD")
	end
	if frame.SlotBackground then frame.SlotBackground:Hide() end
	if frame.SlotArt then frame.SlotArt:Hide() end

	-- Clamp interaction textures in 11.0
	local function clampTexture(tex)
		if tex then
			tex:ClearAllPoints()
			tex:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
			tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		end
	end
	if frame.GetNormalTexture then clampTexture(frame:GetNormalTexture()) end
	if frame.GetPushedTexture then clampTexture(frame:GetPushedTexture()) end
	if frame.GetHighlightTexture then clampTexture(frame:GetHighlightTexture()) end
	if frame.GetCheckedTexture then clampTexture(frame:GetCheckedTexture()) end
	if frame.CheckedTexture then clampTexture(frame.CheckedTexture) end
	if frame.NewActionTexture then clampTexture(frame.NewActionTexture) end
	if frame.SpellHighlightTexture then clampTexture(frame.SpellHighlightTexture) end
	frame.count = _G[("%sCount"):format(popupButtonName)]
	frame.flash = _G[("%sFlash"):format(popupButtonName)]
	if (Masque) then
		local group = self.parentBar.frame.MasqueGroup
		frame.MasqueButtonData = {
			Border = frame.border,
			Cooldown = frame.cooldown,
			Count = frame.count,
			Flash = frame.flash,
			HotKey = frame.hotKey,
			Icon = frame.icon,
			Name = frame.macroName,
		}
		group:AddButton(frame, frame.MasqueButtonData)
	end

	frame.border = _G[("%sBorder"):format(popupButtonName)]
	
	if frame.Arrow then
		frame.Arrow:Hide()
	end
end


function AutoBar.Class.PopupButton:UpdateIcon()
	local frame = self.frame
	local texture, borderColor = self:GetIconTexture(frame)
	frame:SetAttribute("icon", texture)

	if (texture) then
		frame.icon:SetTexture(texture)
		frame.icon:Show()
		frame.tex = texture
	else
		frame.icon:Hide()
		frame.cooldown:Hide()
		frame.hotKey:SetVertexColor(0.6, 0.6, 0.6)
		frame.tex = nil
	end

	if (borderColor) then
		frame.border:SetVertexColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a)
		frame.border:Show()
	else
		frame.border:Hide()
	end
end


function AutoBar.Class.PopupButton:IsActive()
	return self.frame:GetAttribute("type")
end

