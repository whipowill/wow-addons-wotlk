Chronicle = LibStub('AceAddon-3.0'):NewAddon('Chronicle', 'AceConsole-3.0', 'AceEvent-3.0')
Chronicle.noteMax = 20000 -- set large enough to allow a decent amount of text without lag issues becoming (to) apparent
Chronicle.sorted = {}

local L = LibStub('AceLocale-3.0'):GetLocale('Chronicle')

-- -------------------
-- HOOKED FUNCTIONS --
-- -------------------
local insertLinkTime = 0
local function ChatEdit_InsertLink(text)
	if (Chronicle.focus) then
		if (GetTime() ~= insertLinkTime) then -- hack to fix an apparent weird bug where clicking a link in chat fires twice
			Chronicle.editor.text:Insert(text)
			insertLinkTime = GetTime()
		end
	end
end

local function QuestLogTitleButton_OnClick(quest, button)
	if (Chronicle.focus) then
		if (IsModifiedClick() and IsModifiedClick('CHATLINK')) then
			local link = GetQuestLink(quest:GetID())

			if (link) then
				ChatEdit_InsertLink(link)
			end
		end
	end
end

local function AchievementButton_OnClick(achieve, _, _, ignore)
	if (Chronicle.focus) then
		if (IsModifiedClick() and IsModifiedClick('CHATLINK') and not ignore) then
			local link = GetAchievementLink(achieve.id)

			if (link) then
				ChatEdit_InsertLink(link)
			end
		end
	end
end

-- I don't want to do this, but can find no other way to allow link copying to the chat window with the present UI
local Old_ChatEdit_DeactivateChat
local function Chronicle_ChatEdit_DeactivateChat(editBox)
	if (IsModifiedClick('CHATLINK') and Chronicle.editor:IsVisible() and MouseIsOver(Chronicle.editor)) then
		return
	else
		return Old_ChatEdit_DeactivateChat(editBox)
	end
end

-- ---------------------------
-- MOB SETUP AND BASE FUNCS --
-- ---------------------------
function Chronicle:OnInitialize()
	self:RegisterChatCommand('chronicle', 'SlashHandler')
	self:RegisterChatCommand('journal', 'SlashHandler')

	if (not ChronicleDB) then
		ChronicleDB = {
			pages = {
				[1] = {
					title = L.WelcomeToChronicle,
					text = L.WelcomeToChronicleLong,
					created = time(),
					author = L.Chronicle,
					edited = time(),
					editedby = L.Chronicle,
				},
			},
			active = 1,
			sortBy = 'title',
			sortAscend = true,
			font = 'ChatFontNormal',
			colour = {
				r = 1,
				g = 1,
				b = 1,
			},
			layout = {
				editorA = 'CENTER',
				editorX = 0,
				editorY = 0,
				editorW = 280,
				editorH = 200,
				indexA = 'CENTER',
				indexX = 0,
				indexY = 0,
			}
		}
	end

	self.db = ChronicleDB

	self:RegisterEvent('ADDON_LOADED')

	hooksecurefunc('ChatEdit_InsertLink', ChatEdit_InsertLink)
	hooksecurefunc('QuestLogTitleButton_OnClick', QuestLogTitleButton_OnClick)

	-- I don't want to do this, but can find no other way to allow link copying to the chat window with the present UI
	Old_ChatEdit_DeactivateChat = ChatEdit_DeactivateChat
	ChatEdit_DeactivateChat = Chronicle_ChatEdit_DeactivateChat
end

function Chronicle:OnEnable()
	-- Nothing to do
end

function Chronicle:SlashHandler(cmd)
	if (cmd ~= '') then
		self:Print(L.SlashChronicle)
	else
		self:ToggleEditor()
	end
end

-- -----------------
-- EVENT HANDLERS --
-- -----------------
function Chronicle:ADDON_LOADED(_, addon)
	if (addon == 'Blizzard_AchievementUI') then
		hooksecurefunc('AchievementButton_OnClick', AchievementButton_OnClick)
	end
end

