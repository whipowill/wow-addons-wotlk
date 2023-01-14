local Chronicle = LibStub('AceAddon-3.0'):GetAddon('Chronicle')
local L = LibStub('AceLocale-3.0'):GetLocale('Chronicle')
local indexDateFormat = '%d %b %Y\n%I:%M %p'

-- INDEX SCRIPT FUNCS
local firstShow = true
local function OnShow(self) -- on all but first show update index/page count due to possible changes in editor
	if (firstShow) then
		firstShow = false
	else
		Chronicle:SortPages(Chronicle.db.sortBy, Chronicle.db.sortAscend)
		Chronicle:UpdateIndexHeader()
	end
end

-- --------------------
-- INDEX CONSTRUCTOR --
-- --------------------
function Chronicle:BuildIndexFrame()
	local f = self:BuildBaseFrame('index', 'ChronicleIndexFrame')

	self.index = f

	f:SetPoint(self.db.layout.indexA, self.db.layout.indexX, self.db.layout.indexY)
	f:SetWidth(588)
	f:SetHeight(360.5)
	f:SetFrameLevel(self.editor:GetFrameLevel() + 4) -- make sure all frame elements are higher than the editor
	f:Hide()

	f:SetScript('OnShow', OnShow)

	SetPortraitToTexture(f.corner, 'Interface/EncounterJournal/UI-EJ-PortraitIcon')

	self:BuildSortButtons(f)

	self:BuildIndex(f)

	self:UpdateIndexHeader()

	-- setup opening sort
	for x = 1, #f.sortButtons do
		local s = f.sortButtons[x]

		if (s.sort == self.db.sortBy) then -- found the button we need to manipulate
			if (not self.db.sortAscend) then
				-- descending selected, this requires a 'double' click, call once with dontSort true to fake this
				s:GetScript('OnClick')(s, nil, nil, true)
			end

			s:GetScript('OnClick')(s) -- now call properly to sort

			break
		end
	end


end

