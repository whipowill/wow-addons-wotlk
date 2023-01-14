--[[

	 AutoFlood

	 Version : 1.1
	 Date    : 18/11/2006
	 Author  : Lenwë

]]

-- ===========================================
-- Main code functions
-- ===========================================

-- AutoFlood_InitVars()
--
-- Init conviguration variables

function AutoFlood_InitVars()
    local configInitialisation = 
    {
        ['message']   = "AutoFlood "..AF_version,
        ['system']    = "CHANNEL",
        ['channel']   = "1",
        ['rate']      = 60,
        ['idChannel'] = "1",
    }
    
    if AF_config == nil then
        AF_config = {}
    end
    
    if AF_config[AF_myID] == nil then
        AF_config[AF_myID] = {}
    end	

    for k, v in pairs(configInitialisation) do
    	if AF_config[AF_myID][k] == nil then
    	   AF_config[AF_myID][k] = v
    	end
    end 
end


-- AutoFlood_OnLoad()
--
-- Main script initialization.

function AutoFlood_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED")
	
	AutoFlood_Frame.TimeSinceLastUpdate = 0
	
	AF_maxRate 		= 10
    AF_version 		= "1.1"
    AF_myID = GetCVar("realmName")..'-'..UnitName("player")    
	
	AF_active = false
end

function AutoFlood_OnEvent()
	-- Init saved variables
	if (event == "VARIABLES_LOADED") then
	    AutoFlood_InitVars()
    	s = string.gsub(AUTOFLOOD_LOAD, "VERSION", 	AF_version)
    	DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)	    
	    return
	end	
end


-- AutoFlood_On()
--
-- Enable flood !

function AutoFlood_On()
	AF_active = true
	AutoFlood_Info()
	AutoFlood_Frame.TimeSinceLastUpdate = AF_config[AF_myID]['rate']
end


-- AutoFlood_Off()
--
-- Stop flood.

function AutoFlood_Off()
	DEFAULT_CHAT_FRAME:AddMessage(AUTOFLOOD_INACTIVE,1,1,1)
	AF_active = false
end

function AutoFlood_OnUpdate(arg1)
	if(not AF_active) then return end
	AutoFlood_Frame.TimeSinceLastUpdate = AutoFlood_Frame.TimeSinceLastUpdate + arg1
	if( AutoFlood_Frame.TimeSinceLastUpdate > AF_config[AF_myID]['rate'] ) then
     	SendChatMessage(AF_config[AF_myID]['message'], AF_config[AF_myID]['system'], this.language, GetChannelName(AF_config[AF_myID]['idChannel']))
		AutoFlood_Frame.TimeSinceLastUpdate = 0
	end
end




-- AutoFlood_Info()
--
-- Show parameters.

function AutoFlood_Info()
	local s

	if(AF_active) then
		DEFAULT_CHAT_FRAME:AddMessage(AUTOFLOOD_ACTIVE,1,1,1)
	else
		DEFAULT_CHAT_FRAME:AddMessage(AUTOFLOOD_INACTIVE,1,1,1)
	end

	s = AUTOFLOOD_STATS
	s = string.gsub(s, "MESSAGE", 	AF_config[AF_myID]['message'])
	s = string.gsub(s, "CHANNEL", 	AF_config[AF_myID]['channel'])
	s = string.gsub(s, "RATE", 		AF_config[AF_myID]['rate'])
	DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
end


-- AutoFlood_SetMessage( (string) msg)
--
-- Set the message to send.

function AutoFlood_SetMessage(msg)
	local s
	
	if(msg ~= "") then AF_config[AF_myID]['message'] = msg end
	
	s = string.gsub(AUTOFLOOD_MESSAGE, "MESSAGE", 	AF_config[AF_myID]['message'])
    DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
end


-- AutoFlood_SetRate( (number) r)
--
-- Set the amount of seconds between each message sending.

function AutoFlood_SetRate(r)
	local s
	
	if((r ~= nil) and (tonumber(r) > 0) and (r ~= "")) then r = tonumber(r) end
	if(r >= AF_maxRate) then
		AF_config[AF_myID]['rate'] = r
		s = string.gsub(AUTOFLOOD_RATE, "RATE", 	AF_config[AF_myID]['rate'])
	else
		s = string.gsub(AUTOFLOOD_ERR_RATE, "RATE", 	AF_maxRate)
	end
    DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