-- --------------------
-- PAGE MANIPULATION --
-- --------------------
function Chronicle:NewPage()
	local new = {
		title = '',
		text = '',
		created = time(),
		author = format('%s - %s', UnitName('player'), GetRealmName()),
		edited = time(),
		editedby = format('%s - %s', UnitName('player'), GetRealmName()),
	}

	tinsert(self.db.pages, new)
	self:OpenPage(#self.db.pages)

	if (self.index and self.index:IsShown()) then
		self:UpdateIndexHeader()
	end
end

function Chronicle:SavePage(ignoreCtrl)
	self.db.pages[self.db.active].text = self.editor.text:GetText()
	self.db.pages[self.db.active].title = self.editor.title:GetText()
	self.db.pages[self.db.active].edited = time()
	self.db.pages[self.db.active].editedby = format('%s - %s', UnitName('player'), GetRealmName())

	if (not ignoreCtrl and IsControlKeyDown()) then
		ReloadUI()
	end

	if (self.index and self.index:IsShown()) then -- if index is visible, update sorted list
		self:SortPages(self.db.sortBy, self.db.sortAscend)
	end
end

function Chronicle:Undo()
	self:OpenPage(self.db.active, true)
end

function Chronicle:DeletePage()
	if (IsControlKeyDown() and self.db.active ~= 1) then
		tremove(self.db.pages, self.db.active)
		self:OpenPage(1, true)
	end

	if (self.index and self.index:IsShown()) then -- if index is visible, update sorted list
		self:SortPages(self.db.sortBy, self.db.sortAscend)
		self:UpdateIndexHeader()
	end
end

function Chronicle:OpenPage(page, dontSave)
	if (not dontSave) then
		self:SavePage(true) -- save previous page unless instructed not to
	end

	if (page <= #self.db.pages) then
		self.editor.text:SetText(self.db.pages[page].text)
		self.editor.text:SetCursorPosition(0)
		self.editor.title:SetText(self.db.pages[page].title)
		self.db.active = page

		if (page == 1) then -- cannot delete the first page
			self.editor.microDelete:Disable()
		else
			self.editor.microDelete:Enable()
		end
	end
end

function Chronicle:RunPage()
	if (IsControlKeyDown() and IsAltKeyDown()) then
		RunScript(self.editor.text:GetText())
	end
end

-- -------------------
-- OPTION FUNCTIONS --
-- -------------------
local fontChoices = {
	[1] = 'ChatFontNormal',
	[2] = 'ChatFontSmall',
	[3] = 'GameFontNormal',
	[4] = 'GameFontNormalSmall',
	[5] = 'GameFontNormalLarge',
	[6] = 'QuestTitleFont',
	[7] = 'QuestFont',
	[8] = 'QuestFontNormalSmall',
}

function Chronicle:ChangeFont()
	local current

	for i = 1, #fontChoices do
		if (fontChoices[i] == self.db.font) then
			current = i
		end
	end

	current = (current % 8) + 1

	self.db.font = fontChoices[current]
	self.editor.text:SetFontObject(fontChoices[current])
end

local function ChangeColour_PickerFunc(restore)
	local nR, nG, nB

	if (restore) then
		nR, nG, nB = unpack(restore)
	else
		nR, nG, nB = ColorPickerFrame:GetColorRGB()
	end

	Chronicle.db.colour.r = nR
	Chronicle.db.colour.g = nG
	Chronicle.db.colour.b = nB
	Chronicle.editor.text:SetTextColor(nR, nG, nB)
end

function Chronicle:ChangeColour()
	ColorPickerFrame:SetColorRGB(self.db.colour.r, self.db.colour.g, self.db.colour.b)
	ColorPickerFrame.hasOpacity,ColorPickerFrame.opacity = false, 1
	ColorPickerFrame.previousValues = {self.db.colour.r, self.db.colour.g, self.db.colour.b, 1}
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = ChangeColour_PickerFunc, ChangeColour_PickerFunc, ChangeColour_PickerFunc
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

-- -----------------------
-- INDEX SORT FUNCTIONS --
-- -----------------------
local function SortPages(a, b)
	local sortBy = Chronicle.db.sortBy

	if (Chronicle.db.sortAscend) then
		return Chronicle.db.pages[a][sortBy] < Chronicle.db.pages[b][sortBy]
	else
		return Chronicle.db.pages[a][sortBy] > Chronicle.db.pages[b][sortBy]
	end
end

function Chronicle:SortPages(sort, ascend)
	self.db.sortBy = sort
	self.db.sortAscend = ascend

	local sorted = self.sorted -- local ref

	wipe(sorted) -- wipe contents for new sort

	for x = 1, #self.db.pages do
		sorted[x] = x -- setup table for new sort
	end

	table.sort(sorted, SortPages)

	self:PopulateIndexList()
end