function Chronicle:UpdateIndexHeader()
	if (self.index) then -- check index has been made
		if (#self.db.pages == 1) then
			self.index.headerText:SetText(L.ChroniclePage)
		else
			self.index.headerText:SetText(format(L.ChroniclePages, #self.db.pages))
		end
	end
end

-- ---------------------------
-- SORT BUTTON CONSTRUCTION --
-- ---------------------------
local function SortButton_Up(self, activate)
	if (activate) then
		self.up:SetAlpha(1.0)
		self.up:SetTexture('Interface/MainMenuBar/UI-MainMenu-ScrollUpButton-Up')
	else
		self.up:SetAlpha(0.8)
		self.up:SetTexture('Interface/MainMenuBar/UI-MainMenu-ScrollUpButton-Disabled')
	end
end

local function SortButton_Down(self, activate)
	if (activate) then
		self.down:SetAlpha(1.0)
		self.down:SetTexture('Interface/MainMenuBar/UI-MainMenu-ScrollDownButton-Up')
	else
		self.down:SetAlpha(0.8)
		self.down:SetTexture('Interface/MainMenuBar/UI-MainMenu-ScrollDownButton-Disabled')
	end
end

local function SortButton_DisableSelf(self)
	self.text:SetTextColor(1, 1, 1)
	SortButton_Up(self, false)
	SortButton_Down(self, false)
	self.active = false
end

local function SortButton_OnClick(self, _, _, dontSort) -- extra arg for manual call on first index open
	local otherBtns = self:GetParent().sortButtons -- disable other buttons

	for i = 1, #otherBtns do
		if (i ~= self.id) then
			otherBtns[i]:DisableSelf()
		end
	end

	self.text:SetTextColor(1, 0.81, 0) -- activate button

	if (self.active) then
		-- already active, toggle between ascending/descending
		if (self.ascend) then
			self.ascend = false
			SortButton_Up(self, false)
			SortButton_Down(self, true)
		else
			self.ascend = true
			SortButton_Up(self, true)
			SortButton_Down(self, false)
		end
	else
		-- not active, make active and set for ascending
		self.active = true
		self.ascend = true
		SortButton_Up(self, true)
		SortButton_Down(self, false)
	end

	if (not dontSort) then
		Chronicle:SortPages(self.sort, self.ascend) -- actually do the sort
	end
end

-- SORT BUTTON CONSTRUCTOR
local function CreateSortButton(p, text, id, sort, width, x)
	local f = CreateFrame('Button', nil, p)
	f:SetWidth(width)
	f:SetHeight(24)
	f:SetPoint('TOPLEFT', x, -29)

	f:SetScript('OnEnter', SortButton_OnEnter)
	f:SetScript('OnLeave', SortButton_OnLeave)
	f:SetScript('OnClick', SortButton_OnClick)
	f.DisableSelf = SortButton_DisableSelf

	f.ascend = true
	f.active = false
	f.id = id
	f.sort = sort

	f.text = f:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	f.text:SetHeight(10)
	f.text:SetPoint('TOP')
	f.text:SetText(text)
	f.text:SetTextColor(1, 1, 1)

	f.up = f:CreateTexture(nil, 'OVERLAY')
	f.up:SetHeight(20)
	f.up:SetWidth(20)
	f.up:SetTexture('Interface/MainMenuBar/UI-MainMenu-ScrollUpButton-Disabled')
	f.up:SetPoint('BOTTOM', -8, -4)
	f.up:SetAlpha(0.8)

	f.down = f:CreateTexture(nil, 'OVERLAY')
	f.down:SetHeight(20)
	f.down:SetWidth(20)
	f.down:SetTexture('Interface/MainMenuBar/UI-MainMenu-ScrollDownButton-Disabled')
	f.down:SetPoint('BOTTOM', 8, -4)
	f.down:SetAlpha(0.8)

	return f
end

-- BUILD SORT BUTTONS
function Chronicle:BuildSortButtons(f)
	f.sortButtons = {}

	tinsert(f.sortButtons, CreateSortButton(f, L.SortTitle, 1, 'title', 150, 21, -29))
	tinsert(f.sortButtons, CreateSortButton(f, L.SortCreated, 2, 'created', 75, 173, -29))
	tinsert(f.sortButtons, CreateSortButton(f, L.SortAuthor, 3, 'author', 110, 250, -29))
	tinsert(f.sortButtons, CreateSortButton(f, L.SortEdited, 4, 'edited', 75, 362, -29))
	tinsert(f.sortButtons, CreateSortButton(f, L.SortEditedBy, 5, 'editedby', 110, 439, -29))
end

-- --------------------------
-- INDEX LIST CONSTRUCTION --
-- --------------------------

-- SCROLLFRAME FUNCS
local function Scroll_OnMouseWheel(self, delta)
	local sb = self.scrollbar

	if (delta > 0) then delta = -1 else delta = 1 end

	sb:SetValue(sb:GetValue() + (delta * 1))
end

local function Scroll_OnVerticalScroll(self, offset)
	local sb = self.scrollbar
	local min, max = sb:GetMinMaxValues();

	offset = floor(offset + 0.5)

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

	local pages = Chronicle.db.pages
	local list = Chronicle.index.list
	local sID

	for x = 1, 12 do
		sID = Chronicle.sorted[x + offset]
		list[x]:SetupButton(sID, pages[sID].title, pages[sID].created, pages[sID].author, pages[sID].edited, pages[sID].editedby)
	end
end

-- INDEX LIST/PAGE BUTTON FUNCS
local function PageButton_OnClick(self)
	Chronicle:OpenPage(self.id)
end

local function PageButton_SetupButton(self, id, title, created, author, edited, editedby)
	self.id = id
	self.title:SetText(title)
	self.created:SetText(date(indexDateFormat, created))

	local s = strfind(author, '%s')

	if (s) then
		self.author:SetText(strsub(author, 1, s - 1) .. '\n' .. strsub(author, s + 3))
	else
		self.author:SetText(author)
	end

	self.edited:SetText(date(indexDateFormat, edited))

	s = nil
	s = strfind(editedby, '%s')

	if (s) then
		self.editedby:SetText(strsub(editedby, 1, s - 1) .. '\n' .. strsub(editedby, s + 3))
	else
		self.editedby:SetText(editedby)
	end

	self:Show()
end

local function PageButtonFontString(b, w, x, justify)
	local f = b:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
	f:SetHeight(24)
	f:SetWidth(w)
	f:SetPoint('LEFT', x, 0)
	f:SetJustifyH(justify)
	return f
end

-- LIST/PAGE BUTTON CONSTRUCTOR
local function CreatePageButton(p)
	local b = CreateFrame('Button', nil, p)
	b:SetHeight(24)
	b:SetWidth(536)
	b.title = PageButtonFontString(b, 150, 4, 'LEFT')
	b.created = PageButtonFontString(b, 75, 156, 'CENTER')
	b.author = PageButtonFontString(b, 110, 233, 'CENTER')
	b.edited = PageButtonFontString(b, 75, 345, 'CENTER')
	b.editedby = PageButtonFontString(b, 110, 422, 'CENTER')
	b:SetHighlightTexture('Interface/QuestFrame/UI-QuestTitleHighlight', 'ADD')
	b:SetScript('OnClick', PageButton_OnClick)
	b.SetupButton = PageButton_SetupButton

	b.id = -1

	return b
end

-- LIST CONSTRUCTOR
function Chronicle:BuildIndex(f)
	-- finish setting up scrollframe
	f.scroll:SetPoint('TOPLEFT',17,-57.5)
	f.scroll:SetPoint('BOTTOMRIGHT',-36,16)
	f.scroll:SetScript('OnMouseWheel', Scroll_OnMouseWheel)
	f.scroll:SetScript('OnVerticalScroll', Scroll_OnVerticalScroll)
	f.scroll.scrollbar.scrollStep = 1
	f.scroll.scrollbar:SetValue(0)

	f.list = {}

	for x = 1, 12 do
		f.list[x] = CreatePageButton(f)
		f.list[x]:SetPoint('TOPLEFT', 17, -57 - ((x - 1) * 24))

		if (floor(x / 2) == (x / 2)) then -- background every even entry
			local t = f.list[x]:CreateTexture(nil, 'BACKGROUND')
			t:SetAllPoints()
			t:SetTexture(0.3, 0.3, 0.3, 0.2)
		end
	end
end

-- -----------------------------
-- INDEX SORTED DISPLAY FUNCS --
-- -----------------------------
function Chronicle:PopulateIndexList()
	local pages = self.db.pages
	local scrollbar = self.index.scroll.scrollbar
	local list = self.index.list
	local sID
	local offset = 0

	if (#pages <= 12) then
		scrollbar:SetMinMaxValues(0, 0)

		_G[scrollbar:GetName() .. 'ScrollUpButton']:Disable()
		_G[scrollbar:GetName() .. 'ScrollDownButton']:Disable()
		_G[scrollbar:GetName() .. 'ThumbTexture']:Hide()

		if (#pages < 12) then
			for x = #pages + 1, 12 do -- hide any unused entries
				list[x]:Hide()
			end
		end
	else
		scrollbar:SetMinMaxValues(0, #pages - 12) -- set scroll bar to allow full view

		if (scrollbar:GetValue() + 12 > #pages) then -- offset would show 'beyond' the end of the page list, rectify
			offset = #pages - 12
		else
			offset = scrollbar:GetValue()
		end

		_G[scrollbar:GetName() .. 'ScrollUpButton']:Enable()
		_G[scrollbar:GetName() .. 'ScrollDownButton']:Enable()
		_G[scrollbar:GetName() .. 'ThumbTexture']:Show()
	end

	offset = floor(offset + 0.5) -- round out offset to nearest integer

	scrollbar:SetValue(offset)

	for x = 1, min(#pages, 12) do
		sID = self.sorted[x + offset]
		list[x]:SetupButton(sID, pages[sID].title, pages[sID].created, pages[sID].author, pages[sID].edited, pages[sID].editedby)
	end
end

-- INDEX DISPLAY TOGGLE
function Chronicle:ToggleIndex()
	if (not self.index) then
		self:BuildIndexFrame()
	end

	if (self.index:IsShown()) then
		self.index:Hide()
	else
		self.index:Show()
	end
end
