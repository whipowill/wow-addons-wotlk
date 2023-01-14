QuestAnnounce_enable=1;
QuestAnnounce_every=1;
QuestAnnounce_version="1.02";
QuestAnnounce_ver=0;
QuestAnnounce_advmsg=QA_ADVMSG;
QuestAnnounce_finmsg=QA_FINMSG;

-- qapause to temporarily stop quest announcer
qapause=false;

-- this variable is to get the debug output messages printed in the ui. Not intended for use by the user
qadebug=0
-- debug settings ended

function QuestAnnounce_OnLoad()
	SlashCmdList["QUESTANNOUNCECOMMAND"] = QuestAnnounce_SlashHandler;
	SLASH_QUESTANNOUNCECOMMAND1 = "/questannounce";
	SLASH_QUESTANNOUNCECOMMAND2 = "/qa";

  this:RegisterEvent("UI_INFO_MESSAGE");
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("QuestAnnounce " .. QuestAnnounce_version .. QA_LOADED);
	end

	if (QuestAnnounce_ver < 1) then
		-- Resetting the variables as there was a default bug before!
		QuestAnnounce_advmsg=QA_ADVMSG;
		QuestAnnounce_finmsg=QA_FINMSG;
		QuestAnnounce_every=1
		QuestAnnounce_enable=1;
		QuestAnnounce_every=1;		
		QuestAnnounce_ver=1;
	end
	
end


function QuestAnnounce_OnEvent(event, message, arg2, arg3, arg4, arg5)
	if ( event == "UI_INFO_MESSAGE" ) then
		if (QuestAnnounce_enable == 1) and (qapause == false) then
			local questUpdateText = gsub(message,"(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$","%1",1);

			if ( questUpdateText ~= message) then
				local outmessage

      	local ii, jj, strItemName, iNumItems, iNumNeeded = string.find(message, "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$");

        local stillneeded = iNumNeeded-iNumItems

				local everyresult = math.fmod(iNumItems,QuestAnnounce_every)

        if stillneeded < 1 then
          outmessage=QuestAnnounce_finmsg;
          outmessage=string.gsub(outmessage,"$NumItems",iNumItems);
          outmessage=string.gsub(outmessage,"$NumNeeded",iNumNeeded);
          outmessage=string.gsub(outmessage,"$ItemName",strItemName);
          outmessage=string.gsub(outmessage,"$NumLeft",stillneeded);
        end                   
        if stillneeded > 0 then
          outmessage=QuestAnnounce_advmsg;
          outmessage=string.gsub(outmessage,"$NumItems",iNumItems);
          outmessage=string.gsub(outmessage,"$NumNeeded",iNumNeeded);
          outmessage=string.gsub(outmessage,"$ItemName",strItemName);
          outmessage=string.gsub(outmessage,"$NumLeft",stillneeded);
         
        end
        
        -- To make sure the we announce the first everytime
        if tonumber(iNumItems) == 1 then
        	everyresult=0
        end
        
        -- To make sure the we announce the last everytime
        if tonumber(stillneeded) == 0 then
        	everyresult=0
        end

        -- This routine checks for the result of the modula operation
        if everyresult ~= 0 then
					if qadebug==1 then
          	DEFAULT_CHAT_FRAME:AddMessage("Debug: "..everyresult.." ger message"..outmessage,1,1,1);
					end
          outmessage = ""
        end
         
				if qadebug==1 then
        	DEFAULT_CHAT_FRAME:AddMessage("Debug: "..outmessage,1,1,1);
				end

				if (GetNumPartyMembers()>0) and outmessage ~= nil then 
					SendChatMessage(outmessage, "PARTY");
				end
				
			end
		end
	end
end

function QuestAnnounce_SlashHandler(msg)
  if string.lower(msg) == "debug" then
  	qadebug=1
  end
  
  if string.lower(msg) == "pause" then
  	qapause=true
  end

  if string.lower(msg) == "resume" then
  	qapause=false
  end
  
  
  if string.lower(msg) == "std" then
		QuestAnnounce_advmsg=QA_ADVMSG;
		QuestAnnounce_finmsg=QA_FINMSG;
		QuestAnnounce_every=1
		QuestAnnounce_enable=1;
		QuestAnnounce_every=1;
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_RESET,1,1,1);
	end
  
	if string.lower(string.sub(msg,1,6)) == "advmsg" then
		if qadebug==1 then
			DEFAULT_CHAT_FRAME:AddMessage("Debug: ".. string.sub(msg,7))
		end
		if string.sub(msg,7) ~= "" then
			QuestAnnounce_finmsg=string.sub(msg,7)
		end
	end

	if string.lower(string.sub(msg,1,5)) == "every" then
		if qadebug==1 then
			DEFAULT_CHAT_FRAME:AddMessage("Debug: ".. string.sub(msg,7))
		end
		if string.sub(msg,6) ~= "" then
			QuestAnnounce_every=string.sub(msg,6)
		end
	end

	if string.lower(string.sub(msg,1,6)) == "finmsg" then
		if qadebug==1 then
			DEFAULT_CHAT_FRAME:AddMessage("Debug: ".. string.sub(msg,7))
		end
		if string.sub(msg,7) ~= "" then
			QuestAnnounce_advmsg=string.sub(msg,7)
		end
	end
	
  if msg == "" or string.lower(msg) == "help" then
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_VERSION..QuestAnnounce_version,1,0.5,0.5);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD,1,1,1);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD_STATUS,1,1,1);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD_ON,1,1,1);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD_OFF,1,1,1);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD_CLASSIC,1,1,1);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD_STD,1,1,1);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD_EVERYNUM,1,1,1);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD_PAUSE,1,1,1);
    DEFAULT_CHAT_FRAME:AddMessage(QA_CHAT_MSG_CMD_RESUME,1,1,1);


  end

	if string.lower(msg) == "status" then
	   if QuestAnnounce_enable==1 then
 	     UIErrorsFrame:AddMessage(QA_CHAT_MSG_ON, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		 end
	   if QuestAnnounce_enable==0 then
  	   UIErrorsFrame:AddMessage(QA_CHAT_MSG_OFF, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		 end
	end		      
	
	if string.lower(msg) == "on" then
		 QuestAnnounce_enable=1;
	   UIErrorsFrame:AddMessage(QA_CHAT_MSG_ON2, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	end

	if string.lower(msg) == "off" then
		 QuestAnnounce_enable=0;
	   UIErrorsFrame:AddMessage(QA_CHAT_MSG_OFF2, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	end

	if string.lower(msg) == "classic" then
		QuestAnnounce_advmsg="$ItemName: $NumItems/$NumNeeded";
		QuestAnnounce_finmsg="$ItemName: $NumItems/$NumNeeded";
		QuestAnnounce_every=1
		QuestAnnounce_enable=1;
		QuestAnnounce_every=1;
	   UIErrorsFrame:AddMessage(QA_CHAT_MSG_CLASSIC, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	end

end
