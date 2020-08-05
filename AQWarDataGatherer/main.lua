-- get gossips from war effort NPCs, printing the progress
-- This us my very first LUA/ WoW Addon experience, don't blame my style or skills.

debug = 0
print('AQ War Data Gatherer (Horde Side) started. Speak with the War Effort NPCs to gather the data, and then use /aqwar to call the results interface. Note that if you use horizontal tab as a delimiter, it will show as \"?\" in the wow frame, but pasting it outside wow will still produce yhe correct horizontal tab.')



-- Delimiter for the output data
output_delimiter = "\t" -- \t for horizontal tab

-- Those are set for Horde side
alliance_npc_name = "Commander Stronghammer"
horde_npc_name = "Warlord Gorchuk"

a_metal1_index = 17
a_metal2_index = 23
a_metal3_index = 30
a_herb1_index = 24
a_herb2_index = 37 
a_herb3_index = 43
a_leather1_index = 18
a_leather2_index = 23
a_leather3_index = 30
a_bandage1_index = 24
a_bandage2_index = 29
a_bandage3_index = 35
a_food1_index = 26
a_food2_index = 39
a_food3_index = 45

h_metal1_index = 11
h_metal2_index = 20
h_metal3_index = 29
h_herb1_index = 10
h_herb2_index = 15 
h_herb3_index = 20
h_leather1_index = 19
h_leather2_index = 30
h_leather3_index = 37
h_bandage1_index = 30
h_bandage2_index = 38
h_bandage3_index = 45
h_food1_index = 19
h_food2_index = 25
h_food3_index = 32

alliance_data_names_header = "Copper Bar" .. output_delimiter .. "Iron Bar" .. output_delimiter .. "Thorium Bar" .. output_delimiter .. "Stranglekelp" .. output_delimiter .. "Purple Lotus" .. output_delimiter .. "Arthas' Tears" .. output_delimiter .. "Light Leather" .. output_delimiter .. "Medium Leather" .. output_delimiter .. "Thick Leather" .. output_delimiter .. "Linen Bandage" .. output_delimiter .. "Silk Bandage" .. output_delimiter .. "Runecloth Bandage" .. output_delimiter .. "Rainbow Fin Albacore" .. output_delimiter .. "Roast Raptor" .. output_delimiter .. "Spotted Yellowtail"

horde_data_names_header = "Copper Bar" .. output_delimiter .. "Tin Bar" .. output_delimiter .. "Mithril Bar" .. output_delimiter .. "Peacebloom" .. output_delimiter .. "Firebloom" .. output_delimiter .. "Purple Lotus" .. output_delimiter .. "Heavy Leather" .. output_delimiter .. "Thick Leather" .. output_delimiter .. "Rugged Leather" .. output_delimiter .. "Wool Bandage" .. output_delimiter .. "Mageweave Bandage" .. output_delimiter .. "Runecloth Bandage" .. output_delimiter .. "Lean Wolf Steak" .. output_delimiter .. "Spotted Yellowtail" .. output_delimiter .. "Baked Salmon"

local alliance_gossip_position = 2
local horde_gossip_position = 2
local a_result_array = {}
local h_result_array = {}
local a_result
local h_result

a_date = date("%y-%m-%d %H:%M")
h_date = date("%y-%m-%d %H:%M")

a_data = "No data for Alliance side, or the data is incomplete, please speak to " .. alliance_npc_name .. "!"
h_data = "No data for Horde side, or the data is incomplete, please speak to " .. horde_npc_name .. "!"


SLASH_AQWARGOSSIP1 = "/aqwar"
SlashCmdList["AQWARGOSSIP"] = function(msg)

	if a_food3 then
		a_data = a_metal1 .. output_delimiter .. a_metal2 .. output_delimiter .. a_metal3 .. output_delimiter .. a_herb1 .. output_delimiter .. a_herb2 .. output_delimiter .. a_herb3 .. output_delimiter .. a_leather1 .. output_delimiter .. a_leather2 .. output_delimiter .. a_leather3 .. output_delimiter .. a_bandage1 .. output_delimiter .. a_bandage2 .. output_delimiter .. a_bandage3 .. output_delimiter .. a_food1 .. output_delimiter .. a_food2 .. output_delimiter .. a_food3
		print('Alliance side: ' .. a_data)
		
	else
		print('Alliance: No data or data incomplete, please speak to ' .. alliance_npc_name .. '!')
		
	end
	
	if h_food3 then
		h_data = h_metal1 .. output_delimiter .. h_metal2 .. output_delimiter .. h_metal3 .. output_delimiter .. h_herb1 .. output_delimiter .. h_herb2 .. output_delimiter .. h_herb3 .. output_delimiter .. h_leather1 .. output_delimiter .. h_leather2 .. output_delimiter .. h_leather3 .. output_delimiter .. h_bandage1 .. output_delimiter .. h_bandage2 .. output_delimiter .. h_bandage3 .. output_delimiter .. h_food1 .. output_delimiter .. h_food2 .. output_delimiter .. h_food3
		print('Horde side: ' .. h_data)
		
	else
		print('Horde: No data or data incomplete, please speak to ' .. horde_npc_name .. '!')
	end
	
	if a_food3 and h_food3 then
		resultsframe("Alliance data:\n" .. "Date Collected" .. output_delimiter .. alliance_data_names_header .. "\n" .. a_date .. output_delimiter .. a_data .. "\n\n\nHorde data:\n" .. "Date Collected" .. output_delimiter .. horde_data_names_header .. "\n" .. h_date .. output_delimiter .. h_data .. "\n\n\nCombined data (Alliance, Horde):\n" .. "Date Collected (Alliance)" .. output_delimiter .. alliance_data_names_header .. output_delimiter .. horde_data_names_header .. "\n" .. a_date .. output_delimiter .. a_data .. output_delimiter .. h_data)
	else
		print('Collect all the data before calling the results frame.')
	end
	
	
