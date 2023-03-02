local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_DEAD");

function frame:print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function frame:Bg_Release()
	inInstance, instanceType = IsInInstance();
	if inInstance == 1 and instanceType == "pvp" then
		RepopMe();
	end
end

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "BGRelease" then
		if bgreleasebool == nil then
			bgreleasebool = "on";
		end
	elseif event == "PLAYER_DEAD" then
		if bgreleasebool == "on" then
			frame:Bg_Release();
		end
	end
end

frame:SetScript("OnEvent", frame.OnEvent);
SLASH_BGRELEASE1 = "/bgrelease";

function SlashCmdList.BGRELEASE(msg)
	if msg ~= nil then
		msg = string.lower(msg);
	end
	if msg == "on" then
		print("BGRelease: on");
		bgreleasebool = "on";
	elseif msg == "off" then
		print("BGRelease: off");
		bgreleasebool = "off";
	else
		if bgreleasebool == "on" then
			print("BGRelease: " .. bgreleasebool);
		else
			print("BGRelease: " .. bgreleasebool);
		end
		print("Type /bgrelease off or on to change");	
	end
end