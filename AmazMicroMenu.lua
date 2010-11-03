
-- Config
local AMM_Scale = 1.0

local AMM_Font = TukuiCF.media.font
local AMM_FontSize = 12
local AMM_FontOutline = ""
local AMM_FontColor = {
	["R"] = 0.8,
	["G"] = 0.8,
	["B"] = 0.8,
}

local AMM_ButtonSize = 8

local AMM_MenuItems = {}
table.insert(AMM_MenuItems, {enabled = true, letter = "C", name = "Character"})
table.insert(AMM_MenuItems, {enabled = true, letter = "S", name = "Spells_Abilities"})
table.insert(AMM_MenuItems, {enabled = true, letter = "T", name = "Talents"})
table.insert(AMM_MenuItems, {enabled = true, letter = "A", name = "Achievements"})
table.insert(AMM_MenuItems, {enabled = true, letter = "Q", name = "Quests"})
table.insert(AMM_MenuItems, {enabled = true, letter = "F", name = "Social"})
table.insert(AMM_MenuItems, {enabled = true, letter = "G", name = "Guild"})
table.insert(AMM_MenuItems, {enabled = true, letter = "P", name = "PvP"})
table.insert(AMM_MenuItems, {enabled = true, letter = "D", name = "LFG"})
table.insert(AMM_MenuItems, {enabled = true, letter = "?", name = "Help"})

-- Stuff
local AMM = {}
local AMMFrame = CreateFrame("Frame","AMMFrame",UIParent)
AMMFrame:SetHeight(AMM_FontSize + 4)
AMMFrame:SetPoint("RIGHT",AmazChatLeftTopCaption,"RIGHT",-4,0)

--[[
AMMFrame:SetBackdropColor(1,0,0,1);
AMMFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
                                            edgeFile = "", 
                                            tile = false, tileSize = 0, edgeSize = 0, 
                                            insets = { left = 0, right = 0, top = 0, bottom = 0 }});
]]--

-- Create one menu item
function AMM:CreateMenuItem(menuName, menuInfo)
	local MIFrame = CreateFrame("BUTTON", "AMMMenu_".. menuName, AMMFrame, "SecureActionButtonTemplate")
	MIFrame:SetHeight(AMM_FontSize*AMM_Scale+2)
	MIFrame:SetWidth(AMM_ButtonSize*AMM_Scale)
	--TukuiDB.SetTemplate(MIFrame)
	
	MIFrame.letter = MIFrame:CreateFontString(nil, "ARTWORK")
	MIFrame.letter:SetPoint("center", MIFrame, "center", 0, 0)
	MIFrame.letter:SetFont(AMM_Font, AMM_FontSize*AMM_Scale, AMM_FontOutline)
	MIFrame.letter:SetTextColor(AMM_FontColor.R, AMM_FontColor.G, AMM_FontColor.B)
	MIFrame.letter:SetText(menuInfo.letter)
	MIFrame.letter:SetShadowOffset(TukuiDB.mult, -TukuiDB.mult)
	MIFrame.letter:Show()
	
	MIFrame:RegisterForClicks("AnyUp")
	MIFrame:SetScript("OnClick", function() AMM:ToggleDialog(menuInfo.letter) end)
	
	return MIFrame
end

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

function AMM:Init()
	
	-- Create menu items
	local previousItem = nil
	local menuItems = 0
	
	for menuName, menuInfo in pairs(AMM_MenuItems) do
		if (menuInfo.enabled == true) then
			local menuItem = AMM:CreateMenuItem(menuName, menuInfo)
			if (previousItem == nil) then
				menuItem:SetPoint("LEFT", AMMFrame, "LEFT", 0, 0)
			else
				menuItem:SetPoint("LEFT", previousItem, "RIGHT", 2, 0)
			end
			previousItem = menuItem
			
			menuItems = menuItems + 1
		end
	end
	
	AMMFrame:SetWidth((((menuItems - 2) * 2) + (menuItems * AMM_ButtonSize)) * AMM_Scale)
	
	AMM_MenuItems = nil
end

AMM.Init()