end 

function gossiptexttowords() -- Get the gossip, and make array/list with the words
	GossipText = GetGossipText()
	gtarray = {}
	for w in GossipText:gmatch("%S+") do
		w = w:gsub('%.', '') -- remove the extra dots from the numbers
		table.insert(gtarray, w)
	end
end

function debug_print(text)
	if debug == 1 then
		print(text)
	end
end


-- Resizeable frame, taken from the Internet, no experience here, just reusing
function resultsframe(text)
    local f = CreateFrame("Frame", "KethoEditBox", UIParent, "DialogBoxFrame")
    f:SetPoint("CENTER")
    f:SetSize(600, 500)
    
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
        edgeSize = 16,
        insets = { left = 8, right = 6, top = 8, bottom = 8 },
    })
    f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
    
    -- Movable
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            self:StartMoving()
        end
    end)
    f:SetScript("OnMouseUp", f.StopMovingOrSizing)
    
    -- ScrollFrame
    local sf = CreateFrame("ScrollFrame", "KethoEditBoxScrollFrame", KethoEditBox, "UIPanelScrollFrameTemplate")
    sf:SetPoint("LEFT", 16, 0)
    sf:SetPoint("RIGHT", -32, 0)
    sf:SetPoint("TOP", 0, -16)
    sf:SetPoint("BOTTOM", KethoEditBoxButton, "TOP", 0, 0)
    
    -- EditBox
    local eb = CreateFrame("EditBox", "KethoEditBoxEditBox", KethoEditBoxScrollFrame)
    eb:SetSize(sf:GetSize())
    eb:SetMultiLine(true)
    eb:SetAutoFocus(false) -- dont automatically focus
    eb:SetFontObject("NumberFont_Small")
    eb:SetScript("OnEscapePressed", function() f:Hide() end)
	eb:SetText(text)
	eb:HighlightText()
    sf:SetScrollChild(eb)
    
    -- Resizable
    f:SetResizable(true)
    f:SetMinResize(150, 100)
    
    local rb = CreateFrame("Button", "KethoEditBoxResizeButton", KethoEditBox)
    rb:SetPoint("BOTTOMRIGHT", -6, 7)
    rb:SetSize(16, 16)
    
    rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    
    rb:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            f:StartSizing("BOTTOMRIGHT")
            self:GetHighlightTexture():Hide() -- more noticeable
        end
    end)
	
    rb:SetScript("OnMouseUp", function(self, button)
        f:StopMovingOrSizing()
        self:GetHighlightTexture():Show()
        eb:SetWidth(sf:GetWidth())
    end)
    f:Show()
end

-- Start --
local Gossip_Frame = CreateFrame("Frame")
Gossip_Frame:RegisterEvent("GOSSIP_SHOW")

