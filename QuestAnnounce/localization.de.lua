if ( GetLocale() == "deDE" ) then
	
	-- Umlauts are encoded as:
	--
	-- ü - \195\188
	-- Ü - \195\156
	-- ö - \195\182
	-- Ö - \195\150
	-- ä - \195\164
	-- Ä - \195\134
	-- ß - \195\159
	
	QA_ADVMSG = "Ich habe $NumItems von $ItemName. Gebraucht werden $NumNeeded. Es fehlen noch $NumLeft.";
	QA_FINMSG = "Ich habe genug $ItemName. $NumItems/$NumNeeded";
	
	QA_LOADED = " geladen";
	
	QA_CHAT_MSG_RESET = "Die QuestAnnounce Einstellungen wurden zur\195\188 ckgesetzt.";
	QA_CHAT_MSG_VERSION = "QuestAnnouce Hilfe f\195\188r Version ";
	
	QA_CHAT_MSG_CMD = "/qa oder /questannounce gefolgt von ";
	QA_CHAT_MSG_CMD_STATUS = " status zeigt die aktuelle Konfiguration";
	QA_CHAT_MSG_CMD_ON = " on schaltet QuestAnnounce an";
	QA_CHAT_MSG_CMD_OFF = " off schaltet QuestAnnounce aus";
	QA_CHAT_MSG_CMD_CLASSIC = " classic schaltet QuestAnnounce in den normalen Modus und aktiviert es, falls es ausgeschaltet war";
	QA_CHAT_MSG_CMD_STD = " std stellt die Standard Konfiguration ein";
	QA_CHAT_MSG_CMD_EVERYNUM = " every [num] zeigt die Gegenst\195\164nde in Abst\195\164nden von [num] Gegenst\195\164nden an";
	QA_CHAT_MSG_CMD_CONFIG = " config \195\182ffbet ein Konfigurationsfenster";
	QA_CHAT_MSG_CMD_PAUSE = " pause will disable the questannounce until you select resume or reload the ui. Not saved";
  QA_CHAT_MSG_CMD_RESUME = " resume will resume the questannounce if paused";

	
	QA_CHAT_MSG_CLASSIC = "QuestAnnounce hat die normalen Einstellungen geladen";
	QA_CHAT_MSG_OFF = "QuestAnnounce ist ausgeschaltet";
	QA_CHAT_MSG_OFF2 = "QuestAnnounce ausgeschaltet";
	QA_CHAT_MSG_ON = "QuestAnnounce ist angeschaltet";
	QA_CHAT_MSG_ON2 = "QuestAnnounce angeschaltet";
	
end
