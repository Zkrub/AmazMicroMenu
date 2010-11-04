
-- Config
local AMM_Scale = 1.0
local AMM_Enable_TukPanel = false	-- Enable micro menu with Tukui panel as background
local AMM_TukDatatext = 5 			-- Set position if you wish to enable it

local AMM_Font = TukuiCF.media.font
local AMM_FontSize = 12
local AMM_FontOutline = ""
local AMM_FontColor = {
	["R"] = 0.8,
	["G"] = 0.8,
	["B"] = 0.8,
}

local AMM_ButtonSize = 10
local AMM_ButtonPadding = 2

local AMM_MenuItems = {}
table.insert(AMM_MenuItems, {enabled = true, letter = "C", name = "Character"}) 		-- #1
table.insert(AMM_MenuItems, {enabled = true, letter = "S", name = "Spells_Abilities"})	-- #2
table.insert(AMM_MenuItems, {enabled = true, letter = "T", name = "Talents"})			-- #3
table.insert(AMM_MenuItems, {enabled = true, letter = "A", name = "Achievements"})		-- #4
table.insert(AMM_MenuItems, {enabled = true, letter = "Q", name = "Quests"})			-- #5
table.insert(AMM_MenuItems, {enabled = true, letter = "F", name = "Social"})			-- #6
table.insert(AMM_MenuItems, {enabled = true, letter = "G", name = "Guild"})				-- #7
table.insert(AMM_MenuItems, {enabled = true, letter = "P", name = "PvP"})				-- #8
table.insert(AMM_MenuItems, {enabled = true, letter = "D", name = "LFG"})				-- #9
table.insert(AMM_MenuItems, {enabled = true, letter = "?", name = "Help"})				-- #10

-- Set up basic stuff
local AMM = {}
local AMMFrame = CreateFrame("Frame","AMMFrame",UIParent)
AMMFrame:SetHeight(18 * AMM_Scale)

if (AMM_TukDatatext > 0) then
	AMM_FontSize = TukuiCF["datatext"].fontsize
	AMM_FontColor = { R = 1.0, G = 1.0, B = 1.0 }
	TukuiDB.PP(AMM_TukDatatext, AMMFrame)
elseif (AMM_Enable_TukPanel == true) then
	TukuiDB.CreatePanel(AMMFrame, AMMFrame:GetWidth() + 8, AMMFrame:GetHeight(), "CENTER", UIParent, "CENTER", 0, 0)
else
	AMMFrame:SetPoint("RIGHT", AmazChatLeftTopCaption, "RIGHT", -8, 0)
end


-- Create menu
function AMM:CreateMenuItems()

	local previousItem = nil
	local menuItems = 0
	
	--for menuName, menuInfo in pairs(AMM_MenuItems) do
	for i = 1, table.getn(AMM_MenuItems) do
		local menuInfo = AMM_MenuItems[i]
		if (menuInfo.enabled == true) then
	
			local MIFrame = CreateFrame("BUTTON", "AMMMenu_".. i, AMMFrame, "SecureActionButtonTemplate")
			MIFrame:SetHeight(AMM_FontSize*AMM_Scale)
			MIFrame:SetWidth(AMM_ButtonSize*AMM_Scale)
			MIFrame:SetBackdrop({bgFile = TukuiCF["media"].blank,
				edgeFile = "",
				tile = false, tileSize = 0, edgeSize = 0,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }});
			MIFrame:SetBackdropColor(0,0,0,0)
			
			if (previousItem == nil) then
				if (AMM_Enable_TukPanel == true) then
					MIFrame:SetPoint("LEFT", AMMFrame, "LEFT", 3, 0)
				else
					MIFrame:SetPoint("LEFT", AMMFrame, "LEFT", 0, 0)
				end
			else
				MIFrame:SetPoint("LEFT", previousItem, "RIGHT", AMM_ButtonPadding * AMM_Scale, 0)
			end
			
			MIFrame:SetScript("OnEnter", function(self, motion) self:SetBackdropColor(0.75,0.6,0.1,0.4) end)
			MIFrame:SetScript("OnLeave", function(self, motion) self:SetBackdropColor(0,0,0,0) end)
			
			--TukuiDB.SetTemplate(MIFrame)
			
			MIFrame.letter = MIFrame:CreateFontString(nil, "ARTWORK")
			MIFrame.letter:SetPoint("CENTER", MIFrame, "CENTER", 0.5, 0)
			MIFrame.letter:SetFont(AMM_Font, AMM_FontSize*AMM_Scale, AMM_FontOutline)
			--MIFrame.letter:SetTextColor(AMM_FontColor.R, AMM_FontColor.G, AMM_FontColor.B)
			MIFrame.letter:SetText(menuInfo.letter)
			--MIFrame.letter:SetShadowOffset(TukuiDB.mult, -TukuiDB.mult)
			MIFrame.letter:Show()
			
			MIFrame:RegisterForClicks("AnyUp")
			MIFrame:SetScript("OnClick", function() AMM:ToggleDialog(menuInfo.letter) end)
			
			
			previousItem = MIFrame
			menuItems = menuItems + 1
		end
	end
	
	AMMFrame:SetWidth(((menuItems * AMM_ButtonSize) + ((menuItems - 2) * AMM_ButtonPadding)) * AMM_Scale)
