local Chronicle = LibStub('AceAddon-3.0'):GetAddon('Chronicle')

local function CreateFrameTexture(p, layer, h, w, tex, minx, maxx, miny, maxy)
	local t = p:CreateTexture(nil, layer)
	if (h) then t:SetHeight(h) end
	if (w) then t:SetWidth(w) end
	t:SetTexture(tex)
	t:SetTexCoord(minx, maxx, miny, maxy)
	return t
end

-- ---------------------
-- FRAME SCRIPT FUNCS --
-- ---------------------
local function OnDragStart(self)
	self:StartMoving()
end

local function OnDragStop(self)
	self:StopMovingOrSizing()

	local point, _, _, x, y = self:GetPoint(1)

	Chronicle.db.layout[self.intName .. 'A'] = point
	Chronicle.db.layout[self.intName .. 'X'] = x
	Chronicle.db.layout[self.intName .. 'Y'] = y
end

local tw, tx
local max, min = math.max, math.min
local function OnSizeChanged(self, w, h)
	tw = 0

	for tx = 0, 4 do
		tw = max(0, min((w - 160) - (tx * 100), 100))

		if (tw > 0) then
			self.top[tx]:Show()
			self.top[tx]:SetWidth(tw)
			self.top[tx]:SetTexCoord(0.5, 0.5 + (0.004 * tw), 0, 0.5)
		else
			self.top[tx]:Hide()
		end
	end
end

local function CloseButton_OnClick(self)
	self:GetParent():Hide()
end

-- --------------------------
-- BASE FRAME CONSTRUCTION --
-- --------------------------
function Chronicle:BuildBaseFrame(intName, extName)
	local f = CreateFrame('Frame', extName, UIParent)
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag('LeftButton')
	f:SetScript('OnDragStart', OnDragStart)
	f:SetScript('OnDragStop', OnDragStop)
	f:SetScript('OnSizeChanged', OnSizeChanged)

	f.intName = intName

	table.insert(UISpecialFrames, extName)

	-- corner icon
	local t = f:CreateTexture(nil, 'BACKGROUND')
	t:SetHeight(43.5)
	t:SetWidth(43.5)
	t:SetPoint('TOPLEFT', 6, -5)
	f.corner = t

	-- top, multiple textures to prevent stretching (looks better)
	f.top = {}

	for x = 0, 4 do
		f.top[x] = f:CreateTexture(nil, 'BORDER')
		f.top[x]:SetTexture('Interface/TaxiFrame/UI-TaxiFrame-TopLeft')
		f.top[x]:SetHeight(96)
		f.top[x]:SetPoint('TOPLEFT', 96 + (x * 100), 0)
		f.top[x]:Hide()
	end

	-- top left
	t = CreateFrameTexture(f, 'BORDER', 96, 96, 'Interface/TaxiFrame/UI-TaxiFrame-TopLeft', 0, 0.5, 0, 0.5)
	t:SetPoint('TOPLEFT')

	-- top right
	t = CreateFrameTexture(f, 'BORDER', 96, 96, 'Interface/TaxiFrame/UI-TaxiFrame-TopRight', 0, 1, 0, 0.5)
	t:SetPoint('TOPRIGHT', 16, 0)

	-- left (stretchy)
	t = CreateFrameTexture(f, 'BORDER', nil, nil, 'Interface/TaxiFrame/UI-TaxiFrame-BotLeft', 0, 0.5, 0, 0.5)
	t:SetPoint('TOPLEFT', 0, - 96)
	t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', 96, 48)

	-- right (stretchy)
	t = CreateFrameTexture(f, 'BORDER', nil, nil, 'Interface/TaxiFrame/UI-TaxiFrame-BotRight', 0, 1, 0, 0.5)
	t:SetPoint('TOPRIGHT', 16, - 96)
	t:SetPoint('BOTTOMLEFT', f, 'BOTTOMRIGHT', -80, 48)

	-- bot left
	t = CreateFrameTexture(f, 'BORDER', 96, 96, 'Interface/TaxiFrame/UI-TaxiFrame-BotLeft', 0, 0.5, 0.5, 1)
	t:SetPoint('BOTTOMLEFT', 0, -48)

	-- bot right
	t = CreateFrameTexture(f, 'BORDER', 96, 96, 'Interface/TaxiFrame/UI-TaxiFrame-BotRight', 0, 1, 0.5, 1)
	t:SetPoint('BOTTOMRIGHT', 16, -48)

	-- bottom (stretchy)
	t = CreateFrameTexture(f, 'BORDER', 96, 96, 'Interface/TaxiFrame/UI-TaxiFrame-BotLeft', 0.5, 1, 0.5, 1)
	t:SetPoint('TOPLEFT', f, 'BOTTOMLEFT', 96, 48)
	t:SetPoint('BOTTOMRIGHT', -80, -48)

	-- center (stretchy)
	t = f:CreateTexture(nil, 'ARTWORK')
	t:SetTexture(0, 0, 0, 1)
	t:SetPoint('TOPLEFT', 18, -58)
	t:SetPoint('BOTTOMRIGHT', -19, 17)

	-- create header
	local b = CreateFrame('Button', nil, f)
	b:SetHeight(10)
	b:SetPoint('TOPLEFT', 60, -12)
	b:SetPoint('TOPRIGHT', -36, -12)
	f.header = b

	local s = b:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
	s:SetAllPoints()
	f.headerText = s

	-- create close button
	b = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
	b:SetHeight(24)
	b:SetWidth(24)
	b:SetPoint('TOPRIGHT', -6.5, -6)
	b:SetScript('OnClick', CloseButton_OnClick)

	-- scroll frame
	local sf = CreateFrame('ScrollFrame', nil, f)
	sf:EnableMouseWheel(true)
	f.scroll = sf

	-- scrollbar (slider)
	local sb = CreateFrame('Slider', extName .. 'Slider', sf, 'UIPanelScrollBarTemplate')
	sb:SetPoint('TOPLEFT', sf, 'TOPRIGHT', 2, -16)
	sb:SetPoint('BOTTOMLEFT', sf, 'BOTTOMRIGHT', 2, 15)
	sb:SetWidth(16)
	sb:SetMinMaxValues(0, 0)
	sb:SetValue(0)
	_G[sb:GetName() .. 'ScrollUpButton']:Disable()
	_G[sb:GetName() .. 'ScrollDownButton']:Disable()
	_G[sb:GetName() .. 'ThumbTexture']:Hide()
	sf.scrollbar = sb

	-- slider background
	t = sb:CreateTexture(nil, 'BACKGROUND')
	t:SetAllPoints(sb)
	t:SetTexture(0.1, 0.1, 0.1, 0.3)

	return f
end
