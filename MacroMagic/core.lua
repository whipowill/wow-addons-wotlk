SLASH_SFXON1 = "/x"
function SlashCmdList.SFXON(msg, editbox)
	SetCVar("Sound_EnableSFX", tonumber(GetCVar("Sound_EnableSFX")) == 1 and 0 or 1)
	UIErrorsFrame:Clear()
end
