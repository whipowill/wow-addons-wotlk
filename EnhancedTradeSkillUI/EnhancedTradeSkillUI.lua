-- -------------------------------------------------------------------------- --
-- EnhancedTradeSkillUI by kunda                                              --
-- -------------------------------------------------------------------------- --

EnhancedTradeSkillUI = CreateFrame("Frame") -- container
EnhancedTradeSkillUI_Options = {}           -- SavedVariable options table

local L = EnhancedTradeSkillUI_Locales      -- localization table
local maxTradeSkills = 30                   -- maximum number of shown TradeSkills (blendbridge.tga is designed for max. 30 skills)
local minScale       = 0.5                  -- minimum value for TradeSkillFrame scale
local maxScale       = 1.5                  -- maximum value for TradeSkillFrame scale
local IsTradeSkillUI = false                -- check value for Blizzard_TradeSkillUI

-- ---------------------------------------------------------------------------------------------------------------------
local function SlashHandler()
	InterfaceOptionsFrame_OpenToCategory("EnhancedTradeSkillUI")
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function EnhancedTradeSkillUI:InitOptions()
	SlashCmdList["ENHANCEDTRADESKILLUI"] = SlashHandler
	SLASH_ENHANCEDTRADESKILLUI1 = "/etsui"
	SLASH_ENHANCEDTRADESKILLUI2 = "/tradeskillui"
	SLASH_ENHANCEDTRADESKILLUI3 = "/enhancedtradeskillui"

	if EnhancedTradeSkillUI_Options.ShownSkills == nil then EnhancedTradeSkillUI_Options.ShownSkills = 8 end
	if EnhancedTradeSkillUI_Options.scale       == nil then EnhancedTradeSkillUI_Options.scale       = 1 end
	if EnhancedTradeSkillUI_Options.lock        == nil then EnhancedTradeSkillUI_Options.lock        = false end
	if EnhancedTradeSkillUI_Options.tooltip     == nil then EnhancedTradeSkillUI_Options.tooltip     = true end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function EnhancedTradeSkillUI:CreateInterfaceOptions()
	local options = CreateFrame("FRAME", "EnhancedTradeSkillUI_InterfaceOptions")
	options.name = "EnhancedTradeSkillUI"

	-- title & description START
	local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("EnhancedTradeSkillUI")
	title:SetJustifyH("LEFT")
	title:SetJustifyV("TOP")

	local subText = options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subText:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subText:SetText(L["Shows more recipies in the profession window."])
	subText:SetNonSpaceWrap(true)
	subText:SetJustifyH("LEFT")
	subText:SetJustifyV("TOP")
	-- title & description END

	-- shownSkills option START
	local shownSkills = CreateFrame("Slider", "EnhancedTradeSkillUI_InterfaceOptions_shownSkills", EnhancedTradeSkillUI_InterfaceOptions, "OptionsSliderTemplate")
	EnhancedTradeSkillUI_InterfaceOptions_shownSkills:SetWidth(200)
	EnhancedTradeSkillUI_InterfaceOptions_shownSkills:SetHeight(16)
	EnhancedTradeSkillUI_InterfaceOptions_shownSkills:SetPoint("TOPLEFT", subText, "BOTTOMLEFT", 8, -30)
	EnhancedTradeSkillUI_InterfaceOptions_shownSkillsText:SetPoint("LEFT")
	EnhancedTradeSkillUI_InterfaceOptions_shownSkillsText:SetText(L["Shown Skills"]..": "..EnhancedTradeSkillUI_Options.ShownSkills)
	EnhancedTradeSkillUI_InterfaceOptions_shownSkillsLow:SetText("8")
	EnhancedTradeSkillUI_InterfaceOptions_shownSkillsHigh:SetText(tostring(maxTradeSkills))
	EnhancedTradeSkillUI_InterfaceOptions_shownSkills:SetMinMaxValues(8, maxTradeSkills)
	EnhancedTradeSkillUI_InterfaceOptions_shownSkills:SetValueStep(1)
	EnhancedTradeSkillUI_InterfaceOptions_shownSkills:SetValue(EnhancedTradeSkillUI_Options.ShownSkills)
	EnhancedTradeSkillUI_InterfaceOptions_shownSkills:SetScript("OnValueChanged", function(self, value)
		EnhancedTradeSkillUI_InterfaceOptions_shownSkillsText:SetText(L["Shown Skills"]..": "..value)
		EnhancedTradeSkillUI_Options.ShownSkills = value
		EnhancedTradeSkillUI:Resize(value, EnhancedTradeSkillUI_Options.scale)
	end)
	BlizzardOptionsPanel_Slider_Enable(EnhancedTradeSkillUI_InterfaceOptions_shownSkills)

	local shownSkillsText = options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	shownSkillsText:SetPoint("TOPLEFT", shownSkills, "BOTTOMLEFT", 0, -10)
	shownSkillsText:SetText("("..L["WoW Default"].." = 8)")
	shownSkillsText:SetNonSpaceWrap(true)
	-- shownSkills option END

	-- scale option START
	local scale = CreateFrame("Slider", "EnhancedTradeSkillUI_InterfaceOptions_scale", EnhancedTradeSkillUI_InterfaceOptions, "OptionsSliderTemplate")
	EnhancedTradeSkillUI_InterfaceOptions_scale:SetWidth(200)
	EnhancedTradeSkillUI_InterfaceOptions_scale:SetHeight(16)
	EnhancedTradeSkillUI_InterfaceOptions_scale:SetPoint("TOPLEFT", shownSkillsText, "BOTTOMLEFT", 0, -30)
	EnhancedTradeSkillUI_InterfaceOptions_scaleText:SetPoint("LEFT")
	EnhancedTradeSkillUI_InterfaceOptions_scaleText:SetText(L["Scale"]..": "..(EnhancedTradeSkillUI_Options.scale*100).."%")
	EnhancedTradeSkillUI_InterfaceOptions_scaleLow:SetText(tostring(minScale*100).."%")
	EnhancedTradeSkillUI_InterfaceOptions_scaleHigh:SetText(tostring(maxScale*100).."%")
	EnhancedTradeSkillUI_InterfaceOptions_scale:SetMinMaxValues(minScale, maxScale)
	EnhancedTradeSkillUI_InterfaceOptions_scale:SetValueStep(0.05)
	EnhancedTradeSkillUI_InterfaceOptions_scale:SetValue(EnhancedTradeSkillUI_Options.scale)
	EnhancedTradeSkillUI_InterfaceOptions_scale:SetScript("OnValueChanged", function(self, value)
		local value = ceil(value*100-0.5) / 100
		EnhancedTradeSkillUI_InterfaceOptions_scaleText:SetText(L["Scale"]..": "..(value*100).."%")
		EnhancedTradeSkillUI_Options.scale = value
		EnhancedTradeSkillUI:Resize(EnhancedTradeSkillUI_Options.ShownSkills, value)
	end)
	BlizzardOptionsPanel_Slider_Enable(EnhancedTradeSkillUI_InterfaceOptions_scale)

	local scaleText = options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	scaleText:SetPoint("TOPLEFT", scale, "BOTTOMLEFT", 0, -10)
	scaleText:SetText("("..L["WoW Default"].." = 100%)")
	scaleText:SetNonSpaceWrap(true)
	-- scale option END

	-- lock frame pos START
	local lockFrame = CreateFrame("CheckButton", "EnhancedTradeSkillUI_InterfaceOptions_lockFrame", EnhancedTradeSkillUI_InterfaceOptions, "InterfaceOptionsCheckButtonTemplate")
	EnhancedTradeSkillUI_InterfaceOptions_lockFrame:SetPoint("TOPLEFT", scaleText, "TOPLEFT", -8, -20)
	EnhancedTradeSkillUI_InterfaceOptions_lockFrameText:SetText(L["Lock"])
	EnhancedTradeSkillUI_InterfaceOptions_lockFrame:SetChecked(EnhancedTradeSkillUI_Options.lock)
	EnhancedTradeSkillUI_InterfaceOptions_lockFrame:SetScript("OnClick", function(self)
		EnhancedTradeSkillUI_Options.lock = not EnhancedTradeSkillUI_Options.lock
	end)
	lockFrame.tooltipText = L["Locks or unlocks the TradeSkillFrame for movement."]
	-- lock frame pos END

	-- portait tooltip START
	local PortraitTooltip = CreateFrame("CheckButton", "EnhancedTradeSkillUI_InterfaceOptions_PortraitTooltip", EnhancedTradeSkillUI_InterfaceOptions, "InterfaceOptionsCheckButtonTemplate")
	EnhancedTradeSkillUI_InterfaceOptions_PortraitTooltip:SetPoint("TOPLEFT", lockFrame, "TOPLEFT", 0, -20)
	EnhancedTradeSkillUI_InterfaceOptions_PortraitTooltipText:SetText(L["Portrait Tooltip"])
	EnhancedTradeSkillUI_InterfaceOptions_PortraitTooltip:SetChecked(EnhancedTradeSkillUI_Options.tooltip)
	EnhancedTradeSkillUI_InterfaceOptions_PortraitTooltip:SetScript("OnClick", function(self)
		EnhancedTradeSkillUI_Options.tooltip = not EnhancedTradeSkillUI_Options.tooltip
	end)
	-- portait tooltip END

	InterfaceOptions_AddCategory(options)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function EnhancedTradeSkillUI:Init()
	EnhancedTradeSkillUI:SetUIPanel(TradeSkillFrame, nil)
	table.insert(UISpecialFrames,"TradeSkillFrame")

	TradeSkillFrame:SetClampedToScreen(true)
	TradeSkillFrame:SetClampRectInsets(0, -34, 0, 72)

	local button = CreateFrame("Button", "EnhancedTradeSkillUI_Mover", TradeSkillFrame)
	button:ClearAllPoints()
	button:SetPoint("CENTER", "TradeSkillFramePortrait", "CENTER", 0, 0)
	button:SetFrameLevel(TradeSkillFrame:GetFrameLevel()+1)
	button:SetWidth(55)
	button:SetHeight(55)
	button:RegisterForClicks("LeftButtonDown", "RightButtonUp")
	button:SetScript("OnEnter", function(self, button)
		if EnhancedTradeSkillUI_Options.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 50)
			if EnhancedTradeSkillUI_Options.lock then
				GameTooltip:SetText(L["Right-Click: Options"], nil, nil, nil, nil, 1)
			else
				GameTooltip:SetText(L["Left-Click: Move"].."\n"..L["Right-Click: Options"], nil, nil, nil, nil, 1)
			end
		end
	end)
	button:SetScript("OnLeave", function(self, button)
		GameTooltip:Hide()
	end)
	button:SetScript("OnMouseDown", function(self, button)
		GameTooltip:Hide()
		if button == "RightButton" then
			InterfaceOptionsFrame_OpenToCategory("EnhancedTradeSkillUI")
		else
			if not EnhancedTradeSkillUI_Options.lock then
				TradeSkillFrame:StartMoving()
			end
		end
	end)
	button:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then return end
		if not EnhancedTradeSkillUI_Options.lock then
			TradeSkillFrame:StopMovingOrSizing()
			EnhancedTradeSkillUI:SaveFramePos()
		end
	end)
	button:SetScript("OnDragStop", function(self, button)
		if button == "RightButton" then return end
		if not EnhancedTradeSkillUI_Options.lock then
			TradeSkillFrame:StopMovingOrSizing()
		end
	end)

	if EnhancedTradeSkillUI_Options.posX then
		TradeSkillFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", EnhancedTradeSkillUI_Options.posX, EnhancedTradeSkillUI_Options.posY)
	end
