-----------------------------------------------------------------
-- Header
-----------------------------------------------------------------
	do
		WorldExplorer = CreateFrame("Frame", "WorldExplorer", UIParent); --Creates a new UI frame called "WorldExplorer"
		
		WorldExplorer.Name = "WorldExplorer";
		
		WorldExplorer.Version = GetAddOnMetadata(WorldExplorer.Name, "Version");
		WorldExplorer.sVersionType = GetAddOnMetadata(WorldExplorer.Name, "X-VersionType");
		WorldExplorer.LoadedStatus = {}; -- Says what stage the addon loading is at.
		WorldExplorer.LoadedStatus["Initialized"] = 0; -- Say that the addon has not loaded yet.
		WorldExplorer.LoadedStatus["RunLevel"] = 3; -- Specifies what level the addon is "Running"
	end;
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Libraries
-----------------------------------------------------------------
	local ZMC, L; -- Registering local variables outside hider do
	do
		WorldExplorer.Astrolabe = DongleStub("Astrolabe-0.4");
		WorldExplorer.Dongle = DongleStub("Dongle-1.2"):New("DongleWorldExplorerTemplate");
		
		ZMC = LibStub("LibZasMsgCtr-1.0");
		WorldExplorer.ZMC = ZMC; -- Store a copy of this application so it can be used again by any bolton addons
		ZMC:Initialize(WorldExplorer, WorldExplorer.Name, ZMC.COLOUR_BLUE, 1) -- Initialize the debugging/messaging library's settings for this addon (CallingAddon, AddonName, DefaultColour1, Debug_Frame, DefaultColour2, DefaultErrorColour, DefaultMsgFrame)
		
		L = LibStub("AceLocale-3.0"):GetLocale(WorldExplorer.Name, false);
		WorldExplorer.L = L; -- Store a copy of this application so it can be used again by any bolton addons
	end;
-----------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------
-- DEFAULTS and Variable declarations
----------------------------------------------------------------------------------------------------------------------
	do
		if (WorldExplorer.Default_Enabled == nil) then
			WorldExplorer.Default_Enabled = true;
		end;
		
		WorldExplorer.Icons = {}
		
		WorldExplorer.Icons.Cross = {};
		WorldExplorer.Icons.Cross.Texture = "Interface\\Addons\\WorldExplorer\\Images\\WE_WhiteCross";
		WorldExplorer.Icons.Cross.Width = 5;
		WorldExplorer.Icons.Cross.Height = 5;
		
		WorldExplorer.Icons.Circle = {};
		WorldExplorer.Icons.Circle.Texture = "Interface\\Addons\\WorldExplorer\\Images\\WE_WhiteCircle";
		WorldExplorer.Icons.Circle.Width = 10;
		WorldExplorer.Icons.Circle.Height = 10;
		
		WorldExplorer.Icons.Square = {};
		WorldExplorer.Icons.Square.Texture = "Interface\\Addons\\WorldExplorer\\Images\\WE_WhiteSquare";
		WorldExplorer.Icons.Square.Width = 10;
		WorldExplorer.Icons.Square.Height = 10;
		
		i=1;
		WorldExplorer.DefaultAlpha = 0.3;
		WorldExplorer.Colour = {};
		WorldExplorer.Alpha = {};
		
		WorldExplorer.Colour[i] = "FFFFFF";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "0000FF";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "FF0000";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "00FF00";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "FF7F00";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "FF00FF";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "007F00";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "8B4513";
		WorldExplorer.Alpha[i] = 0.6; i=i+1;
		
		WorldExplorer.Colour[i] = "FFFF00";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "7F00FF";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "00FFFF";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "007FFF";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "00007F";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "00FF7F";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "7F007F";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
		
		WorldExplorer.Colour[i] = "007F7F";
		WorldExplorer.Alpha[i] = 0.3; i=i+1;
	end;
----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------
-- KeyBinding Variables
-----------------------------------------------------------------
	do
		BINDING_HEADER_WORLDEXPLORER = "WorldExplorer";
		BINDING_NAME_WorldExplorer_ToggleAddon = L["Enable/Disable WorldExplorer"];
		--[[BINDING_NAME_WorldExplorer_ToggleBreadDrop = L["Start/Stop Dropping WorldExplorer"];
		BINDING_NAME_WorldExplorer_ToggleHideBread = L["Hide/Show WorldExplorer"];
		BINDING_NAME_WorldExplorer_ToggleDropWhenDead = L["Start/Stop Dropping WorldExplorer when Dead"];]]--
	end;
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Local Functions
-----------------------------------------------------------------
	local function TableCount(tableToCount) -- TableCount: Counts table members
		----------------------------------------------
		-- Default: If DebugTxt is set to true all of
		-- the debug msgs in THIS function will apear!
		----------------------------------------------
			local DebugTxt = false;
			-- DebugTxt = true; -- Uncomment this to debug
		----------------------------------------------
		
		-- ZMC:Msg(WorldExplorer, "TableCount(tableToCount = "..tostring(tableToCount)..")",true,DebugTxt);
		-- ZMC:Msg(WorldExplorer, "type(tableToCount) = "..tostring(type(tableToCount)),true,DebugTxt);
		
		if (type(tableToCount) == "table") then -- This is a table so count it and return number
			local TableCount=0;
			
			for _ in pairs(tableToCount) do
				TableCount=TableCount+1;
			end;
			
			-- ZMC:Msg(WorldExplorer,"Table Count = "..tostring(TableCount),true,DebugTxt);
			
			return TableCount;
		else -- This is NOT a table so return 0
			return 0;
		end;
	end;
	
	local WorldExplorer_DefaultChatFrame_DisplayTimePlayed = ChatFrame_DisplayTimePlayed; -- Stores the time played chat frame so we can supress it when we want to use it...
-----------------------------------------------------------------

function WorldExplorer:OnEvent(event)
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:OnEvent("..tostring(event)..") self.LoadedStatus[Initialized] = "..tostring(self.LoadedStatus["Initialized"]).." arg1 = "..tostring(arg1).. " and self.LoadedStatus[RunLevel] = "..tostring(self.LoadedStatus["RunLevel"]),true,DebugTxt);
	
	if (event == "ADDON_LOADED" and self.LoadedStatus["Initialized"] == 0 and arg1 == "WorldExplorer") then
		-- ZMC:Msg(self, "event == ADDON_LOADED and self.LoadedStatus[Initialized] == "..tostring(self.LoadedStatus["Initialized"]).." and arg1 == WorldExplorer",true,DebugTxt);
		
		self:Initialize();
	elseif(event == "WORLD_MAP_UPDATE" and self.LoadedStatus["Initialized"] == self.LoadedStatus["RunLevel"]) then
		-- ZMC:Msg(self, "event == WORLD_MAP_UPDATE and self.LoadedStatus[Initialized] == "..tostring(self.LoadedStatus["Initialized"]),true,DebugTxt);
		
		self:UpdateMap();
	elseif(event == "ZONE_CHANGED" and self.LoadedStatus["Initialized"] and self.LoadedStatus["Initialized"] >= 1) then -- Needed as Achievements can't be used below level 10!
		-- ZMC:Msg(self, "event == ZONE_CHANGED and self.LoadedStatus[Initialized] == "..tostring(self.LoadedStatus["Initialized"]),true,DebugTxt);
		
		self:NewAreaEntered();
	elseif(event == "UI_INFO_MESSAGE" and self.LoadedStatus["Initialized"] and self.LoadedStatus["Initialized"] >= 1) then -- Needed as Achievements can't be used below level 10!
		-- ZMC:Msg(self, "event == UI_INFO_MESSAGE and self.LoadedStatus[Initialized] == "..tostring(self.LoadedStatus["Initialized"]),true,DebugTxt);
		
		self:RequestUpdateKnownZoneList();
	end
end;

function WorldExplorer:Initialize() -- Initialize the addon
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:Initialize()",true,DebugTxt);
	
	self:UnregisterEvent("ADDON_LOADED");
	
	self:VarInit(); -- Initialize the variables
	
	--- Slash Command Handler
	SLASH_WorldExplorer1 = "/WE";
	SLASH_WorldExplorer2 = "/WorldExplorer";
	SlashCmdList["WorldExplorer"] = function(msg)
		self:SlashCmdHandler(msg);
	end;
	
	if not self.UpdateFrame then
		self.UpdateFrame = CreateFrame("Frame");
		self.UpdateFrame:SetScript("OnUpdate", function(frame, elapsed) WorldExplorer:Update(frame, elapsed); end);
	end;
	
	self:AddInterfaceOptions(); -- Creates and adds the options window to the Bliz interface tab
	
	if not(WorldExplorer_Options["Enabled"]) then
		ZMC:Msg(self, L["WARNING: Addon disabled!"], false, DebugTxt, true);
	end;
	
	self:TogAddon(WorldExplorer_Options["Enabled"]);
	
	self:RegisterEvent("WORLD_MAP_UPDATE"); -- Catches when the WorldMap is updated
	self:RegisterEvent("UI_INFO_MESSAGE"); -- Catches when a UI info message is recived
	self:RegisterEvent("ZONE_CHANGED"); -- Catches when you change areas
	
	local numOverlays = WorldExplorer:GetNumberOfMapOverlays(true); -- Returns the number of overlays that exist including blank ones.
	WorldExplorer.lastNumOverlays = numOverlays;
	
	self:InitLevel(1); -- Says that the first part of the setup is done. Need to get a zone update yet though.
end;