end

-- Handler for the diffrent menu clicks
function AMM:ToggleDialog(cmd)
	if (cmd == "C") then -- Character Info
		ToggleCharacter("PaperDollFrame")
	elseif (cmd == "S") then -- Spells & Abilities
		ToggleFrame(SpellBookFrame)
	elseif (cmd == "T") then -- Talents
		ToggleTalentFrame()
	elseif (cmd == "A") then -- Achievements
		ToggleAchievementFrame()
	elseif (cmd == "Q") then -- Quest Log
		ToggleFrame(QuestLogFrame)
	elseif (cmd == "F") then -- Social
		ToggleFriendsFrame()
	elseif (cmd == "G") then -- Guild
		ToggleGuildFrame()
	elseif (cmd == "P") then -- PvP
		TogglePVPFrame()
	elseif (cmd == "D") then -- Dungeon Finder
		ToggleLFDParentFrame()
	elseif (cmd == "?") then -- Help
		ToggleHelpFrame()
	end
end

-- Check which menu items we should show
function AMM:CheckAvailable()
	-- Check for talent points
	if GetNumTalentPoints ~= nil then
		if GetNumTalentPoints() == 0 then
			AMM_MenuItems[3].enabled = false
		end
	end
	
	-- Check for achieve
	if (UnitLevel("player") < AchievementMicroButton.minLevel) then
		AMM_MenuItems[4].enabled = false
	end
	
	-- Check for guild
	if (not IsInGuild()) then
		AMM_MenuItems[7].enabled = false
	end
	
	-- Check for PvP lvl req
	if (UnitLevel("player") < PVPMicroButton.minLevel) then
		AMM_MenuItems[8].enabled = false
	end
	
	-- Check for LFG lvl req
	if (UnitLevel("player") < LFDMicroButton.minLevel) then
		AMM_MenuItems[9].enabled = false
	end
end

function AMMFrame:Clear()
	local childs = {AMMFrame:GetChildren()}
	for i = 1, table.getn(childs) do
		childs[i]:Hide()
	end
end

function AMMFrame:PLAYER_ENTERING_WORLD(event)
	AMMFrame:DoRedraw()
end

function AMMFrame:PLAYER_LEVEL_UP(event)
	AMMFrame:DoRedraw()
end

function AMMFrame:DoRedraw()
	AMMFrame:Clear()
	
	AMM:CheckAvailable()
	
	AMM:CreateMenuItems()
end

function AMM:Init()
    AMMFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	AMMFrame:RegisterEvent("PLAYER_LEVEL_UP")
	
	AMMFrame:SetScript("OnEvent", function(self, event, ...)
		AMMFrame[event](self, event, ...)
	end)
end

AMM.Init()
