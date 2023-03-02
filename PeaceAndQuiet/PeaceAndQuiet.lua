local PeaceAndQuiet = LibStub("AceAddon-3.0"):NewAddon("PeaceAndQuiet", "AceConsole-3.0", "AceEvent-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("PeaceAndQuiet", true)

local defaults = {
    profile = {
        verbose = true,
        manageGeneral = true,
        manageLocalDefense = true,
        manageGuild = true,
        manageWorld = true
    }
}

local options

function PeaceAndQuiet:GetOptions()
    if not options then
        options = {
            name = "PeaceAndQuiet",
            type = 'group',
            args = {}
        }
    end
        
    return options
end

function PeaceAndQuiet:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(PeaceAndQuiet, "paq", "PeaceAndQuiet", input)
    end
end

function PeaceAndQuiet:OnInitialize()
    -- Load the settings
    self.db = LibStub("AceDB-3.0"):New("PeaceAndQuietDB", defaults, "Default")

    -- Register the options table
    LibStub("AceConfig-3.0"):RegisterOptionsTable("PeaceAndQuiet", self:GetOptions())
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
	    "PeaceAndQuiet", "Peace And Quiet")

    self:RegisterChatCommand("peaceandquiet", "ChatCommand")
    self:RegisterChatCommand("paq", "ChatCommand")

    -- Register to receive the PLAYER_ENTERING_WORLD event
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function PeaceAndQuiet:OnEnable()
    -- Register to receive the PLAYER_ENTERING_WORLD event
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function PeaceAndQuiet:OnDisable()
    -- Unregister events
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function PeaceAndQuiet:PLAYER_ENTERING_WORLD()
    local isInstance, instanceType = IsInInstance()

    if instanceType == "none" then
        -- Player is in the world or a battleground
        self:Print(L["Displaying global channels"])
        if self.db.profile.manageGeneral == true then
            ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, L["General"])
        end
        if self.db.profile.manageLocalDefense == true then
            ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, L["LocalDefense"])
        end
        if self.db.profile.manageGuild == true then
            ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, L["Guild"])
        end
        if self.db.profile.manageWorld == true then
            ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, L["world"])
        end
    else
        -- Player is in an instance, raid, or arena
        self:Print(L["Hiding the global channels"])
        if self.db.profile.manageGeneral == true then
            ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, L["General"])
        end
        if self.db.profile.manageLocalDefense == true then
            ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, L["LocalDefense"])
        end
        if self.db.profile.manageGuild == true then
            ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, L["Guild"])
        end
        if self.db.profile.manageWorld == true then
            ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, L["world"])
        end
    end
end
