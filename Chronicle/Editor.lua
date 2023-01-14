local Chronicle = LibStub('AceAddon-3.0'):GetAddon('Chronicle')
local L = LibStub('AceLocale-3.0'):GetLocale('Chronicle')
local texPath = 'Interface\\AddOns\\Chronicle\\Gfx\\'
local tooltipDateFormat = '%d %b %Y %I:%M %p'

-- -----------------------
-- RESIZER SCRIPT FUNCS --
-- -----------------------
local function Resizer_OnDragStart(self)
	self:GetParent():StartSizing('BOTTOMRIGHT')
end

local function Resizer_OnDragStop(self)
	local parent = self:GetParent()

	parent:StopMovingOrSizing()

	local point, _, _, x, y = parent:GetPoint(1)

	Chronicle.db.layout[parent.intName .. 'A'] = point
	Chronicle.db.layout[parent.intName .. 'X'] = x
	Chronicle.db.layout[parent.intName .. 'Y'] = y
	Chronicle.db.layout[parent.intName .. 'W'] = parent:GetWidth()
	Chronicle.db.layout[parent.intName .. 'H'] = parent:GetHeight()
end

-- ----------------------
-- HEADER SCRIPT FUNCS --
-- ----------------------
local function Header_OnEnter(self)
	local active = Chronicle.db.active

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT', -5, 0)
	GameTooltip:SetText(L.PageMetadata, 1, 0.82, 0, 1)

	GameTooltip:AddDoubleLine(L.Created, date(tooltipDateFormat, Chronicle.db.pages[active].created), 0.28, 0.47, 0.81, 1, 1, 1)
	GameTooltip:AddDoubleLine(L.Author, Chronicle.db.pages[active].author, 0.28, 0.47, 0.81, 1, 1, 1)
	GameTooltip:AddDoubleLine(L.LastEdited, date(tooltipDateFormat, Chronicle.db.pages[active].edited), 0.28, 0.47, 0.81, 1, 1, 1)
	GameTooltip:AddDoubleLine(L.EditedBy, Chronicle.db.pages[active].editedby, 0.28, 0.47, 0.81, 1, 1, 1)
	GameTooltip:AddDoubleLine(L.LetterCount, strlen(Chronicle.editor.text:GetText()) .. '/' .. Chronicle.noteMax, 0.28, 0.47, 0.81, 1, 1, 1)

	GameTooltip:Show()
end

local function Header_OnLeave(self)
	GameTooltip:Hide()
end

-- ----------------------------
-- EDITOR FRAME CONSTRUCTION --
-- ----------------------------
function Chronicle:BuildEditorFrame()
	local f = self:BuildBaseFrame('editor', 'ChronicleEditorFrame')

	self.editor = f

	f:SetResizable(true)
	f:SetMinResize(280, 200)
	f:SetMaxResize(660, 760)
	f:SetPoint(self.db.layout.editorA, self.db.layout.editorX, self.db.layout.editorY)
	f:SetWidth(self.db.layout.editorW)
	f:SetHeight(self.db.layout.editorH)
	f:Hide()

	SetPortraitToTexture(f.corner, 'Interface/Spellbook/Spellbook-Icon')

	f.header:SetScript('OnEnter', Header_OnEnter)
	f.header:SetScript('OnLeave', Header_OnLeave)

	-- create divider bar
	t = f:CreateTexture(nil, 'OVERLAY')
	t:SetTexture(1, 1, 1, 1)
	t:SetGradient('HORIZONTAL', 0.247, 0.231, 0.216, 0.176, 0.173, 0.145)
	t:SetHeight(1.5)
	t:SetPoint('BOTTOMLEFT', 14, 30.5)
	t:SetPoint('BOTTOMRIGHT', -17, 30.5)

	-- create resizer
	local r = CreateFrame('Button', nil, f)
	r:SetHeight(14)
	r:SetWidth(14)
	r:SetPoint('BOTTOMRIGHT', -9, 7)
	r:RegisterForDrag('LeftButton')
	r:SetScript('OnDragStart', Resizer_OnDragStart)
	r:SetScript('OnDragStop', Resizer_OnDragStop)
	t = r:CreateTexture(nil, 'OVERLAY')
	t:SetTexture(texPath .. 'Resizer')
	t:SetPoint('TOPLEFT', -6, 6)
	t:SetPoint('BOTTOMRIGHT', -4, 4)

	self:BuildMicroButtons(f)

	self:BuildEditor(f)

	self:OpenPage(self.db.active, true)