function WorldExplorer:VarInit() -- Initialize the variables
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:VarInit()",true,DebugTxt);
	
	WorldExplorer_Options = WorldExplorer_Options or {}; -- Initializes WorldExplorer_Options if it doesn't already exist
	WorldExplorer_KnownAreas = WorldExplorer_KnownAreas or {}; -- Initializes WorldExplorer_KnownAreas if it doesn't already exist
	WorldExplorer_KnownAreasOld = WorldExplorer_KnownAreasOld or {}; -- Initializes WorldExplorer_KnownAreasOld if it doesn't already exist
	
	self.UpdateKnownZoneListRequest = 0; -- Initializes the request for all zone overlays updates flag.
	
	if (WorldExplorer_Options["Enabled"] == nil) then -- Initializes WorldExplorer_Options["Enabled"] with the default value of self.Default_Enabled if it doesn't already exist
		WorldExplorer_Options["Enabled"] = self.Default_Enabled;
	end;
	
	if (WorldExplorer_Options["HideKnown"] == nil) then -- Initializes WorldExplorer_Options["HideKnown"] with the default value of false if it doesn't already exist
		WorldExplorer_Options["HideKnown"] = true; -- This is the default value and should only be used by people who know what they are doing. Mainly the Author but if you have read the code and know to do the correct checks you can enable this!
	end;
	
	if (WorldExplorer_Options["HideNoneAchiv"] == nil) then -- Initializes WorldExplorer_Options["HideNoneAchiv"] with the default value of false if it doesn't already exist
		WorldExplorer_Options["HideNoneAchiv"] = true; -- This is the default value and should only be used by people who know what they are doing. Mainly the Author but if you have read the code and know to do the correct checks you can enable this!
	end;
	
	if (WorldExplorer_Options["CurrentDBVersion"] == nil) then -- Initializes WorldExplorer_Options["CurrentDBVersion"] with the default value of self.Version if it doesn't already exist
		WorldExplorer_Options["CurrentDBVersion"] = self.Version;
	end;
	
	--------------------------------------------
	-- Store all names for all Zones & Continent
	--------------------------------------------
		self.ZoneNames = {GetMapContinents()}; -- Array that stores the Continent & Zone Names Use WorldExplorer.ZoneNames[##Continent Number##][##Zone Number##]
		
		for Key,Value in pairs(self.ZoneNames) do
			-- ZMC:Msg(self, "Key = "..tostring(Key)..",Value = "..tostring(Value).."", true, DebugTxt);
			
			self.ZoneNames[Key] = {GetMapZones(Key)};
			self.ZoneNames[Key]["Name"] = Value; -- Moves the name up a level
		end;
	--------------------------------------------
	
	self.UpdatedMap = false; -- Used to say if the map has been updated.
	
	self.LoadedStatus["AddonVariables"] = true;
end

function WorldExplorer:InitLevel(Level) -- Initializes the addon to the level specified (used to set specific variables etc as the addon loads up)
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:InitLevel(Level = "..tostring(Level)..")",true,DebugTxt);
	
	-- ZMC:Msg(self, "Request to initializing addon from level  = '"..tostring(self.LoadedStatus["Initialized"]).."' to level = '"..tostring(Level).."'", true, DebugTxt);
	
	if (Level == 1) and (self.LoadedStatus["Initialized"] == 0) then
		self.LoadedStatus["Initialized"] = Level; -- Updates addon initialiation to specified level
		
		self.Dongle:ScheduleTimer("WorldExplorer_StartupZoneUpdate", function() self:RequestUpdateKnownZoneList(2); end, 2); -- Requests the time the player has played and when it gets the time it does a full update of all points
	elseif (Level == 2) and (self.LoadedStatus["Initialized"] == 1) then
		self.LoadedStatus["Initialized"] = Level; -- Updates addon initialiation to specified level
		
		self:InitLevel(3);
	elseif (Level == 3) and (self.LoadedStatus["Initialized"] == 2) then
		self.LoadedStatus["Initialized"] = Level; -- Updates addon initialiation to specified level
		
		self:MapUpdated(); -- Runs when the map has finished updating and is ready to get the Overlay info from it.
		
		if (WorldExplorer_KnownAreas["CurrentDBVersion"] == nil) then
			WorldExplorer_KnownAreas["CurrentDBVersion"] = "0";
		end;
		
		if (not(WorldExplorer_Options["CurrentDBVersion"] == self.Version) or  (WorldExplorer_KnownAreas["CurrentDBVersion"] < self.Version)) then -- Ether the current db doesn't match the current version or there hasn't been an update to the db since the last update
			-- V2 DB is NOT compatible with V1 and for the current the two need to run side by side!!! :-O
			-- ZMC:Msg(self, "DB Updated", true, DebugTxt);
			
			if ((WorldExplorer_Options["CurrentDBVersion"] < self.Version) or (WorldExplorer_KnownAreas["CurrentDBVersion"] < self.Version)) then
				ZMC:Msg(self, "WARNING: You have updated WorldExplorer to a new version. If you have any trouble try resetting the settings to default using the command '"..tostring(SLASH_WorldExplorer1).." reset'.", false, DebugTxt, true); -- Warn the user that they have updated to a newer version of WorldExplorer so if they have problems they should reset all the WorldExplorer settings
				
				if ((WorldExplorer_KnownAreas["CurrentDBVersion"]) or WorldExplorer_KnownAreas["CurrentDBVersion"] < "2.0.2") then -- This DB is older than Version 2.0.2 BETA so it needs it's V1 DB copying to WorldExplorer_KnownAreasOld and WorldExplorer_KnownAreas wiping for the V2 DB
					WorldExplorer_KnownAreasOld = WorldExplorer_KnownAreas; -- Copy V1 DB to the new variable
					WorldExplorer_KnownAreas = {}; -- Wipe the new V2 DB ready for it's first use...
				end;
			elseif (WorldExplorer_Options["CurrentDBVersion"] > self.Version) then
				ZMC:Msg(self, "WARNING: You have DOWNGRADED WorldExplorer to a version OLDER than your Database! This is NOT adviced as the DB structure MAY have changed... If you have any trouble try resetting the settings to default using the command '"..tostring(SLASH_WorldExplorer1).." resetALL'.", false, DebugTxt, true); -- Warn the user that they have DOWNGRADED to a older version of WorldExplorer than there DB so if they have problems they should reset all the WorldExplorer settings
			end;
		elseif (WorldExplorer_Updater) then
			ZMC:Msg(self, "WARNING: You have an old WorldExplorer update addon installed that isn't needed... Please uninstall WorldExplorer and delete the addon's folders 'WorldExplorer' & 'WorldExplorer_Updater' and download the newest version of WorldExplorer from Curse.com to ensure it all runs smoothly! ;-)", false, DebugTxt, true);
			
			if not(WorldExplorer_Admin) then -- Ensure the Admin module isn't running (as we may need the update module for that
				DisableAddOn("WorldExplorer_Updater"); -- Disables this module the next time the UI is restarted as we are done with it now.
			end;
		-- else
			-- ZMC:Msg(self, "WorldExplorer_Options[CurrentDBVersion] = "..tostring(WorldExplorer_Options["CurrentDBVersion"]), true, DebugTxt);
			-- ZMC:Msg(self, "WorldExplorer_KnownAreas[CurrentDBVersion] = "..tostring(WorldExplorer_KnownAreas["CurrentDBVersion"]), true, DebugTxt);
		end;
		
		WorldExplorer_Options["CurrentDBVersion"] = self.Version; -- Change the DB version to be this version...
		WorldExplorer_KnownAreasOld["CurrentDBVersion"] = self.Version; -- Change the DB version to be this version...
		WorldExplorer_KnownAreas["CurrentDBVersion"] = self.Version; -- Change the DB version to be this version...
		
		if (WorldExplorer_Options.UpdateDBComplete) then
			WorldExplorer_Options.UpdateDBComplete = nil; -- Remove this as it isn't needed.
		end;
		
		ZMC:Msg(self, L["Loaded"]..". "..L["For help type"].." "..tostring(SLASH_WorldExplorer1).." "..L["or"].." "..tostring(SLASH_WorldExplorer2));
	else
		ZMC:Msg(self, "Addon's current level ("..tostring(self.LoadedStatus["Initialized"])..") doesn't match expected level to progress to level ("..tostring(Level)..") or requested level isn't known... Aborting!'", false, DebugTxt, true);
	end;
end;

function WorldExplorer:SlashCmdHandler(msg) -- Slash Command Handler
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "Initialize",true,DebugTxt);
	-- ZMC:Msg(self, "msg = '"..tostring(msg).."'",true,DebugTxt);
	
	-- ZMC:Msg(self, "strlower(strsub(msg,1,8) = "..tostring(strlower(strsub(msg,1,8))),true,DebugTxt);
	
	if (msg == nil or msg == "") then
		if (WorldExplorer_Options["Enabled"]) then
			ZMC:Msg(self, L["is Enabled"],false,DebugTxt);
		else
			ZMC:Msg(self, L["is Disabled"], false, DebugTxt, true);
		end;
		
		ZMC:Msg(self, L["Use"].." '"..tostring(SLASH_WorldExplorer1).." options' "..L["to open up the Addon's Options screen"], false, DebugTxt);
	elseif ((strlower(strsub(msg,1,7)) == "options") or (strlower(strsub(msg,1,6)) == "config")) then -- This is the macro checking in...
		ZMC:Msg(self, L["Opening WorldExplorer Options Panel"]);
		
		InterfaceOptionsFrame_OpenToCategory("WorldExplorer");
	elseif(strlower(strsub(msg,1,8)) == "resetall") then -- This is the macro checking in...
		ZMC:Msg(self, "Reloading Defaults and DELETING ALL DATA!!!");
		
		StaticPopup_Show ("ResetALLWorldExplorersSettings"); -- Shows the Reset WorldExplorer Settings warning question dialog box
	elseif(strlower(strsub(msg,1,5)) == "reset") then -- This is the macro checking in...
		ZMC:Msg(self, L["Reloading Defaults"]);
		
		StaticPopup_Show ("ResetWorldExplorersSettings"); -- Shows the Reset WorldExplorer Settings warning question dialog box
	elseif(strlower(strsub(msg,1,6)) == "enable") then -- This is the macro checking in...
		ZMC:Msg(self, L["Enableing WorldExplorer"]);
		
		self:TogAddon(true);
	elseif(strlower(strsub(msg,1,7)) == "disable") then -- This is the macro checking in...
		ZMC:Msg(self, L["Disabling WorldExplorer"]);
		
		self:TogAddon(false);
	-- else
		-- ZMC:Msg(self, "Message not known = '"..tostring(msg).."'",true,Debugtxt);
	end;
end;

function WorldExplorer:Update(frame, elapsed) -- Runs all the time (thousands of times a second!)
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:Update()",true,DebugTxt);
	
	if not((WorldExplorer_Options["Enabled"]) and (self.LoadedStatus["Initialized"] == self.LoadedStatus["RunLevel"])) then -- Addon is disabled so exit
		-- ZMC:Msg(self, "Addon is disabled so exit", true, DebugTxt);
		return;
	end;
	
	if (self.UpdatedMap) then -- When the map has been updated this will run.
		self:MapUpdated(); -- Runs when the map has finished updating and is ready to get the Overlay info from it.
		
		self.UpdatedMap = false; -- Sets it back to false to wait for the next update.
	end;	
end;

