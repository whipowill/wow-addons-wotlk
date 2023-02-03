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
            args = {
                verbose = {
                    name = L["Verbose"],
                    desc = L["Toggles the display of informational messages."],
                    type = "toggle",
                    width = "double",
                    set = function(info, val) self.db.profile.verbose = val end,
                    get = function(info) return self.db.profile.verbose end,
                    order = 10
                },
                --[[
                manageGeneral = {
                    name = L["Manage General Channel"],
                    desc = L["Toggles whether the General chat channel is automatically enabled/disabled."],
                    type = "toggle",
                    width = "double",
                    set = function(info, val) self.db.profile.manageGeneral = val end,
                    get = function(info) return self.db.profile.manageGeneral end,
                    order = 20
                },
                manageLocalDefense = {
                    name = L["Manage Local Defense Channel"],
                    desc = L["Toggles whether the Local Defense chat channel is automatically enabled/disabled."],
                    type = "toggle",
                    width = "double",
                    set = function(info, val) self.db.profile.manageLocalDefense = val end,
                    get = function(info) return self.db.profile.manageLocalDefense end,
                    order = 30
                },
                manageGuild = {
                    name = L["Manage Guild Channel"],
                    desc = L["Toggles whether the Guild chat channel is automatically enabled/disabled."],
                    type = "toggle",
                    width = "double",
                    set = function(info, val) self.db.profile.manageGuild = val end,
                    get = function(info) return self.db.profile.manageGuild end,
                    order = 40
                },
                manageWorld = {
                    name = L["Manage World Channel"],
                    desc = L["Toggles whether the World chat channel is automatically enabled/disabled."],
                    type = "toggle",
                    width = "double",
                    set = function(info, val) self.db.profile.manageWorld = val end,
                    get = function(info) return self.db.profile.manageWorld end,
                    order = 50
                }
                ]]
            }
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
        if self.db.profile.verbose then
            self:Print(L["Displaying global channels"])
        end
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
        if self.db.profile.verbose then
            self:Print(L["Hiding the global channels"])
        end
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