end

-- ------------------------------------
-- MICRO BUTTON CONSTRUCTION & FUNCS --
-- ------------------------------------
local function MicroButton_OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT', -5, 0)
	GameTooltip:SetText(self.tipHeader, 1, 0.82, 0, 1)
	GameTooltip:AddLine(self.tipText, 1, 1, 1, 1)
	GameTooltip:Show()
end

local function MicroButton_OnLeave(self)
	GameTooltip:Hide()
end

local function MicroButton_OnMouseDown(self)
	self.pushed:Show()
end

local function MicroButton_OnMouseUp(self)
	self.pushed:Hide()
end

local function CreateMicroButton(f, anchor, posX, posY, tex, tipHeader, tipText)
	local b = CreateFrame('Button', nil, f)
	b:SetWidth(20)
	b:SetHeight(40)
	b:SetPoint(anchor, posX, posY)
	b:SetHitRectInsets(0, 0, 13, 0)
	b:SetNormalTexture(tex)
	b:SetHighlightTexture('Interface/Buttons/UI-MicroButton-Hilight')
	if (textDisabled) then b:SetDisabledTexture(texDisabled) end
	b.pushed = b:CreateTexture(nil, 'OVERLAY')
	b.pushed:SetTexture(texPath .. 'Micro-Pushed')
	b.pushed:SetBlendMode('ADD')
	b.pushed:SetAllPoints(b)
	b.pushed:Hide()
	b.tipHeader = tipHeader
	b.tipText = tipText
	b:SetScript('OnEnter', MicroButton_OnEnter)
	b:SetScript('OnLeave', MicroButton_OnLeave)
	b:SetScript('OnMouseDown', MicroButton_OnMouseDown)
	b:SetScript('OnMouseUp', MicroButton_OnMouseUp)
	return b
end

function Chronicle:BuildMicroButtons(f)
	local m

	m = CreateMicroButton(f, 'TOPLEFT', 56, -13, 'Interface/Buttons/UI-MicroButton-Spellbook-Up', L.NewPage, L.NewPageDesc)
	m:SetScript('OnClick', function() self:NewPage() end)

	m = CreateMicroButton(f, 'TOPLEFT', 77, -13,  texPath .. 'Save', L.SavePage, L.SavePageDesc)
	m:SetScript('OnClick', function() self:SavePage() end)

	m = CreateMicroButton(f, 'TOPLEFT', 98, -13,  texPath .. 'Undo', L.Undo, L.UndoDesc)
	m:SetScript('OnClick', function() self:Undo() end)

	-- special case, can be disabled (if viewing the first page)
	m = CreateMicroButton(f, 'TOPLEFT', 119, -13,  texPath .. 'Delete', L.DeletePage, L.DeletePageDesc)
	m:SetDisabledTexture(texPath .. 'Delete-Disabled')
	m:SetScript('OnClick', function() self:DeletePage() end)
	f.microDelete = m

	m = CreateMicroButton(f, 'TOPLEFT', 145, -13, 'Interface/Buttons/UI-MICROBUTTON-QUEST-UP', L.RunPage, L.RunPageDesc)
	m:SetScript('OnClick', function() self:RunPage() end)

	m = CreateMicroButton(f, 'TOPLEFT', 171, -13, 'Interface/Buttons/UI-MicroButton-EJ-Up', L.OpenIndex, L.OpenIndexDesc)
	m:SetScript('OnClick', function() self:ToggleIndex() end)

	m = CreateMicroButton(f, 'TOPRIGHT', -35, -13, texPath .. 'ChangeFont', L.ChangeFont, L.ChangeFontDesc)
	m:SetScript('OnClick', function() self:ChangeFont() end)

	m = CreateMicroButton(f, 'TOPRIGHT', -15, -13, texPath .. 'ChangeColour', L.ChangeColour, L.ChangeColourDesc)
	m:SetScript('OnClick', function() self:ChangeColour() end)
