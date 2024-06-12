local AceGUI = LibStub("AceGUI-3.0")

local function addLabel(text, parent)
	local label = AceGUI:Create("Label")
	label:SetText(text)
	label:SetFullWidth(true)
	label:SetFontObject(GameFontNormal)
	parent:AddChild(label)
	return label
end

local function addSpacer(parent)
	local spacer = AceGUI:Create("Label")
	spacer:SetText(" ")
	spacer:SetFontObject(GameFontNormal)
	parent:AddChild(spacer)
end

local function addSpacers(count, parent)
	for i = 1, count do
		addSpacer(parent)
	end
end

local mainFrame = AceGUI:Create("Window")
mainFrame:SetTitle("Easy Bronze")
mainFrame:SetWidth(280)
mainFrame:SetHeight(300)
mainFrame.sizer_se:Hide()
mainFrame.closebutton:ClearAllPoints()
mainFrame.closebutton:SetPoint("TOPRIGHT", mainFrame.frame, "TOPRIGHT", -3, -3)
mainFrame:Hide()

local tab = AceGUI:Create("ScrollFrame")
tab:SetFullWidth(true)
tab:SetHeight(200)

-- Spools
local label = addLabel("Caches", tab)
addSpacers(5, tab)

local cacheButton = CreateItemButton(EasyBronze.CACHE.id)
cacheButton:SetParent(tab.content)
cacheButton:SetPoint('TOPLEFT', label.frame, "BOTTOMLEFT", 0, -5)

-- Spools
local label = addLabel("Threads", tab)
addSpacers(5, tab)

local lastButton = nil
for _, spool in ipairs(EasyBronze.SPOOLS) do
	local button = CreateItemButton(spool.id)
	button:SetParent(tab.content)

	if lastButton == nil then
		button:SetPoint('TOPLEFT', label.frame, "BOTTOMLEFT", 0, -5)
	else
		button:SetPoint('TOPLEFT', lastButton, "TOPRIGHT", 5, 0)
	end

	lastButton = button
end

-- Caches
local label = addLabel("Bronze", tab)
addSpacers(3, tab)

local lastButton = nil
for _, cache in ipairs(EasyBronze.BRONZE_CACHES) do
	local button = CreateItemButton(cache.id)
	button:SetParent(tab.content)

	if lastButton == nil then
		button:SetPoint('TOPLEFT', label.frame, "BOTTOMLEFT", 0, -5)
	else
		button:SetPoint('TOPLEFT', lastButton, "TOPRIGHT", 5, 0)
	end

	lastButton = button
end

local currentTab = nil
local function selectTab(container, _, group)
	if currentTab ~= nil then
		tremove(container.children, 1)
		currentTab.frame:SetParent(nil)
		currentTab.frame:Hide()
	end

	if group == "loot" then
		currentTab = tab
		container:AddChild(currentTab)
	end
end

local tabGroup = AceGUI:Create("TabGroup")
tabGroup:SetFullWidth(true)
tabGroup:SetLayout("Flow")
tabGroup:SetTabs({ { text = "Loot", value = "loot" } })
tabGroup:SetCallback("OnGroupSelected", selectTab)
tabGroup:SelectTab("loot")
mainFrame:AddChild(tabGroup)


EasyBronze.gui.consumablesFrame = mainFrame;
