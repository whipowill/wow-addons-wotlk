function addline_itemid()
	itemName,itemLink = ItemRefTooltip:GetItem()
	if itemLink ~= nil then
		local itemString = string.match(itemLink, "item[%-?%d:]+")
		local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, 
		jewelId4, suffixId, uniqueId, linkLevel, reforgeId = strsplit(":", itemString)

		ItemRefTooltip:AddLine("ItemID: |cFFFFFFFF"..itemId)
		ItemRefTooltip:Show();
	end
end

function addline_gametip()
	itemName,itemLink = GameTooltip:GetItem()
	if itemLink ~= nil then	   
		local itemString = string.match(itemLink, "item[%-?%d:]+")
		local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, 
		jewelId4, suffixId, uniqueId, linkLevel, reforgeId = strsplit(":", itemString)

		GameTooltip:AddLine("ItemID: |cFFFFFFFF"..itemId)
		GameTooltip:Show();
	end
end

ItemRefTooltip:SetScript("OnShow", addline_itemid)
GameTooltip:SetScript("OnShow",addline_gametip)