Gossip_Frame:SetScript("OnEvent",
	function(self, event, ...)
		
		if UnitName("target") == alliance_npc_name then
			print('Collecting data for Alliance, please do not interrupt...')
	
			if alliance_gossip_position == 7 then
				print('Data collection for Alliance completed.')
				alliance_gossip_position = 2
				return
			end
	
			-- Check where we are
			if GetNumGossipOptions() == 6 then
			-- debug_print('We are at main gossip window, 6 options available. Entering sub-gossip # ' .. alliance_gossip_position )
			SelectGossipOption(alliance_gossip_position)
		
			elseif GetNumGossipOptions() == 1 then
		
				-- debug_print('We are in the sub-gossip window, as only one option is available')

				if alliance_gossip_position == 2 then
					debug_print('Metal')
					gossiptexttowords()
					
					a_metal1 = gtarray[a_metal1_index]
					a_metal2 = gtarray[a_metal2_index]
					a_metal3 = gtarray[a_metal3_index]
					debug_print(a_metal1)
					debug_print(a_metal2)
					debug_print(a_metal3)
									
				elseif alliance_gossip_position == 3 then
					debug_print('Herbs')
					gossiptexttowords()
					a_herb1 = gtarray[a_herb1_index]
					a_herb2 = gtarray[a_herb2_index]
					a_herb3 = gtarray[a_herb3_index]
					debug_print(a_herb1)
					debug_print(a_herb2)
					debug_print(a_herb3)
				
				elseif alliance_gossip_position == 4 then
					debug_print('Skins')
					gossiptexttowords()
					a_leather1 = gtarray[a_leather1_index]
					a_leather2 = gtarray[a_leather2_index]
					a_leather3 = gtarray[a_leather3_index]
					debug_print(a_leather1)
					debug_print(a_leather2)
					debug_print(a_leather3)
						
				elseif alliance_gossip_position == 5 then
					debug_print('Bandages')
					gossiptexttowords()
					a_bandage1 = gtarray[a_bandage1_index]
					a_bandage2 = gtarray[a_bandage2_index]
					a_bandage3 = gtarray[a_bandage3_index]
					debug_print(a_bandage1)
					debug_print(a_bandage2)
					debug_print(a_bandage3)
							
				elseif alliance_gossip_position == 6 then
					debug_print('Cooked Goods')
					gossiptexttowords()
				
					a_food1 = gtarray[a_food1_index]
					a_food2 = gtarray[a_food2_index]
					a_food3 = gtarray[a_food3_index]
					a_date = date("%y-%m-%d %H:%M")
					debug_print(a_food1)
					debug_print(a_food2)
					debug_print(a_food3)
				
				else
					debug_print('I\'m not sure where we are')
				end
				
				-- debug_print('Going back to main')
				alliance_gossip_position = alliance_gossip_position + 1
				SelectGossipOption(1)
			end
	
		elseif UnitName("target") == horde_npc_name then
			print('Collecting data for Horde, please do not interrupt...')
			
			if horde_gossip_position == 7 then 
				print('Data collection for Horde completed.')
				horde_gossip_position = 2
				return
			end
	
			-- Check where we are
			if GetNumGossipOptions() == 6 then
			-- debug_print('We are at main gossip window, 6 options available. Entering sub-gossip # ' .. horde_gossip_position )
			SelectGossipOption(horde_gossip_position)
		
			elseif GetNumGossipOptions() == 1 then
		
				-- debug_print('We are in the sub-gossip window, as only one option is available')

				if horde_gossip_position == 2 then
					debug_print('Metal')
					gossiptexttowords()
					
					h_metal1 = gtarray[h_metal1_index]
					h_metal2 = gtarray[h_metal2_index]
					h_metal3 = gtarray[h_metal3_index]
					debug_print(h_metal1)
					debug_print(h_metal2)
					debug_print(h_metal3)
									
				elseif horde_gossip_position == 3 then
					debug_print('Herbs')
					gossiptexttowords()
					h_herb1 = gtarray[h_herb1_index]
					h_herb2 = gtarray[h_herb2_index]
					h_herb3 = gtarray[h_herb3_index]
					debug_print(h_herb1)
					debug_print(h_herb2)
					debug_print(h_herb3)
				
				elseif horde_gossip_position == 4 then
					debug_print('Skins')
					gossiptexttowords()
					h_leather1 = gtarray[h_leather1_index]
					h_leather2 = gtarray[h_leather2_index]
					h_leather3 = gtarray[h_leather3_index]
					debug_print(h_leather1)
					debug_print(h_leather2)
					debug_print(h_leather3)
						
				elseif horde_gossip_position == 5 then
					debug_print('Bandages')
					gossiptexttowords()
					h_bandage1 = gtarray[h_bandage1_index]:gsub('%.', '')
					h_bandage2 = gtarray[h_bandage2_index]
					h_bandage3 = gtarray[h_bandage3_index]
					debug_print(h_bandage1)
					debug_print(h_bandage2)
					debug_print(h_bandage3)
							
				elseif horde_gossip_position == 6 then
					debug_print('Cooked Goods')
					gossiptexttowords()
				
					h_food1 = gtarray[h_food1_index]
					h_food2 = gtarray[h_food2_index]
					h_food3 = gtarray[h_food3_index]
					h_date = date("%y-%m-%d %H:%M")
					debug_print(h_food1)
					debug_print(h_food2)
					debug_print(h_food3)
				
				else
					debug_print('I\'m not sure where we are')
				end
				
				-- debug_print('Going back to main')
				horde_gossip_position = horde_gossip_position + 1
				SelectGossipOption(1)
			end
		end
	
	end)