end

function EnhancedTradeSkillUI:SetUIPanel(frame, info)
	local function NOOP() end
	local name = frame:GetName()
	local visible = frame:IsShown()
	local script1 = frame:GetScript("OnShow")
	local script2 = frame:GetScript("OnHide")

	if visible then
		frame:HookScript("OnShow", NOOP)
		frame:HookScript("OnHide", NOOP)
		HideUIPanel(frame)
	end

	UIPanelWindows[name] = info

	if visible then
		ShowUIPanel(frame)
		frame:HookScript("OnShow", script1)
		frame:HookScript("OnHide", script2)
	end
end

function EnhancedTradeSkillUI:SaveFramePos()
	EnhancedTradeSkillUI_Options.posX = TradeSkillFrame:GetLeft()
	EnhancedTradeSkillUI_Options.posY = TradeSkillFrame:GetTop()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function EnhancedTradeSkillUI:CreateTradeSkillButtons()
	if TradeSkillSkill9 then return end
	for i=9, maxTradeSkills do
		local b = CreateFrame("Button", "TradeSkillSkill"..i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
		b:SetPoint("TOPLEFT", "TradeSkillSkill"..(i-1), "BOTTOMLEFT", 0, 0)
	end
end

function EnhancedTradeSkillUI:CreateBackgroundTextures()
	if EnhancedTradeSkillUI_Texture1left then return end
	local texture1left = TradeSkillFrame:CreateTexture("EnhancedTradeSkillUI_Texture1left", "BORDER")
	texture1left:ClearAllPoints()
	texture1left:SetPoint("TOPLEFT", 0, -256)
	texture1left:SetWidth(256)
	texture1left:SetHeight(134)
	texture1left:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-BotLeft")
	texture1left:SetTexCoord(0/256,256/256,0/256,134/256) -- 16px left for blendbridge.tga
	local texture1right = TradeSkillFrame:CreateTexture("EnhancedTradeSkillUI_Texture1right", "BORDER")
	texture1right:ClearAllPoints()
	texture1right:SetPoint("TOPRIGHT", 0, -256)
	texture1right:SetWidth(128)
	texture1right:SetHeight(134)
	texture1right:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-BotRight")
	texture1right:SetTexCoord(0/128,128/128,0/256,134/256) -- 16px left for blendbridge.tga

	local texture2blendbridge = TradeSkillFrame:CreateTexture("EnhancedTradeSkillUI_Texture2blendbridge", "BORDER")
	texture2blendbridge:ClearAllPoints()
	texture2blendbridge:SetPoint("TOPLEFT", 0, -390) -- 256+134
	texture2blendbridge:SetWidth(512)
	texture2blendbridge:SetHeight(128)
	texture2blendbridge:SetTexture("Interface\\Addons\\EnhancedTradeSkillUI\\blendbridge")

	local texture3left = TradeSkillFrame:CreateTexture("EnhancedTradeSkillUI_Texture3left", "BACKGROUND")
	texture3left:ClearAllPoints()
	texture3left:SetPoint("BOTTOMLEFT", 0, 256)
	texture3left:SetWidth(256)
	texture3left:SetHeight(156)
	texture3left:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-TopLeft")
	texture3left:SetTexCoord(0/256,256/256,100/256,256/256)
	local texture3right = TradeSkillFrame:CreateTexture("EnhancedTradeSkillUI_Texture3right", "BACKGROUND")
	texture3right:ClearAllPoints()
	texture3right:SetPoint("BOTTOMRIGHT", 0, 256)
	texture3right:SetWidth(128)
	texture3right:SetHeight(156)
	texture3right:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-TopRight")
	texture3right:SetTexCoord(0/128,128/128,100/256,256/256)

	local texture4scrollbar = TradeSkillListScrollFrame:CreateTexture("EnhancedTradeSkillUI_Texture4scrollbar", "BACKGROUND")
	texture4scrollbar:ClearAllPoints()
	texture4scrollbar:SetPoint("TOPRIGHT", TradeSkillListScrollFrame, "TOPRIGHT", 29, -50)
	texture4scrollbar:SetWidth(32)
	texture4scrollbar:SetHeight(0)
	texture4scrollbar:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-ScrollBar")
	texture4scrollbar:SetTexCoord(0/64,32/64,25/128,123/128)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function EnhancedTradeSkillUI:Resize(newsize, scale)
	if not IsTradeSkillUI then return end

	TRADE_SKILLS_DISPLAYED = newsize

	TradeSkillFrame:SetHeight(384+newsize*16)

	TradeSkillListScrollFrame:SetHeight(2+newsize*16)
	TradeSkillListScrollFrameScrollChildFrame:SetHeight(16*newsize-60)
	if newsize > 14 then
		EnhancedTradeSkillUI_Texture4scrollbar:Show()
		EnhancedTradeSkillUI_Texture4scrollbar:SetHeight((16*newsize)-(16*8))
		EnhancedTradeSkillUI_Texture2blendbridge:SetHeight(128)
	else
		EnhancedTradeSkillUI_Texture4scrollbar:Hide()
		EnhancedTradeSkillUI_Texture4scrollbar:SetHeight(0)
		EnhancedTradeSkillUI_Texture2blendbridge:SetHeight((newsize*16)-(16*8)+1)
	end

	TradeSkillHorizontalBarLeft:SetPoint("TOPLEFT", "TradeSkillFrame", "TOPLEFT", 15, -221-(newsize-8)*16)
	TradeSkillDetailScrollFrame:SetPoint("TOPLEFT", "TradeSkillFrame", "TOPLEFT", 20, -234-(newsize-8)*16)

	TradeSkillCreateButton:SetPoint("CENTER", "TradeSkillFrame", "TOPLEFT", 224, -422-(newsize-8)*16)
	TradeSkillCancelButton:SetPoint("CENTER", "TradeSkillFrame", "TOPLEFT", 305, -422-(newsize-8)*16)
    
	for i = newsize+1, maxTradeSkills do
		_G["TradeSkillSkill"..i]:Hide()
	end

	TradeSkillFrame:SetScale(scale)
	TradeSkillFrame_Update()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function EnhancedTradeSkillUI:OnEvent()
	if event == "ADDON_LOADED" then
		if arg1 == "EnhancedTradeSkillUI" then
			EnhancedTradeSkillUI:InitOptions()
			EnhancedTradeSkillUI:CreateInterfaceOptions()
		elseif arg1 == "Blizzard_TradeSkillUI" then
			IsTradeSkillUI = true
			EnhancedTradeSkillUI:Init()
			EnhancedTradeSkillUI:CreateTradeSkillButtons()
			EnhancedTradeSkillUI:CreateBackgroundTextures()
			EnhancedTradeSkillUI:Resize(EnhancedTradeSkillUI_Options.ShownSkills, EnhancedTradeSkillUI_Options.scale)
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

EnhancedTradeSkillUI:RegisterEvent("ADDON_LOADED")
EnhancedTradeSkillUI:SetScript("OnEvent", EnhancedTradeSkillUI.OnEvent)