function WorldExplorer:AddInterfaceOptions() -- Creates and adds the options window to the Bliz interface tab
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:AddInterfaceOptions()",true,DebugTxt);
	
	if (WorldExplorer_Options.RepairInterfaceOptionsFrameStrataTog) then
		-- ZMC:Msg(self, "Repair InterfaceOptionsFrame Strata ENABLED", true,DebugTxt);
		InterfaceOptionsFrame:SetFrameStrata(WorldExplorer_Options.RepairInterfaceOptionsFrameStrata); -- Repair InterfaceOptionsFrame Strata as other addon's make it above dialogs!!! You know who you are "LibBetterBlizzOptions"
	-- else
		-- ZMC:Msg(self, "Repair InterfaceOptionsFrame Strata DISABLED", true,DebugTxt);
	end;
	
	local sVersion; -- Sets the string for version infomation
	if (self.sVersionType == "ALPHA") then -- If this is a ALPHA version then
		sVersion = ZMC.COLOUR_RED..L["Version"]..": "..tostring(self.Version).." "..L["ALPHA"]..ZMC.COLOUR_CLOSE
	elseif (self.sVersionType == "BETA") then -- If this is a BETA version then
		sVersion = ZMC.COLOUR_ORANGE..L["Version"]..": "..tostring(self.Version).." "..L["BETA"]..ZMC.COLOUR_CLOSE
	else
		sVersion = self.ZMC_DefaultColour1..L["Version"]..": "..tostring(self.Version)..ZMC.COLOUR_CLOSE
	end;
	
	self.ResetVisable = false; -- Ensures the reset button is disabled!
	
	---------------------------------------------------------
	-- Reset Settings Static Popup Dialog
	---------------------------------------------------------
		StaticPopupDialogs["ResetWorldExplorersSettings"] = {
			text = L["Are you sure you want to reset ALL WorldExplorer Settings to default?"],
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				self:ResetAllSettings(); -- Deletes all settings and restarts UI
			end,
			OnCancel = function()
				self.ResetVisable = false; -- Disables the button again
				LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Refreshes Options Window
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
	---------------------------------------------------------
	
	---------------------------------------------------------
	-- Reset ALL Settings Static Popup Dialog
	---------------------------------------------------------
		StaticPopupDialogs["ResetALLWorldExplorersSettings"] = {
			text = "THIS WILL DELETE ALL GATHERED DATA! Are you sure you want to reset ALL WorldExplorer Settings to default AND Delete ALL data?",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				self:ResetAllSettings(true); -- Deletes all settings and restarts UI
			end,
			OnCancel = function()
				self.ResetVisable = false; -- Disables the button again
				LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Refreshes Options Window
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
	---------------------------------------------------------
	
	local Options = {
		type = "group",
		childGroups = "tab",
		name = "WorldExplorer("..self.ZMC_DefaultColour1.."Zasurus"..ZMC.COLOUR_CLOSE..") "..sVersion,
		desc = L["These options allow you to configure various aspects of WorldExplorer."],
		args = {
			Enabled = { -- Creates and Sets Up the Addon Enable Toggle
				type = "toggle",
				name = L["WorldExplorer Enabled (KeyBinding Available)"],
				desc = L["Turns WorldExplorer On/Off. If you don't plan to use it for a long time or just don't want to use it on this toon your better disabling it via the 'Addon' menu on the toon selection screen to save memory."],
				order = 1,
				get = function(info)
					return WorldExplorer_Options["Enabled"];
				end,
				set = function(info, value)
					self:TogAddon(value);
				end,
				width = "full",
			},
			HideKnown = { -- Creates and Sets Up the Hide Known Points Toggle
				type = "toggle",
				name = L["Hide Known Areas"],
				desc = L["Hide Known Areas On/Off. This says whether we show areas we have already discovered or not."],
				order = 2,
				get = function(info)
					return WorldExplorer_Options["HideKnown"];
				end,
				set = function(info, value)
					self:TogHideKnown(value);
				end,
				width = "full",
			},
			HideTog = { -- Creates and Sets Up the Addon Hide Toggle
				type = "toggle",
				name = L["Hide None Achievement Areas"],
				desc = L["Hide None Achievement Areas On/Off. This says if we hide the areas that have nothing to do with the World Explorer Achievement."],
				order = 3,
				get = function(info)
					return WorldExplorer_Options["HideNoneAchiv"];
				end,
				set = function(info, value)
					self:TogHideNoneAchieveAreas(value);
				end,
				width = "full",
			},
			--[[Other options
			ResetOnReload = { -- Creates and Sets Up the Addon "Reset points on reload/load" Toggle
				type = "toggle",
				name = L["Reset Trail on Load/Reload"],
				desc = L["Enable to start a fresh trail every time the addon is loaded/reloaded."],
				order = 4,
				get = function(info)
					return WorldExplorer_Options["ResetOnReload"];
				end,
				set = function(info, value)
					WorldExplorer_Options["ResetOnReload"] = value;
				end,
				width = "full",
			},
			DontDropWhenDead = { -- Creates and Sets Up the Addon "Don't Drop when Dead" Toggle
				type = "toggle",
				name = L["Don't Drop Breadcrumbs when Dead (KeyBinding Available)"],
				desc = L["Enable to stops dropping WorldExplorer when you die so you don't have a useless trail from the grave and lose your berings!"],
				order = 5,
				get = function(info)
					return WorldExplorer_Options["DontDropWhenDead"];
				end,
				set = function(info, value)
					self:TogDropWhenDead(value);
				end,
				width = "full",
			},
			DistBetweenPoints = { -- Creates and Sets Up the DistBetweenPoints slider
				type = "range",
				name = L["Space Between Points"],
				desc = L["This slider specifies how close together the points are that make up the line. Closer together gives a better looking line but makes it shorter."].."\n\n"..self.ZMC_DefaultColour1..L["NOTE: This will also affect the length of the line so you may need to also adjust the number of points used for the line."].."\n\n"..L["Also this will only affect new WorldExplorer and not your existing trail."].."|r",
				order = 6,
				min = 1,
				max = 100,
				step = 1,
				get = function(info)
					return WorldExplorer_Options["DistBetweenPoints"];
				end,
				set = function(info, value)
					WorldExplorer_Options["DistBetweenPoints"] = value;
				end,
				
			},
			NumberOfPoints = { -- Creates and Sets Up the NumberOfPoints slider
				type = "range",
				name = L["Number of Points"],
				desc = L["This slider specifies how many points are used to create the line and therefore how long it will be."].."\n\n"..self.ZMC_DefaultColour1..L["NOTE: Use this and the spacing one to crate the line you want."].."\n\n"..L["ALSO this will reset your WorldExplorer(remove your trail)! So ensure you make a note of which way you have come from."].."|r\n\n"..self.ZMC_DefaultErrorColour..L["WARNING! Setting this higher MAY slow the game down!"].."|r",
				order = 7,
				min = 2, -- Can't be <2!
				max = 100,
				step = 1,
				get = function(info)
					return WorldExplorer_Options["NumPoints"];
				end,
				set = function(info, value)
					if (WorldExplorer_Options["NumPoints"] == value) then -- If no change then don't do anything!
						ZMC:Msg(self, "WorldExplorer_Options.NumPoints == value",true,DebugTxt);
						return;
					end;
					
					WorldExplorer_Options["NumPoints"] = value; -- Set the number of points to the ones specified
					
					self:GeneratePoints(); -- Recreate the new number of points
					
					if (HudMapCluster) then
						ZMC:Msg(self, "HudMapCluster Exists!",true,DebugTxt);
						
						if (HudMapCluster:IsShown()) then
							ZMC:Msg(self, "and HudMapCluster is Shown!",true,DebugTxt);
							
							HudMapCluster:Hide(); -- Hide the SexyMap's HUD
							HudMapCluster:Show(); -- Now Show the SexyMap's HUD again to reset everything.
						-- else
							ZMC:Msg(self, "and HudMapCluster is NOT Shown!",true,DebugTxt);
						end;
					-- else
						ZMC:Msg(self, "HudMapCluster Does NOT Exist!",true,DebugTxt);
					end;
				end,
			},
			LastNumToHide = { -- Creates and Sets Up the LastNumToHide slider
				type = "range",
				name = L["Hide Closest # Points"],
				desc = L["This slider specifies how many of the closest points to the player (if any) should be hidden."].."\n\n"..L["This is to help prevent the players arrow from being covered."],
				order = 8,
				min = 1,
				max = 50,
				step = 1,
				get = function(info)
					return WorldExplorer_Options["LastNumToHide"];
				end,
				set = function(info, value)
					WorldExplorer_Options.LastNumToHide = value;
					
					self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
					
					self:UpdatePoints();
				end,
			},
			---------------------------------------------------------------------------------------------------------------------------------
			-- Minimap
			---------------------------------------------------------------------------------------------------------------------------------
				MinimapGroup = {
					type = "group",
					name = "Minimap",
					order = 9,
					args = {
						---------------------------------------------------------------------------------------------------------------------------------
						-- First Point's Colour/Opacity for the Minimap
						---------------------------------------------------------------------------------------------------------------------------------
							MinimapColour2 = { -- Creates and Sets Up the Last Point's Colour/Opacity for the Minimap
								type = "color",
								name = L["to"],
								desc = L["This sets the Colour & Opacity level of the last point that make up the WorldExplorer when on the Minimap."],
								order = 1,
								hasAlpha = true,
								width = "half",
								get = function(info)
									local Red = WorldExplorer_Options.MinimapColour2.Red;
									local Green = WorldExplorer_Options.MinimapColour2.Green;
									local Blue = WorldExplorer_Options.MinimapColour2.Blue;
									local TextureOpacity = WorldExplorer_Options.MinimapColour2.TextureOpacity;
									
									return Red, Green, Blue, TextureOpacity;
								end,
								set = function(info, Red, Green, Blue, TextureOpacity)
									ZMC:Msg(self, "MinimapColour2 - setFunc(Red = "..tostring(Red)..", Green = "..tostring(Green)..", Blue = "..tostring(Blue)..", TextureOpacity = "..tostring(TextureOpacity)..")", true, DebugTxt);
									WorldExplorer_Options.MinimapColour2.Red = Red;
									WorldExplorer_Options.MinimapColour2.Green = Green;
									WorldExplorer_Options.MinimapColour2.Blue = Blue;
									WorldExplorer_Options.MinimapColour2.TextureOpacity = TextureOpacity;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
								end,
								hidden = function()
									ZMC:Msg(self, "return not(WorldExplorer_Options.MinimapGradiant("..tostring(WorldExplorer_Options.MinimapGradiant).."));", true, DebugTxt);
									return not(WorldExplorer_Options.MinimapGradiant);
								end,
							},
							MinimapColour1 = { -- Creates and Sets Up the First Point's Colour/Opacity for the Minimap
								type = "color",
								name = L["Colour/Opacity (Minimap)"],
								desc = L["This sets the Colour & Opacity level of the first point (or all if gradiant is disabled) that make up the WorldExplorer when on the Minimap."],
								order = 2,
								hasAlpha = true,
								width = "double",
								get = function(info)
									local Red = WorldExplorer_Options.MinimapColour1.Red;
									local Green = WorldExplorer_Options.MinimapColour1.Green;
									local Blue = WorldExplorer_Options.MinimapColour1.Blue;
									local TextureOpacity = WorldExplorer_Options.MinimapColour1.TextureOpacity;
									
									return Red, Green, Blue, TextureOpacity;
								end,
								set = function(info, Red, Green, Blue, TextureOpacity)
									ZMC:Msg(self, "MinimapColour1 - setFunc", true, DebugTxt);
									WorldExplorer_Options.MinimapColour1.Red = Red;
									WorldExplorer_Options.MinimapColour1.Green = Green;
									WorldExplorer_Options.MinimapColour1.Blue = Blue;
									WorldExplorer_Options.MinimapColour1.TextureOpacity = TextureOpacity;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
								end,
							},
							MinimapGradiant = { -- Creates and Sets Up the Minimap Gradiant Toggle
								type = "toggle",
								name = L["Gradiant"],
								desc = L["Gradually change the colour/transparancy between the first and last point on the Minimap"],
								order = 3,
								get = function(info)
									return WorldExplorer_Options["MinimapGradiant"];
								end,
								set = function(info, value)
									self:TogMiniGrad(value);
								end,
								width = "full",
							},
							-- if (WorldExplorer_Options.MinimapGradiant) then -- Minimap Gradiant is disabled so disable options
								-- self.OptionsPanel.MinimapColour2:Enable(); -- Enable the colour picker for the last point as it's needed now.
								-- self.OptionsPanel.MinimapColour2:Show(); -- Show the colour picker for the last point as it's needed now.
								-- panel.MinimapColour1:SetPoint("TOPLEFT", panel.MinimapColour2, "TOPRIGHT", 15, 0); -- Move the First colour picker to the right of the second one
							-- else
								-- self.OptionsPanel.MinimapColour2:Disable(); -- Disable the colour picker for the last point as it's not needed any more.
								-- panel.MinimapColour2:Hide();
								-- panel.MinimapColour1:SetPoint("TOPLEFT", panel.MinimapColour2, "TOPLEFT", 0, 0);
							-- end;
						---------------------------------------------------------------------------------------------------------------------------------
						
						---------------------------------------------------------------------------------------------------------------------------------
						-- Minimap Size Settings
						---------------------------------------------------------------------------------------------------------------------------------
							MinimapSizeOfPoints2 = { -- Creates and Sets Up the MinimapSizeOfPoints2 slider
								type = "range",
								name = L["Last Point Size to -->"],
								desc = L["This slider specifies the size of the first point on the minimap is."],
								order = 4,
								min = 1,
								max = 50,
								step = 1,
								get = function(info)
									return WorldExplorer_Options["MinimapSizeOfPoints2_Width"];
								end,
								set = function(info, value)
									WorldExplorer_Options.MinimapSizeOfPoints2_Width = value;
									WorldExplorer_Options.MinimapSizeOfPoints2_Height = value;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints();
								end,
								hidden = function()
									ZMC:Msg(self, "return not(WorldExplorer_Options.MinimapSizeGradiant("..tostring(WorldExplorer_Options.MinimapSizeGradiant).."));", true, DebugTxt);
									return not(WorldExplorer_Options.MinimapSizeGradiant);
								end,
							},
							MinimapSizeOfPoints1 = { -- Creates and Sets Up the MinimapSizeOfPoints1 slider
								type = "range",
								name = L["Size(Minimap)"],
								desc = L["This slider specifies how big the last point on the minimap is."],
								order = 5,
								min = 1,
								max = 50,
								step = 1,
								get = function(info)
									return WorldExplorer_Options["MinimapSizeOfPoints1_Width"];
								end,
								set = function(info, value)
									WorldExplorer_Options.MinimapSizeOfPoints1_Width = value;
									WorldExplorer_Options.MinimapSizeOfPoints1_Height = value;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints();
								end,
							},
							MinimapSizeGradiant = { -- Creates and Sets Up the Minimap Size Gradiant Toggle
								type = "toggle",
								name = L["Gradiant"],
								desc = L["Gradually change the size between the first and last point on the Minimap"],
								order = 6,
								get = function(info)
									return WorldExplorer_Options["MinimapSizeGradiant"];
								end,
								set = function(info, value)
									self:TogMinimapSizeGrad(value);
								end,
								width = "full",
							},
							-- if (WorldExplorer_Options.MinimapSizeGradiant) then -- Minimap Size Gradiant is disabled so disable options
								-- self.OptionsPanel.MinimapSizeOfPoints2:Enable(); -- Enable the size slider for the last point as it's needed now.
								-- self.OptionsPanel.MinimapSizeOfPoints2:Show(); -- Show the size slider for the last point as it's needed now.
								-- panel.MinimapSizeOfPoints1:SetPoint("TOPLEFT", panel.MinimapSizeOfPoints2, "TOPRIGHT", 15, 0); -- Move the First size slider to the right of the second one
							-- else
								-- self.OptionsPanel.MinimapSizeOfPoints2:Disable(); -- Disable the slider for the last point as it's not needed any more.
								-- panel.MinimapSizeOfPoints2:Hide();
								-- panel.MinimapSizeOfPoints1:SetPoint("TOPLEFT", panel.MinimapSizeOfPoints2, "TOPLEFT", 0, 0);
							-- end;
							
							-- if (not(HudMapCluster)) then -- The SexyMap Minimap doesn't exist so disable options
								-- panel.MinimapSizeGradiant:Disable();
							-- end;
						---------------------------------------------------------------------------------------------------------------------------------
					},
				},
			---------------------------------------------------------------------------------------------------------------------------------
			
			
			
			---------------------------------------------------------------------------------------------------------------------------------
			-- SexyMap HUD
			---------------------------------------------------------------------------------------------------------------------------------
				HUDGroup = {
					type = "group",
					name = "SexyMapHUD",
					order = 10,
					args = {
						---------------------------------------------------------------------------------------------------------------------------------
						-- First Point's Colour/Opacity for the HUD
						---------------------------------------------------------------------------------------------------------------------------------
							HUDColour2 = { -- Creates and Sets Up the Last Point's Colour/Opacity for the HUD
								type = "color",
								name = L["to"],
								desc = L["This sets the Colour & Opacity level of the last point that make up the WorldExplorer when on the Minimap."],
								order = 1,
								hasAlpha = true,
								width = "half",
								get = function(info)
									local Red = WorldExplorer_Options.HUDColour2.Red;
									local Green = WorldExplorer_Options.HUDColour2.Green;
									local Blue = WorldExplorer_Options.HUDColour2.Blue;
									local TextureOpacity = WorldExplorer_Options.HUDColour2.TextureOpacity;
									
									return Red, Green, Blue, TextureOpacity;
								end,
								set = function(info, Red, Green, Blue, TextureOpacity)
									ZMC:Msg(self, "HUDColour2 - setFunc", true, DebugTxt);
									WorldExplorer_Options.HUDColour2.Red = Red;
									WorldExplorer_Options.HUDColour2.Green = Green;
									WorldExplorer_Options.HUDColour2.Blue = Blue;
									WorldExplorer_Options.HUDColour2.TextureOpacity = TextureOpacity;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
								end,
								hidden = function()
									ZMC:Msg(self, "return not(WorldExplorer_Options.HUDGradiant("..tostring(WorldExplorer_Options.HUDGradiant).."));", true, DebugTxt);
									return not(WorldExplorer_Options.HUDGradiant);
								end,
							},
							HUDColour1 = { -- Creates and Sets Up the First Point's Colour/Opacity for the HUD
								type = "color",
								name = L["Colour/Opacity (Minimap)"],
								desc = L["This sets the Colour & Opacity level of the first point (or all if gradiant is disabled) that make up the WorldExplorer when on the Minimap."],
								order = 2,
								hasAlpha = true,
								width = "double",
								get = function(info)
									local Red = WorldExplorer_Options.HUDColour1.Red;
									local Green = WorldExplorer_Options.HUDColour1.Green;
									local Blue = WorldExplorer_Options.HUDColour1.Blue;
									local TextureOpacity = WorldExplorer_Options.HUDColour1.TextureOpacity;
									
									return Red, Green, Blue, TextureOpacity;
								end,
								set = function(info, Red, Green, Blue, TextureOpacity)
									ZMC:Msg(self, "HUDColour1 - setFunc", true, DebugTxt);
									WorldExplorer_Options.HUDColour1.Red = Red;
									WorldExplorer_Options.HUDColour1.Green = Green;
									WorldExplorer_Options.HUDColour1.Blue = Blue;
									WorldExplorer_Options.HUDColour1.TextureOpacity = TextureOpacity;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints(); -- Updates the Colour/Opacity and Size of all of the points
								end,
							},
							HUDGradiant = { -- Creates and Sets Up the HUD Gradiant Toggle
								type = "toggle",
								name = L["Gradiant"],
								desc = L["Gradually change the colour/transparancy between the first and last point on the HUD"],
								order = 3,
								get = function(info)
									return WorldExplorer_Options["HUDGradiant"];
								end,
								set = function(info, value)
									self:TogHUDGrad(value);
								end,
								width = "full",
							},
						---------------------------------------------------------------------------------------------------------------------------------
						
						
						---------------------------------------------------------------------------------------------------------------------------------
						-- HUD Size Settings
						---------------------------------------------------------------------------------------------------------------------------------
							HUDSizeOfPoints2 = { -- Creates and Sets Up the HUDSizeOfPoints2 slider
								type = "range",
								name = L["Last Point Size to -->"],
								desc = L["This slider specifies how big the points on the SexyMapHUD are."],
								order = 4,
								min = 1,
								max = 50,
								step = 1,
								get = function(info)
									return WorldExplorer_Options["HUDSizeOfPoints2_Width"];
								end,
								set = function(info, value)
									WorldExplorer_Options.HUDSizeOfPoints2_Width = value;
									WorldExplorer_Options.HUDSizeOfPoints2_Height = value;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints();
								end,
								hidden = function()
									ZMC:Msg(self, "return not(WorldExplorer_Options.HUDSizeGradiant("..tostring(WorldExplorer_Options.HUDSizeGradiant).."));", true, DebugTxt);
									return not(WorldExplorer_Options.HUDSizeGradiant);
								end,
							},
							MinimapSizeOfPoints1 = { -- Creates and Sets Up the MinimapSizeOfPoints1 slider
								type = "range",
								name = L["Size(SexyMapHUD)"],
								desc = L["This slider specifies the size of the first point (or all if Gradian is diabled) on the SexyMapHUD."],
								order = 5,
								min = 1,
								max = 50,
								step = 1,
								get = function(info)
									return WorldExplorer_Options["HUDSizeOfPoints1_Width"];
								end,
								set = function(info, value)
									WorldExplorer_Options.HUDSizeOfPoints1_Width = value;
									WorldExplorer_Options.HUDSizeOfPoints1_Height = value;
									
									self:UpdateGradiants(); -- Updates the gradiants with any new colours/transparancys
									
									self:UpdatePoints();
								end,
							},
							MinimapSizeGradiant = { -- Creates and Sets Up the HUD Size Gradiant Toggle
								type = "toggle",
								name = L["Gradiant"],
								desc = L["Gradually change the size between the first and last point on the SexyMapHUD"],
								order = 6,
								get = function(info)
									return WorldExplorer_Options["HUDSizeGradiant"];
								end,
								set = function(info, value)
									self:TogHUDSizeGrad(value);
								end,
								width = "full",
							},
						---------------------------------------------------------------------------------------------------------------------------------	
					},
				},
			---------------------------------------------------------------------------------------------------------------------------------
			
			
			
			---------------------------------------------------------------------------------------------------------------------------------
			-- Others
			---------------------------------------------------------------------------------------------------------------------------------
				OtherGroup = {
					type = "group",
					name = "Other Settings",
					order = 11,
					args = {
						EnableReset = { -- Creates and Sets Up the HUD Size Gradiant Toggle
							type = "toggle",
							name = L["Enable Reset"],
							desc = L["This enables the reset button (so you don't click it by acident!)"],
							order = 1,
							get = function(info)
								return self.ResetVisable;
							end,
							set = function(info, value)
								self.ResetVisable = value;
							end,
						},
						ResetButton = { -- Creates and Sets up the Reset Settings Button
							type = "execute",
							name = L["Reset Settings"],
							desc = L["This resets ALL WorldExplorer settings back to there defaults (Like a fresh install)!"].."\n\n"..ZMC.COLOUR_ORANGE..L["WARNING! This will reload the UI!"]..ZMC.COLOUR_CLOSE,
							order = 2,
							func = function(info)
								StaticPopup_Show ("ResetWorldExplorersSettings"); -- Shows the Reset WorldExplorer Settings warning question dialog box
							end,
							disabled = function(info)
								return not(self.ResetVisable);
							end,
						},
						RepairInterfaceStrata = { -- Creates and Sets Up the Interface Strata Repair Toggle
							type = "toggle",
							name = L["Repair Interface Strata"],
							desc = L["This repairs the InterfaceOptionsFrame's Strata back to: '"]..ZMC.COLOUR_RED..tostring(WorldExplorer_Options.RepairInterfaceOptionsFrameStrata)..ZMC.COLOUR_CLOSE..L["' default normally '"]..ZMC.COLOUR_ORANGE..tostring(self.Default_RepairInterfaceOptionsFrameStrata)..ZMC.COLOUR_CLOSE..L["') as some addon's (you know who you are 'LibBetterBlizzOptions-1.0') make it so high no other frame can be ontop of it!"].."\n\n"..ZMC.COLOUR_ORANGE..L["The UI will need reloading for this to take affect!"]..ZMC.COLOUR_CLOSE,
							order = 3,
							width = "double",
							get = function(info)
								return WorldExplorer_Options.RepairInterfaceOptionsFrameStrataTog;
							end,
							set = function(info, value)
								WorldExplorer_Options.RepairInterfaceOptionsFrameStrataTog = value;
							end,
						},
					},
				},
			--]]-------------------------------------------------------------------------------------------------------------------------------
		},
	};
	
	------------------------------------------------------------------------------
	-- Uses the options table just created to 
	------------------------------------------------------------------------------
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(self.Name, Options) -- Registers the "options" table ready to be used
		self.BCOptionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WorldExplorer", "WorldExplorer") -- Refreshes the open window (encase an external function changes the "options" table)
	------------------------------------------------------------------------------
end;

function WorldExplorer:TogHideKnown(value) -- Show or Hide Known areas
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:TogHideKnown(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value has been passed so just invert the current one
		if WorldExplorer_Options["HideKnown"] == true then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value == true) then -- True passed so enable addon
		if (WorldExplorer_Options["HideKnown"] == false) then
			ZMC:Msg(self, L["Hidding Known Areas."],false,DebugTxt);
		end;
		
		WorldExplorer_Options["HideKnown"] = true;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
	elseif (value == false) then -- False passed so enable addon
		WorldExplorer_Options["HideKnown"] = false;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
		
		ZMC:Msg(self, L["Unhiding discovered areas (showing them)."], false, DebugTxt, true);
	-- else
		-- ZMC:Msg(self, "ERROR value not specified",true,DebugTxt,true);
	end;
	
	self:AddShapeToMap(); -- Adds a shape to the map for this area
end;

function WorldExplorer:TogHideNoneAchieveAreas(value) -- Show or Hide Known areas
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:TogHideNoneAchieveAreas(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value has been passed so just invert the current one
		if WorldExplorer_Options["HideNoneAchiv"] == true then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value == true) then -- True passed so enable addon
		if (WorldExplorer_Options["HideNoneAchiv"] == false) then
			ZMC:Msg(self, L["Hidding None Achievement Areas."],false,DebugTxt);
		end;
		
		WorldExplorer_Options["HideNoneAchiv"] = true;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
	elseif (value == false) then -- False passed so enable addon
		WorldExplorer_Options["HideNoneAchiv"] = false;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
		
		ZMC:Msg(self, L["Unhiding none achievement areas (showing them)."], false, DebugTxt, true);
	-- else
		-- ZMC:Msg(self, "ERROR value not specified",true,DebugTxt,true);
	end;
	
	self:AddShapeToMap(); -- Adds a shape to the map for this area
end;

function WorldExplorer:TogAddon(value) -- Enables or Disables WorldExplorer
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:TogAddon(value = "..tostring(value)..")",true,DebugTxt);
	
	if (value == nil) then -- No value has been passed so just invert the current one
		if WorldExplorer_Options["Enabled"] == true then
			value = false;
		else
			value = true;
		end;
	end;
	
	if (value == true) then -- True passed so enable addon
		if (WorldExplorer_Options["Enabled"] == false) then
			ZMC:Msg(self, L["Enabled."],false,DebugTxt);
		end;
		
		WorldExplorer_Options["Enabled"] = true;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
	elseif (value == false) then -- False passed so enable addon
		WorldExplorer_Options["Enabled"] = false;
		
		LibStub("AceConfigRegistry-3.0"):NotifyChange(self.Name) -- Updates the options window
		
		ZMC:Msg(self, L["Disabled."], false, DebugTxt, true);
	-- else
		-- ZMC:Msg(self, "ERROR value not specified",true,DebugTxt,true);
	end;
end;

function WorldExplorer:ResetAllSettings() -- Deletes all settings and restarts UI
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:ResetAllSettings()",true,DebugTxt);
	
	self:TogAddon(false); -- Disables WorldExplorer to ensure it doesn't error
	
	WorldExplorer_Options = nil; -- Wipes the settings
	WorldExplorer_KnownAreasOld = nil; -- Wipes the DBs
	WorldExplorer_KnownAreas = nil; -- Wipes the DBs
	
	ReloadUI(); -- Reloads the UI so WorldExplorer reinitialize correctly
end;

function WorldExplorer:UpdateMap() -- Kicks off when the world map is updated
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:UpdateMap()",true,DebugTxt);
	
	self.UpdatedMap = true; -- Says that the map has updated
end;

function WorldExplorer:GetNumberOfMapOverlays(bBlanks) -- Returns the number of overlays that exist.
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
	local DebugTxt = false;
	-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:GetNumberOfMapOverlays(bBlanks = "..tostring(bBlanks)..")",true,DebugTxt);
	
	local numBlank = 0; -- Used to store the number of blank overlays (to take off the number of good overlays
	for i=1, 999 do -- Loops though all of the posible overlays (999 is ment to be WAY more than there ever can be to ensure we find the true number)
		local tname,tw,th,ofx,ofy = GetMapOverlayInfo(i) -- Pulls back this overlays details
		if not(tname) then -- Checks if this overlay exists
			-- ZMC:Msg(self, "Number of Overlays = "..tostring(i-1).." and there where '"..tostring(numBlank).."' blank overlays leaving '"..tostring(i-1-numBlank), true, DebugTxt);
			
			if (bBlanks) then -- We want to return the total number including blanks
				return i-1; -- If it doesn't exist then return the LAST overlay number as that was the last one!
			else -- We only want the number of none blank overlays.
				return i-1-numBlank; -- If it doesn't exist then return the LAST overlay number as that was the last one!
			end;
		elseif (tname == "") then -- No texture for this overlay so likely blank (not sure why!)
			numBlank = numBlank + 1; -- Increase the number of blank overlays by 1
		end;
	end;
end;

function WorldExplorer:MapUpdated() -- Runs when the map has finished updating and is ready to get the Overlay info from it. If variable "bBlanks" is true it will return total including blanks!
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:MapUpdated()",true,DebugTxt);
	
	----------------------------------------------------------
	-- Get the number of overlays
	----------------------------------------------------------
		local numOverlays = self:GetNumberOfMapOverlays(true) -- Returns the number of overlays that exist including blank ones.
		-- ZMC:Msg(self, "numOverlays = "..tostring(numOverlays).."", true, DebugTxt);
		-- ZMC:Msg(self, "numOverlays(NoBlanks) = "..tostring(self:GetNumberOfMapOverlays()).."", true, DebugTxt);
	----------------------------------------------------------
	
	
	
	----------------------------------------------------------
	-- Exit if the zone hasn't changed
	----------------------------------------------------------
		local MapContinentNum = GetCurrentMapContinent();
		local MapZoneNum = GetCurrentMapZone();
		
		self.LastCont = self.LastCont or 0; -- Sets up the Last Cont variable if doesn't exist
		self.LastZone = self.LastZone or 0; -- Sets up the Last Zone variable if doesn't exist
		
		if ((self.LastCont == MapContinentNum) and (self.LastZone == MapZoneNum)) then -- The zone hasn't changed so no need to do anything
			return;
		else -- Changed so save the new cont/zone and continue...
			self.LastCont = MapContinentNum;
			self.LastZone = MapZoneNum;
		end;
	----------------------------------------------------------
	
	
	
	----------------------------------------------------------
	-- Get names of the continent and zone
	----------------------------------------------------------
		local MapContinentName = "UNKNOWN CONTINENT!"; -- Default encase this continent isn't in the DB!
		local MapZoneName = "UNKNOWN ZONE!"; -- Default encase this zone isn't in the DB!
		
		-- ZMC:Msg(self, "MapContinentNum = "..tostring(MapContinentNum).."", true, DebugTxt);
		-- ZMC:Msg(self, "MapZoneNum = "..tostring(MapZoneNum).."", true, DebugTxt);
		
		if (MapZoneNum == 0) then -- The map is not showing a continent
			MapZoneName = "Entire Continent";
		end;
		
		if (MapContinentNum == 0) then -- The map is not showing a continent
			MapContinentName = "All of Azeroth";
		-- elseif (MapContinentNum == -1) then -- The map is not showing a continent
			-- Could be "Cosmic Map" or a "Battleground Map". Also when showing The Scarlet Enclave, the Death Knights' starting area.
			-- As there are so many it's easyer to say we don't know! ;)
		end;
		
		if (self.ZoneNames[MapContinentNum]) then
			MapContinentName = self.ZoneNames[MapContinentNum]["Name"];
			
			if (self.ZoneNames[MapContinentNum][MapZoneNum]) then
				MapZoneName = self.ZoneNames[MapContinentNum][MapZoneNum];
			end;
		end;
		
		-- ZMC:Msg(self, "MapContinentName = "..tostring(MapContinentName).."", true, DebugTxt);
		-- ZMC:Msg(self, "MapZoneName = "..tostring(MapZoneName).."", true, DebugTxt);
	----------------------------------------------------------
	
	
	
	
	----------------------------------------------------------
	-- Get details on the overlays (area's we have found)
	----------------------------------------------------------
		-- for i=1, numOverlays do
			-- local textureName, texWidth, texHeight, ofsX, ofsY, mapX, mapY = GetMapOverlayInfo(i); -- Pulls back this overlays details
			
			-- if not(textureName == "") then -- If there is a texture
				-- ZMC:Msg(self, "textureName = "..tostring(textureName)..", texWidth = "..tostring(texWidth)..", texHeight = "..tostring(texHeight)..", ofsX = "..tostring(ofsX)..", ofsY = "..tostring(ofsY)..", mapX = "..tostring(mapX)..", mapY = "..tostring(mapY).."", true, DebugTxt);
			-- end;
		-- end;
		
		self:AddPointsToMap(); -- Adds points to the map for this area
		self:AddShapeToMap(); -- Adds area's to the map
	----------------------------------------------------------
end;

function WorldExplorer:AddPointsToMap() -- Adds points to the map for this area
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:AddPointsToMap()",true,DebugTxt);
	
	self.DiscPoints = self.DiscPoints or {};
	
	local CurrentDiscPoint = 0;
	
	if (TableCount(self.DiscPoints) > 0) then -- There are already points so clear them
		for Key, DiscoverPoint in pairs(self.DiscPoints) do
			DiscoverPoint:Hide(); -- Hides the frame as we don't need it for a bit
		end;
	end;
	
	local ContNum = GetCurrentMapContinent();
	local ZoneNum = GetCurrentMapZone();
	
	local icT;
	if (Nx) then -- Carbonite exits so setup the icon types for it (Also clears any existing icons)
		-- ZMC:Msg(self, "Carbonite exits so setup the icon types for it", true, DebugTxt);
		
		----------------------------------------------------------
		-- Setup the icon types for this addon (also wipes all old
		-- icons from the same addon)
		----------------------------------------------------------
			local CarbMap=Nx.Map:GeM(1);
			icT = "!"..tostring(self.Name); -- Name of the addon
			local drM = "WP"; -- This specifies it's a waypoint
			local tex = ""; -- This is a texture. Don't know what this is for as it's almost always blank.
			local w = 10; -- This is the Width of the icon
			local h = 10; -- This is the Hight of the icon
			CarbMap:IIT(icT,drM,tex,w,h);
			
			CarbMap:SITA("!WorldExplorer",1); -- Set the Alpha of these points. 0.7
			CarbMap:SITAS("!WorldExplorer",0.3);--0.5); -- Sets the scale these points disapears at.
		----------------------------------------------------------
	end;
	
	
	
	-------------------------------------------------
	-- Hard coded to ignore this zone as the new version
	-- handels this zone. :-)
	-------------------------------------------------
		if (WorldExplorer_StaticData_Areas[ContNum] and WorldExplorer_StaticData_Areas[ContNum][ZoneNum]) then -- This Zone has info in the Discovered DB and static DB
			return;
		end;
	-------------------------------------------------
	
	if (WorldExplorer_StaticData[ContNum] and WorldExplorer_StaticData[ContNum][ZoneNum]) then -- This Zone has info in the static DB
		-- ZMC:Msg(self, "This zone ("..tostring(ContNum)..", "..tostring(ZoneNum)..") has entrys in the static date DB", true, DebugTxt);
		
		local ZoneName;
		if (self.ZoneNames[ContNum] and self.ZoneNames[ContNum][ZoneNum]) then
			ZoneName = self.ZoneNames[ContNum][ZoneNum]; -- Pulls back the name for this zone
			-- ZMC:Msg(self, "ZoneName = "..tostring(ZoneName).."", true, DebugTxt);
		-- else
			-- ZMC:Msg(self, "ERROR: No entry in WorldExplorer.ZoneNames for Continent Number = '"..tostring(ContNum).."' and Zone Number = '"..tostring(ZoneNum).."'! Please report this to the Author (Zasurus) on Curse.com for help.", false, DebugTxt, true);
		end;
		
		-- ZMC:Msg(self, "Nx = "..tostring(Nx).." ZoneName = "..tostring(ZoneName).."", true, DebugTxt);
		
		local CurColourNum = 1;
		
		for Area, Discoverys in pairs(WorldExplorer_StaticData[ContNum][ZoneNum]) do -- Loop though all areas in this zone to make sure we have discovered it and display a point if we haven't
			-- ZMC:Msg(self, "", true, DebugTxt);
			-- ZMC:Msg(self, "Loop though all areas in this zone. Area = "..tostring(Area).."", true, DebugTxt);
			
			local Colour = self.Colour[CurColourNum]
			
			if (type(Discoverys) == "table") then -- Makes sure this isn't any of the name entrys for this zone
				-- ZMC:Msg(self, "Not a name variable", true, DebugTxt);
				
				local bKnownArea = false;
				if (WorldExplorer_KnownAreasOld[ContNum] and WorldExplorer_KnownAreasOld[ContNum][ZoneNum]) then -- Makes sure this has an entry
					-- ZMC:Msg(self, "WorldExplorer_KnownAreasOld[ContNum = "..tostring(ContNum).."][ZoneNum = "..tostring(ZoneNum).."][Area = "..tostring(Area).."] = "..tostring(WorldExplorer_KnownAreasOld[ContNum][ZoneNum][Area]).."", true, DebugTxt);
					bKnownArea = (WorldExplorer_KnownAreasOld[ContNum][ZoneNum][Area] == true)
				end;
				
				if not(bKnownArea) then -- We haven't yet discovered this area so add tbe dot(s)!
					-- ZMC:Msg(self, "We haven't yet discovered this area so add a dot!", true, DebugTxt);
					-- ZMC:Msg(self, "WorldExplorer_KnownAreasOld[ContNum = "..tostring(ContNum).."][ZoneNum = "..tostring(ZoneNum).."][Area = "..tostring(Area).."]", true, DebugTxt);
					
					if (WorldExplorer_StaticData[ContNum][ZoneNum][Area]) then -- Ensure this are exists in the static DB
						for DiscoveredPointNum, DiscoveredPoint in pairs(WorldExplorer_StaticData[ContNum][ZoneNum][Area]) do
							if (type(DiscoveredPoint) == "table") then -- Ensure this is a discovery point and not a text string for texture name etc...
								------------------------------------------
								-- Choice which icon to use
								------------------------------------------
									local Icon;
									
									if ((WorldExplorer_StaticData[ContNum][ZoneNum][Area][DiscoveredPointNum]) and (WorldExplorer_StaticData[ContNum][ZoneNum][Area][DiscoveredPointNum]["Dud"] == true)) then
										-- ZMC:Msg(self, "Area = "..tostring(Area).." Is a dud!", true, DebugTxt);
										Icon = self.Icons.Cross;
									elseif (WorldExplorer_StaticData[ContNum][ZoneNum][Area] and (WorldExplorer_StaticData[ContNum][ZoneNum][Area][DiscoveredPointNum]["Generated"] == true)) then
										-- ZMC:Msg(self, "Area = "..tostring(Area).." Is NOT a dud BUT is generated", true, DebugTxt);
										Icon = self.Icons.Square;
									else
										-- ZMC:Msg(self, "Area = "..tostring(Area).." Is nether a dud or generated", true, DebugTxt);
										Icon = self.Icons.Circle;
									end;
								------------------------------------------
								
								
								
								------------------------------------------
								-- Pull out the colours and alpha
								------------------------------------------
									local Colour_r=tonumber(strsub(Colour,1,2),16)/255;
									local Colour_g=tonumber(strsub(Colour,3,4),16)/255;
									local Colour_b=tonumber(strsub(Colour,5,6),16)/255;
									local Alpha = 1;
								------------------------------------------
								
								local IconNote;
								if (WorldExplorer_StaticData[ContNum][ZoneNum][Area]["AreaName"]) then
									IconNote = WorldExplorer_StaticData[ContNum][ZoneNum][Area]["AreaName"];
								else
									IconNote = Area;
								end;
								
								if ((CurrentDiscPoint + 1) < TableCount(self.DiscPoints)) then -- There is already a point we can use so don't create one
									local DiscoverPoint = self.DiscPoints[CurrentDiscPoint]; -- Pulls back a point(frame) out of the pot to reuse
									DiscoverPoint:SetWidth(Icon.Width);
									DiscoverPoint:SetHeight(Icon.Height);
									DiscoverPoint.icon:SetAllPoints();
									DiscoverPoint:SetScript("OnEnter", function() ChatFrame1:AddMessage("Button = "..tostring(IconNote)); end);
									DiscoverPoint.icon:SetTexture(Icon.Texture);
									DiscoverPoint.icon:SetVertexColor(Colour_r, Colour_g, Colour_b, Alpha) -- Sets the colour (Red, Green, Blue, Alpha)
									DiscoverPoint:SetFrameLevel(10000);
									DiscoverPoint:EnableMouse(true);
									DiscoverPoint:Show();
									self.DiscPoints[CurrentDiscPoint] = DiscoverPoint; -- Stores the point back into the pot (it won't be reused until we are done with it)
								else
									local DiscoverPoint=CreateFrame("Button", "ExplorerCoordsWorldTargetFrame",WorldMapDetailFrame );
									DiscoverPoint:SetWidth(Icon.Width);
									DiscoverPoint:SetHeight(Icon.Height);
									DiscoverPoint.icon = DiscoverPoint:CreateTexture("ARTWORK");
									DiscoverPoint.icon:SetAllPoints();
									DiscoverPoint:SetScript("OnEnter", function() ChatFrame1:AddMessage("Button = "..tostring(IconNote)); end);
									DiscoverPoint.icon:SetTexture(Icon.Texture);
									DiscoverPoint.icon:SetVertexColor(Colour_r, Colour_g, Colour_b, Alpha) -- Sets the colour (Red, Green, Blue, Alpha)
									DiscoverPoint:SetFrameLevel(10000);
									DiscoverPoint:EnableMouse(true);
									DiscoverPoint:Show();
									self.DiscPoints[CurrentDiscPoint] = DiscoverPoint; -- Stores the point back into the pot (it won't be reused until we are done with it)
								end;
								
								-- ZMC:Msg(self, "WorldExplorer_StaticData[ContNum = "..tostring(ContNum).."][ZoneNum = "..tostring(ZoneNum).."][Area = "..tostring(Area).."][DiscoveredPointNum = "..tostring(DiscoveredPointNum).."][CordX]", true, DebugTxt);
								local CordX = WorldExplorer_StaticData[ContNum][ZoneNum][Area][DiscoveredPointNum]["CordX"]
								local CordY = WorldExplorer_StaticData[ContNum][ZoneNum][Area][DiscoveredPointNum]["CordY"]
								
								-- ZMC:Msg(self, "CordX = "..tostring(CordX).." CordY = "..tostring(CordY).." Icon.Texture = "..tostring(Icon.Texture).."", true, DebugTxt);
								
								-- ZMC:Msg(self, "self.Astrolabe:PlaceIconOnWorldMap(WorldMapDetailFrame = "..tostring(WorldMapDetailFrame)..", self.DiscPoints[CurrentDiscPoint] = "..tostring(self.DiscPoints[CurrentDiscPoint])..", ContNum = "..tostring(ContNum)..", ZoneNum = "..tostring(ZoneNum)..", CordX = "..tostring(CordX)..", CordY = "..tostring(CordY)..");", true, DebugTxt);
								self.Astrolabe:PlaceIconOnWorldMap(WorldMapDetailFrame, self.DiscPoints[CurrentDiscPoint], ContNum, ZoneNum, CordX, CordY);
								
								if (Nx and ZoneName) then -- Carbonite exits so add the icons to that as well
									-- ZMC:Msg(self, "Carbonite exits so add this icon to that as well", true, DebugTxt);
									
									----------------------------------------------------------
									-- Creates an icon
									----------------------------------------------------------
										local mapName = ZoneName; -- This is the name of the zone e.g. "Tirisfal Glades"
										local zoneX = CordX * 100; -- This is how from the left to the right of the zone the icon is in %. So if this was 0 it would be the far left if it was 100 it would be far right and if it was 50 it would be half way across
										local zoneY = CordY * 100; -- This is a % of the Hight of the zone (same as the width)
										local texture = Icon.Texture; -- This is the texure that will be used for the icon(Picture)
										local iconNote = tostring(IconNote); -- This is the note text(the text that pops up when you mouse over the icon)
										
										-- ZMC:Msg(self, "mapName = "..tostring(mapName).." zoneX = "..tostring(zoneX).." zoneY = "..tostring(zoneY).." texture = "..tostring(texture).." iconNote = "..tostring(iconNote).."", true, DebugTxt);
										
										local map2=Nx.Map:GeM(1);
										local maI=Nx.MNTI1[mapName];
										if maI then
											local wx,wy=map2:GWP(maI,zoneX,zoneY);
											-- ZMC:Msg(self, "wx = "..tostring(wx)..",wy = "..tostring(wy).."", true, DebugTxt);
											local icon = map2:AIP(icT,wx,wy,Colour,texture);
											map2:SIT(icon, iconNote); -- This sets the note(the text that pops up when you mouse over the icon)
										end;
									----------------------------------------------------------
								end;
								
								CurrentDiscPoint = CurrentDiscPoint + 1; -- Increase the current point by one.
							end;
						end;
					end;
				end;
			end;
			
			CurColourNum = CurColourNum + 1;
			if (CurColourNum > TableCount(self.Colour)) then
				CurColourNum = 1;
			end;
		end;
	end;
end;

function WorldExplorer:RequestUpdateKnownZoneList(RequestType) -- Requests the time the player has played and when it gets the time it does a full update of all points
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:RequestUpdateKnownZoneList( = "..tostring(RequestType)..")",true,DebugTxt);
	
	WorldExplorer.UpdateKnownZoneListRequest = RequestType or 2; -- If no request type specified then say we want to update the list of discovered area's (Default)
	
	-- ZMC:Msg(self, "WorldExplorer.UpdateKnownZoneListRequest = "..tostring(WorldExplorer.UpdateKnownZoneListRequest).."", true, DebugTxt);
	
	if (self.LoadedStatus["Initialized"] == 1) then
		self:InitLevel(2); -- Says that the second part of the setup is done if it hasn't already been! Need to get a zone update yet though.
	end;
	
	self.Dongle:ScheduleTimer("WorldExplorer_UpdateKnownZones", function() self:UpdateKnownZoneList(); self:UpdateKnownZoneList2(); self:AddPointsToMap(); end, 1); -- Schedule function "UpdateKnownZoneList" to run in a second to try to prevent it from messing around with the discover zones function
end;

function WorldExplorer:UpdateKnownZoneList() -- Goes though all zones updating the area's that we have explored! (Should be run for the first time you play a toon with this addon and any time you have explored an area without the addon running
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:UpdateKnownZoneList()",true,DebugTxt);
	
	--[[
		"WorldExplorer.UpdateKnownZoneListRequest" is used by the calling function to tell this
		function what information to gather and what to do with it:
		
		0 = Do nothing drop out of function.
		2 = Update list of discovered area's (for when the addon first loads encase points where
			discovered when the addon wasn't loaded or this is the first time it has been loaded).
	]]--
	
	local TempLocationStore = {}; -- The tempory variable we will use for updating (reduces if's for each different type)
	
	if (WorldExplorer.UpdateKnownZoneListRequest == 2) then
		-- ZMC:Msg(self, "Update request in place(2). Continuing update.", true, DebugTxt);
		--TempLocationStore = WorldExplorer_KnownAreasOld; -- Store the current contence into the Temp Variable
	elseif not(WorldExplorer.UpdateKnownZoneListRequest == 1) then
		-- ZMC:Msg(self, "No update request so exiting.", true, DebugTxt);
		return;
	end;
	
	local tempContinent = GetCurrentMapContinent(); -- Gets the Continent the map is currently showing (so we can put it back after)
	local tempZone = GetCurrentMapZone(); -- Gets the Continent the map is currently showing (so we can put it back after)
	
	for ContNum,ContInfo in pairs(self.ZoneNames) do -- Loop though all of the continents
		ContName = ContInfo["Name"]; -- Stores the Continent Name
		
		for ZoneNum,ZoneName in pairs(self.ZoneNames[ContNum]) do -- Loop though all of the zones for this continent
			-- ZMC:Msg(self, "[ContNum = "..tostring(ContNum)..", ZoneNum = "..tostring(ZoneNum).."] ContName = "..tostring(ContName).."ZoneName = "..tostring(ZoneName).."", true, DebugTxt);
			
			if not(ZoneNum == "Name") then -- Makes sure this is not the Continent Name Label
				SetMapZoom(ContNum, ZoneNum); -- Set the current map zoom of the world map to a specific continent and zone to get the info on it.
				
				local numOverlays = self:GetNumberOfMapOverlays(true); -- Returns the number of overlays that exist including blank ones.
				-- ZMC:Msg(self, "numOverlays = "..tostring(numOverlays).."", true, DebugTxt);
				
				if (self:GetNumberOfMapOverlays() > 0) then -- There are overlays for this zone so we have discovered something in it
					-- ZMC:Msg(self, "There are overlays("..tostring(self:GetNumberOfMapOverlays())..") for this zone("..tostring(ContName)..", "..tostring(ZoneName)..") so we have discovered something in it", true, DebugTxt);
					
					--------------------------------------------------------------
					-- Make sure that this zone and it's continent exist in the DB
					--------------------------------------------------------------
						if not(type(TempLocationStore[ContNum]) == "table") then -- Makes sure this is already an array and not a string etc...
							TempLocationStore[ContNum] = {};
						end;
						
						if not(type(TempLocationStore[ContNum][ZoneNum]) == "table") then -- Makes sure this is already an array and not a string etc...
							TempLocationStore[ContNum][ZoneNum] = {};
						end;
					--------------------------------------------------------------
					
					if not(TempLocationStore[ContNum][ZoneNum]["Name"]) then -- The name for this zone doesn't exist so take it from the ZoneNames array
						TempLocationStore[ContNum][ZoneNum]["Name"] = ZoneName; -- Store the name in it's own field
					end;
					
					local mapFileName, ZoneTextureHeight, ZoneTextureWidth = GetMapInfo();
					TempLocationStore[ContNum][ZoneNum]["mapFileName"] = mapFileName; -- Stores/Overwrites the map name for this zone
					----------------------------------------------------------
					-- Get details on the overlays (area's we have found)
					----------------------------------------------------------
						for i=1, numOverlays do -- Loop though all of the overlays
							local textureName, textureWidth, textureHeight, offsetX, offsetY, mapPointX, mapPointY = GetMapOverlayInfo(i);
							-- ZMC:Msg(self, "i = "..tostring(i).."", true, DebugTxt);
							if ( textureName and textureName ~= "" ) then -- Makes sure this overlay has a texture
								-- ZMC:Msg(self, "This overlay has a texture: "..tostring(textureName), true, DebugTxt);
								
								local OverlayName = strsub(GetMapOverlayInfo(i), - (strfind(strrev(GetMapOverlayInfo(i)),"\\") -1))
								
								TempLocationStore[ContNum][ZoneNum][OverlayName] = true; -- Say we know about this area!
							end
						end
					----------------------------------------------------------
				end;
			end;
		end;
	end;
	
	SetMapZoom(tempContinent, tempZone); -- Reset the map to the original zone.
	
	if (WorldExplorer.UpdateKnownZoneListRequest == 2) then
		-- ZMC:Msg(self, "Update request in place(2). Finishing update.", true, DebugTxt);
		WorldExplorer_KnownAreasOld = TempLocationStore; -- Restore the Temp Variable into the original variable
	end;
	
	WorldExplorer.UpdateKnownZoneListRequest = 0; -- Resets back to 0 for next time.
end;

function WorldExplorer:GetRealPlayerLocation() -- Quickly switch to the current map and store the players current location
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:GetRealPlayerLocation()",true,DebugTxt);
	
	local tempContinent = GetCurrentMapContinent(); -- Gets the Continent the map is currently showing (so we can put it back after)
	local tempZone = GetCurrentMapZone(); -- Gets the Continent the map is currently showing (so we can put it back after)
	
	SetMapToCurrentZone(); -- Set the map to the zone the player is currently in
	
	local ReturnAry = {}; -- An array that will be returned with the players current location...
	ReturnAry[1] = GetCurrentMapContinent(); -- Get the current continent number
	ReturnAry[2] = GetCurrentMapZone(); -- Get the current zone number
	ReturnAry[3], ReturnAry[4] = GetPlayerMapPosition("player"); -- Get the players current location
	
	if not((self.CurContNum == tempContinent) and (self.CurZoneNum == tempZone)) then -- Only change the zone back if it has really changed!
		SetMapZoom(tempContinent, tempZone); -- Reset the map to the original zone.
	end;
	
	return ReturnAry; -- Say there where no errors (that we picked up on) so it's all OK!
end;

function WorldExplorer:AddShapeToMap() -- Adds a shape to the map for this area
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:AddShapeToMap()",true,DebugTxt);
	
	self.DiscAreaTextures = self.DiscAreaTextures or {};
	
	local CurrentDiscArea = 0;
	
	if (TableCount(self.DiscAreaTextures) > 0) then -- There are already areas so clear them
		for Key, DiscoverArea in pairs(self.DiscAreaTextures) do
			DiscoverArea:Hide(); -- Hides the frame as we don't need it for a bit
		end;
	end;
	
	local ContNum = GetCurrentMapContinent();
	local ZoneNum = GetCurrentMapZone();
	
	self.DiscArea = self.DiscArea or CreateFrame("Frame", "WorldExplorer_Areas", WorldMapDetailFrame); --Creates a new UI frame if it doesn't exist;
	self.DiscArea:SetParent(WorldMapDetailFrame); -- Ensures the frame has the correct parent
	self.DiscArea:ClearAllPoints(); -- Clear all existing points
	self.DiscArea:SetAllPoints(); -- Make this the same size etc as it's parent frame
	
	local icT_Icons;
	if (Nx) then -- Carbonite exits so setup the area types for it (Also clears any existing icons)
		-- ZMC:Msg(self, "Carbonite exits so setup the area types for it", true, DebugTxt);
		
		----------------------------------------------------------
		-- Setup the Area(icon) values for this addon (also wipes all old
		-- icons from the same addon)
		----------------------------------------------------------
			local CarbMap=Nx.Map:GeM(1);
			icT_Areas = "!"..tostring(self.Name).."_Areas"; -- Name of the addon
			local drM = "ZR"; -- This specifies it's a "World point"
			local tex = ""; -- This is a texture. Don't know what this is for as it's almost always blank.
			local lev = -6; -- This is the frame level this icon should have. (Setting it to -1 seems to put it behind icons)
			CarbMap:IIT(icT_Areas,drM);
			
			CarbMap:SITL(icT_Areas,lev);
			CarbMap:SITAS(icT_Areas,0.3); -- Sets the scale these points disapears at.
		----------------------------------------------------------
	end;
	
	if (WorldExplorer_StaticData_Areas[ContNum] and WorldExplorer_StaticData_Areas[ContNum][ZoneNum]) then -- This Zone has info in the Discovered DB and static DB
		-- ZMC:Msg(self, "This zone ("..tostring(ContNum)..", "..tostring(ZoneNum)..") has entrys in the static date DB", true, DebugTxt);
		
		local ZoneName;
		if (self.ZoneNames[ContNum] and self.ZoneNames[ContNum][ZoneNum]) then
			ZoneName = self.ZoneNames[ContNum][ZoneNum]; -- Pulls back the name for this zone
			-- ZMC:Msg(self, "ZoneName = "..tostring(ZoneName).."", true, DebugTxt);
		else
			ZMC:Msg(self, "ERROR: No entry in WorldExplorer.ZoneNames for Continent Number = '"..tostring(ContNum).."' and Zone Number = '"..tostring(ZoneNum).."'! Please report this to the Author (Zasurus) on Curse.com for help.", false, DebugTxt, true);
		end;
		
		-- ZMC:Msg(self, "Nx = "..tostring(Nx).." ZoneName = "..tostring(ZoneName).."", true, DebugTxt);
		
		local CurColourNum = 1;
		
		for Area, Discoverys in pairs(WorldExplorer_StaticData_Areas[ContNum][ZoneNum]) do -- Loop though all areas in this zone to make sure we have discovered it and display a point if we haven't
			-- ZMC:Msg(self, "", true, DebugTxt);
			-- ZMC:Msg(self, "Loop though all areas in this zone. Area = "..tostring(Area).."", true, DebugTxt);
			
			if ((type(Discoverys) == "table") )then-- and (WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"])) then -- Makes sure this isn't any of the name entrys for this zone
				-- ZMC:Msg(self, "Not a name variable", true, DebugTxt);
				
				local bNotAchieveArea = true;
				local bKnownArea = false;
				
				if (WorldExplorer_KnownAreas[ContNum] and WorldExplorer_KnownAreas[ContNum][ZoneNum]) then -- Makes sure this has an entry
					-- ZMC:Msg(self, "WorldExplorer_KnownAreas[ContNum = "..tostring(ContNum).."][ZoneNum = "..tostring(ZoneNum).."][Area = "..tostring(Area).."] = "..tostring(WorldExplorer_KnownAreas[ContNum][ZoneNum][Area]).."", true, DebugTxt);
					bKnownArea = (WorldExplorer_KnownAreas[ContNum][ZoneNum][Area] == true)
				end
				
				if (WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"]) then
					-- ZMC:Msg(self, "bNotAchieveArea = false;", true, DebugTxt);
					
					bNotAchieveArea = false; -- Say this is an achievement area (as in required for the explorer achievement)
					
					if (WorldExplorer_KnownAreas[ContNum] and WorldExplorer_KnownAreas[ContNum][ZoneNum]) then -- Makes sure this has an entry
						-- ZMC:Msg(self, "WorldExplorer_KnownAreas[ContNum = "..tostring(ContNum).."][ZoneNum = "..tostring(ZoneNum).."][Area = "..tostring(WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"]).."] = "..tostring(WorldExplorer_KnownAreas[ContNum][ZoneNum][WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"]]).."", true, DebugTxt);
						bKnownArea = (WorldExplorer_KnownAreas[ContNum][ZoneNum][WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"]] == true)
						-- ZMC:Msg(self, "bKnownArea = "..tostring(bKnownArea).."", true, DebugTxt);
					end;
				end;
				
				local AreaNote = Area;
				if (WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["Notes"]) then
					AreaNote = AreaNote.."\n"..tostring(WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["Notes"]);
				end;
				
				if (not(WorldExplorer_Options["HideNoneAchiv"]) and not(bNotAchieveArea)) then
					if (WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"] == Area) then
						AreaNote = AreaNote.."\n|cffff9900Achievement|r";
					else
						AreaNote = AreaNote.."\n|cffff9900Achievement ("..WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"]..")|r";
					end;
				elseif (not(bNotAchieveArea) and not(WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"] == Area)) then
					AreaNote = AreaNote.."\n|cffff9900("..WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["AchivementString"]..")|r";
				end;
				
				-- ZMC:Msg(self, "AreaNote = "..tostring(AreaNote).." WorldExplorer_Options[HideKnown] = "..tostring(WorldExplorer_Options["HideKnown"]).." and bKnownArea = "..tostring(bKnownArea)..")) and not(WorldExplorer_Options[HideNoneAchiv] = "..tostring(WorldExplorer_Options["HideNoneAchiv"]).." and bNotAchieveArea = "..tostring(bNotAchieveArea).."", true, DebugTxt);
				
				if (not(WorldExplorer_Options["HideKnown"] and bKnownArea)) and not(WorldExplorer_Options["HideNoneAchiv"] and bNotAchieveArea) then -- Hides known area's and none achievement aera's if those options are enabled
					local Alpha = self.DefaultAlpha; -- Alpha in numeric value 0 being transparent and 1 being solid
					
					local ColourNumber;
					
					if (WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["ColourNum"] == 0) then
						Colour = tostring("000000")..tostring(format("%X", Alpha*255));
						ColourNumber = 0;
					else
						if (WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["ColourNum"]) then
							ColourNumber = WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]["ColourNum"];
						else
							ColourNumber = CurColourNum;
							
							CurColourNum = CurColourNum + 1;
							if (CurColourNum > TableCount(self.Colour)) then
								CurColourNum = 1;
							end;
						end;
						
						Alpha = self.Alpha[ColourNumber];
						Colour = tostring(self.Colour[ColourNumber])..tostring(format("%X", Alpha*255)) -- Add alpha in hex
					end;
					
					for DiscoveredAreaNum, DiscoveredArea in pairs(WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area]) do
						if (type(DiscoveredArea) == "table") then -- Ensure this is a discovery point and not a text string for texture name etc...
							------------------------------------------
							-- Pull out the colours and alpha
							------------------------------------------
								local Colour_r=tonumber(strsub(Colour,1,2),16)/255;
								local Colour_g=tonumber(strsub(Colour,3,4),16)/255;
								local Colour_b=tonumber(strsub(Colour,5,6),16)/255;
								local Colour_a=tonumber(strsub(Colour,7,8),16)/255;
							------------------------------------------
							
							
							
							------------------------------------------
							-- Pulls out/sets up the coords
							------------------------------------------
								-- ZMC:Msg(self, "WorldExplorer_StaticData_Areas[ContNum = "..tostring(ContNum).."][ZoneNum = "..tostring(ZoneNum).."][Area = "..tostring(Area).."][DiscoveredAreaNum = "..tostring(DiscoveredAreaNum).."]", true, DebugTxt);
								local Left = WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area][DiscoveredAreaNum]["Left"]
								local Right = WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area][DiscoveredAreaNum]["Right"]
								local Top = WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area][DiscoveredAreaNum]["Top"]
								local Bottom = WorldExplorer_StaticData_Areas[ContNum][ZoneNum][Area][DiscoveredAreaNum]["Bottom"]
								
								local Width = self.DiscArea:GetWidth(); -- The width of the area frame
								local Height = self.DiscArea:GetHeight(); -- The height of the area frame
								
								local CoordTopLeftX = Width * Left -- Calculate the X coordinates from the top left of this area to the top left of this area
								local CoordTopLeftY = Height * Top -- Calculate the Y coordinates from the top left of this area to the top left of this area
								local CoordBottomRightX = Width * Right -- Calculate the X coordinates from the top left of this area to the bottom right of this area
								local CoordBottomRightY = Height * Bottom -- Calculate the Y coordinates from the top left of this area to the bottom right of this area
							------------------------------------------
							
							local DiscAreaTexture; -- A temporary place to store this texture while we use it.
							
							if ((CurrentDiscArea + 1) < TableCount(self.DiscAreaTextures)) then -- There is already a point we can use so don't create one
								DiscAreaTexture = self.DiscAreaTextures[CurrentDiscArea]; -- Pulls back a area(texture) out of the pot to reuse
							else
								DiscAreaTexture = self.DiscArea:CreateTexture(); -- Creates a new UI texture
							end;
							
							DiscAreaTexture:SetTexture(Colour_r, Colour_g, Colour_b, Colour_a);
							DiscAreaTexture:ClearAllPoints();
							DiscAreaTexture:SetPoint("TOPLEFT", self.DiscArea, "TOPLEFT", CoordTopLeftX, -CoordTopLeftY);
							DiscAreaTexture:SetPoint("BOTTOMRIGHT", self.DiscArea, "TOPLEFT", CoordBottomRightX, -CoordBottomRightY);
							DiscAreaTexture:Show();
							
							self.DiscAreaTextures[CurrentDiscArea] = DiscAreaTexture; -- Puts back the area(texture) into the pot to reuse later
							self.DiscArea:Show();
							self.DiscAreaTextures[CurrentDiscArea] = DiscAreaTexture; -- Stores the area into the pot (it won't be reused until we are done with it)
							
							-- ZMC:Msg(self, "Left = "..tostring(Left).." Right = "..tostring(Right).." Top = "..tostring(Top).." Bottom = "..tostring(Bottom), true, DebugTxt);
							
							-- AreaNote = AreaNote.."Left = "..tostring(Left).." Right = "..tostring(Right).." Top = "..tostring(Top).." Bottom = "..tostring(Bottom); -- Adds the coords to the note(for dev only)
							
							if (Nx and ZoneName) then -- Carbonite exits so add the icons to that as well
								-- ZMC:Msg(self, "Carbonite exits so add this area to that as well", true, DebugTxt);
								
								----------------------------------------------------------
								-- Creates a coloured rectangle
								----------------------------------------------------------
									do
										local mapName = ZoneName; -- This is the name of the zone e.g. "Tirisfal Glades"
										local zoneX = Left * 100; -- This is how from the left to the right of the zone the icon is in %. So if this was 0 it would be the far left if it was 100 it would be far right and if it was 50 it would be half way across
										local zoneY = Top * 100; -- This is a % of the Hight of the zone (same as the width)
										local zoneX2 = Right * 100; -- This is how from the left to the right of the zone the icon is in %. So if this was 0 it would be the far left if it was 100 it would be far right and if it was 50 it would be half way across
										local zoneY2 = Bottom * 100; -- This is a % of the Hight of the zone (same as the width)
										local AreaNote2 = AreaNote; -- This is the note text(the text that pops up when you mouse over the icon)
										
										-- ZMC:Msg(self, "icT_Areas = "..tostring(icT_Areas)..",maI = "..tostring(maI)..",zoneX = "..tostring(zoneX)..",zoneY = "..tostring(zoneY)..",zoneX2 = "..tostring(zoneX2)..",zoneY2 = "..tostring(zoneY2)..",Colour = "..tostring(Colour).."", true, DebugTxt);
										
										local map2=Nx.Map:GeM(1);
										local maI=Nx.MNTI1[mapName];
										if maI then
											local Rectange = map2:AIR(icT_Areas,maI,zoneX,zoneY,zoneX2,zoneY2,Colour)
											map2:SIT(Rectange, AreaNote2); -- This sets the note(the text that pops up when you mouse over the Rectange)
										end;
									end;
								----------------------------------------------------------
							end;
							
							CurrentDiscArea = CurrentDiscArea + 1; -- Increase the current point by one.
						end;
					end;
				end;
			end;
		end;
	-- else
		-- ZMC:Msg(self, "No data in WorldExplorer_StaticData_Areas for this zone!", true, DebugTxt, true);
	end;
end;

function WorldExplorer:UpdateKnownZoneList2() -- Goes though all zones updating the area's that we have explored! (Should be run for the first time you play a toon with this addon and any time you have explored an area without the addon running
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:UpdateKnownZoneList2()",true,DebugTxt);
	
	achievementID = 46; -- This is the WorldExplorer Achievement ID
	
	-- ZMC:Msg(self, "achievementID = "..tostring(achievementID).."", true, DebugTxt);
	
	local IDNumber, Name, Points, CompletedM, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(achievementID);
	
	-- ZMC:Msg(self, "IDNumber = "..tostring(IDNumber)..", Name = "..tostring(Name)..", Points = "..tostring(Points)..", Completed = "..tostring(Completed)..", Month = "..tostring(Month)..", Day = "..tostring(Day)..", Year = "..tostring(Year)..", Description = "..tostring(Description)..", Flags = "..tostring(Flags)..", Image = "..tostring(Image)..", RewardText = "..tostring(RewardText).."", true, DebugTxt);
	
	local numCriteria = GetAchievementNumCriteria(achievementID)
	
	-- ZMC:Msg(self, "numCriteria = "..tostring(numCriteria), true, DebugTxt);
	
	WorldExplorer_KnownAreas = WorldExplorer_KnownAreas or {};
	WorldExplorer_KnownAreas["RealAchieveComplete"] = CompletedM;
	
	for i=1, numCriteria do -- Loops though the number of Criteria in Achievement
		local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID = GetAchievementCriteriaInfo(achievementID, i);
		
		local CurContNum;
		for ContNum,Zones in pairs(self.ZoneNames) do -- Loop though all of the Continent numbers to find this one
			if (self.ZoneNames[ContNum]["Name"] == criteriaString) then -- This is the continent we want
				CurContNum = ContNum; -- Store this Continent number
			end;
		end;
		
		-- ZMC:Msg(self, "criteriaString = "..tostring(criteriaString).." CurContNum = "..tostring(CurContNum).."", true, DebugTxt);
		
		WorldExplorer_KnownAreas[CurContNum] = WorldExplorer_KnownAreas[CurContNum] or {};
		WorldExplorer_KnownAreas[CurContNum]["RealAchieveComplete"] = completed;
		
		-- ZMC:Msg(self, "   criteriaString = "..tostring(criteriaString)..", criteriaType = "..tostring(criteriaType)..", completed = "..tostring(completed)..", quantity = "..tostring(quantity)..", reqQuantity = "..tostring(reqQuantity)..", charName = "..tostring(charName)..", flags = "..tostring(flags)..", assetID = "..tostring(assetID)..", quantityString = "..tostring(quantityString)..", criteriaID = "..tostring(criteriaID).."", true, DebugTxt);
		
		local numCriteria2 = GetAchievementNumCriteria(assetID)
		for j=1, numCriteria2 do -- Loops though the number of Criteria in the SubAchievement
			local criteriaString2, criteriaType2, completed2, quantity2, reqQuantity2, charName2, flags2, assetID2, quantityString2, criteriaID2 = GetAchievementCriteriaInfo(assetID, j);
			
			local CurZoneNum;
			for ZoneNum,Areas in pairs(self.ZoneNames[CurContNum]) do -- Loop though all of the Zone numbers to find this one
				-- ZMC:Msg(self, "                     CurContNum = "..tostring(CurContNum).." ZoneNum = "..tostring(ZoneNum).."", true, DebugTxt);
				
				if (not(ZoneNum == "Name") and (self.ZoneNames[CurContNum][ZoneNum] == criteriaString2)) then -- This is the Zone we want
					CurZoneNum = ZoneNum; -- Store this Zone number
				end;
			end;
			
			if (CurZoneNum == nil) then -- We didn't find a matching name so try the dif db
				if (WorldExplorer_StaticData_AchieveDif and WorldExplorer_StaticData_AchieveDif[CurContNum]) then
					for ZoneNum,Areas in pairs(WorldExplorer_StaticData_AchieveDif[CurContNum]) do -- Loop though all of the Zone numbers to find this one
						-- ZMC:Msg(self, "                     CurContNum = "..tostring(CurContNum).." ZoneNum = "..tostring(ZoneNum).."", true, DebugTxt);
						
						if (not(ZoneNum == "Name") and (WorldExplorer_StaticData_AchieveDif[CurContNum][ZoneNum] == criteriaString2)) then -- This is the Zone we want
							CurZoneNum = ZoneNum; -- Store this Zone number
						end;
					end;
				else
					ZMC:Msg(self, "ERROR: Continent Number: '"..tostring(criteriaString2).."' can't be found!", false, DebugTxt, true);
					return;
				end;
				
				if (CurZoneNum == nil) then -- It's still not found so give in!
					ZMC:Msg(self, "ERROR: Zone: '"..tostring(criteriaString2).."' wan't found in continent number '"..tostring(CurContNum).."'", false, DebugTxt, true);
					return;
				end;
			end;
			
			-- ZMC:Msg(self, "criteriaString2 = "..tostring(criteriaString2).." CurZoneNum = "..tostring(CurZoneNum).."", true, DebugTxt);
			
			WorldExplorer_KnownAreas[CurContNum][CurZoneNum] = WorldExplorer_KnownAreas[CurContNum][CurZoneNum] or {};
			WorldExplorer_KnownAreas[CurContNum][CurZoneNum]["Complete"] = completed2;
			
			local numCriteria3 = GetAchievementNumCriteria(assetID2)
			for k=1, numCriteria3 do -- Loops though the number of Criteria in the SubAchievement
				local criteriaString3, criteriaType3, completed3, quantity3, reqQuantity3, charName3, flags3, assetID3, quantityString3, criteriaID3 = GetAchievementCriteriaInfo(assetID2, k);
				
				WorldExplorer_KnownAreas[CurContNum][CurZoneNum][criteriaString3] = completed3;
			end;
		end;
	end;
	
	self:AddShapeToMap(); -- Adds area's to the map
end;

function WorldExplorer:NewAreaEntered() -- We entered a new area so assume we now know this zone and if we didn't before refresh the map points
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:NewAreaEntered()",true,DebugTxt);
	
	local ContNum, ZoneNum, CordX, CordY, ZoneName, RealZoneName, SubZoneName, MiniMapZoneName = self:GetCurrentToonLocation(); -- Get character location
	
	-- ZMC:Msg(self, "ContNum = "..tostring(ContNum)..", ZoneNum = "..tostring(ZoneNum)..", MiniMapZoneName = "..tostring(MiniMapZoneName).."", true, DebugTxt);
	
	if not(WorldExplorer_KnownAreas and WorldExplorer_KnownAreas[ContNum] and WorldExplorer_KnownAreas[ContNum][ZoneNum] and WorldExplorer_KnownAreas[ContNum][ZoneNum][MiniMapZoneName]) then
		-- ZMC:Msg(self, "WorldExplorer_KnownAreas[ContNum = "..tostring(ContNum).."][ZoneNum = "..tostring(ZoneNum).."][MiniMapZoneName = "..tostring(MiniMapZoneName).."] FOUND!", true, DebugTxt);
		
		WorldExplorer_KnownAreas = WorldExplorer_KnownAreas or {};
		WorldExplorer_KnownAreas[ContNum] = WorldExplorer_KnownAreas[ContNum] or {};
		WorldExplorer_KnownAreas[ContNum][ZoneNum] = WorldExplorer_KnownAreas[ContNum][ZoneNum] or {};
		WorldExplorer_KnownAreas[ContNum][ZoneNum][MiniMapZoneName] = true;
		
		self:AddShapeToMap(); -- Adds a shape to the map for this area
	end;
end;

function WorldExplorer:GetCurrentToonLocation(bOverride) -- This returns the current location of your character in an array
	----------------------------------------------
	-- Default: If DebugTxt is set to true all of
	-- the debug msgs in THIS function will apear!
	----------------------------------------------
		local DebugTxt = false;
		-- DebugTxt = true; -- Uncomment this to debug
	----------------------------------------------
	
	-- ZMC:Msg(self, "WorldExplorer:GetCurrentToonLocation()",true,DebugTxt);
	
	local tempContinent = GetCurrentMapContinent(); -- Gets the Continent the map is currently showing (so we can put it back after)
	local tempZone = GetCurrentMapZone(); -- Gets the Continent the map is currently showing (so we can put it back after)
	
	if not(bOverride) then -- Don't change maps if the bOverride flag is true
		SetMapToCurrentZone(); -- Set the map to the zone the player is currently in
	end;
	
	local ContNum = GetCurrentMapContinent(); -- Get the current continent number
	local ZoneNum = GetCurrentMapZone(); -- Get the current zone number
	
	local CordX, CordY = GetPlayerMapPosition("player"); -- Get the players current location
	
	local ZoneName = GetZoneText(); -- This is the Zone's Name
	local RealZoneName = GetRealZoneText(); -- This is the Zone's Name OR Instance Name if in an instance
	
	local SubZoneName = GetSubZoneText(); -- This is the Sub Zone Name (It is nil if not in a sub zone) This looks like the area's that revial map zones!!!!
	local MiniMapZoneName = GetMinimapZoneText(); -- This gives us the subzone name OR if there is no subzone it gives us the Zone name...
	
	if not(bOverride) then -- Don't change maps if the bOverride flag is true
		SetMapZoom(tempContinent, tempZone); -- Reset the map to the original zone.
	-- else
		-- ZMC:Msg(self, "bOverride!", true, DebugTxt);
	end;
	
	return ContNum, ZoneNum, CordX, CordY, ZoneName, RealZoneName, SubZoneName, MiniMapZoneName; -- Return the values we just generated
end;

WorldExplorer:RegisterEvent("ADDON_LOADED"); -- BCatch when this addon has finished loading
WorldExplorer:SetScript("OnEvent", WorldExplorer.OnEvent);