end

-- ------------------------------
-- EDITOR CONSTRUCTION & FUNCS --
-- ------------------------------

-- SCROLLFRAME FUNCS
local function Scroll_OnMouseWheel(self, delta)
	local sb = self.scrollbar

	if (delta > 0) then delta = -1 else delta = 1 end

	sb:SetValue(sb:GetValue() + (delta * (sb:GetHeight() / 2)))
end

local function Scroll_OnScrollRangeChanged(self, x, y)
	local sb = self.scrollbar
	local v = sb:GetValue()

	if (not y) then y = self:GetVerticalScrollRange() end
	if (v > y) then v = y end

	sb:SetMinMaxValues(0, y)
	sb:SetValue(v)

	if (floor(y) == 0) then
		_G[sb:GetName() .. 'ScrollUpButton']:Disable()
		_G[sb:GetName() .. 'ScrollDownButton']:Disable()
		_G[sb:GetName() .. 'ThumbTexture']:Hide()
	elseif (y - v > 0.005) then
		_G[sb:GetName() .. 'ScrollUpButton']:Enable()
		_G[sb:GetName() .. 'ScrollDownButton']:Enable()
		_G[sb:GetName() .. 'ThumbTexture']:Show()
	end
end

local function Scroll_OnSizeChanged(self)
	self.text:SetWidth(self:GetWidth())
end

local function Scroll_OnVerticalScroll(self, offset)
	local sb = self.scrollbar
	local min, max = sb:GetMinMaxValues();

	sb:SetValue(offset)

	if (offset == 0) then
		_G[sb:GetName() .. 'ScrollUpButton']:Disable()
	else
		_G[sb:GetName() .. 'ScrollUpButton']:Enable()
	end

	if ((sb:GetValue() - max) == 0) then
		_G[sb:GetName() .. 'ScrollDownButton']:Disable()
	else
		_G[sb:GetName() .. 'ScrollDownButton']:Enable()
	end
end

-- FOCUS FRAME FUNC
local function Focus_OnClick(self)
	self:GetParent().text:SetFocus()
end

-- EDIT/TITLE COMMON FUNC
local function OnEscapePressed(self)
	self:ClearFocus()
end