end


-- AutoFlood_SetChannel( (string) ch)
--
-- Set the event / system / channel type according fo the game channel /ch.
-- Allowed values : s, say, guild, raid, party and actually joined channel numbers (0-9)

function AutoFlood_SetChannel(ch)
	AF_config[AF_myID]['system'] = ""
	if ((ch == "say") or (ch == "s")) then
		AF_config[AF_myID]['system']	= "SAY"
		AF_config[AF_myID]['channel'] 	= ch
	end
	if ((ch == "guild") or (ch == "g")) then
		AF_config[AF_myID]['system']  	= "GUILD"
		AF_config[AF_myID]['channel'] 	= ch
	end
	if (ch == "raid") then
		AF_config[AF_myID]['system']  = "RAID"
		AF_config[AF_myID]['channel'] = ch
	end
	if ((ch == "gr") or (ch == "party")) then
		AF_config[AF_myID]['system']  	= "PARTY"
		AF_config[AF_myID]['channel'] 	= ch
	end   
	if (ch == "bg") then
		AF_config[AF_myID]['system']  	= "BATTLEGROUND"
		AF_config[AF_myID]['channel'] 	= ch
	end
	if(AF_config[AF_myID]['system'] == "") then
		if (GetChannelName(ch) ~= 0) then
			AF_config[AF_myID]['idChannel'] = ch
			AF_config[AF_myID]['system']    = "CHANNEL"
			AF_config[AF_myID]['channel']   = ch
		end
	end

	-- Bad channel
	if(AF_config[AF_myID]['system'] == "") then
		AF_config[AF_myID]['system']  	= "SAY"
		AF_config[AF_myID]['channel']  = "s"
		s = string.gsub(AUTOFLOOD_ERR_CHAN, "CHANNEL", ch)
    	DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)
		return false
	end
	
	s = string.gsub(AUTOFLOOD_CHANNEL, "CHANNEL", AF_config[AF_myID]['channel'])
    DEFAULT_CHAT_FRAME:AddMessage(s,1,1,1)

	return true
end




-- ===========================================
-- Slash command aliases
-- ===========================================

-- /flood [on|off]
--
-- Start / stop flood

SlashCmdList["AUTOFLOOD"] = function(s)
	if(s == "on") then
	     AutoFlood_On()
	elseif(s == "off") then
	     AutoFlood_Off()
	else
		if(AF_active) then AutoFlood_Off() else AutoFlood_On() end
	end
end


-- /floodmessage <message>
--
-- Set the message to send

SlashCmdList["AUTOFLOODSETMESSAGE"] = function(s)
	AutoFlood_SetMessage(s)
end


-- /floodchan <channel>
--
-- Set the channel

SlashCmdList["AUTOFLOODSETCHANNEL"] = function(s)
	AutoFlood_SetChannel(s)
end


-- /floodrate <duration>
--
-- Set the period (in seconds)

SlashCmdList["AUTOFLOODSETRATE"] = function(s)
	AutoFlood_SetRate(s)
end


-- /floodinfo
--
-- Display the parameters in chat window

SlashCmdList["AUTOFLOODINFO"] = function()
	AutoFlood_Info()
end


-- /floodhelp
--
-- Display help in chat window

SlashCmdList["AUTOFLOODHELP"] = function()
	local l
	for _, l in pairs(AUTOFLOOD_HELP) do
		DEFAULT_CHAT_FRAME:AddMessage(l,1,1,1)
	end
end


SLASH_AUTOFLOOD1           = "/flood"

SLASH_AUTOFLOODSETMESSAGE1 = "/floodmessage"
SLASH_AUTOFLOODSETMESSAGE2 = "/floodmsg"

SLASH_AUTOFLOODSETCHANNEL1 = "/floodchannel"
SLASH_AUTOFLOODSETCHANNEL2 = "/floodchan"

SLASH_AUTOFLOODSETRATE1    = "/floodrate"

SLASH_AUTOFLOODINFO1  	   = "/floodinfo"
SLASH_AUTOFLOODINFO2  	   = "/floodconfig"

SLASH_AUTOFLOODHELP1       = "/floodhelp"
SLASH_AUTOFLOODHELP2       = "/floodman"