-- EDIT BOX FUNCS
local function Edit_OnEditFocusGained()
	Chronicle.focus = true -- used in chat hooks (so it isn't firing -all- the time)
end

local function Edit_OnEditFocusLost()
	Chronicle.focus = false
end

local function Edit_OnCursorChanged(self, _, y, _, height)
	self, y = self:GetParent(), -y

	local offset = self:GetVerticalScroll()

	if (y < offset) then
		self:SetVerticalScroll(y)
	else
		y = y + height - self:GetHeight()
		if (y > offset) then
			self:SetVerticalScroll(y)
		end
	end

end

local lastTrade
local function Edit_OnMouseUp(self, button) -- used to allow for clicking hotlinks in the editor and copying them to other chat windows
	local cp = self:GetCursorPosition()

	if (not cp) then return end

	local txt = self:GetText()
	local len = strlen(txt)
	local ls, le, i = nil, nil, cp

	while (not ls) do
		if (i == 0) then break end

		-- if find end of another link, can't be mid link on click
		if (strfind(strsub(txt, i, i + 3), '\124h\124r')) then break end

		if (strfind(strsub(txt, i, i + 1), '\124c')) then
			ls = i -- found link start
			break
		end

		i = i - 1
	end

	if (ls) then -- no point looking for end if no start
		i = cp

		while (not le) do
			if (i >= len - 2) then break end

			-- if find start of another link, can't be mid link on click
			if (strfind(strsub(txt, i, i + 1), '\124c')) then break end

			if (strfind(strsub(txt, i, i + 3), '\124h\124r')) then
				le = i + 3 -- found link end
				break
			end

			i = i + 1
		end
	end

	if (ls and le) then
		local activeWindow = ChatEdit_GetActiveWindow()
		if (IsModifiedClick('CHATLINK') and activeWindow) then
			activeWindow:Insert(strsub(txt, ls, le))
			activeWindow:SetFocus()
			return
		else
			local link = strsub(txt, ls, le)
			local reflink = strmatch(link, '\124H(.-)\124h')

			if (reflink and reflink:match('^trade:')) then -- handler for tradeskill links
				if (TradeSkillFrame and TradeSkillFrame:IsVisible() and lastTrade == reflink) then
					HideUIPanel(TradeSkillFrame)
					lastTrade = nil
				else
					SetItemRef(reflink, link)
					lastTrade = reflink
				end
			else
				SetItemRef(link, link, GetMouseButtonClicked()) -- not a tradeskill link
			end
		end
	end
end

-- TITLE BOX FUNC
local function Title_OnTextChanged(self)
	self:GetParent().headerText:SetFormattedText(L.Header, self:GetText())
end

-- ACTUAL EDITOR CONSTRUCTOR
function Chronicle:BuildEditor(f)
	-- edit box
	local t = CreateFrame('EditBox', nil, f.scroll)
	t:SetAutoFocus(false)
	t:SetFontObject(self.db.font)
	t:SetTextColor(self.db.colour.r, self.db.colour.g, self.db.colour.b, 1)
	t:SetMaxLetters(self.noteMax)
	t:SetMultiLine(true)
	t:SetPoint('TOPLEFT')
	t:SetPoint('BOTTOMRIGHT')
	t:SetHeight(f.scroll:GetHeight())
	t:SetWidth(f.scroll:GetWidth())
	t:SetScript('OnEditFocusGained', Edit_OnEditFocusGained)
	t:SetScript('OnEditFocusLost', Edit_OnEditFocusLost)
	t:SetScript('OnCursorChanged', Edit_OnCursorChanged)
	t:SetScript('OnEscapePressed', OnEscapePressed)
	t:SetScript('OnMouseUp', Edit_OnMouseUp)
	f.scroll.text = t
	f.text = t

	-- finish setting up scrollframe
	f.scroll:SetPoint('TOPLEFT',17,-57.5)
	f.scroll:SetPoint('BOTTOMRIGHT',-36,34)
	f.scroll:SetScript('OnMouseWheel', Scroll_OnMouseWheel)
	f.scroll:SetScript('OnScrollRangeChanged', Scroll_OnScrollRangeChanged)
	f.scroll:SetScript('OnSizeChanged', Scroll_OnSizeChanged)
	f.scroll:SetScript('OnVerticalScroll', Scroll_OnVerticalScroll)

	-- add editbox as child
	f.scroll:SetScrollChild(t)

	-- focus button
	local focus = CreateFrame('Button', nil, f)
	focus:SetPoint('TOPLEFT', 17, -57.5)
	focus:SetPoint('BOTTOMRIGHT', -36, 34)
	focus:SetScript('OnClick', Focus_OnClick)

	-- title box header
	local th = f:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	th:SetHeight(10)
	th:SetJustifyH('LEFT')
	th:SetText(L.Title)
	th:SetPoint('BOTTOMLEFT', 18, 18)

	-- title box
	local tb = CreateFrame('EditBox', nil, f)
	tb:SetHeight(14)
	tb:SetPoint('TOPLEFT', th, 'TOPRIGHT', 4, 2)
	tb:SetPoint('TOPRIGHT', f, 'BOTTOMRIGHT', -18.5, 30)
	tb:SetAutoFocus(false)
	tb:SetMultiLine(false)
	tb:SetMaxLetters(128)
	tb:SetFontObject('GameFontHighlightSmall')
	tb:SetScript('OnEscapePressed', OnEscapePressed)
	tb:SetScript('OnTextChanged', Title_OnTextChanged)
	f.title = tb
end

-- EDITOR DISPLAY TOGGLE
function Chronicle:ToggleEditor()
	if (not self.editor) then
		self:BuildEditorFrame()
	end

	if (self.editor:IsShown()) then
		self.editor:Hide()
	else
		self.editor:Show()
	end
end
